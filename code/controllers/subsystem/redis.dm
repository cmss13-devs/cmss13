SUBSYSTEM_DEF(redis)
	name = "Redis"
	init_order = SS_INIT_REDIS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	wait = 1
	flags = SS_TICKER

	/// if a connection to redis has been established
	var/connected = FALSE

	/// subscribed to channels on the redis server
	var/list/subbed_channels = list()

	/// message queue, for messages sent prior to initialization
	var/list/datum/redis_message/queue = list()

	/// the name this server uses externally
	var/instance_name = "game"
	/// if this server is sending logs to redis, in addition to the file system
	var/redis_logging = FALSE

/datum/controller/subsystem/redis/stat_entry(msg)
	msg =  "S:[length(subbed_channels)] | Q:[length(queue)] | C:[connected ? "Y" : "N"]"
	return ..()

/datum/controller/subsystem/redis/Initialize()
	instance_name = CONFIG_GET(string/instance_name)
	var/datum/tgs_api/api = TGS_READ_GLOBAL(tgs)
	if(api?.InstanceName())
		instance_name = api.InstanceName()

	redis_logging = CONFIG_GET(flag/redis_logging)

	if(connect() == CONFIG_DISABLED)
		can_fire = FALSE
		return SS_INIT_SUCCESS

	if(!connected)
		return SS_INIT_FAILURE


	for(var/datum/redis_message/message as anything in queue)
		publish(message.channel, message.message)
		queue -= message

	for(var/callback in subtypesof(/datum/redis_callback))
		var/datum/redis_callback/redis_cb = new callback()

		if(isnull(redis_cb.channel))
			stack_trace("[redis_cb.type] has no channel set!")
			continue

		if(redis_cb.channel in subbed_channels)
			stack_trace("Attempted to subscribe to the channel '[redis_cb.channel]' from [redis_cb.type] twice!")

		rustg_redis_subscribe(redis_cb.channel)
		subbed_channels[redis_cb.channel] = redis_cb

	log_debug("Registered [length(subbed_channels)] callback(s).")

	return SS_INIT_SUCCESS

/datum/controller/subsystem/redis/fire()
	if(!connected)
		can_fire = FALSE
		return

	check_messages()

	for(var/datum/redis_message/message as anything in queue)
		publish(message.channel, message.message)
		queue -= message

/datum/controller/subsystem/redis/Shutdown()
	if(!connected)
		return
	disconnect(SHUTDOWN)

/datum/controller/subsystem/redis/proc/connect()
	if(!CONFIG_GET(flag/redis_enabled))
		return CONFIG_DISABLED

	var/connection_attempt = rustg_redis_connect(CONFIG_GET(string/redis_connection))

	if(connection_attempt)
		message_admins("Failed to connect to redis: [connection_attempt]")
		return

	var/list/data = list("source" = SSredis.instance_name, "type" = "connect")
	publish("byond.meta", json_encode(data))

	connected = TRUE
	can_fire = TRUE

/datum/controller/subsystem/redis/proc/disconnect(reason)
	message_admins("Note: Redis connection interrupted.")
	var/list/data = list("source" = SSredis.instance_name, "type" = "disconnect", "reason" = reason)
	publish("byond.meta", json_encode(data))
	rustg_redis_disconnect()
	connected = FALSE

/datum/controller/subsystem/redis/proc/reconnect()
	connect()

	if(!connected)
		return

	for(var/channel in subbed_channels)
		rustg_redis_subscribe(channel)

/datum/controller/subsystem/redis/proc/check_messages()
	var/raw_data = rustg_redis_get_messages()
	var/list/usable_data

	try
		usable_data = json_decode(raw_data)
	catch
		message_admins("Failed to deserialise a redis message.")
		log_debug("Failed to deserialise: [raw_data]")
		return

	for(var/channel in usable_data)
		if(channel == RUSTG_REDIS_ERROR_CHANNEL)
			message_admins("Redis error: [json_encode(usable_data[channel])]")
			continue

		if(!(channel in subbed_channels))
			stack_trace("Received a message on a non-subscribed channel.")
			continue

		var/datum/redis_callback/redis_cb = subbed_channels[channel]

		for(var/message in usable_data[channel])
			redis_cb.on_message(message)

/datum/controller/subsystem/redis/proc/publish(channel, message)
	if(!connected)
		var/datum/redis_message/redis = new()
		redis.channel = channel
		redis.message = message

		queue += redis
		return

	rustg_redis_publish(channel, message)

/datum/controller/subsystem/redis/CanProcCall(procname)
	return FALSE

/datum/controller/subsystem/redis/vv_edit_var(var_name, var_value)
	return FALSE

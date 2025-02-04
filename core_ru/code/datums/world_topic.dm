/datum/world_topic/status/Run(list/input)
	. = ..()

	data = list()

	data["round_id"] = null
	if(GLOB.round_id)
		data["round_id"] = GLOB.round_id

	data["map_name"] = null
	if(SSmapping.configs?[GROUND_MAP])
		data["map_name"] = SSmapping.configs[GROUND_MAP].map_name
	if(SSmapping.next_map_configs?[GROUND_MAP])
		data["next_map_name"] = SSmapping.next_map_configs[GROUND_MAP].map_name

	data["ship_map_name"] = null
	if(SSmapping.configs?[SHIP_MAP])
		data["ship_map_name"] = SSmapping.configs[SHIP_MAP].map_name
	if(SSmapping.next_map_configs?[SHIP_MAP])
		data["next_ship_map_name"] = SSmapping.next_map_configs[SHIP_MAP].map_name

	data["players"] = length(GLOB.clients)

	data["revision"] = GLOB.revdata.commit
	data["revision_date"] = GLOB.revdata.date

	data["round_duration"] = ROUND_TIME

	data["delay"] = SSticker.delay_start

	statuscode = 200
	response = "Status retrieved"

/datum/world_topic/status/authed
	key = "status_authed"
	anonymous = FALSE

/datum/world_topic/status/authed/Run(list/input)
	. = ..()

	data["round_name"] = null
	data["mode"] = null
	if(SSticker.mode)
		if(GLOB.round_statistics)
			data["round_name"] = GLOB.round_statistics.round_name
		if(SSticker.mode.round_finished)
			data["round_end_state"] = SSticker.mode.end_round_message()
		data["mode"] = SSticker.mode.name

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	data["admins"] = length(presentmins) + length(afkmins)
	data["gamestate"] = SSticker.current_state

	//Time dilation stats.
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	data["mcpu"] = world.map_cpu
	data["cpu"] = world.cpu

/datum/world_topic/delay
	key = "set_delay"
	required_params = list("delay")

/datum/world_topic/delay/Run(list/input)
	. = ..()

	if(SSticker.delay_start == input["delay"])
		statuscode = 501
		response = "Delay already set to same state."
		return

	SSticker.delay_start = input["delay"]
	message_admins(SPAN_NOTICE("[input["source"]] ([input["addr"]]) [SSticker.delay_start ? "delayed the round start" : "has made the round start normally"]."))
	to_chat(world, SPAN_CENTERBOLD("The game start has been [SSticker.delay_start ? "delayed" : "continued"]."))
	if(SSticker.delay_start)
		statuscode = 200
		response = "Delay set."
	else
		statuscode = 200
		response = "Delay removed."

/datum/world_topic/shutdown_warning
	key = "lowpop_shutdown_warning"

/datum/world_topic/shutdown_warning/Run(list/input)
	. = ..()

	message_admins(SPAN_NOTICE("[input["source"]] ([input["addr"]]), WARNING, you have approximately 30 SECONDS before the server will be turned offline automaticaly due to lowpop (<a href='byond://?_src_=\ref[src];[HrefToken(forceGlobal = TRUE)];denyserverreboot=1'>DENY</a>)"))
	to_chat(world, SPAN_CENTERBOLD("Server will be turned offline in 30 SECONDS due to lowpop. Only admins can deny this action in this time frame."))

	statuscode = 200
	response = "Request Sended"

/datum/world_topic/shutdown_warning/Topic(href, href_list)
	if(href_list["denyserverreboot"])
		REDIS_PUBLISH("byond.round", "state" = "stop_auto_stop")
		to_chat(world, SPAN_CENTERBOLD("Shutdown canceled."))

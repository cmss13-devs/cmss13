/// Sends collected statistics to an influxdb v2 backend periodically
SUBSYSTEM_DEF(influxdriver)
	name       = "InfluxDB Driver"
	wait       = 10 SECONDS
	init_order = SS_INIT_INFLUXDRIVER
	priority   = SS_PRIORITY_INFLUXDRIVER
	runlevels  = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

	var/list/send_queue = list()

	/// Maximum amount of metric lines to send at most in one request
	/// This is neccessary because sending a lot of metrics can get expensive
	/// and drive the subsystem into overtime, but we can't split the work as it'd be even less efficient
	var/max_batch = 150

	/// Last timestamp in microseconds
	var/timestamp_cache_realtime
	/// Last tick time the timestamp was taken at
	var/timestamp_cache_worldtime

/datum/controller/subsystem/influxdriver/Initialize()
	var/period = text2num(CONFIG_GET(number/influxdb_send_period))
	if(isnum(period))
		wait = max(period * (1 SECONDS), 2 SECONDS)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/influxdriver/stat_entry(msg)
	msg += "period=[wait] queue=[length(send_queue)]"
	return ..()

/datum/controller/subsystem/influxdriver/proc/unix_timestamp_string() // pending change to rust-g
	return RUSTG_CALL(RUST_G, "unix_timestamp")()

/datum/controller/subsystem/influxdriver/proc/update_timestamp()
	PRIVATE_PROC(TRUE)
	// We make only one request to rustg per game tick, so we cache the result per world.time
	var/whole_timestamp = unix_timestamp_string() // Format "7129739474.4758981" - timestamp with up to 7-8 decimals
	var/list/tsparts = splittext(whole_timestamp, ".")
	var/fractional = copytext(pad_trailing(tsparts[2], "0", 6), 1, 7) // in microseconds
	timestamp_cache_worldtime = world.time
	timestamp_cache_realtime = "[tsparts[1]][fractional]"

/datum/controller/subsystem/influxdriver/fire(resumed)
	var/maxlen = min(length(send_queue)+1, max_batch)
	var/list/queue = send_queue.Copy(1, maxlen)
	send_queue.Cut(1, maxlen)
	flush_queue(queue)

/// Flushes measurements batch to InfluxDB backend
/datum/controller/subsystem/influxdriver/proc/flush_queue(list/queue)
	PRIVATE_PROC(TRUE)

	var/host   = CONFIG_GET(string/influxdb_host)
	var/token  = CONFIG_GET(string/influxdb_token)
	var/bucket = CONFIG_GET(string/influxdb_bucket)
	var/org    = CONFIG_GET(string/influxdb_org)

	if(!host || !token || !bucket || !org)
		can_fire = FALSE
		return

	if(!length(queue))
		return // Nothing to do

	var/url = "[host]/api/v2/write?org=[org]&bucket=[bucket]&precision=us" // microseconds
	var/list/headers = list()
	headers["Authorization"] = "Token [token]"
	headers["Content-Type"] = "text/plain; charset=utf-8"
	headers["Accept"] = "application/json"

	var/datum/http_request/request = new
	var/payload = ""
	for(var/line in queue)
		payload += "[line]\n"
	request.prepare(RUSTG_HTTP_METHOD_POST, url, payload, headers)
	request.begin_async()
	// TODO possibly check back result of request later

/// Enqueues sending to InfluxDB Backend selected measurement values - round_id and timestamp are filled in automatically
/datum/controller/subsystem/influxdriver/proc/enqueue_stats(measurement, list/tags, list/fields)
	. = FALSE
	var/valid = FALSE
	var/serialized = "[measurement],round_id=[GLOB.round_id]"
	if(tags)
		for(var/tag in tags)
			var/serialized_tag = serialize_field(tag, tags[tag])
			if(serialized_tag)
				serialized += ",[serialized_tag]"
	serialized += " "
	var/comma = ""
	for(var/field in fields)
		var/serialized_field = serialize_field(field, fields[field])
		if(serialized_field)
			valid = TRUE
			serialized += "[comma][serialized_field]"
			comma = ","
	if(!valid)
		CRASH("Attempted to serialize to InfluxDB backend an invalid measurement (likely has no fields)")
	if(timestamp_cache_worldtime != world.time)
		update_timestamp()
	serialized += " [timestamp_cache_realtime]"
	send_queue += serialized
	return TRUE

/// Enqueues sending varied stats in a dumb and simpler format directly as: measurement count=
/datum/controller/subsystem/influxdriver/proc/enqueue_stats_crude(measurement, value, field_name = "count")
	. = FALSE
	var/serialized_field = serialize_field(field_name, value)
	if(!length(serialized_field))
		return
	if(timestamp_cache_worldtime != world.time)
		update_timestamp()
	var/serialized = "[measurement],round_id=[GLOB.round_id] [serialized_field] [timestamp_cache_realtime]"
	send_queue += serialized
	return TRUE

/// Puts a single field or tag value into InfluxDB Line format
/datum/controller/subsystem/influxdriver/proc/serialize_field(field, value)
	var/static/regex/whitelistedCharacters = regex(@{"([^a-zA-Z0-9_]+)"}, "g")
	var/sanitized_field = whitelistedCharacters.Replace("[field]", "")
	if(!length(sanitized_field) || copytext(sanitized_field, 1, 2) == "_")
		CRASH("Invalid tag/field for InfluxDB serialization: '[sanitized_field]' (original: '[field]')")
	var/sanitized_value
	if(isnum(value))
		sanitized_value = value
	else if(istext(value))
		sanitized_value = whitelistedCharacters.Replace("[value]", "")
		if(!length(sanitized_value) || copytext(sanitized_value, 1, 2) == "_")
			CRASH("Invalid value for InfluxDB serialization: '[sanitized_value]' (original: '[value]')")
	else
		CRASH("Invalid value type passed for InfluxDB serialization: '[value]'")
	return "[sanitized_field]=[sanitized_value]"

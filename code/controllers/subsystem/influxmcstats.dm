SUBSYSTEM_DEF(influxmcstats)
	name       = "InfluxDB MC Stats"
	wait       = 60 SECONDS
	priority   = SS_PRIORITY_INFLUXMCSTATS
	init_order = SS_INIT_INFLUXMCSTATS
	runlevels  = RUNLEVEL_LOBBY|RUNLEVELS_DEFAULT
	flags      = SS_KEEP_TIMING
	var/checkpoint = 0
	var/list/subsystem_name_cache = list()

/datum/controller/subsystem/influxmcstats/Initialize()
	var/period = text2num(CONFIG_GET(number/influxdb_mcstats_period))
	if(isnum(period))
		wait = max(period * (1 SECONDS), 10 SECONDS)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/influxmcstats/stat_entry(msg)
	msg += "period=[wait] checkpoint=[checkpoint]"
	return ..()

/datum/controller/subsystem/influxmcstats/fire(resumed)
	if(!SSinfluxdriver.can_fire)
		can_fire = FALSE
		return

	var/list/data = list()
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast
	SSinfluxdriver.enqueue_stats("tidi", null, data)

	SSinfluxdriver.enqueue_stats("cpu", null, list("cpu" = world.cpu, "map_cpu" = world.map_cpu))

	var/static/regex/get_last_path_element = regex(@{"/([^/]+)$"})
	checkpoint++
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if(!SS.can_fire)
			continue
		if(!subsystem_name_cache[SS.type])
			get_last_path_element.Find("[SS.type]")
			subsystem_name_cache[SS.type] = "SS[get_last_path_element.group[1]]"
		var/SSname = subsystem_name_cache[SS.type]
		if(!SSname)
			stack_trace("Influx MC Stats couldnt name a subsystem, type=[SS.type]")
			continue
		SSinfluxdriver.enqueue_stats("sstimings", list("ss" = SSname), list("cost" = SS.cost, "tick_overrun" = SS.tick_overrun, "tick_usage" = SS.tick_usage, "wait" = SS.wait))

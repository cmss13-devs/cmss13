SUBSYSTEM_DEF(influxmcstats)
	name       = "InfluxDB MC Stats"
	wait       = 60 SECONDS
	priority   = SS_PRIORITY_INFLUXMCSTATS
	init_order = SS_INIT_INFLUXMCSTATS
	runlevels  = RUNLEVEL_LOBBY|RUNLEVELS_DEFAULT
	flags      = SS_KEEP_TIMING
	var/checkpoint = 0

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
	var/static/regex/get_last_path_element=regex(@{"/([^/]+)$"})
	checkpoint++
	for(var/datum/controller/subsystem/SS in Master.subsystems)
		if(!SS.can_fire)
			continue
		if(!get_last_path_element.Find("[SS.type]"))
			stack_trace("Influx MC Stats couldnt name a subsystem, type=[SS.type]")
			continue
		var/SSname = "SS[get_last_path_element.group[1]]"
		SSinfluxdriver.enqueue_stats("sstimings", list("ss" = SSname), list("cost" = SS.cost, "tick_overrun" = SS.tick_overrun, "tick_usage" = SS.tick_usage, "times_fired" = SS.times_fired))

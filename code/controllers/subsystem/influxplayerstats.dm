SUBSYSTEM_DEF(influxplayerstats)
	name = "Influx Player Stats"
	wait = 1 MINUTES
	priority = SS_PRIORITY_INFLUXPLAYERSTATS
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	// The different stats we're recording for each mob
	var/list/stat_types = list()
	// Recorded stats
	var/list/recorded_stats = list()

	var/list/currentrun = list()

/datum/controller/subsystem/influxplayerstats/Initialize()
	for(var/typepath in subtypesof(/datum/player_stats))
		var/datum/player_stats/stat = new typepath()
		recorded_stats[stat.key] = list()
		stat_types += stat

	return SS_INIT_SUCCESS


/datum/controller/subsystem/influxplayerstats/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.mob_list

	for(var/key in recorded_stats)
		for(var/entry in recorded_stats[key])
			recorded_stats[entry] = 0


	while(length(src.currentrun))
		var/mob/target = currentrun[length(currentrun)]
		currentrun.len--

		for(var/datum/player_stats/stat as anything in src.stat_types)
			if(!stat.is_relevant(target))
				continue
			var/list/data = recorded_stats[stat.key]
			var/grouping = stat.group_by(target)
			if(!(grouping in data))
				data[grouping] = 0
			data[grouping] += 1

		if(MC_TICK_CHECK)
			return

	for(var/key in recorded_stats)
		SSinfluxdriver.enqueue_stats(key, list(), recorded_stats[key])

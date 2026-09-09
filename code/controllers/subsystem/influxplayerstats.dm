#define IPS_GROUND_LEVEL "ground"
#define IPS_SHIP_LEVEL "ship"

SUBSYSTEM_DEF(influxplayerstats)
	name = "InfluxDB Player Stats"
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
	recorded_stats[IPS_GROUND_LEVEL] = list()
	recorded_stats[IPS_SHIP_LEVEL] = list()

	for(var/typepath in subtypesof(/datum/influx_player_stats))
		var/datum/influx_player_stats/stat = new typepath()
		recorded_stats[IPS_GROUND_LEVEL][stat.key] = list()
		recorded_stats[IPS_SHIP_LEVEL][stat.key] = list()
		stat_types += stat

	return SS_INIT_SUCCESS


/datum/controller/subsystem/influxplayerstats/fire(resumed = FALSE)
	if(!resumed)
		currentrun = GLOB.human_mob_list + GLOB.xeno_mob_list + GLOB.marker_mob_list

	for(var/datum/influx_player_stats/stat as anything in stat_types)
		var/list/ground_level = recorded_stats[IPS_GROUND_LEVEL][stat.key]
		var/list/ship_level = recorded_stats[IPS_SHIP_LEVEL][stat.key]
		for(var/entry in ground_level)
			ground_level[entry] = 0
		for(var/entry in ship_level)
			ship_level[entry] = 0


	while(length(currentrun))
		var/mob/target = currentrun[length(currentrun)]
		currentrun.len--

		if(QDELETED(target) || should_block_game_interaction(target, TRUE))
			continue

		var/turf/target_turf = get_turf(target)
		var/list/level_stats
		if(is_mainship_level(target_turf.z) || is_reserved_level(target_turf.z))
			level_stats = recorded_stats[IPS_SHIP_LEVEL]
		else if(is_ground_level(target_turf.z))
			level_stats = recorded_stats[IPS_GROUND_LEVEL]
		else
			// Some unknown level, skip
			continue

		for(var/datum/influx_player_stats/stat as anything in stat_types)
			if(!stat.is_relevant(target))
				continue
			var/list/data = level_stats[stat.key]
			var/grouping = stat.group_by(target)
			if(isnull(grouping))
				continue
			if(!istext(grouping))
				stack_trace("Tried to use an invalid grouping value: [grouping]")
				continue
			if(!(grouping in data))
				data[grouping] = 0
			data[grouping] += 1

		if(MC_TICK_CHECK)
			return

	for(var/datum/influx_player_stats/stat as anything in stat_types)
		var/list/ship_level_data = recorded_stats[IPS_SHIP_LEVEL][stat.key]
		var/list/ground_level_data = recorded_stats[IPS_GROUND_LEVEL][stat.key]
		if(length(ship_level_data))
			SSinfluxdriver.enqueue_stats(stat.key, list("level" = IPS_SHIP_LEVEL), ship_level_data)
		if(length(ground_level_data))
			SSinfluxdriver.enqueue_stats(stat.key, list("level" = IPS_GROUND_LEVEL), ground_level_data)

#undef IPS_GROUND_LEVEL
#undef IPS_SHIP_LEVEL

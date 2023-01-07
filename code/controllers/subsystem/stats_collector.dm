/// Collects simple round statistics periodically
SUBSYSTEM_DEF(stats_collector)
	name   = "Round Stats"
	wait   = 30 SECONDS
	priority  = SS_PRIORITY_PAGER_STATUS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags  = SS_KEEP_TIMING | SS_NO_INIT

	var/stat_ticks = 0
	var/players_counter = 0

/datum/controller/subsystem/stats_collector/fire(resumed = FALSE)
	players_counter += length(GLOB.clients)
	stat_ticks++

/datum/controller/subsystem/stats_collector/proc/get_avg_players()
	return players_counter / stat_ticks

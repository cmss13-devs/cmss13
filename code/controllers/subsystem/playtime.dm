SUBSYSTEM_DEF(playtime)
	name = "Playtime"
	wait = 1 MINUTES
	priority = SS_PRIORITY_PLAYTIME
	flags = SS_NO_INIT | SS_KEEP_TIMING

	var/list/currentrun = list()

/datum/controller/subsystem/playtime/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = clients.Copy()

	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/client/C = currentrun[currentrun.len]
		currentrun.len--
		
		var/mob/M = C.mob
		var/datum/entity/player/P = C.player_data

		if(!M || !M.job || M.stat == DEAD || M.statistic_exempt || !P || !P.playtime_loaded)
			if(MC_TICK_CHECK)
				return
			continue
		
		var/datum/entity/player_time/PTime = LAZYACCESS(P.playtimes, M.job)
		
		if(!PTime)
			PTime = DB_ENTITY(/datum/entity/player_time)
			PTime.player_id = P.id
			PTime.role_id = M.job
			LAZYSET(P.playtimes, M.job, PTime)
		
		PTime.total_minutes += 1
		PTime.save()

		if (MC_TICK_CHECK)
			return
SUBSYSTEM_DEF(playtime)
	name = "Playtime"
	wait = 1 MINUTES
	priority = SS_PRIORITY_PLAYTIME
	flags = SS_NO_INIT | SS_KEEP_TIMING

	var/list/currentrun = list()

/datum/controller/subsystem/playtime/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun

	while (length(currentrun))
		var/client/C = currentrun[length(currentrun)]
		currentrun.len--

		var/mob/M = C.mob
		var/datum/entity/player/P = C.player_data

		var/effective_job

		// skip if player invalid
		if(!M || !P || !P.playtime_loaded)
			effective_job = null
		// assign as observer if ghost or dead
		else if(isobserver(M) || ((M.stat == DEAD) && isliving(M)))
			effective_job = JOB_OBSERVER
		// assign the mob job if it's applicable
		else if(M.job && M.stat != DEAD && !M.statistic_exempt)
			effective_job = M.job
		// else, invalid job or statistic exempt

		if(!effective_job)
			if(MC_TICK_CHECK)
				return
			continue

		var/datum/entity/player_time/PTime = LAZYACCESS(P.playtimes, effective_job)

		if(!PTime)
			PTime = DB_ENTITY(/datum/entity/player_time)
			PTime.player_id = P.id
			PTime.role_id = effective_job
			LAZYSET(P.playtimes, effective_job, PTime)

		PTime.total_minutes++
		PTime.save()

		if (MC_TICK_CHECK)
			return

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

	while (currentrun.len)
		var/client/current_client = currentrun[currentrun.len]
		currentrun.len--

		var/mob/mob = current_client.mob
		var/datum/entity/player/current_player = current_client.player_data

		var/effective_job

		// skip if player invalid
		if(!mob || !current_player || !current_player.playtime_loaded)
			effective_job = null
		// assign as observer if ghost or dead
		else if(isobserver(mob) || ((mob.stat == DEAD) && isliving(mob)))
			effective_job = JOB_OBSERVER
		// assign the mob job if it's applicable
		else if(mob.job && mob.stat != DEAD && !mob.statistic_exempt)
			effective_job = mob.job
		// else, invalid job or statistic exempt

		if(!effective_job)
			if(MC_TICK_CHECK)
				return
			continue

		var/datum/entity/player_time/PTime = LAZYACCESS(current_player.playtimes, effective_job)

		if(!PTime)
			PTime = DB_ENTITY(/datum/entity/player_time)
			PTime.player_id = current_player.id
			PTime.role_id = effective_job
			LAZYSET(current_player.playtimes, effective_job, PTime)

		PTime.total_minutes++
		PTime.save()

		if (MC_TICK_CHECK)
			return

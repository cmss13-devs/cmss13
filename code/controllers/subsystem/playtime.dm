SUBSYSTEM_DEF(playtime)
	name = "Playtime"
	wait = 1 MINUTES
	init_order = SS_INIT_PLAYTIME
	priority = SS_PRIORITY_PLAYTIME
	flags = SS_KEEP_TIMING

	var/list/best_playtimes = list()
	var/list/currentrun = list()

/datum/controller/subsystem/playtime/Initialize()
	get_best_playtimes()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/playtime/proc/get_best_playtimes()
	set waitfor = FALSE
	set background = TRUE

	WAIT_DB_READY

	var/list/datum/view_record/playtime/all_records = DB_VIEW(/datum/view_record/playtime)
	var/list/real_best_playtimes = list()
	for(var/datum/view_record/playtime/record as anything in all_records)
		CHECK_TICK
		if(!real_best_playtimes[record.role_id])
			real_best_playtimes[record.role_id] = list(record.total_minutes, record)
			continue
		if(real_best_playtimes[record.role_id][1] > record.total_minutes)
			continue
		real_best_playtimes[record.role_id] = list(record.total_minutes, record)

	for(var/role_name in real_best_playtimes)
		CHECK_TICK
		var/list/info_list = real_best_playtimes[role_name]
		var/datum/view_record/playtime/record = info_list[2]
		if(!record)
			continue
		var/datum/view_record/players/player = SAFEPICK(DB_VIEW(/datum/view_record/players, DB_COMP("id", DB_EQUALS, record.player_id)))
		if(!player)
			continue
		best_playtimes += list(list("ckey" = player.glob_pt_visibility ? player.ckey : "Anon #[player.id]") + record.get_nanoui_data())

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

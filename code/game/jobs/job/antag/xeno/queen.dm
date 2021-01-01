/datum/job/antag/xenos/queen
	title = JOB_XENOMORPH_QUEEN
	role_ban_alternative = "Queen"
	supervisors = "Queen Mother"
	selection_class = "job_xeno_queen"
	total_positions = 1
	spawn_positions = 1

/datum/job/antag/xenos/queen/set_spawn_positions(var/count)
	return spawn_positions

/datum/job/antag/xenos/queen/transform_to_xeno(var/mob/new_player/NP, var/hive_index)
	var/datum/mind/queen_mind = NP.mind
	var/mob/living/original = queen_mind.current
	queen_mind.setup_xeno_stats()
	var/datum/hive_status/hive = GLOB.hive_datum[hive_index]
	if(hive.living_xeno_queen)
		return

	// Make the list pretty
	var/spawn_list_names = list()
	for(var/T in GLOB.queen_spawns)
		spawn_list_names += get_area(T)

	// Timed input, answer before the time is up
	// H'yup, that's how you do it, ugly as fuck
	var/list/spawn_name = list("temp")
	var/datum/temp = new()
	var/expiration = world.time + MINUTES_2
	spawn()
		src = temp
		spawn_name[1] = input(original, "Where do you want to spawn?") as null|anything in spawn_list_names
	while(spawn_name[1] == "temp")
		if(world.time > expiration)
			del(temp)
			break
		else
			sleep(SECONDS_2)

	var/turf/QS
	for(var/T in GLOB.queen_spawns)
		if(get_area(T) == spawn_name[1])
			QS = get_turf(T)

	// Pick a random one if nothing was picked
	if(isnull(QS))
		QS = get_turf(pick(GLOB.queen_spawns))
		// Support maps without queen spawns
		if(isnull(QS))
			QS = get_turf(pick(GLOB.xeno_spawns))

	QDEL_LIST(GLOB.queen_spawns)

	spawn_start_hive_structs(QS)

	var/mob/living/carbon/Xenomorph/new_queen = new /mob/living/carbon/Xenomorph/Queen(QS, null, hive.hivenumber)
	queen_mind.transfer_to(new_queen)
	queen_mind.name = queen_mind.current.name

	new_queen.generate_name()

	SSround_recording.recorder.track_player(new_queen)

	new_queen.update_icons()

/datum/job/antag/xenos/queen/announce_entry_message(var/mob/new_queen, var/account, var/whitelist_status)
	to_chat(new_queen, "<B>You are now the alien queen!</B>")
	to_chat(new_queen, "<B>Your job is to spread the hive.</B>")
	to_chat(new_queen, "<B>You should start by building a hive core.</B>")
	to_chat(new_queen, "Talk in Hivemind using <strong>;</strong> (e.g. ';Hello my children!')")

/datum/job/antag/xenos/queen/proc/spawn_start_hive_structs(var/turf/T)
	if(!istype(T))
		return

	for(var/obj/effect/landmark/structure_spawner/xenos/X in get_area(T))
		new X.path_to_spawn(X.loc)
		qdel(X)

AddTimelock(/datum/job/antag/xenos/queen, list(
	JOB_XENO_ROLES = 10 HOURS
))

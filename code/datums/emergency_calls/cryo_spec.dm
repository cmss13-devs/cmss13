/datum/emergency_call/cryo_spec
	name = "Marine Cryo Reinforcement (Spec)"
	mob_max = 1
	mob_min = 1
	probability = 0
	objectives = "Assist the USCM forces"
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
	spawn_max_amount = TRUE

/datum/emergency_call/cryo_spec/remove_nonqualifiers(list/datum/mind/candidates_list)
	var/list/datum/mind/candidates_clean = list()
	for(var/datum/mind/single_candidate in candidates_list)
		if(check_timelock(single_candidate.current?.client, JOB_SQUAD_ROLES_LIST, time_required_for_job))
			candidates_clean.Add(single_candidate)
			continue
		if(single_candidate.current)
			to_chat(single_candidate.current, SPAN_WARNING("You didn't qualify for the ERT beacon because you don't have the specialist job unlocked!"))
	return candidates_clean

/datum/emergency_call/cryo_spec/create_member(datum/mind/mind, turf/override_spawn_loc)
	set waitfor = FALSE
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/human = new(spawn_loc)

	if(mind)
		mind.transfer_to(human, TRUE)
	else
		human.create_hud()

	if(!mind)
		FOR_DVIEW(var/obj/structure/machinery/cryopod/pod, 7, human, HIDE_INVISIBLE_OBSERVER)
			if(pod && !pod.occupant)
				pod.go_in_cryopod(human, silent = TRUE)
				break
		FOR_DVIEW_END

	sleep(5)
	human.client?.prefs.copy_all_to(human, JOB_SQUAD_SPECIALIST, TRUE, TRUE)
	arm_equipment(human, /datum/equipment_preset/uscm/spec/cryo,  mind == null, TRUE)
	to_chat(human, SPAN_ROLE_HEADER("You are a Weapons Specialist in the USCM"))
	to_chat(human, SPAN_ROLE_BODY("Your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	to_chat(human, SPAN_BOLDWARNING("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))

	sleep(10)
	if(!mind)
		human.free_for_ghosts()
	to_chat(human, SPAN_BOLD("Objectives: [objectives]"))

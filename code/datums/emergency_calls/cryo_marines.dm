

//whiskey outpost extra marines
/datum/emergency_call/cryo_squad
	name = "Marine Cryo Reinforcements (Squad)"
	mob_max = 10
	mob_min = 1
	probability = 0
	objectives = "Assist the USCM forces"
	max_engineers = 4
	max_medics = 2
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
	var/leaders = 0
	spawn_max_amount = TRUE

/datum/emergency_call/cryo_squad/spawn_candidates(announce, override_spawn_loc, announce_dispatch_message)
	var/datum/squad/marine/cryo/cryo_squad = RoleAuthority.squads_by_type[/datum/squad/marine/cryo]
	leaders = cryo_squad.num_leaders
	. = ..()
	// if(length(members))
	shipwide_ai_announcement("Successfully deployed [mob_max] Foxtrot marines, of which [length(members)] ready for duty.")
	if(mob_max > length(members))
		announce_dchat("Some cryomarines were not taken, use the Join As Freed Mob verb to take one of them.", src)

/datum/emergency_call/cryo_squad/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)

	if(M)
		M.transfer_to(H, TRUE)
	else
		H.create_hud()

	if(!M)
		for(var/obj/structure/machinery/cryopod/pod in view(7,H))
			if(pod && !pod.occupant)
				pod.go_in_cryopod(H, silent = TRUE)
				break

	sleep(5)
	var/datum/squad/marine/cryo/cryo_squad = RoleAuthority.squads_by_type[/datum/squad/marine/cryo]
	if(leaders < cryo_squad.max_leaders && (!M || (HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))))
		leader = H
		leaders++
		H.client?.prefs.copy_all_to(H, JOB_SQUAD_LEADER, TRUE, TRUE)
		arm_equipment(H, /datum/equipment_preset/uscm/leader/cryo, M == null, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Squad Leader in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
		to_chat(H, SPAN_BOLDWARNING("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))
	else if (heavies < max_heavies && (!M || (HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(H.client, JOB_SQUAD_SPECIALIST, time_required_for_job))))
		heavies++
		H.client?.prefs.copy_all_to(H, JOB_SQUAD_SPECIALIST, TRUE, TRUE)
		arm_equipment(H, /datum/equipment_preset/uscm/spec/cryo,  M == null, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Weapons Specialist in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
		to_chat(H, SPAN_BOLDWARNING("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))
	else if (medics < max_medics && (!M || (HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))))
		medics++
		H.client?.prefs.copy_all_to(H, JOB_SQUAD_MEDIC, TRUE, TRUE)
		arm_equipment(H, /datum/equipment_preset/uscm/medic/cryo,  M == null, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Hospital Corpsman in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
		to_chat(H, SPAN_BOLDWARNING("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))
	else if (engineers < max_engineers && (!M || (HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))))
		engineers++
		H.client?.prefs.copy_all_to(H, JOB_SQUAD_ENGI, TRUE, TRUE)
		arm_equipment(H, /datum/equipment_preset/uscm/engineer/cryo,  M == null, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Engineer in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
		to_chat(H, SPAN_BOLDWARNING("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))
	else
		H.client?.prefs.copy_all_to(H, JOB_SQUAD_MARINE, TRUE, TRUE)
		arm_equipment(H, /datum/equipment_preset/uscm/pfc/cryo,  M == null, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Rifleman in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
		to_chat(H, SPAN_BOLDWARNING("If you wish to cryo or ghost upon spawning in, you must ahelp and inform staff so you can be replaced."))

	sleep(10)
	if(!M)
		H.free_for_ghosts()
	to_chat(H, SPAN_BOLD("Objectives: [objectives]"))

/datum/emergency_call/cryo_squad/platoon
	name = "Marine Cryo Reinforcements (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_engineers = 8

/obj/effect/landmark/ert_spawns/distress_cryo
	name = "Distress_Cryo"

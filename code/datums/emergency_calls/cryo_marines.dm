

//whiskey outpost extra marines
/datum/emergency_call/cryo_squad
	name = "Marine Cryo Reinforcements (Squad)"
	mob_max = 15
	mob_min = 1
	probability = 0
	objectives = "Assist the USCM forces"
	max_engineers = 4
	max_medics = 2
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""
	var/leaders = 0

/datum/emergency_call/cryo_squad/spawn_candidates(announce, override_spawn_loc)
	var/datum/squad/marine/cryo/cryo_squad = RoleAuthority.squads_by_type[/datum/squad/marine/cryo]
	leaders = cryo_squad.num_leaders
	return ..()

/datum/emergency_call/cryo_squad/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	var/datum/squad/marine/cryo/cryo_squad = RoleAuthority.squads_by_type[/datum/squad/marine/cryo]
	if(leaders < cryo_squad.max_leaders && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		leaders++
		arm_equipment(H, /datum/equipment_preset/uscm/leader/cryo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Squad Leader in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	else if (medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(H, /datum/equipment_preset/uscm/medic/cryo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Hospital Corpsman in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	else if (engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(H, /datum/equipment_preset/uscm/engineer/cryo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an Engineer in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	else
		arm_equipment(H, /datum/equipment_preset/uscm/pfc/cryo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Rifleman in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))

	sleep(10)
	to_chat(H, SPAN_BOLD("Objectives: [objectives]"))

/datum/emergency_call/cryo_squad/platoon
	name = "Marine Cryo Reinforcements (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_engineers = 8

/obj/effect/landmark/ert_spawns/distress_cryo
	name = "Distress_Cryo"

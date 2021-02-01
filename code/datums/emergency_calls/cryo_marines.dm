

//whiskey outpost extra marines
/datum/emergency_call/cryo_squad
	name = "Marine Cryo Reinforcements (Squad)"
	mob_max = 15
	mob_min = 1
	probability = 0
	objectives = "Assist the USCM forces"
	max_heavies = 4
	max_medics = 2
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

/datum/emergency_call/cryo_squad/create_member(datum/mind/M)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	if (medics < max_medics)
		medics++
		arm_equipment(H, "USCM (Cryo) Squad Medic", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a medic in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	else if (heavies < max_heavies)
		heavies++
		arm_equipment(H, "USCM (Cryo) Squad Engineer", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are an engineer in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))
	else
		arm_equipment(H, "USCM (Cryo) Squad Marine (PFC)", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a private in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("You are here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to the chain of command."))

	sleep(10)
	to_chat(H, SPAN_BOLD("Objectives: [objectives]"))
	RoleAuthority.randomize_squad(H, TRUE) //we force put people in squads so even if we have a max amount of medics / engis we still give them a squad
	H.sec_hud_set_ID()
	H.hud_set_squad()

	GLOB.data_core.manifest_inject(H) //Put people in crew manifest

/datum/emergency_call/cryo_squad/platoon
	name = "Marine Cryo Reinforcements (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_heavies = 8

/obj/effect/landmark/ert_spawns/distress_cryo
	name = "Distress_Cryo"

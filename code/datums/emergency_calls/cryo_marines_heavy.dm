
/*
 *   Heavy DEFCON ERT (with full equipment)
 */

/datum/emergency_call/cryo_squad_equipped
	name = "Marine Cryo Reinforcements (Full Equipment) (Squad)"
	mob_max = 15
	mob_min = 1
	probability = 0
	objectives = "Assist the USCM forces"
	max_heavies = 4
	max_medics = 2
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_cryo
	shuttle_id = ""

	var/leaders = 0

/datum/emergency_call/cryo_squad_equipped/spawn_candidates(announce, override_spawn_loc)
	var/datum/squad/echo/echo_squad = locate() in RoleAuthority.squads
	leaders = echo_squad.num_leaders
	return ..()

/datum/emergency_call/cryo_squad_equipped/create_member(datum/mind/M, var/turf/override_spawn_loc)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	var/datum/squad/echo/echo_squad = locate() in RoleAuthority.squads
	if(leaders < echo_squad.max_leaders)
		leader = H
		leaders++
		arm_equipment(H, /datum/equipment_preset/uscm/leader_equipped/echo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Squad leader in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]."))
	else if (heavies < max_heavies)
		heavies++
		if(prob(40))
			arm_equipment(H, /datum/equipment_preset/uscm/smartgunner_equipped, TRUE, TRUE)
			to_chat(H, SPAN_ROLE_HEADER("You are a smartgunner in the USCM"))
			to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader."))
		else if(prob(20))
			arm_equipment(H, /datum/equipment_preset/uscm/specialist_equipped/echo, TRUE, TRUE)
			to_chat(H, SPAN_ROLE_HEADER("You are a weapons specialist in the USCM"))
			to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader."))
		else
			arm_equipment(H, /datum/equipment_preset/uscm/engineer_equipped/echo, TRUE, TRUE)
			to_chat(H, SPAN_ROLE_HEADER("You are an engineer in the USCM"))
			to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader."))
	else if (medics < max_medics)
		medics++
		arm_equipment(H, /datum/equipment_preset/uscm/medic_equipped/echo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a hospital corpsman in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader."))
	else
		arm_equipment(H, /datum/equipment_preset/uscm/private_equipped/echo, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a private in the USCM"))
		to_chat(H, SPAN_ROLE_BODY("Your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader."))

	sleep(10)
	to_chat(H, SPAN_BOLD("Objectives: [objectives]"))


datum/emergency_call/cryo_squad_equipped/platoon
	name = "Marine Cryo Reinforcements (Full Equipment) (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_heavies = 8

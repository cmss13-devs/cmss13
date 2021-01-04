
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

/datum/emergency_call/cryo_squad_equipped/create_member(datum/mind/M)
	set waitfor = 0
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		name_of_spawn = /obj/effect/landmark/ert_spawns/distress_wo
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	sleep(5)
	if(!leader)
		leader = H
		arm_equipment(H, "USCM Cryo Squad Leader (Equipped)", TRUE, TRUE)
		to_chat(H, SPAN_WARNING("You are a Squad leader in the USCM, your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. </B>"))
	else if (heavies < max_heavies)
		heavies++
		if(prob(40))
			arm_equipment(H, "USCM Cryo Smartgunner (Equipped)", TRUE, TRUE)
			to_chat(H, SPAN_WARNING("You are a smartgunner in the USCM, your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader. </B>"))
		else if(prob(20))
			arm_equipment(H, "USCM Cryo Specialist (Equipped)", TRUE, TRUE)
			to_chat(H, SPAN_WARNING("You are a specialist in the USCM, your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader. </B>"))
		else
			arm_equipment(H, "USCM Cryo Engineer (Equipped)", TRUE, TRUE)
			to_chat(H, SPAN_WARNING("You are an engineer in the USCM, your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader. </B>"))
	else if (medics < max_medics)
		medics++
		arm_equipment(H, "USCM Cryo Medic (Equipped)", TRUE, TRUE)
		to_chat(H, SPAN_WARNING("You are a medic in the USCM, your squad is here to assist in the defence of the [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader. </B>"))
	else
		arm_equipment(H,"USCM Cryo Private (Equipped)", TRUE, TRUE)
		to_chat(H, SPAN_WARNING("You are a private in the USCM, your squad is here to assist in the defence of [SSmapping.configs[GROUND_MAP].map_name]. Listen to [leader.name] they are your (acting) squad leader. </B>"))

	sleep(10)
	to_chat(H, "<B>Objectives:</b> [objectives]")

	RoleAuthority.randomize_squad(H)
	H.sec_hud_set_ID()
	H.hud_set_squad()

	// Have to add radio headsets AFTER squad assignment, because the self-setting headset depends on things set in randomize_squad
	// which also depend on things set in arm_equipment
	// which doesn't just arm equipment, but sets a bunch of other important things . Who knew?
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/almayer/marine/self_setting(H), WEAR_EAR)

	GLOB.data_core.manifest_inject(H) //Put people in crew manifest


datum/emergency_call/cryo_squad_equipped/platoon
	name = "Marine Cryo Reinforcements (Full Equipment) (Platoon)"
	mob_min = 8
	mob_max = 30
	probability = 0
	max_heavies = 8

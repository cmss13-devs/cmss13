// basic halo marines
/datum/emergency_call/unsc
	name = "UNSC Marines (Squad)"
	mob_max = 8
	probability = 20
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_smartgunners = 0
	max_medics = 2
	max_heavies = 2

/datum/emergency_call/unsc/platoon
	name = "UNSC Marines (Platoon)"
	mob_min = 6
	mob_max = 25
	probability = 0
	max_medics = 2
	max_heavies = 2
	max_smartgunners = 0

/datum/emergency_call/unsc/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is the UNSC Vector High responding to your distress call, We've got a squad of marines preparing to board."
	objectives = "Investigate the distress beacon from [MAIN_SHIP_NAME]."


/datum/emergency_call/unsc/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC Marine Squad Leader!"))
		arm_equipment(mob, /datum/equipment_preset/unsc/leader/equipped, TRUE, TRUE)

	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		if(prob(50))
			to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC Marine SPNKR Specialist!"))
			arm_equipment(mob, /datum/equipment_preset/unsc/spec/equipped_spnkr, TRUE, TRUE)
		else
			to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC Marine Sniper Specialist!"))
			arm_equipment(mob, /datum/equipment_preset/unsc/spec/equipped_sniper, TRUE, TRUE)

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC Marine Medic!"))
		arm_equipment(mob, /datum/equipment_preset/unsc/medic/equipped, TRUE, TRUE)

	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC Marine Rifleman!"))
		arm_equipment(mob, /datum/equipment_preset/unsc/pfc/equipped, TRUE, TRUE)

	transfer_marine_to_squad(mob, /datum/squad/marine/solardevils, mob.assigned_squad, mob.wear_id)
	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/unsc/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in the core colonies", 10;"in a frontier colony", 10;"on Reach", 5;"on Earth")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
	to_chat(M, SPAN_BOLD("You joined the UNSC Marines not too long ago."))

// basic halo marines
/datum/emergency_call/unsc/odst
	name = "UNSC ODSTs (Squad)"
	mob_max = 8
	probability = 20
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item

	max_smartgunners = 0
	max_medics = 2
	max_heavies = 2

/datum/emergency_call/unsc/odst/platoon
	name = "UNSC ODSTs (Platoon)"
	mob_min = 6
	mob_max = 25
	probability = 0
	max_medics = 2
	max_heavies = 2
	max_smartgunners = 0

/datum/emergency_call/unsc/odst/New()
	..()
	arrival_message = "[MAIN_SHIP_NAME], this is the UNSC All Under Heaven responding to your distress call, We've got a squad of ODSTs preparing to board."
	objectives = "Investigate the distress beacon from [MAIN_SHIP_NAME]."


/datum/emergency_call/unsc/odst/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	M.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC ODST Squad Leader!"))
		arm_equipment(mob, /datum/equipment_preset/unsc/leader/odst/equipped, TRUE, TRUE)

	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		if(prob(50))
			to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC ODST SPNKR Specialist!"))
			arm_equipment(mob, /datum/equipment_preset/unsc/spec/odst/equipped_spnkr, TRUE, TRUE)
		else
			to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC ODST Sniper Specialist!"))
			arm_equipment(mob, /datum/equipment_preset/unsc/spec/odst/equipped_sniper, TRUE, TRUE)

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC ODST Medic!"))
		arm_equipment(mob, /datum/equipment_preset/unsc/medic/odst/equipped, TRUE, TRUE)

	else
		to_chat(mob, SPAN_ROLE_HEADER("You are a UNSC ODST Rifleman!"))
		arm_equipment(mob, /datum/equipment_preset/unsc/pfc/odst/equipped, TRUE, TRUE)

	transfer_marine_to_squad(mob, /datum/squad/marine/sof, mob.assigned_squad, mob.wear_id)
	print_backstory(mob)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)


/datum/emergency_call/unsc/odst/print_backstory(mob/living/carbon/human/M)
	to_chat(M, SPAN_BOLD("You were born [pick(75;"in the core colonies", 10;"in a frontier colony", 10;"on Reach", 5;"on Earth")] to a [pick(75;"well-off", 15;"well-established", 10;"average")] family."))
	to_chat(M, SPAN_BOLD("You joined the veteran ODSTs a while ago."))

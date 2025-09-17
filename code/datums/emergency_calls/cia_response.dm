/datum/emergency_call/cia_grs
	name = "CIA Strike Team (FRIENDLY)"
	mob_min = 4
	mob_max = 8
	probability = 0
	max_medics = 1
	max_engineers = 1
	max_heavies = 1
	max_smartgunners = 1

	shuttle_id = MOBILE_SHUTTLE_ID_ERT5

	hostility = FALSE
	var/is_deathsquad = FALSE

/datum/emergency_call/cia_grs/hostile
	name = "CIA Strike Team (Hostile)"
	hostility = TRUE

/datum/emergency_call/cia_grs/deathsquad
	name = "CIA Strike Team (Hostile !DEATHSQUAD!)"
	hostility = TRUE
	is_deathsquad = TRUE

/datum/emergency_call/cia_grs/large
	name = "CIA Strike Team (Reinforced) (Friendly)"
	mob_min = 8
	mob_max = 24
	probability = 0
	max_medics = 3
	max_engineers = 3
	max_heavies = 2
	max_smartgunners = 2

/datum/emergency_call/cia_grs/large/hostile
	name = "CIA Strike Team (Reinforced) (HOSTILE)"
	hostility = TRUE

/datum/emergency_call/cia_grs/large/deathsquad
	name = "CIA Strike Team (Reinforced) (Hostile !DEATHSQUAD!)"
	hostility = TRUE
	is_deathsquad = TRUE

/datum/emergency_call/cia_grs/New()
	. = ..()
	if(hostility)
		arrival_message = "[MAIN_SHIP_NAME], this is shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
		objectives = "Terminate the crew of the [MAIN_SHIP_NAME]. Obey your Team Leader and any senior CIA agents present. Leave no witnesses."
	else
		arrival_message = "[MAIN_SHIP_NAME], this is shuttle [pick(GLOB.alphabet_lowercase)][pick(GLOB.alphabet_lowercase)]-[rand(1, 99)] responding to your distress call. Prepare for boarding."
		objectives = "Help the crew of the [MAIN_SHIP_NAME]. Obey your Team Leader and any senior CIA agents present. Your survival, and that of your fellow operators and CIA agents, is more valuable than the Almayer."

/datum/emergency_call/cia_grs/print_backstory(mob/living/carbon/human/H)
	to_chat(H, SPAN_BOLD("You are a highly trained operator working for the CIA Global Response Staff."))
	to_chat(H, SPAN_BOLD("Drawn from United Americas Special Forces, and in some cases from the Special Forces of the TWE, you represent some of the best armed personnel in UA space."))
	to_chat(H, SPAN_NOTICE(SPAN_BOLD("Your team have been tasked to assist the [MAIN_SHIP_NAME].")))
	to_chat(H, SPAN_NOTICE(SPAN_BOLD("Ensure they are not destroyed, but not at the cost of your lives.")))
	if(hostility)
		to_chat(H, SPAN_WARNING(FONT_SIZE_HUGE("YOU ARE HOSTILE to the USCM unless otherwise specified by staff.")))
	else
		to_chat(H, SPAN_WARNING(FONT_SIZE_HUGE("YOU ARE FRIENDLY to the USCM unless otherwise specified by staff.")))

/datum/emergency_call/cia_grs/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = H
		if(!is_deathsquad)
			if(!hostility)
				arm_equipment(H, /datum/equipment_preset/cia_global_response/leader, TRUE, TRUE)
			else
				arm_equipment(H, /datum/equipment_preset/cia_global_response/leader/no_iff, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/cia_global_response/leader/deathsquad, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the Global Response Team Leader!"))

	else if(smartgunners < max_smartgunners && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		smartgunners++
		if(!is_deathsquad)
			if(!hostility)
				arm_equipment(H, /datum/equipment_preset/cia_global_response/heavy, TRUE, TRUE)
			else
				arm_equipment(H, /datum/equipment_preset/cia_global_response/heavy/no_iff, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/cia_global_response/heavy/deathsquad, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Global Response Heavy Operator!"))

	else if(heavies < max_heavies && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(H.client, JOB_SQUAD_SMARTGUN, time_required_for_job))
		heavies++
		if(!is_deathsquad)
			if(!hostility)
				arm_equipment(H, /datum/equipment_preset/cia_global_response/sniper, TRUE, TRUE)
			else
				arm_equipment(H, /datum/equipment_preset/cia_global_response/sniper/no_iff, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/cia_global_response/sniper/deathsquad, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Global Response Advanced Marksman!"))

	else if(medics < max_medics && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(H.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		if(!is_deathsquad)
			if(!hostility)
				arm_equipment(H, /datum/equipment_preset/cia_global_response/medic, TRUE, TRUE)
			else
				arm_equipment(H, /datum/equipment_preset/cia_global_response/medic/no_iff, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/cia_global_response/medic/deathsquad, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Global Response Medic!"))

	else if(engineers < max_engineers && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(H.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		if(!is_deathsquad)
			if(!hostility)
				arm_equipment(H, /datum/equipment_preset/cia_global_response/engineer, TRUE, TRUE)
			else
				arm_equipment(H, /datum/equipment_preset/cia_global_response/engineer/no_iff, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/cia_global_response/engineer/deathsquad, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Global Response Technician!"))

	else
		if(!is_deathsquad)
			if(!hostility)
				arm_equipment(H, /datum/equipment_preset/cia_global_response/standard, TRUE, TRUE)
			else
				arm_equipment(H, /datum/equipment_preset/cia_global_response/standard/no_iff, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/cia_global_response/standard/deathsquad, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a Global Response Operator!"))
	print_backstory(H)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

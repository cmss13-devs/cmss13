/datum/emergency_call/solar_devils
	name = "USCM Solar Devils (Half Squad)"
	arrival_message = "This is the Solar Devils of the USCM 2nd Division, responding to your distress beacon. Don't worry, the grown-ups are here to clean up your mess."
	objectives = "Assist local Marine forces in dealing with whatever issue they can't handle. Further orders may be forthcoming."
	home_base = /datum/lazy_template/ert/uscm_station
	probability = 0
	mob_min = 3
	mob_max = 5

	max_medics = 1
	max_smartgunners = 1

/datum/emergency_call/solar_devils/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/tl_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the Solar Devils Team Leader!"))

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/medic_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the Solar Devils Platoon Corpsman!"))

	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are the Solar Devils Smartgunner!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/sg_pve, TRUE, TRUE)

	else
		arm_equipment(mob, /datum/equipment_preset/uscm/rifleman_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a Solar Devils Rifleman!"))

	to_chat(mob, SPAN_ROLE_BODY("You are a member of the 3rd Battalion 'Solar Devils', part of the USCM's 2nd Division, 1st Regiment. Unlike most of the USS Almayer's troops, you are well-trained and properly-equipped career marines. Semper Fidelis."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/solar_devils_full
	name = "USCM Solar Devils (Full Squad)"
	arrival_message = "This is the Solar Devils of the USCM 2nd Division, responding to your distress beacon. Don't worry, the grown-ups are here to clean up your mess."
	objectives = "Assist local Marine forces in dealing with whatever issue they can't handle. Further orders may be forthcoming."
	home_base = /datum/lazy_template/ert/uscm_station
	probability = 0
	mob_min = 3
	mob_max = 10

	max_engineers = 2
	max_medics = 1
	max_smartgunners = 2

/datum/emergency_call/solar_devils_full/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/sl_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the Solar Devils Platoon Leader!"))

	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		engineers++
		arm_equipment(mob, /datum/equipment_preset/uscm/tl_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a Solar Devils Team Leader!"))

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/medic_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the Solar Devils Platoon Corpsman!"))

	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a Solar Devils Smartgunner!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/sg_pve, TRUE, TRUE)

	else
		arm_equipment(mob, /datum/equipment_preset/uscm/rifleman_pve, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a Solar Devils Rifleman!"))

	to_chat(mob, SPAN_ROLE_BODY("You are a member of the 3rd Battalion 'Solar Devils', part of the USCM's 2nd Division, 1st Regiment. Unlike most of the USS Almayer's troops, you are well-trained and properly-equipped career marines. Semper Fidelis."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

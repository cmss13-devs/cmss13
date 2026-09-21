
/datum/emergency_call/us_army
	name = "US Army (32nd Armor)"
	home_base = /datum/lazy_template/ert/uscm_station
	mob_min = 1
	mob_max = 14
	probability = 0
	shuttle_id = ""
	chance_hidden = 0
	name_of_spawn = /obj/effect/landmark/ert_spawns/groundside_army

	max_heavies = 2
	max_medics = 2
	max_smartgunners = 2

/datum/emergency_call/us_army/New()
	..()
	arrival_message = "Break, break. This is USS Victory, local Army elements confirm your sector is free of hostile tangos. Be advised, the 32nd Armour is en-route, forward elements should be entering your AO shortly to assist in mop-up. You may have just saved a lot of lives today Falling Falcons. Over and out."
	objectives = "Assist the Marines in securing the area of operations."

/datum/emergency_call/us_army/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/us_army/sl, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the US Army Squad Leader!"))

	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a US Army Tank Crewman!"))
		arm_equipment(mob, /datum/equipment_preset/us_army/tank, TRUE, TRUE)

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/us_army/medic, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the US Army Medic!"))

	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a US Army Gunner!"))
		arm_equipment(mob, /datum/equipment_preset/us_army/gunner, TRUE, TRUE)

	else
		arm_equipment(mob, /datum/equipment_preset/us_army/standard, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a US Army Trooper!"))

	to_chat(mob, SPAN_ROLE_BODY("You are a member of the US Army 32nd Armored Division. You and your division have been held in reserve until the Falling Falcons could secure a beachhead. Now that this is true, you are being sent in to help secure the breach!"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

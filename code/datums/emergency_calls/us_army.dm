
/datum/emergency_call/us_army
	name = "US Army (32nd Armor)"
	home_base = /datum/lazy_template/ert/uscm_station
	mob_min = 1
	mob_max = 10
	probability = 0
	shuttle_id = ""
	name_of_spawn = /obj/effect/landmark/ert_spawns/groundside_army

	max_heavies = 1
	max_medics = 1
	max_smartgunners = 1

/datum/emergency_call/us_army/New()
	..()
	arrival_message = "This is USS Victory, well done Almayer. The 32nd Armour is en-route, the forward elements should be entering your AO shortly to assist in mop-up. You may have just saved a lot of lives today Falling Falcons."
	objectives = "Assist the Marines in securing the area of operations."

/datum/emergency_call/us_army/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/squad_leader, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the FORECON Squad Leader!"))

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/tech, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the FORECON Support Technician!"))

	else if(smartgunners < max_smartgunners && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(mob.client, JOB_SQUAD_SMARTGUN))
		smartgunners++
		to_chat(mob, SPAN_ROLE_HEADER("You are a FORECON Smartgunner!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/smartgunner, TRUE, TRUE)

	else if(heavies < max_heavies && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_HEAVY) && check_timelock(mob.client, JOB_SQUAD_SPECIALIST))
		heavies++
		to_chat(mob, SPAN_ROLE_HEADER("You are a FORECON Designated Marskman!"))
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/marksman, TRUE, TRUE)

	else
		arm_equipment(mob, /datum/equipment_preset/uscm/forecon/standard, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a FORECON Rifleman!"))

	to_chat(mob, SPAN_ROLE_BODY("You are a member of the USCM's Force Reconnisance. FORECON is a force that specializes in special operations behind enemy lines, or conducting reconnisance in situations regular Marines are not expected to handle."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

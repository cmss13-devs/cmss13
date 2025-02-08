/datum/emergency_call/cbrn
	name = "CBRN (Squad)"
	arrival_message = "Attention, this is the USS Kurtz, we have dispatched a CBRN squad to your ship per your distress call. Stand by for arrival."
	objectives = "Handle the chemical, biological, radiological, or nuclear threat. Further orders may be provided."
	home_base = /datum/lazy_template/ert/uscm_station
	mob_min = 3
	mob_max = 5
	max_heavies = 0
	max_smartgunners = 0

/datum/emergency_call/cbrn/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/leader, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the CBRN Fireteam Leader!"))

	else if(medics < max_medics && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(mob.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/medic, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the CBRN Squad Medic!"))

	else if(engineers < max_engineers && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_ENGINEER) && check_timelock(mob.client, JOB_SQUAD_ENGI, time_required_for_job))
		engineers++
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/engineer, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the CBRN Squad Engineer!"))

	else
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/standard, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a CBRN Squad Rifleman!"))

	to_chat(mob, SPAN_ROLE_BODY("You are a member of the USCM's CBRN. The CBRN is a force that specializes in handling chemical, biological, radiological, and nuclear threats."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

/datum/emergency_call/cbrn/ert
	name = "CBRN (Distress)"
	arrival_message = "Attention, this is the USS Kurtz, we have dispatched a CBRN squad to your ship per your distress call. Stand by for arrival."
	probability = 10

/datum/emergency_call/cbrn/ert/New()
	..()
	objectives = "Investigate the distress signal aboard the [MAIN_SHIP_NAME]."

/datum/emergency_call/cbrn/specialists
	name = "CBRN (Specialists)"
	mob_min = 2
	mob_max = 5
	max_engineers = 0
	max_medics = 0

/datum/emergency_call/cbrn/specialists/New()
	var/cbrn_ship_name = "Unit [pick(GLOB.nato_phonetic_alphabet)]-[rand(1, 99)]"
	arrival_message = "[MAIN_SHIP_NAME], CBRN [cbrn_ship_name] has been dispatched. Follow all orders provided by [cbrn_ship_name]."
	objectives = "You are a specialist team in [cbrn_ship_name] dispatched to quell a threat to [MAIN_SHIP_NAME]. Further orders may be provided."

/datum/emergency_call/cbrn/specialists/create_member(datum/mind/new_mind, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	new_mind.transfer_to(mob, TRUE)

	if(!leader && HAS_FLAG(mob.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(mob.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = mob
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/specialist/lead, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are the CBRN Specialist Squad Leader!"))
	else
		arm_equipment(mob, /datum/equipment_preset/uscm/cbrn/specialist, TRUE, TRUE)
		to_chat(mob, SPAN_ROLE_HEADER("You are a CBRN Specialist!"))

	to_chat(mob, SPAN_ROLE_BODY("You are a member of the USCM's CBRN. The CBRN is a force that specializes in handling chemical, biological, radiological, and nuclear threats."))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), mob, SPAN_BOLD("Objectives:</b> [objectives]")), 1 SECONDS)

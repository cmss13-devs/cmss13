


//Weyland-Yutani Deathsquad - W-Y Deathsquad. Event only
/datum/emergency_call/death
	name = "Weyland Whiteout Operators (!DEATHSQUAD!)"
	mob_max = 8
	mob_min = 5
	arrival_message = "'!`2*%slau#*jer t*h$em a!l%. le&*ve n(o^ w&*nes%6es.*v$e %#d ou^'"
	objectives = "Whiteout protocol is in effect for the target. Ensure there are no traces of the infestation or any witnesses."
	probability = 0
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	item_spawn = /obj/effect/landmark/ert_spawns/distress_pmc/item
	max_medics = 1
	max_heavies = 2
	hostility = TRUE


// DEATH SQUAD--------------------------------------------------------------------------------
/datum/emergency_call/death/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/person = new(spawn_loc)
	player.transfer_to(person, TRUE)

	if(!leader && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(person.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = person
		to_chat(person, SPAN_ROLE_HEADER("You are the Whiteout Team Leading Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/leader, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(person.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(person, SPAN_ROLE_HEADER("You are a Whiteout Team Support Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(person.client, list(JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN), time_required_for_job))
		heavies++
		to_chat(person, SPAN_ROLE_HEADER("You are a Whiteout Team Cloaker Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/cloaker, TRUE, TRUE)
	else
		to_chat(person, SPAN_ROLE_HEADER("You are a Whiteout Team Combat Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout, TRUE, TRUE)

	to_chat(person, SPAN_WARNING(FONT_SIZE_HUGE("YOU ARE [hostility? "HOSTILE":"FRIENDLY"] to the USCM")))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), person, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/death/low_threat
	name = "Weyland Whiteout Operators"

// DEATH SQUAD--------------------------------------------------------------------------------
/datum/emergency_call/death/low_threat/create_member(datum/mind/player, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/person = new(spawn_loc)
	player.transfer_to(person, TRUE)

	if(!leader && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(person.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = person
		to_chat(person, SPAN_ROLE_HEADER("You are the Whiteout Team Leading Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat/leader, TRUE, TRUE)
	else if(medics < max_medics && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_MEDIC) && check_timelock(person.client, JOB_SQUAD_MEDIC, time_required_for_job))
		medics++
		to_chat(person, SPAN_ROLE_HEADER("You are a Whiteout Team Support Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat/medic, TRUE, TRUE)
	else if(heavies < max_heavies && HAS_FLAG(person.client.prefs.toggles_ert, PLAY_SMARTGUNNER) && check_timelock(person.client, list(JOB_SQUAD_SPECIALIST, JOB_SQUAD_SMARTGUN), time_required_for_job))
		heavies++
		to_chat(person, SPAN_ROLE_HEADER("You are a Whiteout Team Cloaker Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat/cloaker, TRUE, TRUE)
	else
		to_chat(person, SPAN_ROLE_HEADER("You are a Whiteout Team Combat Unit!"))
		to_chat(person, SPAN_ROLE_BODY("Whiteout protocol is in effect for the target, all assets onboard are to be liquidated with expediency unless otherwise instructed by Weyland Yutani personnel holding the position of Director or above."))
		arm_equipment(person, /datum/equipment_preset/pmc/w_y_whiteout/low_threat, TRUE, TRUE)

	to_chat(person, SPAN_WARNING(FONT_SIZE_HUGE("YOU ARE [hostility? "HOSTILE":"FRIENDLY"] to the USCM")))

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), person, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

//################################################################################################
// Marine commandos - USCM Deathsquad. Event only
/datum/emergency_call/marsoc
	name = "Marine Raider Operatives (!DEATHSQUAD!)"
	mob_max = 8
	mob_min = 5
	probability = 0
	shuttle_id = MOBILE_SHUTTLE_ID_ERT2
	home_base = /datum/lazy_template/ert/weyland_station
	name_of_spawn = /obj/effect/landmark/ert_spawns/distress_pmc
	var/leader_preset = /datum/equipment_preset/uscm/marsoc/sl
	var/member_preset = /datum/equipment_preset/uscm/marsoc

/datum/emergency_call/marsoc/create_member(datum/mind/player, turf/override_spawn_loc)

	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/member = new(spawn_loc)
	player.transfer_to(member, TRUE)

	if(!leader && HAS_FLAG(member.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(member.client, JOB_SQUAD_LEADER, time_required_for_job))    //First one spawned is always the leader.
		leader = member
		to_chat(member, SPAN_WARNING(FONT_SIZE_BIG("You are a Marine Raider Team Leader, better than all the rest.")))
		arm_equipment(member, leader_preset, TRUE, TRUE)
	else
		to_chat(member, SPAN_WARNING(FONT_SIZE_BIG("You are an elite Marine Raider Operative, the best of the best.")))
		arm_equipment(member, member_preset, TRUE, TRUE)
	to_chat(member, SPAN_BOLDNOTICE("You are absolutely loyal to High Command and must follow their directives."))
	to_chat(member, SPAN_BOLDNOTICE("Execute the mission assigned to you with extreme prejudice!"))
	return

/datum/emergency_call/marsoc/covert
	name = "Marine Raider Operatives (!DEATHSQUAD! Covert)"
	leader_preset = /datum/equipment_preset/uscm/marsoc/sl/covert
	member_preset = /datum/equipment_preset/uscm/marsoc/covert


/datum/emergency_call/marsoc/low_threat
	name = "Marine Raider Operatives"
	leader_preset = /datum/equipment_preset/uscm/marsoc/low_threat/sl
	member_preset = /datum/equipment_preset/uscm/marsoc/low_threat

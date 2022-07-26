
//A gaggle of gladiators
/datum/emergency_call/pirates
	name = "Fun - Pirates"
	mob_max = 35
	mob_min = 10
	arrival_message = "Intercepted Transmission: 'What shall we do with a drunken sailor? What shall we do with a drunken sailor? What shall we do with a drunken sailor early in the morning?'"
	objectives = "Pirate! Loot! Ransom!"
	probability = 0
	hostility = TRUE

/datum/emergency_call/pirates/create_member(datum/mind/M, var/turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)
	if(!leader && HAS_FLAG(H.client.prefs.toggles_ert, PLAY_LEADER) && check_timelock(H.client, JOB_SQUAD_LEADER, time_required_for_job))
		leader = H
		arm_equipment(H, /datum/equipment_preset/fun/pirate/captain, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the leader of these jolly pirates!"))
		to_chat(H, SPAN_ROLE_BODY("Loot this place for all its worth! Take everything of value that's not nailed down!"))
	else
		arm_equipment(H, /datum/equipment_preset/fun/pirate, TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a jolly pirate! Yarr!"))
		to_chat(H, SPAN_ROLE_BODY("Loot this place for all its worth! Take everything of value that's not nailed down!"))

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

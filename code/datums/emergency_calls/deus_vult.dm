
//A gaggle of gladiators
/datum/emergency_call/deus_vult
	name = "Deus Vult!"
	mob_max = 35
	mob_min = 10
	max_heavies = 10
	arrival_message = "Intercepted Transmission: 'Deus le volt. Deus le volt! DEUS LE VOLT!!'"
	objectives = "Clense the place of all that is unholy! Die in glory!"
	probability = 0
	hostility = TRUE

/datum/emergency_call/deus_vult/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Gladiator Leader", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are the leader of these holy warriors!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the unholy from this wretched place!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from the Higher Power!"))
	else if(heavies < max_heavies)
		heavies++
		arm_equipment(H, "Gladiator Champion", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a champion of the holy warriors!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the unholy from this wretched place!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from the Higher Power!"))
	else
		arm_equipment(H, "Gladiator", TRUE, TRUE)
		to_chat(H, SPAN_ROLE_HEADER("You are a holy warrior!"))
		to_chat(H, SPAN_ROLE_BODY("You must clear out any traces of the unholy from this wretched place!"))
		to_chat(H, SPAN_ROLE_BODY("Follow any orders directly from the Higher Power!"))

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

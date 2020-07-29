
//A gaggle of gladiators
/datum/emergency_call/pirates
	name = "Fun - Pirates"
	mob_max = 35
	mob_min = 10
	arrival_message = "Intercepted Transmission: 'What shall we do with a drunken sailor? What shall we do with a drunken sailor? What shall we do with a drunken sailor early in the morning?'"
	objectives = "Pirate! Loot! Ransom!"
	probability = 0
	hostility = TRUE

/datum/emergency_call/pirates/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Fun - Pirate Captain", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are the leader of these jolly pirates!</font>")
		to_chat(H, "<B> Loot this place for all its worth! Take everything of value that's not nailed down!</b>")
	else
		arm_equipment(H, "Fun - Pirate", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are a jolly pirate! Yarr!</font>")
		to_chat(H, "<B> Loot this place for all its worth! Take everything of value that's not nailed down!</b>")

	sleep(10)
	to_chat(H, "<B>Objectives:</b> [objectives]")

	return
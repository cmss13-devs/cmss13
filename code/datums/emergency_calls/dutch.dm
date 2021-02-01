//Dutch's Dozen!... well, Dutch's Half Dozen

/datum/emergency_call/dutch
	name = "Dutch's Dozen"
	mob_max = 6
	mob_min = 4
	max_heavies = 1
	arrival_message = "Intercepted Transmission: 'We're here to kick ass and kill Yautja. Mainly kill Yautja."
	objectives = "Hunt down and kill all Yautja without mercy. Retrieve the gear and leave."
	probability = 0

/datum/emergency_call/dutch/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Dutch's Dozen - Arnold", TRUE, TRUE)
	else if(heavies < max_heavies)
		heavies++
		arm_equipment(H, "Dutch's Dozen - Minigun", TRUE, TRUE)
	else
		arm_equipment(H, "Dutch's Dozen - Soldier", TRUE, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

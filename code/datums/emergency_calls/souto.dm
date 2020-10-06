//Best ert ever

/datum/emergency_call/souto
	name = "Souto Man"
	mob_max = 1
	mob_min = 1
	arrival_message = "Incoming Transmission: 'Get ready to be: Souto'd! Souto Man wants to party with the man who sent in 10 Thousand souto cans to get me here!"
	objectives = "Party like it's 1999!"
	probability = 0

/datum/emergency_call/souto/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, "Souto Man", TRUE, TRUE)

	to_chat(H, "<font size='3'>\red You are Souto Man! You should bring awareness to souto!</font>")
	to_chat(H, "Your job is to deliver your souto. Shoot those marines!")

	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, "<B>Objectives:</b> [objectives]"), 1 SECONDS)

/datum/emergency_call/souto/cryo
	name = "Souto Man (Cryo)"
	probability = 0
	name_of_spawn = "Distress_Cryo"
	shuttle_id = ""
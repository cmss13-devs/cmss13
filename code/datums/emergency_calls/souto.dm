//Best ert ever

/datum/emergency_call/souto
	name = "Souto Man"
	mob_max = 1
	mob_min = 1
	arrival_message = "Incoming Transmission: 'Get ready to be: Souto'd! Souto Man wants to party with the man who sent in 10 Thousand souto cans to get me here!"
	objectives = "Party like it's 1999!"
	probability = 0

/datum/emergency_call/souto/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	mob.key = M.key
	if(mob.client) mob.client.change_view(world.view)
	ticker.mode.traitors += mob.mind

	arm_equipment(mob, "Souto Man", TRUE, TRUE)

	to_chat(mob, "<font size='3'>\red You are Souto Man! You should bring awareness to souto!</font>")
	to_chat(mob, "Your job is to deliver your souto. Shoot those marines!")

	sleep(10)
	to_chat(M, "<B>Objectives:</b> [objectives]")

/datum/emergency_call/souto/cryo
	name = "Souto Man (Cryo)"
	probability = 0
	name_of_spawn = "Distress_Cryo"
	shuttle_id = ""

//A gaggle of gladiators
/datum/emergency_call/deus_vult
	name = "Deus Vult!"
	mob_max = 35
	mob_min = 10
	max_heavies = 10
	arrival_message = "Intercepted Transmission: 'Deus le volt. Deus le volt! DEUS LE VOLT!!'"
	objectives = "Clense the place of all that is unholy! Die in glory!"
	probability = 0

/datum/emergency_call/deus_vult/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	H.key = M.key
	if(H.client)
		H.client.change_view(world.view)
	ticker.mode.traitors += H.mind

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, "Gladiator Leader", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are the leader of these holy warriors!</font>")
		to_chat(H, "<B> You must clear out any traces of the unholy from this wretched place!</b>")
		to_chat(H, "<B> Follow any orders directly from the Higher Power!</b>")
	else if(heavies < max_heavies)
		arm_equipment(H, "Gladiator Champion", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are a champion of the holy warriors!</font>")
		to_chat(H, "<B> You must clear out any traces of the unholy from this wretched place!</b>")
		to_chat(H, "<B> Follow any orders directly from the Higher Power!</b>")
		heavies++
	else
		arm_equipment(H, "Gladiator", TRUE, TRUE)
		to_chat(H, "<font size='3'>\red You are a holy warrior!</font>")
		to_chat(H, "<B> You must clear out any traces of the unholy from this wretched place!</b>")
		to_chat(H, "<B> Follow any orders directly from the Higher Power!</b>")

	sleep(10)
	to_chat(H, "<B>Objectives:</b> [objectives]")

	return
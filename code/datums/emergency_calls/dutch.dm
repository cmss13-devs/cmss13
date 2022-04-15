//Dutch's Dozen!... well, Dutch's Half Dozen

/datum/emergency_call/dutch
	name = "Dutch's Dozen"
	mob_max = 6
	mob_min = 4
	max_heavies = 1
	max_medics = 1
	arrival_message = "Intercepted Transmission: 'We're here to kick ass and kill Yautja. Mainly kill Yautja."
	objectives = "Hunt down and kill all Yautja without mercy. Retrieve the gear and leave."
	probability = 0

/datum/emergency_call/dutch/create_member(datum/mind/M, var/turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(!leader)       //First one spawned is always the leader.
		leader = H
		arm_equipment(H, /datum/equipment_preset/fun/dutch/arnie, TRUE, TRUE)
	else if(heavies < max_heavies)
		heavies++
		if(prob(50))
			arm_equipment(H, /datum/equipment_preset/fun/dutch/minigun, TRUE, TRUE)
		else
			arm_equipment(H, /datum/equipment_preset/fun/dutch/flamer, TRUE, TRUE)
	else if(medics < max_medics)
		medics++
		arm_equipment(H, /datum/equipment_preset/fun/dutch/medic, TRUE, TRUE)
	else
		arm_equipment(H, /datum/equipment_preset/fun/dutch, TRUE, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/dutch/full_dozen //AWWW YEAH DA FULL DOZEN FO TODAY
	name = "Dutch's Dozen - Full Strength"
	mob_max = 12
	mob_min = 8
	max_heavies = 2
	max_medics = 2
	arrival_message = "Intercepted Transmission: 'We're here to kick ass and kill Yautja. Mainly kill Yautja."
	objectives = "Hunt down and kill all Yautja without mercy. Retrieve the gear and leave."
	probability = 0

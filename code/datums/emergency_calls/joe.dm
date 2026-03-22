/datum/emergency_call/joe
	name = "Fun - Working Joe"
	mob_max = 25
	mob_min = 1
	arrival_message = "The Joes Have Arrived."
	objectives = "Joe everyone!"
	probability = 1

/datum/emergency_call/joe/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	if(prob(70))
		arm_equipment(H, /datum/equipment_preset/synth/working_joe, TRUE, TRUE)
	else
		arm_equipment(H, /datum/equipment_preset/synth/working_joe/engi, TRUE, TRUE)
	to_chat(H, SPAN_ROLE_HEADER("You are a joe!"))
	to_chat(H, SPAN_ROLE_BODY("Save the non-joes!"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

/datum/emergency_call/joe/upp
	name = "Fun - UPP Fighting Joe"
	mob_max = 12
	mob_min = 1
	arrival_message = "The Fighting Joes Have Arrived."
	objectives = "Exterminate all non-UPP personell."
	hostility = TRUE

/datum/emergency_call/joe/upp/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)


	arm_equipment(H, /datum/equipment_preset/synth/working_joe/upp/fighting, TRUE, TRUE)
	to_chat(H, SPAN_ROLE_HEADER("You are a combat synthetic!"))
	to_chat(H, SPAN_ROLE_BODY("Exterminate all non-UPP personell!"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

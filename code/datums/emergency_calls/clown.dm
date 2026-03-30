/datum/emergency_call/clown
	name = "Fun - Clown Squad"
	mob_max = 8
	mob_min = 1
	arrival_message = "Honk!"
	objectives = "Tell jokes and make people happy!"
	probability = 1

/datum/emergency_call/clown/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)


	arm_equipment(H, /datum/equipment_preset/fun/clown, TRUE, TRUE)
	to_chat(H, SPAN_ROLE_HEADER("You are a clown!"))
	to_chat(H, SPAN_ROLE_BODY("Make everyone laugh!"))
	to_chat(H, SPAN_WARNING(FONT_SIZE_HUGE("YOU ARE [hostility? "HOSTILE":"FRIENDLY"] to the USCM.")))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)

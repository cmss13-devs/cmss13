// The Order of HEFA has arrived!
/datum/emergency_call/hefa_knight
	name = "HEFA knights"
	mob_max = 15
	mob_min = 3
	arrival_message = "'Приготовьтесь сдаться в распоряжение ГЕФА!'"
	objectives = "Вы - брат ордена ГЕФА! Вы и ваши братья должны вернуть как можно больше ГЕФА!"
	probability = 0
	hostility = TRUE

/datum/emergency_call/hefa_knight/create_member(datum/mind/M, turf/override_spawn_loc)
	var/turf/spawn_loc = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/fun/hefa/melee, FALSE, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), H, SPAN_BOLD("Objectives: [objectives]")), 1 SECONDS)


	to_chat(H, SPAN_WARNING(FONT_SIZE_HUGE("YOU ARE [hostility? "HOSTILE":"FRIENDLY"] to the USCM")))

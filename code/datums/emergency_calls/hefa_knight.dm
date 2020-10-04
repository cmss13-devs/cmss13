// The Order of HEFA has arrived!
/datum/emergency_call/hefa_knight
	name = "HEFA knights"
	mob_max = 15
	mob_min = 3
	arrival_message = "Intercepted Transmission: 'Prepaerth to surrender thine HEFAs unto the order!'"
	objectives = "You are a Brother of the Order of HEFA! You and your fellow brothers must retrieve as many HEFAs as possible!"
	probability = 0
	hostility = TRUE

/datum/emergency_call/hefa_knight/create_member(datum/mind/M)
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)

	arm_equipment(H, "HEFA Knight - Melee", FALSE, TRUE)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, H, "<B>Objectives:</b> [objectives]"), 1 SECONDS)

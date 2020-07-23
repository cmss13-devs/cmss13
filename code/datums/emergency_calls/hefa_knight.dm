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
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/H = new(spawn_loc)
	M.transfer_to(H, TRUE)
	ticker.mode.traitors += H.mind

	arm_equipment(H, "HEFA Knight - Melee", FALSE, TRUE)
	sleep(10)
	to_chat(H, "<B>Objectives:</b> [objectives]")

	return

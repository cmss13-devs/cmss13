
/datum/emergency_call/zombie
	name = "Zombies"
	mob_max = 8
	mob_min = 1
	probability = 0
	auto_shuttle_launch = TRUE //can't use the shuttle console with zombie claws, so has to autolaunch.
	hostility = TRUE


/datum/emergency_call/zombie/create_member(datum/mind/M, var/turf/override_spawn_loc)
	set waitfor = 0
	var/turf/T = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(T))
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	M.transfer_to(H, TRUE)

	arm_equipment(H, /datum/equipment_preset/other/zombie, TRUE, TRUE)

	sleep(20)
	if(H && H.loc)
		to_chat(H, SPAN_ROLE_HEADER("You are a Zombie!"))
		to_chat(H, SPAN_ROLE_BODY("Spread... Consume... Infect..."))

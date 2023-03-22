
/datum/emergency_call/zombie
	name = "Zombies"
	mob_max = 8
	mob_min = 1
	probability = 0
	auto_shuttle_launch = TRUE //can't use the shuttle console with zombie claws, so has to autolaunch.
	hostility = TRUE


/datum/emergency_call/zombie/create_member(datum/mind/M, turf/override_spawn_loc)
	set waitfor = 0
	var/turf/current_turf = override_spawn_loc ? override_spawn_loc : get_spawn_point()

	if(!istype(current_turf))
		return FALSE

	var/mob/living/carbon/human/human = new(current_turf)
	M.transfer_to(human, TRUE)

	arm_equipment(human, /datum/equipment_preset/other/zombie, TRUE, TRUE)

	sleep(20)
	if(human && human.loc)
		to_chat(human, SPAN_ROLE_HEADER("You are a Zombie!"))
		to_chat(human, SPAN_ROLE_BODY("Spread... Consume... Infect..."))

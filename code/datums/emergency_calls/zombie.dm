
/datum/emergency_call/zombie
	name = "Zombies"
	mob_max = 8
	mob_min = 1
	probability = 0
	auto_shuttle_launch = TRUE //can't use the shuttle console with zombie claws, so has to autolaunch.
	hostility = TRUE


/datum/emergency_call/zombie/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/T = get_spawn_point()

	if(!istype(T)) 
		return FALSE

	var/mob/living/carbon/human/H = new(T)
	H.key = M.key
	if(H.client) H.client.change_view(world.view)
	ticker.mode.traitors += H.mind
	arm_equipment(H, "Zombie", TRUE, TRUE)

	sleep(20)
	if(H && H.loc)
		to_chat(H, SPAN_ROLE_HEADER("You are a Zombie!"))
		to_chat(H, SPAN_ROLE_BODY("Spread... Consume... Infect..."))

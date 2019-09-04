// The Order of HEFA has arrived!
/datum/emergency_call/hefa_knight
	name = "HEFA knights"
	mob_max = 15
	mob_min = 3
	arrival_message = "Intercepted Transmission: 'Prepaerth to surrender thine HEFAs unto the order!'"
	objectives = "You are a Brother of the Order of HEFA! You and your fellow brothers must retrieve as many HEFAs as possible!"
	probability = 0

/datum/emergency_call/hefa_knight/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc)) return //Didn't find a useable spawn point.

	var/mob/living/carbon/human/mob = new(spawn_loc)
	mob.key = M.key
	if(mob.client) mob.client.change_view(world.view)
	ticker.mode.traitors += mob.mind

	arm_equipment(mob, "HEFA Knight - Melee", FALSE, TRUE)
	sleep(10)
	to_chat(M, "<B>Objectives:</b> [objectives]")

	return

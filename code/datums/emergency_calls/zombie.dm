
/datum/emergency_call/zombie
	name = "Zombies"
	mob_max = 8
	mob_min = 1
	probability = 0
	auto_shuttle_launch = TRUE //can't use the shuttle console with zombie claws, so has to autolaunch.


/datum/emergency_call/zombie/create_member(datum/mind/M)
	set waitfor = 0
	var/turf/T = get_spawn_point()
	var/mob/original = M.current

	if(!istype(T)) r_FAL

	var/mob/living/carbon/human/H = new(T)
	H.dna.ready_dna(H)
	H.key = M.key
	if(H.client) H.client.change_view(world.view)
	ticker.mode.traitors += H.mind
	arm_equipment(H, "Zombie", TRUE)

	sleep(20)
	if(H && H.loc)
		H << "<span class='role_header'>You are a Zombie!</span>"
		H << "<span class='role_body'>Spread... Consume... Infect...</span>"

	if(original && original.loc)
		cdel(original)
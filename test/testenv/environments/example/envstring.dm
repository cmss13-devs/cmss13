// Simple test environment that demonstrates usage of environment strings
// This makes a 11x6 room with a spec, a drone and a gun in it
/datum/test_environment/example/envstring
	environment_string = {"
		HHHHHHHHHHH
		HFFFFFFFFFH
		HFFgFFFFFFH
		HFFFFmFFdFH
		HFFFFFFFFFH
		HHHHHHHHHHH
	"}

	// The mob we're spawning in
	var/mob/test_mob = null

// Spawn in a gun at g and a mob at m
/datum/test_environment/example/envstring/populate(character, char_turf)
	// Give em some flooring
	new /turf/open/floor/almayer(char_turf)

	switch(character)
		if("g")
			new /obj/item/weapon/gun/rifle/m41a(char_turf)
		if("m")
			test_mob = new /mob/living/carbon/human(char_turf)
		if("d")
			new /mob/living/carbon/Xenomorph/Drone(char_turf)

// Key into the mob
/datum/test_environment/example/envstring/insert_actors()
	set waitfor = FALSE

	// Wait for a client to key in
	while(!length(clients))
		sleep(10)

	for(var/client/C in clients)
		var/datum/mind/M = C.mob.mind
		M.transfer_to(test_mob)

		// Equip the mob as a spec
		arm_equipment(test_mob, "USCM Cryo Specialist (Equipped)", TRUE, TRUE)

		break

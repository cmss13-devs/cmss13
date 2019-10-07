// Test that all predator items are deleted on SD
/datum/test_case/explosion/deletion
	name = "Predator SD"
	var/testing_z = -1

// Set up a 3x3 room to run the explosion in
/datum/test_case/explosion/deletion/setUp()
	// Create a test Z level
	world.maxz = world.maxz + 1
	testing_z = world.maxz

	var/turf/min = locate(1, 1, testing_z)
	var/turf/max = locate(5, 5, testing_z)
	for(var/turf/T in block(min, max))
		var/turf_type = /turf/open/floor/almayer
		if(T.x == 1 || T.y == 1 || T.x == 5 || T.y == 5)
			turf_type = /turf/closed/wall/almayer/outer

		new turf_type(T)

/datum/test_case/explosion/deletion/test()
	var/turf/middle_turf = locate(3, 3, testing_z)

	// Spawn the pred and equip them
	var/mob/living/carbon/human/yautja/predator = new(middle_turf)
	arm_equipment(predator, "Yautja Blooded", FALSE, FALSE)

	var/obj/item/clothing/gloves/yautja/bracer = predator.gloves
	assertTrue(!isnull(bracer))

	// Trigger the SD
	bracer.explodey(predator)

	// Wait for the windup
	sleep(90)

	// Wait for the explosion to finish
	var/explosion_alive = TRUE
	while(explosion_alive)
		explosion_alive = FALSE
		for(var/datum/automata_cell/explosion/E in cellauto_cells)
			if(E.explosion_source == "yautja self destruct")
				explosion_alive = TRUE
				break
		sleep(1)

	// Give everything some time to delete
	sleep(10)

	// Make sure there are only gibs left
	var/turf/min = locate(2, 2, testing_z)
	var/turf/max = locate(4, 4, testing_z)
	for(var/turf/T in block(min, max))
		for(var/atom/A in T)
			if(A.disposed)
				continue
			// Only gibs allowed
			assertTrue(istype(A, /obj/effect))

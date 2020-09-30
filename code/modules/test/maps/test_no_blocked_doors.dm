/datum/test_case/map/turf_blocks_doors
	name = "Dense turfs shouldn't be inside doors"

/datum/test_case/map/turf_blocks_doors/test()
	// Store all the blocked doors we found
	var/list/blocked_doors = list()

	for(var/area/A in all_areas)
		if(!A.z)
			continue

		for(var/turf/T in A)
			if(!T.density)
				continue

			var/obj/structure/machinery/door/D = locate() in T
			if(!D)
				continue

			blocked_doors += "[D] at ([T.x], [T.y], [T.z]) - in [A.name]"

	// Check that no blocked doors were found
	if(blocked_doors.len)
		var/fail_msg = "found [blocked_doors.len] doors containing dense turfs:\n"
		for(var/location in blocked_doors)
			fail_msg += "[location]\n"

		fail(fail_msg)

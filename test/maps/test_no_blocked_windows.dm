/datum/test_case/map/turf_blocks_windows
	name = "Dense turfs shouldn't be inside windows"

/datum/test_case/map/turf_blocks_doors/test()
	// Store all the blocked windows we found
	var/list/blocked_windows = list()

	for(var/area/A in all_areas)
		if(!A.z)
			continue

		for(var/turf/T in A)
			if(!T.density)
				continue

			var/obj/structure/window/W = locate() in T
			if(!W)
				continue

			blocked_windows += "[W] at ([T.x], [T.y], [T.z]) - in [A.name]"

	// Check that no blocked windows were found
	if(blocked_windows.len)
		var/fail_msg = "found [blocked_windows.len] windows containing dense turfs:\n"
		for(var/location in blocked_windows)
			fail_msg += "[location]\n"

		fail(fail_msg)

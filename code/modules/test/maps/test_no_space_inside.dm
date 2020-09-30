/datum/test_case/map/space_in_areas
	name = "There should be no space turfs in non-space areas"

/datum/test_case/map/space_in_areas/test()
	// Store all the space turfs we found here
	var/list/space_turfs = list()

	for(var/area/A in all_areas)
		if(!A.z)
			continue

		// Don't check areas that are exempt from the test
		if(A.test_exemptions & MAP_TEST_EXEMPTION_SPACE)
			continue

		for(var/turf/open/space/S in A)
			// Only base space turfs
			if(!(S.type == /turf/open/space))
				continue
			space_turfs += "([S.x], [S.y], [S.z]) - in [A.name]"

	// Check that no space turfs were found
	if(space_turfs.len)
		var/fail_msg = "found [space_turfs.len] space turfs in non-space areas:\n"
		for(var/location in space_turfs)
			fail_msg += "[location]\n"

		fail(fail_msg)

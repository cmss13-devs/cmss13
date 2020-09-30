/datum/test_case/map/pipes_connected
	name = "All pipes should be properly connected"

/datum/test_case/map/pipes_connected/test()
	// Store all unconnected pipes we found
	var/list/improper_pipes = list()

	for(var/area/A in all_areas)
		if(!A.z)
			continue

		for(var/turf/T in A)
			var/obj/structure/pipes/P = locate() in T
			if(!P)
				continue

			// Check if the pipe is intentionally a broken segment
			if(findtext(P.icon_state, "exposed"))
				continue

			var/fail = FALSE
			var/is_special = FALSE

			if(!length(P.connected_to))
				fail = TRUE

			var/check_connections = 0
			for(var/direction in P.valid_directions)
				for(var/obj/structure/pipes/target in get_step(P, direction))
					check_connections++
					break
				
			if(istype(P, /obj/structure/pipes/vents))
				is_special = TRUE

			if(istype(P, /obj/structure/pipes/unary))
				is_special = TRUE
			
			if(!is_special && check_connections != length(P.valid_directions))
				to_world("failed [check_connections] and [length(P.valid_directions)]")
				fail = TRUE

			if(is_special && (check_connections < 1 || 4 < check_connections))
				fail = TRUE

			if(!fail)
				continue

			improper_pipes += "([T.x], [T.y], [T.z]) - in [A.name]"

	// Check that there were no improperly connected pipes
	if(improper_pipes.len)
		var/fail_msg = "found [improper_pipes.len] improperly connected pipe segments:\n"
		for(var/location in improper_pipes)
			fail_msg += "[location]\n"

		fail(fail_msg)

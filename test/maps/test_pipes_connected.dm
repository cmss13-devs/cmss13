/datum/test_case/map/pipes_connected
	name = "All pipes should be properly connected"

/datum/test_case/map/pipes_connected/test()
	// Store all unconnected pipes we found
	var/list/improper_pipes = list()

	for(var/area/A in all_areas)
		if(!A.z)
			continue

		for(var/turf/T in A)
			var/obj/structure/machinery/atmospherics/pipe/P = locate() in T
			if(!P)
				continue

			// Check if the pipe is intentionally a broken segment
			if(findtext(P.icon_state, "exposed"))
				continue

			var/fail = FALSE

			// Endcaps should have 1 connection
			if(istype(P, /obj/structure/machinery/atmospherics/pipe/cap))
				var/obj/structure/machinery/atmospherics/pipe/cap/PC = P
				if(!PC.node)
					fail = TRUE

			// Simple pipes should have 2 connections
			else if(istype(P, /obj/structure/machinery/atmospherics/pipe/simple))
				var/obj/structure/machinery/atmospherics/pipe/simple/SP = P
				if(!SP.node1 || !SP.node2)
					fail = TRUE

			// Manifolds should have 3 connections
			else if(istype(P, /obj/structure/machinery/atmospherics/pipe/manifold))
				var/obj/structure/machinery/atmospherics/pipe/manifold/M = P
				if(!M.node1 || !M.node2 || !M.node3)
					fail = TRUE

			// 4-way manifolds should have 4 connections
			else if(istype(P, /obj/structure/machinery/atmospherics/pipe/manifold4w))
				var/obj/structure/machinery/atmospherics/pipe/manifold4w/M = P
				if(!M.node1 || !M.node2 || !M.node3 || !M.node4)
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

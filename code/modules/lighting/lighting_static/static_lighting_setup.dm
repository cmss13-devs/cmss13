/proc/create_all_lighting_objects()
	for(var/turf/turf in world) // area contents loops are in-world loops, so we may as well do one directly
		var/area/area = turf.loc
		if(!area.static_lighting)
			continue
		new /atom/movable/static_lighting_object(turf)
		CHECK_TICK

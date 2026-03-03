/proc/create_all_lighting_objects()
	for(var/area/A in GLOB.all_areas)
		if(!A.static_lighting)
			continue

		for(var/list/turf_list in A.get_zlevel_turf_lists())
			for(var/turf/T in turf_list)
				new/datum/static_lighting_object(T)
				CHECK_TICK
		CHECK_TICK

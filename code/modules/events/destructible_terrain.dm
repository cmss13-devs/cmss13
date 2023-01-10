//Enables destructible terrain on the ground level
/proc/enable_destructible_terrain()
	var/list/turfs = get_all_of_type(/turf/closed/wall, TRUE)
	for(var/turf/closed/wall/turf_for_editing in turfs)
		if(turf_for_editing.z != 3)
			//We only want to edit ground turfs!
			continue
		if(istype(turf_for_editing, /turf/closed/shuttle))
			//Don't edit the map boundary!
			continue
		turf_for_editing.hull = FALSE

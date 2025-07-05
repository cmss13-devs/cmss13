//Toggles the destructible terrain on the ground level
/proc/toggle_destructible_terrain()
	var/list/turfs = get_all_of_type(/turf/closed/wall, TRUE)
	for(var/turf/closed/wall/turf_for_editing in turfs)
		if(!is_ground_level(turf_for_editing.z))
			//We only want to edit ground turfs!
			continue
		//If the initial wall was indestructible, we toggle indestructability
		if(initial(turf_for_editing.turf_flags) & TURF_HULL)
			//Note: wall boundaries are safe since they are /turf/closed/shuttle, so not a subset of /turf/closed/wall!
			turf_for_editing.turf_flags &= ~TURF_HULL

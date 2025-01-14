/turf/proc/update_icon() //Base parent. - Abby
	if(QDELETED(src))
		return FALSE

	overlays.Cut()

	//smooth wall stuff
	if(!special_icon)
		icon_state = "blank"
		var/image/I

		flags_atom |= HTML_USE_INITAL_ICON

		for(var/i = 1 to 4)
			I = image(icon, "[get_base_icon()][wall_connections[i]]", dir = 1<<(i-1))
			overlays += I

	update_overlays()

	return TRUE

/turf/proc/update_connections(propagate = FALSE)
	var/list/turf_dirs = list()

	for(var/turf/turf in orange(src, 1))
		switch(can_join_with(turf))
			if(FALSE)
				continue
			if(TRUE)
				turf_dirs += get_dir(src, turf)
		if(propagate)
			turf.update_connections()
			turf.update_icon()

	for(var/turf/turf in orange(src, 1))
		var/success = 0
		for(var/obj/obj in turf)
			for(var/b_type in blend_objects)
				if(istype(obj, b_type))
					success = TRUE
				for(var/nb_type in noblend_objects)
					if(istype(obj, nb_type))
						success = FALSE
				if(success)
					break
			if(success)
				break

		if(success)
			if(get_dir(src, turf) in GLOB.cardinals)
				turf_dirs += get_dir(src, turf)

	for(var/neighbor in turf_dirs)
		neighbors_list |= neighbor
	wall_connections = dirs_to_corner_states(turf_dirs)

/turf/proc/can_join_with(turf/target_turf)
	if(target_turf.type == type)
		return TRUE
	for(var/wb_type in blend_turfs)
		for(var/nb_type in noblend_turfs)
			if(istype(target_turf, nb_type))
				return FALSE
		if(istype(target_turf, wb_type))
			return TRUE
	return FALSE

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to length(ret))
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE

/turf/proc/get_base_icon()
	return base_icon

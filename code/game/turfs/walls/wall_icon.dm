#define BULLETHOLE_STATES 10 //How many variations of bullethole patterns there are
#define BULLETHOLE_MAX 8 * 3 //Maximum possible bullet holes.
//Formulas. These don't need to be defines, but helpful green. Should likely reuse these for a base 8 icon system.
#define cur_increment(v) round((v-1)/8)+1
/turf/closed/wall/update_icon()
	..()
	if(disposed)
		return
	
	if(!damage_overlays[1]) //list hasn't been populated
		generate_damage_overlays()

	overlays.Cut()
	//smooth wall stuff
	if(!special_icon)
		icon_state = "blank"
		var/image/I

		if(!density)
			I = image(icon, "[wall2text(walltype)]fwall_open")
			overlays += I
			return

		for(var/i = 1 to 4)
			I = image(icon, "[wall2text(walltype)][wall_connections[i]]", dir = 1<<(i-1))
			overlays += I

	if(!damage)
		damage_overlay = initial(damage_overlay)
		current_bulletholes = initial(current_bulletholes)
		bullethole_increment = initial(current_bulletholes)
		bullethole_state = initial(current_bulletholes)
	else
		var/dmg_overlay = round(damage / damage_cap * damage_overlays.len) + 1
		if(dmg_overlay > damage_overlays.len) dmg_overlay = damage_overlays.len

		damage_overlay = dmg_overlay
		overlays += damage_overlays[damage_overlay]

		if(current_bulletholes > BULLETHOLE_MAX) //Could probably get away with a unique layer, but let's keep it standardized.
			overlays += bullethole_overlay

		else if(current_bulletholes && current_bulletholes <= BULLETHOLE_MAX)
			if(!bullethole_overlay)
				bullethole_state = rand(1, BULLETHOLE_STATES)
				bullethole_overlay = image('icons/effects/bulletholes.dmi', src, "bhole_[bullethole_state]_[bullethole_increment]")
			if(cur_increment(current_bulletholes) > bullethole_increment) bullethole_overlay.icon_state = "bhole_[bullethole_state]_[++bullethole_increment]"
			overlays += bullethole_overlay

#undef BULLETHOLE_STATES
#undef BULLETHOLE_MAX
#undef cur_increment

/turf/closed/wall/proc/generate_damage_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/closed/wall/proc/update_connections(propagate = 0)
	var/list/wall_dirs = list()

	for(var/turf/closed/wall/W in orange(src, 1))
		switch(can_join_with(W))
			if(0)
				continue
			if(1)
				wall_dirs += get_dir(src, W)
		if(propagate)
			W.update_connections()
			W.update_icon()

	for(var/turf/T in orange(src, 1))
		var/success = 0
		for(var/obj/O in T)
			for(var/b_type in blend_objects)
				if(istype(O, b_type))
					success = 1
				for(var/nb_type in noblend_objects)
					if(istype(O, nb_type))
						success = 0
				if(success)
					break
			if(success)
				break

		if(success)
			if(get_dir(src, T) in cardinal)
				wall_dirs += get_dir(src, T)

	for(var/neighbor in wall_dirs)
		neighbors_list |= neighbor
	wall_connections = dirs_to_corner_states(wall_dirs)

/turf/closed/wall/proc/can_join_with(var/turf/closed/wall/W)
	if(W.type == src.type)
		return 1
	for(var/wb_type in blend_turfs)
		if(istype(W, wb_type))
			return 1
	return 0

#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs)) return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
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
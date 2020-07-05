/atom/movable/Move(NewLoc, direct)
	var/atom/oldloc = loc
	var/old_dir = dir

	. = ..()
	if (flags_atom & DIRLOCK)
		dir = old_dir
	else
		if (old_dir & EAST|WEST) // Can no longer face NW/NE/SW/SE after moving/being moved
			dir &= NORTH|SOUTH
		else
			dir &= EAST|WEST
	l_move_time = world.time
	if ((oldloc != loc && oldloc && oldloc.z == z))
		last_move_dir = get_dir(oldloc, loc)
	if (.)
		Moved(oldloc,direct)

/atom/movable/proc/Collide(atom/A)
	if (throwing)
		launch_impact(A)

	if (A && !A.disposed)
		A.last_bumped = world.time
		A.Collided(src)
	return

/atom/movable/Collided(atom/movable/AM)
	if(isliving(AM) && !anchored)
		var/target_dir = get_dir(AM, src)
		var/turf/target_turf = get_step(loc, target_dir)
		Move(target_turf)
	return

/atom/movable/proc/Moved(atom/OldLoc,Dir)
	if (isturf(loc))
		if (opacity)
			OldLoc.UpdateAffectingLights()
		else
			if (light)
				light.changed()
	return

/atom/movable/proc/forceMove(atom/destination)
	if (destination)
		if (pulledby)
			pulledby.stop_pulling()
		var/oldLoc
		if (loc)
			oldLoc = loc
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		var/area/old_area
		if (oldLoc)
			old_area = get_area(oldLoc)
		var/area/new_area = get_area(destination)
		if (new_area && old_area != new_area)
			new_area.Entered(src)
		for (var/atom/movable/AM in destination)
			if (AM == src)
				continue
			AM.Crossed(src)
		if (oldLoc)
			Moved(oldLoc,dir)
		return 1
	return 0
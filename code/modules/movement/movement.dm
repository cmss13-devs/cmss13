/atom/proc/Collided(atom/movable/AM)
	return

/atom/Cross(atom/movable/AM)
	return TRUE

/atom/Exit(atom/movable/AM)
	return TRUE

/*
 *	Checks whether an atom can pass through the calling atom into its target turf.
 *	Returns the blocking direction.
 *		If the atom's movement is not blocked, returns 0.
 *		If the object is completely solid, returns ALL
 */
/atom/proc/BlockedPassDirs(atom/movable/mover, target_dir)
	var/reverse_dir = REVERSE_DIR(dir)
	var/flags_can_pass = LIST_FLAGS_ADD(pass_flags.flags_can_pass_all, flags_can_pass_all_temp, pass_flags.flags_can_pass_front, flags_can_pass_front_temp)
	var/mover_flags_pass = LIST_FLAGS_ADD(mover.pass_flags.flags_pass, mover.flags_pass_temp)

	if (!density || LIST_FLAGS_COMPARE(flags_can_pass, mover_flags_pass))
		return NO_BLOCKED_MOVEMENT

	if (flags_atom & ON_BORDER)
		if (!(target_dir & reverse_dir))
			return NO_BLOCKED_MOVEMENT
		
		// This is to properly handle diagonal movement (a cade to your NE facing west when you are trying to move NE should block for north instead of east)
		if (target_dir & (NORTH|SOUTH) && target_dir & (EAST|WEST))
			return target_dir - (target_dir & reverse_dir)
		return target_dir & reverse_dir
	else
		return BLOCKED_MOVEMENT

/*
 *	Checks whether an atom can leave its current turf through the calling atom.
 *	Returns the blocking direction.
 *		If the atom's movement is not blocked, returns 0 (no directions)
 *		If the object is completely solid, returns all directions
 */
/atom/proc/BlockedExitDirs(atom/movable/mover, target_dir)
	var/flags_can_pass = LIST_FLAGS_ADD(pass_flags.flags_can_pass_all, flags_can_pass_all_temp, pass_flags.flags_can_pass_behind, flags_can_pass_behind_temp)
	var/mover_flags_pass = LIST_FLAGS_ADD(mover.pass_flags.flags_pass, mover.flags_pass_temp)

	if(flags_atom & ON_BORDER && density && !(LIST_FLAGS_COMPARE(flags_can_pass, mover_flags_pass)))
		return target_dir & dir

	return NO_BLOCKED_MOVEMENT

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

	if (A && !QDELETED(A))
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
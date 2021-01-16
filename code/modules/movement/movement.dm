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
	var/flags_can_pass = pass_flags.flags_can_pass_all|flags_can_pass_all_temp|pass_flags.flags_can_pass_front|flags_can_pass_front_temp
	var/mover_flags_pass = mover.pass_flags.flags_pass|mover.flags_pass_temp

	if (!density || (flags_can_pass & mover_flags_pass))
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
	var/flags_can_pass = pass_flags.flags_can_pass_all|flags_can_pass_all_temp|pass_flags.flags_can_pass_behind|flags_can_pass_behind_temp
	var/mover_flags_pass = mover.pass_flags.flags_pass|mover.flags_pass_temp

	if(flags_atom & ON_BORDER && density && !(flags_can_pass & mover_flags_pass))
		return target_dir & dir

	return NO_BLOCKED_MOVEMENT

/atom/movable/Move(NewLoc, direct)
	// If Move is not valid, exit
	if (SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, NewLoc) & COMPONENT_CANCEL_MOVE)
		return FALSE

	var/atom/oldloc = loc
	var/old_dir = dir

	. = ..()
	if (flags_atom & DIRLOCK)
		setDir(old_dir)
	else
		if (old_dir & EAST|WEST) // Can no longer face NW/NE/SW/SE after moving/being moved
			dir &= NORTH|SOUTH
		else
			dir &= EAST|WEST
	l_move_time = world.time
	if ((oldloc != loc && oldloc && oldloc.z == z))
		last_move_dir = get_dir(oldloc, loc)
	if (.)
		Moved(oldloc, direct)

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

/atom/movable/proc/Moved(atom/oldloc, direction, Forced = FALSE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, oldloc, direction, Forced)
	if (isturf(loc))
		if (opacity)
			oldloc.UpdateAffectingLights()
		else
			if (light)
				light.changed()
	return TRUE

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE
	if(destination)
		. = doMove(destination)
	else
		CRASH("No valid destination passed into forceMove")


/atom/movable/proc/moveToNullspace()
	return doMove(null)


/atom/movable/proc/doMove(atom/destination)
	. = FALSE
	if(destination)
		if(pulledby)
			pulledby.stop_pulling()
		var/atom/oldloc = loc
		var/same_loc = oldloc == destination
		var/area/old_area = get_area(oldloc)
		var/area/destarea = get_area(destination)

		loc = destination

		if(!same_loc)
			if(oldloc)
				oldloc.Exited(src, destination)
				if(old_area && old_area != destarea)
					old_area.Exited(src, destination)
			for(var/atom/movable/AM in oldloc)
				AM.Uncrossed(src)
//			var/turf/oldturf = get_turf(oldloc)  // TODO: maploader
//			var/turf/destturf = get_turf(destination)
//			var/old_z = (oldturf ? oldturf.z : null)
//			var/dest_z = (destturf ? destturf.z : null)
//			if(old_z != dest_z)
//				onTransitZ(old_z, dest_z)
			destination.Entered(src, oldloc)
			if(destarea && old_area != destarea)
				destarea.Entered(src, oldloc)

			for(var/atom/movable/AM in destination)
				if(AM == src)
					continue
				AM.Crossed(src, oldloc)

		Moved(oldloc, NONE, TRUE)
		. = TRUE

	//If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE
		if (loc)
			var/atom/oldloc = loc
			var/area/old_area = get_area(oldloc)
			oldloc.Exited(src, null)
			if(old_area)
				old_area.Exited(src, null)
		loc = null

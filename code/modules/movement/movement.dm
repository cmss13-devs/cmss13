/atom/proc/Collided(atom/movable/AM)
	return

/atom/Cross(atom/movable/AM)
	return TRUE

/atom/Exit(atom/movable/AM)
	return TRUE

/*
 * Checks whether an atom can pass through the calling atom into its target turf.
 * Returns the blocking direction.
 * If the atom's movement is not blocked, returns 0.
 * If the object is completely solid, returns ALL
 */
/atom/proc/BlockedPassDirs(atom/movable/mover, target_dir)
	if(!mover || !mover.pass_flags)
		return NO_BLOCKED_MOVEMENT

	if(!density)
		return NO_BLOCKED_MOVEMENT

	var/flags_can_pass = pass_flags?.flags_can_pass_all|flags_can_pass_all_temp|pass_flags?.flags_can_pass_front|flags_can_pass_front_temp
	var/mover_flags_pass = mover.pass_flags.flags_pass|mover.flags_pass_temp

	if(flags_can_pass & mover_flags_pass)
		return NO_BLOCKED_MOVEMENT

	if (flags_atom & ON_BORDER)
		var/reverse_dir = REVERSE_DIR(dir)
		var/tile_width = mover.bound_width/world.icon_size
		var/tile_height = mover.bound_height/world.icon_size
		// Assumes that bounds (in terms of tiles) are always gonna to be odd numbers, even tile widths with custom bounds will need to be calculated separately
		if (tile_height > 1 || tile_width > 1)
			var/bound_west = mover.x - floor(tile_width/2)
			var/bound_east = mover.x + floor(tile_width/2)
			var/bound_south = mover.y - floor(tile_height/2)
			var/bound_north = mover.y + floor(tile_height/2)
			if ((x > bound_west || dir & EAST) && (x < bound_east || dir & WEST))
				return BLOCKED_MOVEMENT
			if ((y > bound_south || dir & NORTH) && (y < bound_north || dir & SOUTH))
				return BLOCKED_MOVEMENT
		if (!(target_dir & reverse_dir))
			return NO_BLOCKED_MOVEMENT

		// This is to properly handle diagonal movement (a cade to your NE facing west when you are trying to move NE should block for north instead of east)
		if(IS_DIAGONAL_DIR(target_dir))
			return target_dir - (target_dir & reverse_dir)
		return target_dir & reverse_dir
	else
		return BLOCKED_MOVEMENT

/*
 * Checks whether an atom can leave its current turf through the calling atom.
 * Returns the blocking direction.
 * If the atom's movement is not blocked, returns 0 (no directions)
 * If the object is completely solid, returns all directions
 */
/atom/proc/BlockedExitDirs(atom/movable/mover, target_dir)
	if(!mover || !mover.pass_flags)
		return NO_BLOCKED_MOVEMENT

	var/flags_can_pass = pass_flags?.flags_can_pass_all|flags_can_pass_all_temp|pass_flags?.flags_can_pass_behind|flags_can_pass_behind_temp
	var/mover_flags_pass = mover.pass_flags.flags_pass|mover.flags_pass_temp

	if(flags_atom & ON_BORDER && density && !(flags_can_pass & mover_flags_pass))
		return target_dir & dir

	return NO_BLOCKED_MOVEMENT

// TODO: Remove any and all overrides of this proc
/atom/movable/Move(NewLoc, direct)
	var/atom/old_loc = loc
	var/list/atom/old_locs = locs
	var/old_dir = dir

	var/sigresult = SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, NewLoc)
	if (sigresult & COMPONENT_CANCEL_MOVE)
		return FALSE
	if (sigresult & (COMPONENT_MOVE_OVERRIDE_FAILURE|COMPONENT_MOVE_OVERRIDE_SUCCESSFUL))
		. = sigresult & COMPONENT_MOVE_OVERRIDE_SUCCESSFUL
	else
		. = ..()

	if (flags_atom & DIRLOCK)
		setDir(old_dir)
	else if(!isnull(direct) && old_dir != direct)
		setDir(direct)
	l_move_time = world.time
	if ((old_loc != loc && old_loc?.z == z))
		last_move_dir = get_dir(old_loc, loc)
	if(. && buckled_mob && !handle_buckled_mob_movement(loc,direct)) //movement fails if buckled mob's move fails.
		. = FALSE
	if (. && !(sigresult & COMPONENT_SKIP_MOVED))
		Moved(old_loc, old_locs, direct)

/// Called when `crossed_by` enters the atom's turf (via native Move() or doMove() if allowed).
/// Does not return anything, only handles side effects from Crossed.
/atom/Crossed(atom/movable/crossed_by)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_CROSSED, crossed_by)

	..()


// TODO: Revisit the logic for vehicle collisions and see if there is a less snowflake way to handle vehicles plowing through atoms
/**
 * Called when a movable atom has hit an atom via movement
 *
 * Normally returns FALSE to indicate movement was blocked, returns TRUE for special
 * situations where during the collision movement was actually not blocked (i.e. for vehicles)
 */
/atom/movable/proc/Collide(atom/A)
	if (HAS_TRAIT(src, TRAIT_LAUNCHED))
		launch_impact(A)

	if (A && !QDELETED(A))
		A.last_bumped = world.time
		A.Collided(src)

/// Called when an atom has been hit by a movable atom via movement
/atom/movable/Collided(atom/movable/collider)
	if(!anchored && isliving(collider))
		var/target_dir = get_dir(collider, src)
		var/turf/target_turf = get_step(loc, target_dir)
		Move(target_turf)

/atom/movable/proc/Moved(atom/old_loc, list/atom/old_locs, direction, Forced = FALSE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, old_locs, direction, Forced)
	for(var/datum/dynamic_light_source/light as anything in hybrid_light_sources)
		light.source_atom.update_light()
		if(!isturf(loc))
			light.find_containing_atom()
	for(var/datum/static_light_source/L as anything in static_light_sources) // Cycle through the light sources on this atom and tell them to update.
		L.source_atom.static_update_light()
	return TRUE

/atom/movable/proc/moved_to_nullspace(atom/old_loc, list/atom/old_locs, direction)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED_TO_NULLSPACE, old_loc, old_locs, direction)
	return TRUE

/atom/movable/proc/forceMove(atom/destination)
	. = FALSE

	if(destination)
		. = doMove(destination)
	else
		CRASH("No valid destination passed into forceMove")

	// Bring the buckled_mob with us. No Move(), on_move callbacks, or any of this bullshit, we just got teleported
	if(buckled_mob && loc == destination)
		buckled_mob.forceMove(destination)


/atom/movable/proc/moveToNullspace()
	return doMove(null)


/atom/movable/proc/doMove(atom/destination)
	var/sigresult = SEND_SIGNAL(src, COMSIG_MOVABLE_DO_MOVE, destination)
	var/skip_old_loc_processing = sigresult & COMPONENT_SKIP_OLD_LOC_PROCESSING
	var/skip_new_loc_processing = sigresult & COMPONENT_SKIP_NEW_LOC_PROCESSING
	if (destination)
		if (pulledby && (get_dist(pulledby, destination) > 1 || !isturf(destination) || !isturf(pulledby.loc)))
			pulledby.stop_pulling()
		var/atom/old_loc = loc
		var/list/atom/old_locs = locs
		var/same_loc = old_loc == destination
		var/area/old_area = get_area(old_loc)
		var/area/dest_area = get_area(destination)

		loc = destination

		if (!same_loc)
			if (old_loc && !skip_old_loc_processing)
				old_loc.Exited(src, destination)
				if (old_area && (old_area != dest_area || !isturf(destination)))
					old_area.Exited(src, destination)
				for (var/atom/movable/movable in old_loc)
					movable.Uncrossed(src)
			var/turf/old_turf = get_turf(old_loc)  // TODO: maploader
			var/turf/dest_turf = get_turf(destination)
			var/old_z = (old_turf ? old_turf.z : null)
			var/dest_z = (dest_turf ? dest_turf.z : null)
			if (old_z != dest_z)
				onTransitZ(old_z, dest_z)
			if (!skip_new_loc_processing)
				destination.Entered(src, old_loc)
				if (dest_area && (old_area != dest_area || !isturf(old_loc)))
					dest_area.Entered(src, old_loc)
				if (!(SEND_SIGNAL(src, COMSIG_MOVABLE_FORCEMOVE_PRE_CROSSED) & COMPONENT_IGNORE_CROSS))
					for(var/atom/movable/movable in destination)
						if(movable == src)
							continue
						movable.Crossed(src, old_loc)
		Moved(old_loc, old_locs, NONE, TRUE)
		. = TRUE

	// If no destination, move the atom into nullspace (don't do this unless you know what you're doing)
	else
		. = TRUE
		var/atom/old_loc = loc
		var/list/atom/old_locs = locs
		if (loc)
			var/area/old_area = get_area(old_loc)
			old_loc.Exited(src, null)
			if (old_area)
				old_area.Exited(src, null)
		loc = null
		moved_to_nullspace(old_loc, old_locs, NONE, TRUE)

// resets our langchat position if we get forcemoved out of a locker or something
/mob/doMove(atom/destination)
	. = ..()
	langchat_image?.loc = src

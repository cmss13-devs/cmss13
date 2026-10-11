/// Element for movables that cover more than one turf and interact with the turfs (i.e. can block movement)
/datum/element/multitile
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2

	/// The width of the movable when facing NORTH/SOUTH.
	/// The value is in whatever scale is define by the variable `scale`.
	var/width
	/// The height of the movable when facing NORTH/SOUTH.
	/// The value is in whatever scale is define by the variable `scale`.
	var/height
	/// The horizontal offset of the movable's hitbox from the left border towards the center when facing NORTH/SOUTH.
	/// The value is in whatever scale is define by the variable `scale`.
	var/x_offset
	/// The verticle offset of the movable's hitbox from the bottom border towards the center when facing NORTH/SOUTH.
	/// The value is in whatever scale is define by the variable `scale`.
	var/y_offset

	/// Whether the movable can block movement.
	var/can_block_movement

	/// Whether the width and height of the movable are subject to change based on direction.
	/// Mainly used by asymmetric multitile movables.
	var/dynamic
	/// Scale for both the hitbox dimensions and offsets.
	/// Defaults to the size of a tile in pixels.
	var/scale

/// List of additional params to
/datum/multitile_params
	var/dynamic

/datum/multitile_params/New(dynamic = FALSE)
	src.dynamic = dynamic

/atom/proc/get_multitile_params()
	RETURN_TYPE(/datum/multitile_params)
	return null

/datum/element/multitile/Attach(datum/target, width, height, can_block_movement, x_offset = 0, y_offset = 0, dynamic = FALSE, scale = world.icon_size)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE)
		return
	if (!istype(target, /atom/movable))
		return ELEMENT_INCOMPATIBLE
	// Pointless to attach this element for single-tile movables
	if (width == 1 && height == 1)
		return ELEMENT_INCOMPATIBLE

	src.width = width
	src.height = height
	src.can_block_movement = can_block_movement
	src.x_offset = x_offset
	src.y_offset = y_offset
	src.dynamic = dynamic
	src.scale = scale

	set_bounds(target)

	RegisterSignal(target, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(move_override))
	RegisterSignal(target, COMSIG_MOVABLE_DO_MOVE, PROC_REF(set_do_move_flags))
	RegisterSignal(target, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_MOVED_TO_NULLSPACE,
	), PROC_REF(handle_moved))
	if (dynamic)
		RegisterSignal(target, list(
			COMSIG_ATOM_DIR_CHANGE,
		), PROC_REF(set_bounds))

/datum/element/multitile/Detach(atom/movable/multitile, force)
	UnregisterSignal(multitile, list(
		COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON,
		COMSIG_MOVABLE_PRE_MOVE,
		COMSIG_MOVABLE_DO_MOVE,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_MOVED_TO_NULLSPACE,
		COMSIG_ATOM_DIR_CHANGE,
	))
	var/list/turf/old_locs = multitile.locs
	multitile.bound_width = initial(multitile.bound_width)
	multitile.bound_height = initial(multitile.bound_height)
	multitile.bound_x = initial(multitile.bound_x)
	multitile.bound_y = initial(multitile.bound_y)
	if (can_block_movement)
		for (var/turf/turf in multitile.locs)
			if (turf in old_locs)
				continue
			turf.Exited(multitile)
	..()

/datum/element/multitile/proc/set_bounds(atom/movable/multitile)
	SIGNAL_HANDLER

	ASSERT(multitile.dir in CARDINAL_DIRS, "Trying to set bounds for a multitile that is not facing a cardinal direction")
	// Make sure to clean up ALL values modified here, otherwise will lead to problems
	// such as jittery tile movement
	var/list/atom/old_locs = multitile.locs
	if (multitile.dir in list(NORTH, SOUTH))
		multitile.bound_width = width * scale
		multitile.bound_x = x_offset * scale
		multitile.bound_height = height * scale
		multitile.bound_y = y_offset * scale
	else
		multitile.bound_width = height * scale
		multitile.bound_x = y_offset * scale
		multitile.bound_height = width * scale
		multitile.bound_y = x_offset * scale
	if (can_block_movement)
		process_turf_blockers(multitile, multitile.loc, old_locs)
	SEND_SIGNAL(multitile, COMSIG_ATOM_MULTITILE_SET_BOUNDS, old_locs)

// Native BYOND handling for multitile movement is not compatible with how we calculate collisions
/datum/element/multitile/proc/move_override(atom/movable/multitile, turf/new_turf)
	SIGNAL_HANDLER
	var/direction = get_dir(get_turf(multitile), new_turf)
	var/turf/min_turf = locate(multitile.x + x_offset, multitile.y + y_offset, multitile.z)

	var/list/old_turfs = CORNER_BLOCK(min_turf, width, height)

	min_turf = locate(new_turf.x + x_offset, new_turf.y + y_offset, new_turf.z)

	var/movement_blocked = FALSE
	var/list/turf/turfs_to_enter = CORNER_BLOCK(min_turf, width, height)
	// Iterate through all blocks in the new location for tank
	for(var/turf/to_enter as anything in turfs_to_enter)
		if(to_enter in old_turfs)
			// Handling for barricades and other structures that we did not collide with originally
			// since they were facing the same direction as the movement
			for (var/atom/movable/obstacle as anything in to_enter.movement_blockers)
				if (obstacle == multitile)
					continue
				if (obstacle.BlockedExitDirs(multitile, direction) && !multitile.Collide(obstacle))
					movement_blocked = TRUE
			continue

		if(!to_enter.Enter(multitile, old_turfs))
			movement_blocked = TRUE

	if (!movement_blocked)
		multitile.forceMove(new_turf)

	return (movement_blocked ? COMPONENT_MOVE_OVERRIDE_FAILURE : COMPONENT_MOVE_OVERRIDE_SUCCESSFUL)|COMPONENT_SKIP_MOVED

/// Force handling of Entered() and Exited() in doMove() to be in process_turf_blockers()
/datum/element/multitile/proc/set_do_move_flags(atom/movable/multitile, turf/new_turf)
	SIGNAL_HANDLER
	return COMPONENT_SKIP_OLD_LOC_PROCESSING|COMPONENT_SKIP_NEW_LOC_PROCESSING

/datum/element/multitile/proc/handle_moved(atom/movable/multitile, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	process_turf_blockers(multitile, old_loc, old_locs)

/datum/element/multitile/proc/process_turf_blockers(atom/movable/multitile, atom/old_loc, list/atom/old_locs)
	LAZYINITLIST(old_locs)
	var/list/atom/exited = old_locs | list(old_loc)
	var/list/atom/entered = list()
	if (multitile.loc)
		for (var/destination_atom in multitile.locs | list(multitile.loc))
			if (destination_atom in exited)
				exited -= destination_atom
			else
				entered |= destination_atom
	var/list/area/processed_areas = list(get_area(old_loc))
	if (length(exited))
		for (var/atom/exited_atom as anything in exited)
			exited_atom.Exited(multitile, multitile.loc)
			var/area/exited_area = get_area(exited_atom)
			if (exited_area && !(exited_area in processed_areas) && !isturf(multitile.loc))
				exited_area.Exited(multitile, multitile.loc)
				processed_areas += exited_area
			for (var/atom/movable/movable as anything in exited_atom)
				movable.Uncrossed(multitile)

	if (!multitile.loc)
		return

	processed_areas = list(get_area(multitile))
	if (length(entered))
		// TODO: use a different signal
		var/call_crossed = !(SEND_SIGNAL(multitile, COMSIG_MOVABLE_FORCEMOVE_PRE_CROSSED) & COMPONENT_IGNORE_CROSS)
		for (var/atom/entered_atom as anything in entered)
			entered_atom.Entered(multitile, old_loc)
			var/area/entered_area = get_area(entered_atom)
			if (entered_area && !(entered_area in processed_areas) && !isturf(multitile.loc))
				entered_area.Entered(multitile, old_loc)
				processed_areas += entered_area
			if (call_crossed)
				for(var/atom/movable/movable as anything in entered_atom)
					if (movable == multitile)
						continue
					movable.Crossed(multitile, old_loc)

/datum/element/multitile/proc/set_filler_turfs(atom/movable/multitile, list/atom/old_locs)
	// Reset all filler_turfs because it is not necessarily equal to locate_filler_turfs()
	for (var/turf/filler_turf as anything in old_locs)
		filler_turf.set_opacity(null)

	for (var/turf/filler as anything in multitile.locs)
		filler.set_opacity(multitile.opacity)

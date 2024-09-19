/// Element for movables that cover more than one turf and interact with the turfs (i.e. can block movement)
/datum/element/multitile
	element_flags = ELEMENT_BESPOKE
	id_arg_index = 2

	/// The width of the movable (in tiles) when facing NORTH/SOUTH
	var/width
	/// The height of the movable (in tiles) when facing NORTH/SOUTH
	var/height

	/// Whether the width and height of the movable are subject to change based on direction.
	/// Mainly used by asymmetric multitile movables
	var/dynamic

	/// Whether the movable can block movement
	var/can_block_movement

	/// Proc ref to be called when set bounds is called, specify in any child definitions
	var/on_set_bounds
	/// Proc ref to be called when movable is moved, specify in any child definitions
	var/on_moved

/datum/element/multitile/Attach(datum/target, width, height, dynamic, can_block_movement)
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
	src.dynamic = dynamic
	src.can_block_movement = can_block_movement

	RegisterSignal(target, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, PROC_REF(set_bounds))
	RegisterSignal(target, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_MOVED_TO_NULLSPACE,
		COMSIG_MOVABLE_AFTER_SHUTTLE_MOVE,
	), PROC_REF(handle_moved))
	if (dynamic)
		RegisterSignal(target, list(
			COMSIG_ATOM_DIR_CHANGE,
		), PROC_REF(set_bounds))

/datum/element/multitile/Detach(atom/movable/multitile, force)
	UnregisterSignal(multitile, list(
		COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON,
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOVABLE_MOVED_TO_NULLSPACE,
		COMSIG_ATOM_DIR_CHANGE,
	))
	if (can_block_movement)
		for (var/turf/turf in multitile.locs)
			if (turf == multitile.loc) continue
			turf.Exited(multitile)
	multitile.bound_width = 1
	multitile.bound_height = 1

/datum/element/multitile/proc/set_bounds(atom/movable/multitile)
	SIGNAL_HANDLER

	ASSERT(multitile.dir in CARDINAL_DIRS, "Trying to set bounds for a multitile that is not facing a cardinal direction")
	var/list/atom/old_locs = multitile.locs
	if (multitile.dir in list(NORTH, SOUTH))
		multitile.bound_width = width * world.icon_size
		multitile.bound_height = height * world.icon_size
	else
		multitile.bound_width = height * world.icon_size
		multitile.bound_height = width * world.icon_size
	if (can_block_movement)
		process_turf_blockers(multitile, multitile.loc, old_locs)
	if (on_set_bounds)
		call(src, on_set_bounds)(multitile, old_locs)

/datum/element/multitile/proc/handle_moved(atom/movable/multitile, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	process_turf_blockers(multitile, old_loc, old_locs)
	if (on_moved)
		call(src, on_moved)(multitile, old_locs)

/datum/element/multitile/proc/process_turf_blockers(atom/movable/multitile, atom/old_loc, list/atom/old_locs)
	LAZYINITLIST(old_locs)
	// old_loc should already be processed
	var/list/atom/exited = old_locs - old_loc
	var/list/atom/entered = list()
	if (multitile.loc)
		for (var/destination_atom in multitile.locs)
			if (destination_atom in exited)
				exited -= destination_atom
			// loc should already be processed
			else if (destination_atom != multitile.loc)
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

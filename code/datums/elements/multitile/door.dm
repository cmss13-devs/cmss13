/// Element for movables that cover more than one turf and interact with the turfs (i.e. can block movement)
/datum/element/multitile/door
	on_set_bounds = /datum/element/multitile/door::set_filler_turfs()
	on_moved = /datum/element/multitile/door::set_filler_turfs()

/datum/element/multitile/door/Attach(datum/target, width, height, dynamic, can_block_movement)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE)
		return
	RegisterSignal(target, COMSIG_ATOM_SET_OPACITY, PROC_REF(handle_opacity_change))

/datum/element/multitile/door/Detach(atom/movable/multitile, force)
	UnregisterSignal(multitile, COMSIG_ATOM_SET_OPACITY)
	. = ..()

/datum/element/multitile/door/proc/handle_opacity_change(atom/movable/multitile, new_opacity)
	SIGNAL_HANDLER
	for (var/turf/filler as anything in multitile.locs)
		filler.set_opacity(new_opacity)

/datum/element/multitile/door/Detach(atom/movable/multitile, force)
	for (var/turf/filler as anything in multitile.locs)
		filler.set_opacity(null)
	. = ..()

/datum/element/multitile/door/proc/set_filler_turfs(atom/movable/multitile, list/atom/old_locs)
	// Reset all filler_turfs because it is not necessarily equal to locate_filler_turfs()
	for (var/turf/filler_turf as anything in old_locs)
		filler_turf.set_opacity(null)

	for (var/turf/filler as anything in multitile.locs)
		filler.set_opacity(multitile.opacity)

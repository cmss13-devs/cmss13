/// MapCoords Component
///
/// Allows to attach behavior to a movable atom that allows it to keep track
/// of its own movement on the map for use in ranging and sound backends.
/// Attach this to anything you want to track movement of on a Z-plane despite
/// nested storage constraints.

/datum/component/mapcoords
	dupe_mode = COMPONENT_DUPE_UNIQUE

	/// Chain of upward containers our parent is in
	var/list/atom/movable/containers = list()
	/// Container that currently dictates our map movement
	var/atom/movable/master_container

/datum/component/mapcoords/Initialize()
	. = ..()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/mapcoords/Destroy(force, silent)
	. = ..()
	update_signal_chain(null)
	// And just to be sure
	containers.Cut()
	master_container = null

/datum/component/mapcoords/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(register_own_movement))

	var/atom/movable/parent_movable = parent
	var/turf/current_turf = get_turf(parent_movable)

	if(parent_movable.z)
		return // On map. Nothing to do
	if(!current_turf)
		return // Nullspaced. Nothing to do either
	// Otherwise we start tracking objects we're inside of
	update_signal_chain(parent)

/datum/component/mapcoords/UnregisterFromParent()
	. = ..()
	update_signal_chain(null)

/// Updates our registered signals so they match our new location and new containing items
/datum/component/mapcoords/proc/update_signal_chain(atom/movable/new_target)
	var/list/atom/movable/new_containers = list()

	var/atom/movable/current_movable = new_target
	while(current_movable?.loc && !isturf(current_movable.loc))
		current_movable = current_movable.loc
		new_containers += current_movable
	master_container = current_movable
	if(!master_container?.z)
		master_container = null

	var/list/atom/movable/new_signal_targets = new_containers - containers
	for(var/atom/movable/target as anything in new_signal_targets)
		RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(register_movement))
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(detach_chain))

	var/list/atom/movable/invalid_signal_targets = containers - new_containers
	for(var/atom/movable/target as anything in invalid_signal_targets)
		UnregisterSignal(target, list(COMSIG_MOVABLE_MOVED, COMSIG_PARENT_QDELETING))

	containers = new_containers

/// If anything in our containing chain is deleted, we're going to be too,
/// so scrap everything. In the off chance we're not, we'll probably be moved
/// and automatically recover later.
/datum/component/mapcoords/proc/detach_chain(datum/source)
	SIGNAL_HANDLER
	update_signal_chain(null)

/// Fired when our own atom moves
/datum/component/mapcoords/proc/register_own_movement(datum/parent_source, atom/oldloc, direction, Forced)
	SIGNAL_HANDLER
	var/atom/movable/parent_movable = parent

	// Case 1: We're moving on the map. Nothing fancy to do.
	if(parent_movable.z)
		SEND_SIGNAL(parent, COMSIG_MOVABLE_MAPCOORDS_UPDATED, parent_movable.loc)

	// Case 2: We moved into a (different) container
	else if(!master_container || master_container != parent_movable.loc)
		var/turf/new_turf = get_turf(parent_movable)
		SEND_SIGNAL(parent, COMSIG_MOVABLE_MAPCOORDS_UPDATED, new_turf) // Note that turf could be null here
		update_signal_chain(parent_movable)

/// Fired when an atom in our containing chain moves
/datum/component/mapcoords/proc/register_movement(datum/parent_source, atom/oldloc, direction, Forced)
	SIGNAL_HANDLER
	if(parent_source == master_container)
		if(master_container.z) // It's still on map, so send a regular update
			SEND_SIGNAL(parent, COMSIG_MOVABLE_MAPCOORDS_UPDATED, master_container.loc)
		else if(!master_container.loc) // It was nullspaced
			SEND_SIGNAL(parent, COMSIG_MOVABLE_MAPCOORDS_UPDATED, null)
		else // It was put into something else, which forces us to scrap chain
			var/turf/new_turf = get_turf(parent)
			SEND_SIGNAL(parent, COMSIG_MOVABLE_MAPCOORDS_UPDATED, new_turf)
			update_signal_chain(parent)

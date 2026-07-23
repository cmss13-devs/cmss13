/// Handles several mapgrids together for use in the game
/// For example our main implementation is to stack mapgrids to be able to use
/// them with multiple Z-levels.
/// It handles initialization, and switching atoms between mapgrids as they
/// travel between them.

/datum/mapgrid_manager
	/// Dimension of mapgrid cells to be requested - Cannot be updated
	var/dim = 4

	/// List of mapgrids handling each Z-level, mirroring [SSmapping.z_list]
	/// Note that a single mapgrid handles all levels of a multi-Z map, so
	/// one can be there more than once.
	/// The discrimination is done by the using code afterwards
	var/list/datum/mapgrid/mapgrids_by_z = list()

	/// All tracked atoms, that we monitor for changes in Z-level
	var/list/atom/movable/tracked_movables = list()

/datum/mapgrid_manager/New()
	. = ..()
	for(var/datum/space_level/space_level as anything in SSmapping.z_list)
		load_new_z_level(null, space_level)
	RegisterSignal(SSdcs, COMSIG_GLOB_NEW_Z, PROC_REF(load_new_z_level))

/// Loads up a mapgrid for an existing z-level
/datum/mapgrid_manager/proc/load_new_z_level(datum/dcs, datum/space_level/space_level)
	SIGNAL_HANDLER
	if(space_level.z_value != (length(mapgrids_by_z) + 1))
		CRASH("mapgrids and z-levels are not properly synced up!")
	// Evaluate linkage to reuse a mapgrid
	if(space_level.traits[ZTRAIT_DOWN])
		var/z_down = space_level.z_value + space_level.traits[ZTRAIT_DOWN]
		if(z_down < space_level.z_value) // This level links with an instanciated one
			mapgrids_by_z += mapgrids_by_z[z_down]
	else
		mapgrids_by_z += new /datum/mapgrid(dim)

/datum/mapgrid_manager/proc/track_movable(atom/movable/target)
	if(target in tracked_movables)
		return TRUE

	target.AddComponent(/datum/component/mapcoords)

	// Find out where it needs to go and send it to the appropriate mapgrid
	var/turf/location = get_turf(target)
	if(location?.z) // Only if it's currently on map
		var/datum/mapgrid/target_grid = mapgrids_by_z[location.z]
		target_grid.insert(target)

	// Add it to tracking either way
	RegisterSignal(target, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_atom_z_change))
	RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(on_atom_deletion))
	tracked_movables += target


/datum/mapgrid_manager/proc/on_atom_deletion(datum/source)
	SIGNAL_HANDLER
	// Don't have to delete from mapgrids, they do that independently
	tracked_movables -= source

/datum/mapgrid_manager/proc/on_atom_z_change(atom/movable/source, old_z, new_z)
	SIGNAL_HANDLER

	var/datum/mapgrid/source_mapgrid
	if(old_z)
		source_mapgrid = mapgrids_by_z[old_z]

	var/datum/mapgrid/target_mapgrid
	if(new_z)
		target_mapgrid = mapgrids_by_z[new_z]

	if(source_mapgrid == target_mapgrid)
		return // Nothing to do

	source_mapgrid?.forget(source)
	target_mapgrid?.insert(source)

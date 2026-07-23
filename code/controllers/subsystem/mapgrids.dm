SUBSYSTEM_DEF(mapgrids)
	name = "MapGrids"
	wait = 0.5 SECONDS
	priority = SS_PRIORITY_QUADTREE
	// Before SSatoms so things can register to them, but after SSmapping so grids don't have to be expanded at every world expansion
	init_order = SS_INIT_MAPGRIDS

	/// Mapgrid managers for our different contexts
	/// - for now there's only one, but we could split observers and living mobs like old QuadTree did for example
	var/datum/mapgrid_manager/manager

// It's a bit empty in here, but it's to allow several mapgrids to exist later, and to rebalance them dynamically
// Rebalancing them ensures they are used to their full extent and not that this should just be a stupid
// sorted array like we should really have done instead

/datum/controller/subsystem/mapgrids/Initialize()
	. = ..()
	manager = new
	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapgrids/fire()
	// TODO rebalance the mapgrids once in a while for optimal performance
	// This is low priority work

/datum/controller/subsystem/mapgrids/proc/track_movable(atom/movable/target)
	manager.track_movable(target)

/// Queries the mapgrid for ranging information
/// This is the legacy interface that makes use of old QuadTree Rectangle,
/// and the filter flags. Remember, on mapgrids, all levels of multi-z are handled together.
/// TODO remove this later, this is a stand-in replacement for testing
/datum/controller/subsystem/mapgrids/proc/players_in_range_legacy(datum/shape/rectangle/range, z_level, flags = NO_FLAGS)
	var/datum/mapgrid/grid = manager.mapgrids_by_z[z_level]
	if(!grid)
		return

	var/start_x = abs(range.center_x - range.width * 0.5)
	var/end_x   = abs(range.center_x + range.width * 0.5)
	var/start_y = abs(range.center_y - range.height * 0.5)
	var/end_y   = abs(range.center_y + range.height * 0.5)

	var/list/atom/movable/results = grid.query_range(start_x, end_x, start_y, end_y)

	. = list()
	for(var/atom/movable/movable as anything in results)
		if((flags & QTREE_FILTER_LIVING) && !isliving(movable))
			continue
		if(!(flags & QTREE_SCAN_MOBS))
			var/mob/maybe_mob = movable
			if(ismob(maybe_mob) && maybe_mob.client)
				. += maybe_mob.client
		else
			. += movable // This can return non-mobs, which breaks legacy expectations

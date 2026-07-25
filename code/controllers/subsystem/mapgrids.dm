SUBSYSTEM_DEF(mapgrids)
	name = "MapGrids"
	wait = 20 SECONDS // Rebalancing does not need to be done often

	// Before SSatoms so things can register to them, but after SSmapping so grids don't have to be expanded at every world expansion
	init_order = SS_INIT_MAPGRIDS
	priority = SS_PRIORITY_MAPGRIDS
	flags = SS_POST_FIRE_TIMING // This slows down the SS even more if it cannot complete its work within intended timeframe

	/// Mapgrid managers for our different contexts
	/// - for now there's only one, but we could split observers and living mobs like old QuadTree did for example
	var/datum/mapgrid_manager/manager

	/// Internal state holder: the mapgrids left to balance this run
	var/list/datum/mapgrid/currentrun

/datum/controller/subsystem/mapgrids/Initialize()
	. = ..()
	manager = new
	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapgrids/stat_entry(msg)
	msg = "Tracking: [length(manager?.tracked_movables)]"
	return ..()

/datum/controller/subsystem/mapgrids/fire(resumed = FALSE)
	if(!resumed)
		currentrun = manager.all_grids.Copy()

	while(length(currentrun))
		var/datum/mapgrid/grid = currentrun[currentrun.len]
		currentrun.len--
		grid.balance()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/mapgrids/proc/track_movable(atom/movable/target)
	manager.track_movable(target)

/// Queries the mapgrid for ranging information
/// This is the legacy interface that makes use of old QuadTree Rectangle,
/// and the filter flags. Remember, on mapgrids, all levels of multi-z are handled together.
/// TODO remove this later, this is a stand-in replacement for testing
/datum/controller/subsystem/mapgrids/proc/players_in_range_legacy(datum/shape/rectangle/range, z_level, flags = NO_FLAGS)
	if(!z_level)
		return
	var/datum/mapgrid/grid = manager.mapgrids_by_z[z_level]
	if(!grid)
		return

	var/start_x = round(range.center_x - range.width * 0.5, 1)
	var/end_x   = round(range.center_x + range.width * 0.5, 1)
	var/start_y = round(range.center_y - range.height * 0.5, 1)
	var/end_y   = round(range.center_y + range.height * 0.5, 1)

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

// We alternate between two modes for SSmapgrids to help schedule the load easier. This lets us take a break inbetween both.
/// In SCAN mode we compute the upcoming boundaries of the mapgrid.
#define SSMAPGRIDS_MODE_SCAN 1
/// In BALANCE mode we actually apply the computed boundaries
#define SSMAPGRIDS_MODE_BALANCE 2

SUBSYSTEM_DEF(mapgrids)
	name = "MapGrids"

	// Before SSatoms so things can register to them, but after SSmapping so grids don't have to be expanded at every world expansion
	init_order = SS_INIT_MAPGRIDS

	// Rebalancing once in a while helps improve performance, but is not needed for the system to function
	// It is still an expensive task however, and we absolutely do not want it to cause overtime
	// We set very loose scheduling so that it's only ran when the game state allows it
	wait = 20 SECONDS
	priority = SS_PRIORITY_MAPGRIDS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND

	/// Mapgrid managers for our different contexts
	/// for now there's only one, but we could split them for different uses
	var/datum/mapgrid_manager/manager

	/// Internal state holder: the mapgrids left to balance this run
	var/list/datum/mapgrid/currentrun
	/// Upcoming mode of operation - see the comments at top of mapgrids.dm
	var/work_mode = SSMAPGRIDS_MODE_SCAN
	/// Saved boundaries to be sent with SSMAPGRIDS_MODE_BALANCE
	var/list/cached_boundaries_x
	var/list/cached_boundaries_y

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
		work_mode = SSMAPGRIDS_MODE_SCAN

	while(length(currentrun))
		var/datum/mapgrid/grid = currentrun[currentrun.len]

		if(work_mode == SSMAPGRIDS_MODE_SCAN) // Split the load into two so we can pause more often
			cached_boundaries_x = new /list(grid.dim)
			cached_boundaries_y = new /list(grid.dim)
			if(grid.scan_new_bounds(cached_boundaries_x, cached_boundaries_y))
				work_mode = SSMAPGRIDS_MODE_BALANCE
			else // Didn't work out. Skip this grid.
				currentrun.len--
				continue

		if(MC_TICK_CHECK)
			return

		if(work_mode == SSMAPGRIDS_MODE_BALANCE)
			currentrun.len--
			grid.rebalance(cached_boundaries_x, cached_boundaries_y)
			cached_boundaries_x = cached_boundaries_y = null
			work_mode = SSMAPGRIDS_MODE_SCAN

		if(MC_TICK_CHECK)
			return

/// Start tracking an atom into the mapgrid system on the default grid. This will attach implicitely the mapcoords component to them.
/datum/controller/subsystem/mapgrids/proc/track_movable(atom/movable/target)
	manager.track_movable(target)

/// Gets all contents in the mapgrid of given z-level
/// This can include things of unexpected types, any movable, mobs without client, and mobs on other linked z-levels!
/// You are encouraged to use this and not add extra procs for filtering, that way the code that uses this
/// can directly perform all the neccessary checks at once which is much faster
/datum/controller/subsystem/mapgrids/proc/get_movables_in_region(z_level, start_x, end_x, start_y, end_y)
	RETURN_TYPE(/list/atom/movable)
	var/datum/mapgrid/grid = manager.mapgrids_by_z[z_level]
	if(grid)
		return grid.query_range(start_x, end_x, start_y, end_y)

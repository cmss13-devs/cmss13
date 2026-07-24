/// Organizes 2D space in-game for fast searching and ranging queries
/datum/mapgrid
	/// Dimensions of the map grid: 4 -> 4x4 -> 16 cells
	/// Cannot be changed after instantiation
	var/dim = 4

	/// List of the contained atoms and their respective mapcell - maps [/atom/movable] -> [/datum/mapcell]
	var/alist/tracked_atoms = alist()

	/// x -> y -> /datum/mapcell
	var/list/list/cells

	/// X boundaries of the map cells
	/// mapgrid x coordinate -> game x coordinate
	/// example: { 0 => 0, 1 => 40, 2 => 80, 3 => 110, 4 => world.maxx+1 }
	var/list/bounds_x

	/// Y boundaries of the map cells
	var/list/bounds_y

/datum/mapgrid/New(dim)
	. = ..()
	if(dim)
		src.dim = dim

	init_partition()

	// TOOD: ensure mapgrids are created after SSmapping but before SSatoms for optimization so it doesnt continuously run this
	RegisterSignal(SSdcs, COMSIG_GLOB_EXPANDED_WORLD_BOUNDS, PROC_REF(handle_expansion))

/datum/mapgrid/Destroy(force, ...)
	. = ..()
	for(var/atom/movable/tracked_atom as anything in tracked_atoms)
		forget(tracked_atom)
	for(var/list/dim2 as anything in cells)
		QDEL_NULL_LIST(dim2)
	cells.Cut()


/// Partitions the mapgrid, for now to be used only at init, it does not preserve state
/datum/mapgrid/proc/init_partition()
	// Conceptually, the first bound [0] = 1 is not stored, we just handle it in code
	bounds_x = new /list(dim)
	for(var/x in 1 to dim)
		bounds_x[x] = floor(world.maxx / dim) * x
	bounds_x[dim] = world.maxx // To make sure no rounding issue

	bounds_y = new /list(dim)
	for(var/y in 1 to dim)
		bounds_y[y] = floor(world.maxy / dim) * y
	bounds_y[dim] = world.maxy

	// We have to get a little creative here because the cells go past the boundary limits:
	//                    | Cell A    |    Cell B | Cell C | Cell D |
	// bound is at zero -^        1st bound                         ^- dim+1 bound
	cells = new /list(dim,dim)
	for(var/x in 0 to dim-1)
		for(var/y in 0 to dim-1)
			cells[x+1][y+1] = new /datum/mapcell(x ? bounds_x[x] : 0, bounds_x[x+1], y ? bounds_y[y] : 0, bounds_y[y+1])

	// TODO rebalancing

/// Updates the mapgrid when world is expanded
/// Again this does not rebalance right away, this can be done later by SS
/datum/mapgrid/proc/handle_expansion(datum/ssdcs, expanded_x, expanded_y)
	SIGNAL_HANDLER
	bounds_x[dim] = expanded_x
	bounds_y[dim] = expanded_y

/// Inserts an atom with a MapCoords component into the mapgrid
/datum/mapgrid/proc/insert(atom/movable/target)
	var/turf/turf = get_turf(target)
	if(!target)
		return FALSE // No z-level, no mapgrid

	var/reinsert = FALSE
	if(tracked_atoms[target])
		reinsert = TRUE
		var/datum/mapcell/old_mapcell = tracked_atoms[target]
		old_mapcell.contents -= target

	var/x = turf.x
	var/y = turf.y

	// Scan in X direction
	var/grid_x
	for(grid_x = 1 to dim)
		if(bounds_x[grid_x] > x)
			break

	// Scan in Y direction
	var/grid_y
	for(grid_y = 1 to dim)
		if(bounds_y[grid_y] > y)
			break

	var/datum/mapcell/found_cell = cells[grid_x][grid_y]
	found_cell.contents += target
	tracked_atoms[target] = found_cell

	if(!reinsert)
		RegisterSignal(target, COMSIG_PARENT_QDELETING, PROC_REF(forget))
		RegisterSignal(target, COMSIG_MOVABLE_MAPCOORDS_UPDATED, PROC_REF(check_atom_loc))

/// Removes a movable from the mapgrid
/datum/mapgrid/proc/forget(atom/movable/target)
	SIGNAL_HANDLER
	var/datum/mapcell/containing_cell = tracked_atoms[target]
	if(!containing_cell)
		return // Welp. Nothing to do
	UnregisterSignal(target, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_MAPCOORDS_UPDATED))
	containing_cell.contents -= target
	tracked_atoms.Remove(target)

/// Where the update part of the magic happens - when mapcoords propagates updates,
/// we need to ensure that the atom is positioned correctly within the mapgrid
/// This is going to get called a lot of times, so ensure it stays simple
/datum/mapgrid/proc/check_atom_loc(atom/movable/target, turf/map_location)
	SIGNAL_HANDLER
	if(!map_location?.z)
		forget(target) // Safety. This should alreayd be handled by mapgrid_manager
		return

	var/datum/mapcell/current_cell = tracked_atoms[target]

	// Check we're still in the cell, in which case we have nothing to do
	// Watch operators. a mapcell covers [start_x, end_x[
	if ((current_cell.start_x <  map_location.x)  \
	&&  (current_cell.end_x   >= map_location.x)  \
	&&  (current_cell.start_y <  map_location.y)  \
	&&  (current_cell.end_y   >= map_location.y))
		return

	// Otherwise move it
	insert(target)


/// Where most of the magic happens - scans a range over several mapcells in the mapgrid
/// to perform a ranging query. Watch out, for compatibility reasons with external code,
/// the range is inclusive both directions here.
/// If provided, z_list allows to filters results by exact zlevel, for multiz use.
/// This is provided for convenience, I encourage you to take all the results and handle them
/// appropriately in your code instead.
/datum/mapgrid/proc/query_range(start_x, end_x, start_y, end_y, alist/z_list)
	. = list()

	//to_world("=== Range query")

	// Scan X, start then end, clamping grid coordinates
	var/start_grid_x
	for(start_grid_x = 1 to dim)
		if(bounds_x[start_grid_x] > start_x)
			break
	var/end_grid_x
	for(end_grid_x = start_grid_x to dim)
		if(bounds_x[end_grid_x] >= end_x) // >= for inclusion of end bound
			break

	// Y now
	var/start_grid_y
	for(start_grid_y = 1 to dim)
		if(bounds_y[start_grid_y] > start_y)
			break
	var/end_grid_y
	for(end_grid_y = start_grid_y to dim)
		if(bounds_y[end_grid_y] >= end_y)
			break

	// TODO possibly clamp the values of grid coords to avoid issues
	// But there should be no issue to begin with so fix that instead?

	// Now resolve that to cells and search for things matching our range
	for(var/grid_x in start_grid_x to end_grid_x)
		for(var/grid_y in start_grid_y to end_grid_y)
			var/datum/mapcell/searching = cells[grid_x][grid_y]

			//to_world("Visiting: ([grid_x],[grid_y]) : x=([searching.start_x],[searching.end_x]) ; y=([searching.start_y],[searching.end_y]) ; contents=[length(searching.contents)]")

			for(var/atom/movable/possible_target as anything in searching.contents)
				var/turf/target_turf = get_turf(possible_target)
				if(!target_turf)
					continue
				if(start_x <= target_turf.x && end_x >= target_turf.x  \
				&& start_y <= target_turf.y && end_y >= target_turf.y  \
				&& (!z_list || (target_turf.z in z_list)))
					. += possible_target


/// A single cell of a mapgrid
/// Unfortunately this has to be a dedicated datum, because having the
/// coordinates information cached here speeds up updating
/datum/mapcell
	var/list/atom/movable/contents
	var/start_x
	var/end_x
	var/start_y
	var/end_y

/datum/mapcell/New(start_x, end_x, start_y, end_y)
	contents = list()
	src.start_x = start_x
	src.end_x = end_x
	src.start_y = start_y
	src.end_y = end_y

/datum/mapcell/Destroy()
	. = ..()
	contents.Cut()

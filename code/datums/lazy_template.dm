
/**
 * Datum used to designate certain areas that do not need to exist nor be loaded at world start
 * but do want to be loaded under certain circumstances. Use this for stuff like the nukie base or wizden, aka stuff that only matters when their antag is rolled.
 */
/datum/lazy_template
	var/list/datum/turf_reservation/reservations = list()

	/// If this is true each load will increment an index keyed to the type and it will load [map_name]_[index]
	var/uses_multiple_allocations = FALSE

	/// Directory of maps to prefix to the filename
	var/map_dir = "maps/templates/lazy_templates"

	/// The filename (without extension) of the map to load
	var/map_name

/datum/lazy_template/New()
	reservations = list()
	..()

/datum/lazy_template/Destroy(force)
	if(!force)
		stack_trace("Something is trying to delete [type]")
		return QDEL_HINT_LETMELIVE

	QDEL_LIST(reservations)
	GLOB.lazy_templates -= type
	return ..()

/**
 * Does the grunt work of loading the template.
 */
/datum/lazy_template/proc/lazy_load()
	RETURN_TYPE(/datum/turf_reservation)
	// This is a static assosciative list that is used to ensure maps that have variations are correctly varied when spawned
	// I want to make it to where you can make a range and it'll randomly pick'n'take from the available versions at random
	// But that can be done later when I have the time
	var/static/list/multiple_allocation_hash = list()

	var/load_path = "[map_dir]/[map_name].dmm"
	if(uses_multiple_allocations)
		var/times = multiple_allocation_hash[type] || 0
		times += 1
		multiple_allocation_hash[type] = times
		load_path = "[map_dir]/[map_name]_[times].dmm"

	if(!load_path || !fexists(load_path))
		CRASH("lazy template [type] has an invalid load_path: '[load_path]', check directory and map name!")

	var/datum/parsed_map/parsed_template = load_map(
		file(load_path),
		measure_only = TRUE,
	)
	if(isnull(parsed_template.parsed_bounds))
		CRASH("Failed to cache lazy template for loading: '[type]'")

	var/width = parsed_template.parsed_bounds[MAP_MAXX] - parsed_template.parsed_bounds[MAP_MINX] + 1
	var/height = parsed_template.parsed_bounds[MAP_MAXY] - parsed_template.parsed_bounds[MAP_MINY] + 1
	var/datum/turf_reservation/reservation = SSmapping.request_turf_block_reservation(
		width,
		height,
		parsed_template.parsed_bounds[MAP_MAXZ],
	)
	if(!reservation)
		CRASH("Failed to reserve a block for lazy template: '[type]'")

	// lists kept for overall loading
	var/list/loaded_atom_movables = list()
	var/list/loaded_turfs = list()
	var/list/loaded_areas = list()

	for(var/z_idx in parsed_template.parsed_bounds[MAP_MAXZ] to 1 step -1)
		var/turf/bottom_left = reservation.bottom_left_turfs[z_idx]
		var/turf/top_right = reservation.top_right_turfs[z_idx]

		load_map(
			file(load_path),
			bottom_left.x,
			bottom_left.y,
			bottom_left.z,
			z_upper = z_idx,
			z_lower = z_idx,
		)
		for(var/turf/turf as anything in block(bottom_left, top_right))
			loaded_turfs += turf
			loaded_areas |= get_area(turf)

			// atoms can actually be in the contents of two or more turfs based on its icon/bound size
			// see https://www.byond.com/docs/ref/index.html#/atom/var/contents
			for(var/thing in (turf.get_all_contents() - turf))
				loaded_atom_movables |= thing

	SSatoms.InitializeAtoms(loaded_areas + loaded_atom_movables + loaded_turfs)

	SEND_SIGNAL(src, COMSIG_LAZY_TEMPLATE_LOADED, loaded_atom_movables, loaded_turfs, loaded_areas)
	reservations += reservation
	return reservation

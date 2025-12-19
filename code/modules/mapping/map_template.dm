/datum/map_template
	var/name = "Default Template Name"
	var/width = 0
	var/height = 0
	var/mappath = null
	var/loaded = 0 // Times loaded this round
	var/datum/parsed_map/cached_map
	var/keep_cached_map = FALSE

	///Default area associated with the map template
	var/default_area

	///if true, turfs loaded from this template are placed on top of the turfs already there, defaults to TRUE
	var/should_place_on_top = TRUE

	///if true, creates a list of all atoms created by this template loading, defaults to FALSE
	var/returns_created_atoms = FALSE

	///the list of atoms created by this template being loaded, only populated if returns_created_atoms is TRUE
	var/list/created_atoms = list()
	//make sure this list is accounted for/cleared if you request it from ssatoms!


/datum/map_template/New(path = null, rename = null, cache = FALSE)
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath, cache)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path, cache = FALSE)
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.bounds
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
		if(cache)
			cached_map = parsed
	return bounds

/datum/map_template/proc/initTemplateBounds(list/bounds)
	if (!bounds) //something went wrong
		stack_trace("[name] template failed to initialize correctly!")
		return

	var/list/atom/movable/movables = list()
	var/list/obj/docking_port/stationary/ports = list()
	var/list/area/areas = list()

	var/list/turfs = block(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ], bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])
	for(var/turf/current_turf as anything in turfs)
		var/area/current_turfs_area = current_turf.loc
		areas |= current_turfs_area
		if(!SSatoms.initialized)
			continue

		for(var/movable_in_turf in current_turf)
			if(istype(movable_in_turf, /obj/docking_port/mobile))
				continue // mobile docking ports need to be initialized after their template has finished loading, to ensure that their bounds are setup
			movables += movable_in_turf
			if(istype(movable_in_turf, /obj/docking_port/stationary))
				ports += movable_in_turf

	// Not sure if there is some importance here to make sure the area is in z
	// first or not.  Its defined In Initialize yet its run first in templates
	// BEFORE so... hummm
	SSmapping.reg_in_areas_in_z(areas)
	if(!SSatoms.initialized)
		return

	SSatoms.InitializeAtoms(areas + turfs + movables, returns_created_atoms ? created_atoms : null)

	for(var/turf/unlit as anything in turfs)
		var/area/loc_area = unlit.loc
		if(!loc_area.static_lighting)
			continue
		unlit.static_lighting_build_overlay()

/datum/map_template/proc/load_new_z(secret = FALSE, traits = list())
	var/x = floor((world.maxx - width) * 0.5) + 1
	var/y = floor((world.maxy - height) * 0.5) + 1

	var/datum/space_level/level = SSmapping.add_new_zlevel(name, traits, contain_turfs = FALSE)
	var/datum/parsed_map/parsed = load_map(
		file(mappath),
		x,
		y,
		level.z_value,
		no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS),
		place_on_top = should_place_on_top,
		new_z = TRUE,
	)
	var/list/bounds = parsed.bounds
	if(!bounds)
		return FALSE

	repopulate_sorted_areas()
	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	log_game("Z-level [name] loaded at [x],[y],[world.maxz]")

	return level

/**
 * Loads the map template.
 *
 * Arguments:
 * * target_turf - The starting position to load the template
 * * centered - Whether to adjust the starting position to center the template (otherwise target_turf is the bottom left)
 * * delete - Whether to replace atoms
 * * allow_cropping - Whether to fail loading if the template is larger than current world size
 * * crop_within_type - A strict typepath to limit x_upper and y_upper further when in allow_cropping mode
 * * crop_within_border - An extra extra distance to crop within for crop_within_type and expand_type
 * * expand_type - Specifying this typepath will allow expansion mode filling in space tiles with this type
 */
/datum/map_template/proc/load(turf/target_turf, centered=FALSE, delete=FALSE, allow_cropping=FALSE, crop_within_type=null, crop_within_border=1, expand_type=null)
	if(centered)
		target_turf = locate(target_turf.x - floor(width/2), target_turf.y - floor(height/2), target_turf.z)
	if(!target_turf)
		return

	var/x_upper = INFINITY
	var/y_upper = INFINITY
	var/expand_x_start = 0
	var/expand_y_start = 0
	if(!allow_cropping)
		if((target_turf.x + width) - 1 > world.maxx)
			return
		if((target_turf.y + height) - 1 > world.maxy)
			return
	else if(ispath(crop_within_type) && !ispath(expand_type))
		// Check the horizontal line for the strict type
		// ASSUMPTION: Square border shape
		for(var/turf/x_turf in block(target_turf.x, target_turf.y, target_turf.z, min(world.maxx, target_turf.x + width), target_turf.y, target_turf.z))
			if(x_turf.type == crop_within_type)
				x_upper = x_turf.x - 1 - crop_within_border
				if(x_upper < target_turf.x)
					return
				break
		// Check the vertical line for the strict type
		// ASSUMPTION: Square border shape
		for(var/turf/y_turf in block(target_turf.x, target_turf.y, target_turf.z, target_turf.x, min(world.maxy, target_turf.y + height), target_turf.z))
			if(y_turf.type == crop_within_type)
				y_upper = y_turf.y - 1 - crop_within_border
				if(y_upper < target_turf.y)
					return
				break
	else if(ispath(expand_type))
		if(!ispath(crop_within_type))
			crop_within_type = /turf/closed/cordon
		// Check the horizontal line for the strict type or space
		// ASSUMPTION: Square border shape
		for(var/turf/x_turf in block(target_turf.x, target_turf.y, target_turf.z, min(world.maxx, target_turf.x + width), target_turf.y, target_turf.z))
			if(x_turf.type == crop_within_type || istype(x_turf, /turf/open/space))
				expand_x_start = x_turf.x
				break
		// Check the vertical line for the strict type or space
		// ASSUMPTION: Square border shape
		for(var/turf/y_turf in block(target_turf.x, target_turf.y, target_turf.z, target_turf.x, min(world.maxy, target_turf.y + height), target_turf.z))
			if(y_turf.type == crop_within_type || istype(y_turf, /turf/open/space))
				expand_y_start = y_turf.y
				break

	// Accept cached maps, but don't save them automatically - we don't want
	// ruins clogging up memory for the whole round.
	var/datum/parsed_map/parsed = cached_map || new(file(mappath))
	cached_map = keep_cached_map ? parsed : null

	var/list/turf_blacklist = list()
	update_blacklist(target_turf, turf_blacklist)

	UNSETEMPTY(turf_blacklist)
	parsed.turf_blacklist = turf_blacklist
	if(!parsed.load(
		target_turf.x,
		target_turf.y,
		target_turf.z,
		crop_map = TRUE,
		no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS),
		x_upper = x_upper,
		y_upper = y_upper,
		place_on_top = should_place_on_top,
		delete = delete
	))
		return

	var/list/bounds = parsed.bounds
	if(!bounds)
		return

	if(expand_x_start || expand_y_start)
		if(expand_x_start)
			// Eastward expansion minus borders
			for(var/turf/current in block(expand_x_start, target_turf.y, target_turf.z, target_turf.x + width - 1, target_turf.y + height - 1, target_turf.z))
				if(current.type == crop_within_type || istype(current, /turf/open/space))
					current.ChangeTurf(expand_type)
					CHECK_TICK
			// Southern strip cordon
			for(var/turf/current in block(expand_x_start, target_turf.y - 1, target_turf.z, target_turf.x + width, target_turf.y - 1, target_turf.z))
				if(current.type != crop_within_type)
					current.ChangeTurf(crop_within_type)
					CHECK_TICK
			// Force border w/o additional expansion
			if(crop_within_border > 0)
				// Southern strip inner border
				for(var/turf/current in block(expand_x_start, target_turf.y, target_turf.z, target_turf.x + width - 1, target_turf.y + crop_within_border - 1, target_turf.z))
					if(current.type != expand_type)
						current.ChangeTurf(expand_type)
						CHECK_TICK

		if(expand_y_start)
			// Northward expansion minus borders
			var/end_x = expand_x_start ? expand_x_start : target_turf.x + width
			for(var/turf/current in block(target_turf.x, expand_y_start, target_turf.z, end_x - 1, target_turf.y + height - 1, target_turf.z))
				if(current.type == crop_within_type || istype(current, /turf/open/space))
					current.ChangeTurf(expand_type)
					CHECK_TICK
			// Western strip cordon
			for(var/turf/current in block(target_turf.x - 1, expand_y_start, target_turf.z, target_turf.x - 1, target_turf.y + height, target_turf.z))
				if(current.type != crop_within_type)
					current.ChangeTurf(crop_within_type)
					CHECK_TICK
			// Force border w/o additional expansion
			if(crop_within_border > 0)
				// Western strip inner border
				for(var/turf/current in block(target_turf.x + crop_within_border - 1, expand_y_start, target_turf.z, target_turf.x, target_turf.y + height - crop_within_border - 1, target_turf.z))
					if(current.type != expand_type)
						current.ChangeTurf(expand_type)
						CHECK_TICK

		if(expand_x_start && expand_y_start)
			expand_x_start = target_turf.x
			expand_y_start = target_turf.y
		else
			expand_x_start = max(target_turf.x, expand_x_start)
			expand_y_start = max(target_turf.y, expand_y_start)
		// East strip cordon
		for(var/turf/current in block(target_turf.x + width, expand_y_start, target_turf.z, target_turf.x + width, target_turf.y + height - 1, target_turf.z))
			if(current.type != crop_within_type)
				current.ChangeTurf(crop_within_type)
				CHECK_TICK
		// North strip cordon
		for(var/turf/current in block(expand_x_start, target_turf.y + height, target_turf.z, target_turf.x + width, target_turf.y + height, target_turf.z))
			if(current.type != crop_within_type)
				current.ChangeTurf(crop_within_type)
				CHECK_TICK
		// Force border w/o additional expansion
		if(crop_within_border > 0)
			// East strip inner border
			for(var/turf/current in block(target_turf.x + width - crop_within_border, expand_y_start + crop_within_border, target_turf.z, target_turf.x + width - 1, target_turf.y + height - crop_within_border - 1, target_turf.z))
				if(current.type != expand_type)
					current.ChangeTurf(expand_type)
					CHECK_TICK
			// North strip inner border
			for(var/turf/current in block(expand_x_start, target_turf.y + height - 1, target_turf.z, target_turf.x + width - 1, target_turf.y + height - crop_within_border, target_turf.z))
				if(current.type != expand_type)
					current.ChangeTurf(expand_type)
					CHECK_TICK

	repopulate_sorted_areas()

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)

	log_game("[name] loaded at [target_turf.x],[target_turf.y],[target_turf.z]")
	return bounds

/datum/map_template/proc/post_load()
	return

/datum/map_template/proc/update_blacklist(turf/T, list/input_blacklist)
	return

/datum/map_template/proc/get_affected_turfs(turf/target_turf, centered=FALSE, allow_cropping=FALSE, crop_within_type=null, crop_within_border=1, expand_type=null)
	. = list()
	if(centered)
		target_turf = locate(target_turf.x - floor(width/2), target_turf.y - floor(height/2), target_turf.z)
	if(!target_turf)
		return .

	var/x_upper = INFINITY
	var/y_upper = INFINITY
	if(!allow_cropping)
		if((target_turf.x+width) - 1 > world.maxx)
			return .
		if((target_turf.y+height) - 1 > world.maxy)
			return .
	else if(ispath(crop_within_type) && !ispath(expand_type))
		// Check the horizontal line for the strict type
		for(var/turf/x_turf in block(target_turf.x, target_turf.y, target_turf.z, world.maxx, target_turf.y, target_turf.z))
			if(x_turf.type == crop_within_type)
				x_upper = x_turf.x - 1 - crop_within_border
				if(x_upper < target_turf.x)
					return .
				break
		// Check the vertical line for the strict type
		for(var/turf/y_turf in block(target_turf.x, target_turf.y, target_turf.z, target_turf.x, world.maxy, target_turf.z))
			if(y_turf.type == crop_within_type)
				y_upper = y_turf.y - 1 - crop_within_border
				if(y_upper < target_turf.y)
					return .
				break
	else if(ispath(expand_type))
		// Check the horizontal line for the strict type or space
		// ASSUMPTION: Square border shape
		var/expand_x_start = 0
		for(var/turf/x_turf in block(target_turf.x, target_turf.y, target_turf.z, min(world.maxx, target_turf.x + width), target_turf.y, target_turf.z))
			if(x_turf.type == crop_within_type || istype(x_turf, /turf/open/space))
				expand_x_start = x_turf.x
				break
		if(expand_x_start)
			// Southern strip cordon
			. += block(expand_x_start, target_turf.y - 1, target_turf.z, target_turf.x + width, target_turf.y - 1, target_turf.z)

		// Check the vertical line for the strict type or space
		// ASSUMPTION: Square border shape
		var/expand_y_start = 0
		for(var/turf/y_turf in block(target_turf.x, target_turf.y, target_turf.z, target_turf.x, min(world.maxy, target_turf.y + height), target_turf.z))
			if(y_turf.type == crop_within_type || istype(y_turf, /turf/open/space))
				expand_y_start = y_turf.y
				break
		if(expand_y_start)
			// Western strip cordon
			. += block(target_turf.x - 1, expand_y_start, target_turf.z, target_turf.x - 1, target_turf.y + height, target_turf.z)

		if(expand_x_start || expand_y_start)
			if(expand_x_start && expand_y_start)
				expand_x_start = target_turf.x
				expand_y_start = target_turf.y
			else
				expand_x_start = max(target_turf.x, expand_x_start)
				expand_y_start = max(target_turf.y, expand_y_start)
			// East strip cordon
			. += block(target_turf.x + width, expand_y_start, target_turf.z, target_turf.x + width, target_turf.y + height - 1, target_turf.z)
			// North strip cordon
			. += block(expand_x_start, target_turf.y + height, target_turf.z, target_turf.x + width, target_turf.y + height, target_turf.z)

	return . + CORNER_BLOCK(target_turf, min(width, x_upper - target_turf.x + 1), min(height, y_upper - target_turf.y + 1))

//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(file, name)
	var/datum/map_template/template = new(file, name)
	template.load_new_z()

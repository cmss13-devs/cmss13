#define INTERIOR_BORDER_SIZE 2

SUBSYSTEM_DEF(interior)
	name = "Interiors"
	flags = SS_NO_FIRE|SS_NO_INIT
	var/list/datum/interior/interiors = list()

/// Loads an interior, requires the interior datum
/datum/controller/subsystem/interior/proc/load_interior(datum/interior/interior)
	if(!interior || !istype(interior))
		CRASH("Invalid interior passed to SSinterior.load_interior()")

	var/datum/map_template/interior/template = interior.map_template

	var/height_to_request = template.height + INTERIOR_BORDER_SIZE
	var/width_to_request = template.width + INTERIOR_BORDER_SIZE

	var/datum/turf_reservation/reserved_area = SSmapping.request_turf_block_reservation(width_to_request, height_to_request, reservation_type = /datum/turf_reservation/interior)

	var/turf/bottom_left = reserved_area.bottom_left_turfs[1]

	var/list/bounds = template.load(locate(bottom_left.x + (INTERIOR_BORDER_SIZE / 2), bottom_left.y + (INTERIOR_BORDER_SIZE / 2), bottom_left.z), centered = FALSE)

	var/list/turfs = block( locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))

	var/list/areas = list()
	for(var/turf/current_turf as anything in turfs)
		areas |= current_turf.loc

	for(var/area/current_area as anything in areas)
		current_area.add_base_lighting()

	interiors += interior
	return reserved_area

/// Finds which interior is at (x, y, z) and returns its interior datum
/datum/controller/subsystem/interior/proc/get_interior_by_coords(x, y, z)
	for(var/datum/interior/current_interior in interiors)
		var/list/turf/bounds = current_interior.get_bound_turfs()
		if(!bounds)
			continue
		if(x >= bounds[1].x && x <= bounds[2].x && y >= bounds[1].y && y <= bounds[2].y)
			return current_interior
	return

/// Checks if an atom is in an interior
/datum/controller/subsystem/interior/proc/in_interior(loc)
	if(!loc)
		CRASH("No loc passed to is_in_interior()")
	if(!isturf(loc))
		loc = get_turf(loc)

	var/datum/turf_reservation/interior/reservation = SSmapping.used_turfs[loc]

	if(!istype(reservation))
		return FALSE

	return TRUE

#undef INTERIOR_BORDER_SIZE

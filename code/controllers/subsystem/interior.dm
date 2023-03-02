SUBSYSTEM_DEF(interior)
	name = "Interiors"
	flags = SS_NO_FIRE|SS_NO_INIT
	init_order = SS_INIT_INTERIOR

	var/list/datum/interior/interiors = list()


/datum/controller/subsystem/interior/proc/load_interior(datum/interior/interior)
	if(!interior || !istype(interior))
		CRASH("Invalid interior passed to SSinterior.load_interior()")

	var/datum/map_template/interior/template = interior.map_template

	var/datum/turf_reservation/reserved_area = SSmapping.RequestBlockReservation(template.width, template.height, type = /datum/turf_reservation/interior)

	var/turf/bottom_left = TURF_FROM_COORDS_LIST(reserved_area.bottom_left_coords)
	template.load(bottom_left, centered = FALSE)

	interiors += interior

	return reserved_area


// Finds which interior is at (x,y) and returns its interior datum
/datum/controller/subsystem/interior/proc/get_interior_by_coords(x, y, z)
	for(var/datum/interior/current_interior in interiors)
		var/list/turf/bounds = current_interior.get_bound_turfs()
		if(!bounds)
			continue

		if(x >= bounds[1].x && x <= bounds[2].x && y >= bounds[1].y && y <= bounds[2].y)
			return current_interior

	return FALSE

/datum/controller/subsystem/interior/proc/in_interior(loc)
	if(!loc)
		CRASH("No loc passed to is_in_interior()")

	if(!isturf(loc))
		loc = get_turf(loc)

	var/datum/turf_reservation/interior/reservation = SSmapping.used_turfs[loc]

	if(!istype(reservation))
		return FALSE

	return TRUE

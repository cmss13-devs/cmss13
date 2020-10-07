/datum/interior
	// Name of the map containing the interior
	// Doubles as just a general name
	var/name = null

	// Whether the interior is ready to enter or not
	var/ready = FALSE

	// How far can we see out windows?
	var/view_range = 8

	// Convenience vars. Doesn't include view blocker padding
	var/width = -1
	var/height = -1

	// Which atom we represent the interior of
	var/atom/exterior = null
	// A map template representing the interior
	var/datum/map_load_metadata/interior_data = null

	// Which interior chunk we've been assigned by the interior manager
	var/chunk_id = null

	// A list of entry/exit markers in the interior
	var/list/entrance_markers = list()

	// How many grunga bungas can fit inside the vehicle?
	var/human_capacity = 2
	// How many xenos can fit inside the vehicle?
	var/xeno_capacity = 2
	// How many unga dungas are inside the vehicle?
	var/humans_inside = 0
	// How many xenos are inside the vehicle?
	var/xenos_inside = 0

/datum/interior/New(var/atom/E)
	. = ..()

	if(!E)
		qdel(src)
		return

	exterior = E

/datum/interior/Destroy()
	exterior = null

	interior_manager.unload_chunk(chunk_id)

	QDEL_NULL(interior_data)

	return ..()

// Use this proc to load the template back in
/datum/interior/proc/create_interior(var/interior_map)
	if(!isnull(interior_data))
		return

	if(!interior_map)
		return
	name = interior_map

	var/list/data = interior_manager.load_interior(src)

	if(!data)
		qdel(src)
		return

	interior_data = data[1]
	chunk_id = data[2]

	width = (interior_data.bounds[MAP_MAXX] - interior_data.bounds[MAP_MINX]) + 1
	height = (interior_data.bounds[MAP_MAXY] - interior_data.bounds[MAP_MINY]) + 1

	find_entrances()
	handle_landmarks()

	ready = TRUE

/datum/interior/proc/get_passengers()
	if(!ready)
		return null

	var/list/passengers
	var/list/bounds = get_bound_turfs()
	for(var/turf/T in block(bounds[1], bounds[2]))
		for(var/atom/A in T)
			if(isliving(A))
				LAZYADD(passengers, A)
			else
				for(var/mob/living/M in A)
					LAZYADD(passengers, M)
	return passengers

/datum/interior/proc/update_passenger_count()
	humans_inside = 0
	xenos_inside = 0

	if(!ready)
		return

	for(var/mob/living/M in get_passengers())
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!H.is_revivable())
				continue
			humans_inside++
		else if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.stat == DEAD)
				continue
			xenos_inside++

// Moves the atom to the interior
/datum/interior/proc/enter(var/atom/movable/A, var/entrance_used)
	if(!ready)
		return

	if(!A)
		return
	// Ensure we have an accurate count before trying to enter
	update_passenger_count()

	var/humans_entering = ishuman(A)
	var/xenos_entering = isXeno(A)
	for(var/mob/living/M in A)
		if(ishuman(M))
			humans_entering++
		else if(isXeno(M))
			xenos_entering++

	// Xenos don't count towards the passenger limit
	if((humans_entering + humans_inside > human_capacity) || (xenos_entering + xenos_inside > xeno_capacity))
		if(ismob(A))
			to_chat(A, SPAN_WARNING("There's no more space inside!"))
		return FALSE

	// If no entrance is specified drop them in the middle of the interior
	if(!entrance_used)
		var/turf/middle_turf = get_middle_turf()
		if(!middle_turf)
			return FALSE

		A.forceMove(middle_turf)
		return TRUE

	for(var/obj/effect/landmark/interior/spawn/entrance/E in entrance_markers)
		if(E.tag == entrance_used)
			A.forceMove(get_turf(E))
			return TRUE

	return FALSE

// Moves the atom to the exterior
/datum/interior/proc/exit(var/atom/movable/A, var/turf/exit_turf)
	if(!exit_turf)
		exit_turf = get_turf(exterior)
	if(!exit_turf)
		return FALSE
	if(exit_turf.density)
		return FALSE

	var/exit_dir = get_dir(exterior, exit_turf)
	for(var/atom/O in exit_turf)
		if(!O.density)
			continue

		// The exterior itself shouldn't block the exit
		if(O == exterior)
			continue

		if(istype(O, /atom/movable))
			var/atom/movable/M = O
			// Assume we can move the atom over or something when it's not anchored
			if(!M.anchored)
				continue

		if(O.BlockedPassDirs(A, exit_dir))
			if(ismob(A))
				to_chat(A, SPAN_WARNING("Something is blocking the exit!"))
			return FALSE

	A.forceMove(get_turf(exit_turf))

	return TRUE

// Returns min and max turfs for the interior
/datum/interior/proc/get_bound_turfs()
	var/turf/min = locate(interior_data.bounds[MAP_MINX], interior_data.bounds[MAP_MINY], interior_manager.interior_z)
	if(!min)
		return null

	var/turf/max = locate(interior_data.bounds[MAP_MAXX], interior_data.bounds[MAP_MAXY], interior_manager.interior_z)
	if(!max)
		return null

	return list(min, max)

/datum/interior/proc/get_middle_turf()
	var/list/turf/bounds = get_bound_turfs()
	var/turf/middle = locate(Floor(bounds[1].x + (bounds[2].x - bounds[1].x)/2), Floor(bounds[1].y + (bounds[2].y - bounds[1].y)/2), bounds[1].z)
	
	return middle

// Store all entrance and exit markers
/datum/interior/proc/find_entrances()
	var/list/bounds = get_bound_turfs()

	for(var/turf/T in block(bounds[1], bounds[2]))
		var/obj/effect/landmark/interior/spawn/entrance/E = locate() in T
		if(E)
			entrance_markers += E

// Spawn interactables like driver and gunner seats
// Also open view blockers where there are windows
/datum/interior/proc/handle_landmarks()
	var/list/bounds = get_bound_turfs()

	for(var/turf/T in block(bounds[1], bounds[2]))
		for(var/obj/effect/landmark/interior/L in T)
			L.on_load(src)

/// special role slots datum. Stores category name, roles, amount of taken slots and total slots.
/datum/role_reserved_slots
	/// category name for roles
	var/category_name = ""
	/// roles, that fit this category. Don't put same role in more than one category, only first found is checked.
	var/list/roles = list()
	/// amount of slots taken.
	var/taken = 0
	/// total amount of slots.
	var/total = 0

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

	//check multitile.dm for detailed explanation
	//common passenger slots
	var/passengers_slots = 2
	//common passenger slots taken
	var/passengers_taken_slots = 0
	//xenos passenger slots
	var/xenos_slots = 2
	//xenos passenger slots taken
	var/xenos_taken_slots = 0
	//special roles passenger slots, kept in datums
	var/list/role_reserved_slots = list()

/datum/interior/New(var/atom/E)
	. = ..()

	if(!E)
		qdel(src)
		return

	exterior = E

/datum/interior/Destroy()
	exterior = null

	GLOB.interior_manager.unload_chunk(chunk_id)

	QDEL_NULL(interior_data)

	return ..()

// Use this proc to load the template back in
/datum/interior/proc/create_interior(var/interior_map)
	if(!isnull(interior_data))
		return

	if(!interior_map)
		return
	name = interior_map

	var/list/data = GLOB.interior_manager.load_interior(src)

	if(!data)
		qdel(src)
		return

	interior_data = data[1]
	chunk_id = data[2]

	width = (interior_data.bounds[MAP_MAXX] - interior_data.bounds[MAP_MINX]) + 1
	height = (interior_data.bounds[MAP_MAXY] - interior_data.bounds[MAP_MINY]) + 1

	find_entrances()
	handle_landmarks()

	update_passenger_settings()

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

//syncronizes vehicles passenger settings to interior and resets taken slots
/datum/interior/proc/update_passenger_settings()
	var/obj/vehicle/multitile/V = exterior
	passengers_slots = V.passengers_slots
	xenos_slots = V.xenos_slots
	passengers_taken_slots = 0
	xenos_taken_slots = 0

	if(V.role_reserved_slots.len)
		role_reserved_slots = list()
		role_reserved_slots = V.role_reserved_slots.Copy()
		for(var/datum/role_reserved_slots/RRS in role_reserved_slots)
			RRS.taken = 0

/datum/interior/proc/update_passenger_count()
	//If someone changed vehicle's capacity, we want interior to also accept these changes.
	update_passenger_settings()

	if(!ready)
		return

	for(var/mob/living/M in get_passengers())
		if(ishuman(M))
			//whether we put human in some category
			var/role_slot_taken = FALSE
			var/mob/living/carbon/human/H = M
			if(!H.is_revivable())
				continue

			//if we have any special roles slots, we check them first
			if(role_reserved_slots.len)
				for(var/datum/role_reserved_slots/RRS in role_reserved_slots)
					//check each category if it has our role. We stop after we find role to avoid checking others.
					if(RRS.roles.Find(H.job))
						RRS.taken++
						role_slot_taken = TRUE
						break
			//if no special slot is taken, we will check for common passengers
			if(!role_slot_taken)
				passengers_taken_slots++

		else if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			if(X.stat == DEAD)
				continue
			xenos_taken_slots++


// Moves the atom to the interior
/datum/interior/proc/enter(var/atom/movable/A, var/entrance_used)
	if(!ready)
		return

	if(!A)
		return

	if(istype(A, /obj/structure/barricade) || istype(A, /obj/structure/machinery/defenses) || istype(A, /obj/structure/machinery/m56d_post))
		return FALSE

	// Ensure we have an accurate count before trying to enter
	update_passenger_count()

	var/mob/living/M
	if(ismob(A))
		M = A
	else
		var/mobs_amount = 0
		for(M in A)
			mobs_amount++
			//it's much easier to deny entering with many mobs rather than to juggle them around
			M = A
			if(mobs_amount > 1)
				exterior.visible_message(SPAN_WARNING("\The [A] is too bulky to fit with so many creatures inside."))
				return FALSE

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.is_revivable())
			//whether we put human in some category
			var/role_slot_taken = FALSE
			//if we have any special roles slots, we check them first
			if(role_reserved_slots.len)
				for(var/datum/role_reserved_slots/RRS in role_reserved_slots)
					//check each category if it has our role. We stop after we find role to avoid checking others.
					if(RRS.roles.Find(H.job))
						//if we have slots for this category, take it
						if(RRS.taken < RRS.total)
							RRS.taken++
							role_slot_taken = TRUE
						break
			//if no special slot is taken, we will check for common passengers
			if(!role_slot_taken)
				if(passengers_taken_slots < passengers_slots)
					//even if somehow mob moving will fail further down in proc, extra slot taken won't matter, since next update_passenger_count() will fix it
					passengers_taken_slots++
				else
					if(M.stat == CONSCIOUS)
						to_chat(M, SPAN_WARNING("There's no more space inside!"))
					return FALSE

	else if(isXeno(M))
		if(M.stat != DEAD)
			if(xenos_taken_slots < xenos_slots)
				xenos_taken_slots++
			else
				if(M.stat == CONSCIOUS)
					to_chat(M, SPAN_WARNING("There's no more space inside!"))
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
	var/turf/min = locate(interior_data.bounds[MAP_MINX], interior_data.bounds[MAP_MINY], GLOB.interior_manager.interior_z)
	if(!min)
		return null

	var/turf/max = locate(interior_data.bounds[MAP_MAXX], interior_data.bounds[MAP_MAXY], GLOB.interior_manager.interior_z)
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

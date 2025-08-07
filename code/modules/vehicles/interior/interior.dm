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

	// A list of entry/exit markers in the interior
	var/list/entrance_markers

	//check multitile.dm for detailed explanation
	//common passenger slots
	var/passengers_slots = 2
	//common passenger slots taken
	var/passengers_taken_slots = 0
	//xenos passenger slots
	var/xenos_slots = 2
	//xenos passenger slots taken
	var/xenos_taken_slots = 0

	//some vehicles have special slots for dead revivable corpses for various reasons
	//revivable corpses slots
	var/revivable_dead_slots = 0
	//revivable corpses slots taken
	var/revivable_dead_taken_slots = 0

	//list of stuff we do NOT want to be pulled inside. Taken from exterior's list
	var/list/forbidden_atoms

	//special roles passenger slots, kept in datums
	var/list/role_reserved_slots = list()

	/// the map template associated with this interior
	var/datum/map_template/interior/map_template

	/// the turf reservation associated with this interior
	var/datum/turf_reservation/interior/reservation

/datum/interior/New(atom/E)
	. = ..()

	if(!E)
		qdel(src)
		return

	exterior = E

/datum/interior/Destroy()
	exterior = null
	entrance_markers = null

	QDEL_NULL(reservation)
	SSinterior.interiors -= src

	return ..()

// Use this proc to load the template back in
/datum/interior/proc/create_interior(interior_map)
	if(reservation)
		return

	if(!interior_map)
		return

	map_template = new interior_map()
	name = map_template.interior_id

	reservation = SSinterior.load_interior(src)

	if(!reservation)
		qdel(src)
		return

	width = map_template.width
	height = map_template.height

	find_entrances()
	handle_landmarks()

	update_passenger_settings()
	update_forbidden_atoms()

	ready = TRUE

//setup forbidden atoms list
/datum/interior/proc/update_forbidden_atoms()
	forbidden_atoms = list()
	if(isVehicleMultitile(exterior))
		var/obj/vehicle/multitile/V = exterior
		if(length(V.forbidden_atoms))
			forbidden_atoms = V.forbidden_atoms

/datum/interior/proc/get_passengers()
	if(!ready)
		return null

	var/list/passengers
	var/list/bounds = get_bound_turfs()
	for(var/turf/T as anything in block(bounds[1], bounds[2]))
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
	revivable_dead_slots = V.revivable_dead_slots
	passengers_taken_slots = 0
	xenos_taken_slots = 0
	revivable_dead_taken_slots = 0

	if(length(V.role_reserved_slots))
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
			//some vehicles have separate count for non-perma dead corpses
			if(H.stat == DEAD && H.is_revivable())
				if(revivable_dead_slots && revivable_dead_taken_slots < revivable_dead_slots)
					revivable_dead_taken_slots++
					role_slot_taken = TRUE

			//if we have any special roles slots, we check them first
			if(length(role_reserved_slots))
				for(var/datum/role_reserved_slots/RRS in role_reserved_slots)
					//check each category if it has our role. We stop after we find role to avoid checking others.
					if(RRS.roles.Find(H.job))
						if(RRS.taken < RRS.total)
							RRS.taken++
							role_slot_taken = TRUE
						break
			//if no special slot is taken, we will check for common passengers
			if(!role_slot_taken)
				passengers_taken_slots++

		else if(isxeno(M))
			var/mob/living/carbon/xenomorph/X = M
			if(X.stat == DEAD)
				continue
			xenos_taken_slots++


// Moves the atom to the interior
/datum/interior/proc/enter(atom/movable/A, entrance_used)
	if(!ready)
		return FALSE

	if(!A)
		return FALSE

	if(forbidden_atoms)
		for(var/type in forbidden_atoms)
			if(istype(A, type))
				if(A.pulledby)
					to_chat(A.pulledby, SPAN_WARNING("\The [A] won't fit inside!"))
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
		var/role_slot_taken = FALSE
		if(H.stat == DEAD && H.is_revivable())
			//this is here to prevent accummulating people in vehicle by bringing in more and more revivable dead and reviving them inside
			if(revivable_dead_slots && revivable_dead_taken_slots < revivable_dead_slots && passengers_taken_slots < passengers_slots + revivable_dead_slots)
				revivable_dead_taken_slots++
				role_slot_taken = TRUE

		if(!role_slot_taken && length(role_reserved_slots))
			for(var/datum/role_reserved_slots/RRS in role_reserved_slots)
				//check each category if it has our role. We stop after we find role to avoid checking others.
				if(RRS.roles.Find(H.job))
					//if we have slots for this category, take it
					if(RRS.taken < RRS.total)
						RRS.taken++
						role_slot_taken = TRUE
					break


		//whether we put human in some category
		//if we have any special roles slots, we check them first
		//if no special slot is taken, we will check for common passengers
		if(!role_slot_taken)
			if(passengers_taken_slots < passengers_slots)
				//even if somehow mob moving will fail further down in proc, extra slot taken won't matter, since next update_passenger_count() will fix it
				passengers_taken_slots++
			else
				if(M.stat == CONSCIOUS)
					to_chat(M, SPAN_WARNING("There's no more space inside!"))
				return FALSE

	else if(isxeno(M))
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
			var/turf/entrance_turf = locate(E.x + E.offset_x, E.y + E.offset_y, E.z)
			A.forceMove(entrance_turf)
			return TRUE

	return FALSE

// Moves the atom to the exterior
/datum/interior/proc/exit(atom/movable/A, turf/exit_turf)
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
	update_passenger_count()
	return TRUE

// Returns min and max turfs for the interior
/datum/interior/proc/get_bound_turfs()
	return list(reservation.bottom_left_turfs[1], reservation.top_right_turfs[1])

/datum/interior/proc/get_middle_coords()
	var/turf/min = reservation.bottom_left_turfs[1]
	var/turf/max = reservation.top_right_turfs[1]
	return list(floor(min.x + (max.x - min.x)/2), floor(min.y + (max.y - min.y)/2), min.z)


/datum/interior/proc/get_middle_turf()
	var/list/turf/bounds = get_bound_turfs()
	var/turf/middle = locate(floor(bounds[1].x + (bounds[2].x - bounds[1].x)/2), floor(bounds[1].y + (bounds[2].y - bounds[1].y)/2), bounds[1].z)

	return middle

// Store all entrance and exit markers
/datum/interior/proc/find_entrances()
	var/list/bounds = get_bound_turfs()

	for(var/turf/T as anything in block(bounds[1], bounds[2]))
		var/obj/effect/landmark/interior/spawn/entrance/E = locate() in T
		if(E)
			LAZYADD(entrance_markers, E)

// Spawn interactables like driver and gunner seats
// Also open view blockers where there are windows
/datum/interior/proc/handle_landmarks()
	var/list/bounds = get_bound_turfs()

	for(var/turf/T as anything in block(bounds[1], bounds[2]))
		for(var/obj/effect/landmark/interior/L in T)
			L.on_load(src)

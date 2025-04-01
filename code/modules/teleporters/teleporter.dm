/*
	Teleporter datums
*/

/datum/teleporter
	var/list/locations   // Complex list of turfs by ID
	var/list/linked_consoles // Consoles linked to this abstract teleporter
	var/id   // Our teleporter UUID string

	COOLDOWN_DECLARE(next_teleport_time)

	var/cooldown // int to cool down

	var/name // User-friendly name

/datum/teleporter/New()
	locations = list()
	linked_consoles = list()

/datum/teleporter/Destroy()
	for(var/obj/structure/machinery/computer/teleporter_console/T in linked_consoles)
		T.linked_teleporter = null
	linked_consoles = null
	locations = null
	. = ..()

// Teleport (NO SAFETY CHECKS)
/datum/teleporter/proc/teleport(location_source, location_dest)
	var/list/turf/source_turfs = locations[location_source]
	var/list/turf/dest_turfs = locations[location_dest]

	if(!LAZYLEN(source_turfs))
		log_debug("Invalid source location ID [location_source] handed to teleporter [id]. Error code: TELEPORTER_3")
		log_admin("Invalid source location ID [location_source] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_3")
		return FALSE

	if(!LAZYLEN(dest_turfs))
		log_debug("Invalid destination location ID [location_dest] handed to teleporter [id]. Error code: TELEPORTER_3")
		log_admin("Invalid destination location ID [location_dest] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_3")
		return FALSE

	for(var/turf_key in source_turfs)
		var/turf/source_turf = source_turfs[turf_key]
		var/turf/dest_turf = dest_turfs[turf_key]

		for(var/atom/movable/A in source_turf)
			A.forceMove(dest_turf)

	COOLDOWN_START(src, next_teleport_time, cooldown)
	return TRUE

// Checks every turf in the location to make sure it contains no dense things (safe to teleport to)
// Returns: 1 = safe, 0 = unsafe
/datum/teleporter/proc/safety_check_destination(location_id)
	var/list/turf/turfs_to_check = locations[location_id]

	if(!turfs_to_check)
		log_debug("Invalid location ID [location_id] handed to teleporter [id]. Error code: TELEPORTER_2")
		log_admin("Invalid location ID [location_id] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_2")
		return FALSE

	for(var/turf_key in turfs_to_check)

		var/turf/T = turfs_to_check[turf_key]

		if(T.density)
			return FALSE

		for(var/atom/A in T)

			if(A.density)
				return FALSE

	return TRUE

// Checks every turf in the Location to make sure it contains no objects banned from teleporting
/datum/teleporter/proc/safety_check_source(location_id)
	var/list/turf/turfs_to_check = locations[location_id]

	if(!turfs_to_check)
		log_debug("Invalid location ID [location_id] handed to teleporter [id]. Error code: TELEPORTER_5")
		log_admin("Invalid location ID [location_id] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_5")
		return FALSE

	var/vehicle_checked = 0

	for(var/turf_key in turfs_to_check)

		var/turf/T = turfs_to_check[turf_key]
		for(var/atom/A in T)

			// Make sure - IF there's a vehicle in the source area - that ALL of its turfs are inside.
			// Use a bool to make sure we don't scan our area once for every component of the vehicle - we only need to do it once.
			if(istype(A, /obj/vehicle/multitile) && !vehicle_checked)
				if(!check_vehicle_safety(A, location_id))
					return FALSE
				vehicle_checked = 1

	return TRUE

// 0 = can't teleport, 1 = can
/datum/teleporter/proc/check_teleport_cooldown()
	if(!cooldown)
		log_debug("Teleporter [id] has no cooldown set. Error code: TELEPORTER_1")
		log_admin("Teleporter [id] has no cooldown set. Tell the devs. Error code: TELEPORTER_1")
		return FALSE // Return UNSAFE

	if(!COOLDOWN_FINISHED(src, next_teleport_time))
		return FALSE

	return TRUE

// Checks that the *entire* tank is inside the teleporter
// Probably the most hacky solution I've ever done, not my fault the tank maintains
// no current list of its linked objects
// As always, 1 = safe, 0 = unsafe

/datum/teleporter/proc/check_vehicle_safety(obj/vehicle/multitile/vehicle, location_id)
	var/list/turf/location_turfs = locations[location_id]

	var/parts_count = (vehicle.bound_width / world.icon_size) * (vehicle.bound_height / world.icon_size)
	var/current_count = 0

	if(!location_turfs)
		log_debug("Invalid location ID [location_id] handed to teleporter [id]. Error code: TELEPORTER_4")
		log_admin("Invalid location ID [location_id] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_4")
		return FALSE

	for(var/turf_key in location_turfs)
		var/turf/T = location_turfs[turf_key]

		for(var/obj/vehicle/multitile/V in T)
			if(V == vehicle)
				current_count++

			if(current_count == parts_count)
				return TRUE // Good to go

	return FALSE

// Unsafe proc to get the list of turfs from a location
/datum/teleporter/proc/get_turfs_by_location(location_id)
	return locations[location_id]

#define ANIMATION_DURATION 18
// Handler proc for VFX. mostly some easy timing maths
/datum/teleporter/proc/apply_vfx(location_id, time_to_fire = 30)
	if(!(location_id in locations))
		log_debug("Invalid location ID [location_id] handed to teleporter [id]. Error code: TELEPORTER_6")
		log_admin("Invalid location ID [location_id] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_6")
		return

	var/time_to_effects = time_to_fire - ANIMATION_DURATION
	sleep(time_to_effects)
	apply_animation(location_id)
	return

// Backend proc that actually applies the animation
/datum/teleporter/proc/apply_animation(location_id)
	var/list/turfs_to_do = locations[location_id]

	if(!turfs_to_do)
		log_debug("Invalid location ID [location_id] handed to teleporter [id]. Error code: TELEPORTER_7")
		log_admin("Invalid location ID [location_id] handed to teleporter [id]. Tell the devs. Error code: TELEPORTER_7")
		return

	for(var/turf_key in turfs_to_do)
		var/turf/T = turfs_to_do[turf_key]
		var/obj/effect/teleporter_vfx/animation_holder = new()
		animation_holder.forceMove(T)
		flick(animation_holder.icon_state, animation_holder)

/obj/effect/teleporter_vfx
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'icons/effects/effects.dmi'
	icon_state = "teleport"
	var/animation_duration = ANIMATION_DURATION // 18 frames long

/obj/effect/teleporter_vfx/New()
	set waitfor = 0
	sleep(animation_duration)
	qdel(src)

#undef ANIMATION_DURATION

// teleporteren themselves

/datum/teleporter/corsat
	id = "Corsat_Teleporter"
	cooldown = 5 MINUTES // Five minutes
	name = "CORSAT Experimental Teleporter"

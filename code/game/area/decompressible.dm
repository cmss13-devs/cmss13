/area/decompressible
	weather_enabled = FALSE
	var/obj/effect/decompressed/decompression_overlay = null

	/// How long it takes for this room to repressurize and become habitable.
	/// Set to -1 for rooms that are permanently decompressed.
	var/recompression_time = 1 MINUTES

	/// Is this room currently decompressed?
	var/decompressed = FALSE

	/// When in gametime this room was decompressed.
	var/time_decompressed = null

/area/decompressible/Initialize(mapload, ...)
	decompression_overlay = new /obj/effect/decompressed/()
	. = ..()

/area/decompressible/proc/decompress(breach_location, alarm = TRUE)
	time_decompressed = REALTIMEOFDAY
	if (decompressed)
		return

	decompressed = TRUE
	temperature = 42 // 42 K
	pressure = 0 // 0 kPa

	// Handle decompression vfx
	overlays += decompression_overlay

	// Close firedoors
	addtimer(CALLBACK(src, PROC_REF(air_doors_close)), 1 SECONDS)

	// Handle violently flinging everything
	for (var/obj/obj_in_area in src)
		if (!obj_in_area)
			continue
		if (obj_in_area.anchored)
			continue

		// Calculate how violently to throw it
		var/distance = get_dist(get_turf(obj_in_area), breach_location)
		var/throw_range = (distance - 1) > 0 ? 16 / (distance - 1) : 16
		var/throw_speed
		switch (distance)
			if (-1 to 3)
				throw_speed = SPEED_VERY_FAST
			if (4 to 6)
				throw_speed = SPEED_FAST
			else
				throw_speed = SPEED_AVERAGE

		// Throw everything not bolted down towards the breach location, and then some
		var/list/end_throw_callbacks = list(CALLBACK(src, PROC_REF(space_object), obj_in_area, get_turf(obj_in_area), breach_location))
		if (throw_range >= 1)
			INVOKE_ASYNC(src, PROC_REF(fling), obj_in_area, breach_location, throw_range, throw_speed, end_throw_callbacks, null)

	for (var/mob/living/carbon/victim in src)
		// Immobilizing the victim so decompression flinging works properly
		ADD_TRAIT(victim, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DECOMPRESSION)
		// Setting up callbacks for when the fling finishes
		var/list/end_throw_callbacks = list(CALLBACK(src, PROC_REF(space_carbon), victim, get_turf(victim), breach_location))
		var/list/collision_callbacks = list(CALLBACK(src, PROC_REF(process_collision), victim))

		// Calculate how violently to throw the victim, and apply screenshake accordingly
		var/distance = get_dist(get_turf(victim), breach_location)
		var/throw_range = (distance - 1) > 0 ? 16 / (distance - 1) : 16
		var/throw_speed
		switch (distance)
			if (-1 to 3)
				throw_speed = SPEED_VERY_FAST
				shake_camera(victim, 5, 7)
			if (4 to 6)
				throw_speed = SPEED_FAST
				shake_camera(victim, 5, 5)
			else
				throw_speed = SPEED_AVERAGE
				shake_camera(victim, 5, 3)

		// Actually fling them
		if (throw_range >= 1)
			INVOKE_ASYNC(src, PROC_REF(fling), victim, breach_location, throw_range, throw_speed, end_throw_callbacks, collision_callbacks)

		// You're boned, bro
		to_chat(victim, SPAN_HIGHDANGER("You are violently thrown off your feet by the rushing air!"))

		// Handle damage to the victim if they are a human
		// Can make a difference if the human crashes into something during decompression or is otherwise saved
		var/mob/living/carbon/human/human = victim
		if (human != null)
			// Deal a lotta brute
			human.take_limb_damage(40)

			var/datum/internal_organ/lungs/lungs = human.internal_organs_by_name["lungs"]
			if (!lungs || lungs.organ_status & ORGAN_BROKEN)
				continue

			// Rupture their lungs if they're not already
			to_chat(human, SPAN_HIGHDANGER("You feel your lungs explode during the rapid decompression!"))
			lungs.take_damage(20)

	if (recompression_time != -1)
		addtimer(CALLBACK(src, PROC_REF(recompress)), recompression_time)

/// Wrapper proc for flinging things during decompression asynchronously.
/area/decompressible/proc/fling(atom/movable/flingee, target, range, speed, end_throw_callbacks, collision_callbacks)
	flingee.throw_atom(target, range, speed, src, 1, HIGH_LAUNCH, null, end_throw_callbacks, collision_callbacks)

/// Called when the victim being flung out by a rapid decompression collides with something.
/// Lets the victim act early, since they were kicked out of the fling early.
/area/decompressible/proc/process_collision(mob/living/carbon/victim)
	REMOVE_TRAIT(victim, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DECOMPRESSION)

/// A simpler version of space_carbon that flings an object without processing traits.
/area/decompressible/proc/space_object(obj/debris, original_location, breach_location)
	if (get_turf(debris) != breach_location)
		return
	space_thing(debris, original_location, breach_location)

/// Called after a carbon has been initially flung by rapid decompression.
/// Can either proceed with sending them off into space or sparing them, depending on if they collided with something.
/area/decompressible/proc/space_carbon(mob/living/carbon/victim, original_location, breach_location)
	REMOVE_TRAIT(victim, TRAIT_IMMOBILIZED, TRAIT_SOURCE_DECOMPRESSION)
	if (get_turf(victim) != breach_location)
		// If they're not at the location of the breach, then don't proceed with flinging them
		return
	space_thing(victim, original_location, breach_location)

/// Flings "something" into space, before deleting it.
/area/decompressible/proc/space_thing(atom/movable/thing, original_location, breach_location)
	var/fling_angle = Get_Angle(original_location, breach_location)
	var/turf/fling_target = get_angle_target_turf(thing, fling_angle, 8)

	var/list/end_throw_callbacks = list(CALLBACK(src, PROC_REF(cleanup_spaced_thing), thing))
	fling(thing, fling_target, 8, SPEED_VERY_FAST, src, end_throw_callbacks = end_throw_callbacks)

/// A wrapper method for qdel that lets area/decompressible be the owner of the callback.
/// Can be used to define special behavior instead of just deleting an object.
/area/decompressible/proc/cleanup_spaced_thing(atom/movable/thing)
	if (istype(thing, /mob/living/carbon/))
		var/mob/living/carbon/victim = thing
		to_chat(victim, SPAN_DARKER_RED("You are lost to the depths of space..."))

	qdel(thing)

/area/decompressible/proc/recompress()
	decompressed = FALSE
	time_decompressed = null

	// Remove overlays
	overlays -= decompression_overlay

	// Re-open firelocks (NOT ATMOS SHUTTERS)
	air_doors_open()

	temperature = initial(temperature)
	pressure = initial(pressure)

/obj/effect/decompressed
	name = "decompression vfx holder"
	icon = 'icons/effects/weather.dmi'
	icon_state = "strata_clearsky"
	invisibility = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = WEATHER_LAYER

// Areas for decompression_test.dmm
/area/decompressible/test/
	icon = 'icons/turf/area_almayer.dmi'

/area/decompressible/test/bridge
	icon_state = "cic"

/area/decompressible/test/south_observation
	icon_state = "port"

/area/decompressible/test/north_observation
	icon_state = "starboard"

/area/decompressible/test/cargo
	icon_state = "req"

/area/decompressible/test/maints
	icon_state = "lowerhull"

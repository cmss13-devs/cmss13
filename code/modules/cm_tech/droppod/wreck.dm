/// A generic piece of wreckage falling nearby. Wraps a movable payload instead of a supply crate.
/obj/structure/droppod/wreck
	name = "\improper wreckage"
	desc = "A twisted piece of vehicle wreckage."
	drop_time = 0
	dropping_time = 1.5 SECONDS
	open_time = 0
	landing_sound = 'sound/vehicles/metalimpact1.ogg'
	land_sound = 'sound/effects/metal_crash.ogg'
	/// The real object this pod is posing as while it falls.
	var/atom/movable/payload

/obj/structure/droppod/wreck/Initialize(mapload, atom/movable/payload_atom)
	. = ..()
	if(!payload_atom)
		return INITIALIZE_HINT_QDEL
	payload_atom.forceMove(src)
	payload = payload_atom

/obj/structure/droppod/wreck/Destroy(force)
	payload = null
	return ..()

/**
 * Poses as the wrapped payload so it visually reads as the actual wreckage falling.
 * Doesn't call the base droppod's update_icon(), since wreckage doesn't parachute down.
 * Also copies the payload's pixel_x so it doesn't render offset from its real position.
 */
/obj/structure/droppod/wreck/update_icon()
	overlays.Cut()
	if(!payload)
		return
	icon = payload.icon
	icon_state = payload.icon_state
	overlays += payload.overlays
	pixel_x = payload.pixel_x

/// Same fall animation as the base droppod, but lands at the payload's own resting pixel_y.
/obj/structure/droppod/wreck/drop_on_target(turf/T)
	droppod_flags |= DROPPOD_DROPPING
	invisibility = 0
	var/resting_pixel_y = payload ? payload.pixel_y : 0
	pixel_y = 32*tiles_to_take + resting_pixel_y
	playsound(loc, landing_sound, 100, TRUE, 15)
	animate(src, pixel_y = resting_pixel_y, time = dropping_time, easing = LINEAR_EASING)
	addtimer(CALLBACK(src, PROC_REF(land), T), dropping_time)

/// Post effects
/obj/structure/droppod/wreck/post_land()
	. = ..()
	var/datum/effect_system/spark_spread/land_sparks = new
	land_sparks.set_up(5, 0, loc)
	land_sparks.start()

/obj/structure/droppod/wreck/open()
	for(var/atom/movable/content as anything in contents)
		content.forceMove(loc)
	payload = null
	qdel(src)

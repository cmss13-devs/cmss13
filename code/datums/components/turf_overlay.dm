///turf_overlay_effect component. adds and removes
/datum/component/turf_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/turf_overlay_effect/my_turf_overlay_effect
	var/turf_type //! Turf type the effect applies to
	var/ttl = 1

/datum/component/turf_overlay_effect/Initialize(turf_type, y_offset)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	src.turf_type = turf_type
	my_turf_overlay_effect = new(parent)
	my_turf_overlay_effect.pixel_y_offset = y_offset

/datum/component/turf_overlay_effect/Destroy()
	. = ..()
	QDEL_NULL(my_turf_overlay_effect)

/datum/component/turf_overlay_effect/proc/update_turf_overlays_effects(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER

	if(!ttl || forced)
		qdel(src)
		return
	ttl = 0
	my_turf_overlay_effect.update_icons(get_turf(parent))

/datum/component/turf_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(update_turf_overlays_effects))

/datum/component/turf_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/turf_overlay_effect/InheritComponent(datum/component/C, i_am_original, turf_type, y_offset)
	. = ..()

	ttl = 1
	src.turf_type = turf_type
	my_turf_overlay_effect.pixel_y_offset = y_offset
	my_turf_overlay_effect.update_icons(get_turf(parent))

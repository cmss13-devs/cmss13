///display_effect component. adds and removes
/datum/component/display_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/display_effect/my_display_effect
	var/turf_type //! Turf type the effect applies to
	var/ttl = 1

/datum/component/display_effect/Initialize(turf_type, y_offset)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	src.turf_type = turf_type
	my_display_effect = new(parent)
	my_display_effect.pixel_y_offset = y_offset

/datum/component/display_effect/Destroy()
	. = ..()
	QDEL_NULL(my_display_effect)

/datum/component/display_effect/proc/update_turf_overlays_effects(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER

	if(!ttl || forced)
		qdel(src)
		return
	ttl = 0
	my_display_effect.update_icons(get_turf(parent))
	var/mob/M = parent
	if(M.m_intent == MOVE_INTENT_RUN)
		var/turf/open/gm/T = get_turf(parent)
		var/soundname = T.depth >= -4 ? "shallowwading" : (T.depth >= -8 ? "wading":"deepwading")
		playsound(T, "sound/effects/water/[soundname][rand(1,3)].ogg", 15, 1)


/datum/component/display_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(update_turf_overlays_effects))

/datum/component/display_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/display_effect/InheritComponent(datum/component/C, i_am_original, turf_type, y_offset)
	. = ..()

	ttl = 1
	src.turf_type = turf_type
	my_display_effect.pixel_y_offset = y_offset
	my_display_effect.update_icons(get_turf(parent))

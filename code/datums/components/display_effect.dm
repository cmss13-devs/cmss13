///display_effect component. adds and removes
/datum/component/display_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/display_effect/my_display_effect
	var/turf_type //! Turf type the effect applies to


/datum/component/display_effect/Initialize(turf_type, y_offset, force_update=FALSE)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	src.turf_type = turf_type
	my_display_effect = new(parent, force_update)
	my_display_effect.pixel_y_offset = y_offset
	my_display_effect.update_icons(get_turf(parent))

/datum/component/display_effect/Destroy()
	. = ..()
	my_display_effect.Destroy()
	QDEL_NULL(my_display_effect)

/datum/component/display_effect/proc/handle_affected_mob_move(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER
	var/turf/open/gm/TT = get_turf(parent_source) //dont use this
	var/found_depth = TT.depth
	if(found_depth>=0)
		Destroy()
		return
	var/mob/M = parent_source
	if(M.m_intent == MOVE_INTENT_RUN)
		var/turf/open/gm/T = get_turf(parent_source)
		var/soundname = T.depth >= -4 ? "shallowwading" : (T.depth >= -8 ? "wading":"deepwading")
		playsound(T, "sound/effects/water/[soundname][rand(1,3)].ogg", 10, 1, 10, falloff=1)


/datum/component/display_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_affected_mob_move))

/datum/component/display_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/display_effect/InheritComponent(datum/component/C, i_am_original, turf_type, y_offset, datum/effects/display_effect/old_datum)
	. = ..()

	src.turf_type = turf_type
	my_display_effect = old_datum
	my_display_effect.icon_path = old_datum.icon_path
	my_display_effect.the_effect = old_datum.the_effect
	my_display_effect.the_effect.owner = my_display_effect
	my_display_effect.pixel_y_offset = y_offset
	my_display_effect.update_icons(get_turf(parent))

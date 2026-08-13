///water_overlay_effect component. adds and removes
/datum/component/water_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/water_overlay_effect/my_water_overlay_effect
	var/turf_type //! Turf type the effect applies to


/datum/component/water_overlay_effect/Initialize(turf_type, y_offset, force_update=FALSE)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE
	src.turf_type = turf_type
	my_water_overlay_effect = new(parent, force_update)
	my_water_overlay_effect.pixel_y_offset = y_offset
	my_water_overlay_effect.update_icons(get_turf(parent))

/datum/component/water_overlay_effect/Destroy()
	. = ..()
	my_water_overlay_effect.Destroy()

/datum/component/water_overlay_effect/proc/handle_affected_mob_move(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER
	var/turf/open/gm/TT = get_turf(parent_source) //dont use this
	if(TT.depth >= 0 || TT.covered)
		Destroy()
		return
	var/mob/M = parent_source
	if(M.m_intent == MOVE_INTENT_RUN)	//walking doesnt make sounds from moving through water
		var/turf/open/gm/T = get_turf(parent_source)
		var/soundname = T.depth >= -4 ? "shallowwading" : (T.depth >= -8 ? "wading":"deepwading")
		playsound(T, soundname, 10, 1, 10, falloff=1)

/datum/component/water_overlay_effect/proc/handle_lying_angle_change()
	var/turf/open/open_T
	var/turf/T = get_turf(my_water_overlay_effect.affected_atom)
	if(ispath(T.type, /turf/open))
		open_T = T
		my_water_overlay_effect.pixel_y_offset = open_T.depth
	my_water_overlay_effect.update_icons(get_turf(parent))

/datum/component/water_overlay_effect/proc/handle_body_position_change()
	if(!isxeno(parent))	//xenos dont have lying angles, so we use this
		return
	my_water_overlay_effect.update_icons(get_turf(parent))

/datum/component/water_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_affected_mob_move))
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(handle_lying_angle_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_body_position_change))

/datum/component/water_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)

/datum/component/water_overlay_effect/InheritComponent(datum/component/C, i_am_original, turf_type, y_offset, datum/effects/water_overlay_effect/old_datum)
	. = ..()

	src.turf_type = turf_type
	my_water_overlay_effect = old_datum
	my_water_overlay_effect.icon_path = old_datum.icon_path
	my_water_overlay_effect.the_effect = old_datum.the_effect
	my_water_overlay_effect.the_effect.owner = my_water_overlay_effect
	my_water_overlay_effect.pixel_y_offset = y_offset
	my_water_overlay_effect.update_icons(get_turf(parent))

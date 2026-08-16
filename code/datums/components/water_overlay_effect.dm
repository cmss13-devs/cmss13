///water_overlay_effect component. adds and removes
/datum/component/water_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/water_overlay_effect/my_water_overlay_effect
	var/turf_type //! Turf type the effect applies to

/datum/component/water_overlay_effect/Initialize(turf/input_turf, y_offset)
	if((!iscarbon(usr) && !isobj(usr)) || !ispath(input_turf.type, /turf/open))
		return COMPONENT_INCOMPATIBLE
	turf_type = input_turf.type
	my_water_overlay_effect = new(parent, src, input_turf)

/datum/component/water_overlay_effect/Destroy()
	. = ..()
	my_water_overlay_effect.Destroy()

/datum/component/water_overlay_effect/InheritComponent(datum/component/C, i_am_original, turf/input_turf, y_offset)
	. = ..()
	var/will_update = FALSE
	if(turf_type != input_turf.type)
		turf_type = input_turf.type
		will_update = TRUE
	if(my_water_overlay_effect.pixel_y_offset != y_offset)
		my_water_overlay_effect.pixel_y_offset = y_offset
		will_update = TRUE
	if(will_update)
		my_water_overlay_effect.water_turf = input_turf
		my_water_overlay_effect.update()

/datum/component/water_overlay_effect/proc/handle_affected_mob_move(parent_source, oldloc, direction, forced)
	SIGNAL_HANDLER
	var/turf/open/gm/moved_to_turf = get_turf(parent_source)
	if(moved_to_turf.depth >= DEPTH_LAND || moved_to_turf.covered)
		Destroy()
		return
	var/mob/M = parent_source
	if(M.m_intent == MOVE_INTENT_RUN)	//walking doesnt make sounds from moving through water
		var/soundname = moved_to_turf.depth >= DEPTH_COAST_INTERMEDIATE ? "shallowwading" : (moved_to_turf.depth >= DEPTH_SHALLOW ? "wading":"deepwading")
		playsound(moved_to_turf, soundname, 10, 1, 10, falloff=1)

/datum/component/water_overlay_effect/proc/handle_resting_change()
	var/turf/laid_on_turf = get_turf(parent)
	if(ispath(laid_on_turf.type, /turf/open))
		var/turf/open/open_laid_on_turf = laid_on_turf
		my_water_overlay_effect.pixel_y_offset = open_laid_on_turf.depth
	my_water_overlay_effect.water_turf = laid_on_turf
	my_water_overlay_effect.update(laid_on_turf)

/datum/component/water_overlay_effect/proc/update_the_effect()
	SIGNAL_HANDLER
	var/turf/unbuckled_turf = get_turf(parent)
	if(ispath(unbuckled_turf.type, /turf/open))
		var/turf/open/open_buckled_turf = unbuckled_turf
		my_water_overlay_effect.pixel_y_offset = open_buckled_turf.depth
	my_water_overlay_effect.hidden = FALSE
	my_water_overlay_effect.water_turf = unbuckled_turf
	my_water_overlay_effect.update(get_turf(parent))

/datum/component/water_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(handle_affected_mob_move))
	RegisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE, PROC_REF(handle_resting_change))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(handle_resting_change))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(update_the_effect))
	RegisterSignal(parent, COMSIG_MOB_UNHAULED, PROC_REF(update_the_effect))

/datum/component/water_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_LIVING_SET_LYING_ANGLE)
	UnregisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION)
	UnregisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE)
	UnregisterSignal(parent, COMSIG_MOB_UNHAULED)

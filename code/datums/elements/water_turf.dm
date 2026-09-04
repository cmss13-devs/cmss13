/**
 * Handles enter/hit-by behavior for turfs that have water depth.
 * Attach only to open turfs that should run this logic (depth > 0, etc.).
 */
/datum/element/water_turf
	element_flags = ELEMENT_BESPOKE

/datum/element/water_turf/Attach(datum/target)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE)
		return

	if(!istype(target, /turf/open))
		return ELEMENT_INCOMPATIBLE

	var/turf/open/open_target = target
	if(open_target.depth >= DEPTH_LAND || open_target.covered)
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(open_target, COMSIG_TURF_ENTERED, PROC_REF(on_enter))
	RegisterSignal(open_target, COMSIG_ATOM_HITBY, PROC_REF(on_hit))

/datum/element/water_turf/Detach(datum/source, ...)
	UnregisterSignal(source, list(COMSIG_TURF_ENTERED, COMSIG_ATOM_HITBY))
	return ..()

/datum/element/water_turf/proc/on_enter(turf/open/source, atom/movable/mover)
	SIGNAL_HANDLER
	if(iscarbon(mover))
		mover.AddComponent(/datum/component/turf_effect/water, source, source.depth)
	if(!isliving(mover))
		return
	var/mob/living/living_mover = mover
	if(living_mover.m_intent == MOVE_INTENT_RUN)	//walking doesnt make sounds from moving through water
		var/soundname = source.depth >= DEPTH_COAST_INTERMEDIATE ? "shallowwading" : (source.depth >= DEPTH_SHALLOW ? "wading":"deepwading")
		playsound(src, soundname, 10, 1, 10, falloff=1)

/datum/element/water_turf/proc/on_hit(turf/open/hit_turf, atom/movable/mover)
	SIGNAL_HANDLER
	if(hit_turf.depth && !hit_turf.covered)
		new /obj/effect/water_splash(hit_turf, TRUE)	//SPLASHHH!! something hit the water!

		var/datum/component/turf_effect/water/found_component = mover.GetComponent(/datum/component/turf_effect/water)
		if(found_component)	//this is in case the mob flew over water turfs to get here, in which case we need to unhide their component and update()
			found_component.hidden = FALSE
			found_component.effect_turf = hit_turf
			found_component.update()

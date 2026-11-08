/**
 * Handles enter/hit-by behavior for turfs that have water depth, enabling water_overlay_effects/splashes.
 * Attach only to open turfs that should run this logic (depth < 0, etc.).
 *
 * we should probably move the other water turf behaviours to this, washing blood, pred cloak unmasking, putting out fires
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
	if(open_target.depth >= WATER_DEPTH_LAND || open_target.covered || open_target.turf_flags & TURF_CATWALKED)
		open_target.RemoveElement(/datum/element/water_turf)
		return

	RegisterSignal(open_target, COMSIG_TURF_ENTERED, PROC_REF(on_enter))
	RegisterSignal(open_target, COMSIG_TURF_LAUNCHED_LANDING, PROC_REF(on_landed_on))


/datum/element/water_turf/Detach(datum/source, ...)
	UnregisterSignal(source, list(COMSIG_TURF_ENTERED, COMSIG_TURF_LAUNCHED_LANDING))
	return ..()


/datum/element/water_turf/proc/on_enter(turf/open/source, atom/movable/mover)
	SIGNAL_HANDLER

	if(!isliving(mover))
		return
	var/mob/living/living_mover = mover
	if(living_mover.mob_flags & MOB_FLYING)
		return
	mover.AddComponent(/datum/component/water_overlay_effect, source)
	if(source.depth <= WATER_DEPTH_COAST_SHALLOW && living_mover.m_intent == MOVE_INTENT_RUN)	//walking doesnt make sounds from moving through water
		var/soundname = source.depth >= WATER_DEPTH_COAST_INTERMEDIATE ? "shallowwading" : (source.depth >= WATER_DEPTH_SHALLOW ? "wading":"deepwading")
		playsound(source, soundname, 10, 1, 10, falloff=1)


/datum/element/water_turf/proc/on_landed_on(turf/open/hit_turf, atom/movable/mover)
	SIGNAL_HANDLER
	if(hit_turf.depth <= WATER_DEPTH_COAST_SHALLOW && !hit_turf.covered)
		new /obj/effect/water_splash(hit_turf, TRUE)	//SPLASHHH!! something hit the water!

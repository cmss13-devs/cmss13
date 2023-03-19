///turf_overlay_effect component. adds and removes
/datum/component/turf_overlay_effect
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/datum/effects/turf_overlay_effect/my_turf_overlay_effect
	var/turf/open/parent_turf

/datum/component/turf_overlay_effect/New(raw_args)
	parent_turf = raw_args[2]
	. = ..()

/datum/component/turf_overlay_effect/Initialize(parent_turf_type)
	if(!istype(parent, /atom/movable))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(update_turf_overlays_effects))

/datum/component/turf_overlay_effect/proc/update_turf_overlays_effects()
	SIGNAL_HANDLER

	var/turf/T = get_turf(parent)
	if(T.type != parent_turf.type)
		UnregisterFromParent()
		qdel(src)

/datum/component/turf_overlay_effect/RegisterWithParent(datum/target)
	. = ..()
	my_turf_overlay_effect = new /datum/effects/turf_overlay_effect(parent, parent_turf)

/datum/component/turf_overlay_effect/UnregisterFromParent(datum/source, force)
	. = ..()
	my_turf_overlay_effect = qdel(my_turf_overlay_effect)

/datum/component/turf_overlay_effect/InheritComponent(thing, thing2, thing3)
	. = ..()

	parent_turf = thing3
	my_turf_overlay_effect.update_icons(parent_turf)


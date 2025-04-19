
// Just try not to think about this too much.


GLOBAL_LIST_EMPTY(ai_hives)

/datum/component/ai_behavior_override/hive
	behavior_icon_state = "core"

	max_assigned = 0

	var/hive_radius = 5

/datum/component/ai_behavior_override/hive/Initialize(...)
	. = ..()

	if(!istype(parent, /turf/open) && !istype(parent, /obj/effect/alien))
		return COMPONENT_INCOMPATIBLE

	GLOB.ai_hives += src

	if(!istype(parent, /obj/effect/alien))
		new /obj/effect/alien/weeds/node(get_turf(parent))

/datum/component/ai_behavior_override/hive/Destroy(force, silent, ...)
	GLOB.ai_hives -= src

	. = ..()

/datum/component/ai_behavior_override/hive/check_behavior_validity(mob/living/carbon/xenomorph/checked_xeno, distance)
	return FALSE

/datum/component/ai_behavior_override/hive/process_override_behavior(mob/living/carbon/xenomorph/processing_xeno, delta_time)
	return FALSE

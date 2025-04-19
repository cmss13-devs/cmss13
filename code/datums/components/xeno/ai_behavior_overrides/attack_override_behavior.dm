
/datum/component/ai_behavior_override/attack
	behavior_icon_state = "attack_order"

/datum/component/ai_behavior_override/attack/Destroy(force, silent, ...)
	for(var/mob/living/carbon/xenomorph/assigned_xeno in currently_assigned)
		assigned_xeno.current_target = null

	. = ..()

/datum/component/ai_behavior_override/attack/check_behavior_validity(mob/living/carbon/xenomorph/checked_xeno, distance)
	. = ..()
	if(!.)
		return

	if(distance > 10)
		return FALSE

	return TRUE

/datum/component/ai_behavior_override/attack/process_override_behavior(mob/living/carbon/xenomorph/processing_xeno, delta_time)
	. = ..()
	if(!.)
		return

	if(processing_xeno.current_target == parent)
		return FALSE

	processing_xeno.current_target = parent
	processing_xeno.set_resting(FALSE, FALSE, TRUE)
	if(prob(5))
		processing_xeno.emote("hiss")

	return FALSE

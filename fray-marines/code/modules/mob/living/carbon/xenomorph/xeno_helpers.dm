/mob/living/carbon/xenomorph/set_movement_intent(new_intent)
	. = ..()
	if(behavior_delegate)
		behavior_delegate.handle_movement_change(new_intent)

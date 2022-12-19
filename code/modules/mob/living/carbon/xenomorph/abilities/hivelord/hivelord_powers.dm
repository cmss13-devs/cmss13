/datum/action/xeno_action/active_toggle/toggle_speed/toggle_toggle()
	. = ..()
	var/mob/living/carbon/Xenomorph/Hivelord/xeno = owner
	xeno.weedwalking_activated = action_active
	xeno.recalculate_move_delay = TRUE

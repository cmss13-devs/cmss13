/datum/action/xeno_action/active_toggle/toggle_speed/enable_toggle()
	. = ..()
	update_weedwalking()

/datum/action/xeno_action/active_toggle/toggle_speed/disable_toggle()
	. = ..()
	update_weedwalking()

/datum/action/xeno_action/active_toggle/toggle_speed/proc/update_weedwalking()
	var/mob/living/carbon/Xenomorph/Hivelord/xeno = owner
	xeno.weedwalking_activated = action_active
	xeno.recalculate_move_delay = TRUE

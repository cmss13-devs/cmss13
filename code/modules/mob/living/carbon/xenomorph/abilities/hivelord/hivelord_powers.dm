/datum/action/xeno_action/onclick/toggle_speed/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/Hivelord/xeno = owner
	if(!xeno.check_state())
		return

	xeno.recalculate_move_delay = TRUE

	if(xeno.weedwalking_activated)
		to_chat(xeno, SPAN_WARNING("You feel less in tune with the resin."))
		xeno.weedwalking_activated = 0
		button.icon_state = "template"
		return

	if(!xeno.check_plasma(plasma_cost))
		return
	xeno.weedwalking_activated = 1
	xeno.use_plasma(plasma_cost)
	to_chat(xeno, SPAN_NOTICE("You become one with the resin. You feel the urge to run!"))
	button.icon_state = "template_active"

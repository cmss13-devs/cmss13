/datum/action/xeno_action/onclick/toggle_speed/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(!X.check_state())
		return

	X.recalculate_move_delay = TRUE

	if(X.weedwalking_activated)
		to_chat(X, SPAN_WARNING("You feel less in tune with the resin."))
		X.weedwalking_activated = 0
		return

	if(!X.check_plasma(plasma_cost))
		return
	X.weedwalking_activated = 1
	X.use_plasma(plasma_cost)
	to_chat(X, SPAN_NOTICE("You become one with the resin. You feel the urge to run!"))

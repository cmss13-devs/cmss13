/datum/action/xeno_action/onclick/spitter_frenzy/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!istype(X) || !X.check_state())
		return

	if (buffs_active)
		to_chat(X, SPAN_XENOHIGHDANGER("You cannot stack frenzy!"))
		return

	if (!check_and_use_plasma_owner())
		return

	to_chat(X, SPAN_XENOHIGHDANGER("You feel yourself move quicker!"))
	buffs_active = TRUE
	X.speed_modifier -= speed_buff_amount
	X.recalculate_speed()

	addtimer(CALLBACK(src, .proc/remove_effects), duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/spitter_frenzy/proc/remove_effects()
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	X.speed_modifier += speed_buff_amount
	X.recalculate_speed()
	to_chat(X, SPAN_XENOHIGHDANGER("You feel your movement speed slow down!"))
	buffs_active = FALSE
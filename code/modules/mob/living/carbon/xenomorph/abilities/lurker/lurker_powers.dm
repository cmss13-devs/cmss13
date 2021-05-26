/datum/action/xeno_action/onclick/lurker_invisibility/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	animate(X, alpha = alpha_amount, time = 0.1 SECONDS, easing = QUAD_EASING)
	X.update_icons() // callback to make the icon_state indicate invisibility is in lurker/update_icon

	X.speed_modifier -= speed_buff
	X.recalculate_speed()

	if (X.mutation_type == LURKER_NORMAL)
		var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
		BD.on_invisibility()

	// if we go off early, this also works fine.
	invis_timer_id = addtimer(CALLBACK(src, .proc/invisibility_off), duration, TIMER_STOPPABLE)

	// Only resets when invisibility ends
	apply_cooldown_override(1000000000)
	..()
	return

/datum/action/xeno_action/onclick/lurker_invisibility/proc/invisibility_off()
	if(!owner || owner.alpha == initial(owner.alpha))
		return

	if (invis_timer_id != TIMER_ID_NULL)
		deltimer(invis_timer_id)
		invis_timer_id = TIMER_ID_NULL

	var/mob/living/carbon/Xenomorph/X = owner
	if (istype(X))
		animate(X, alpha = initial(X.alpha), time = 0.1 SECONDS, easing = QUAD_EASING)
		to_chat(X, SPAN_XENOHIGHDANGER("You feel your invisibility end!"))

		X.update_icons()

		X.speed_modifier += speed_buff
		X.recalculate_speed()

		if (X.mutation_type == LURKER_NORMAL)
			var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
			if (istype(BD))
				BD.on_invisibility_off()

/datum/action/xeno_action/onclick/lurker_invisibility/ability_cooldown_over()
	to_chat(owner, SPAN_XENOHIGHDANGER("You are ready to use your invisibility again!"))
	..()

/datum/action/xeno_action/onclick/lurker_assassinate/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	if (X.mutation_type != LURKER_NORMAL)
		return

	var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
	if (istype(BD))
		BD.next_slash_buffed = TRUE

	to_chat(X, SPAN_XENOHIGHDANGER("Your next slash will deal increased damage!"))

	addtimer(CALLBACK(src, .proc/unbuff_slash), buff_duration)
	X.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/lurker_assassinate/proc/unbuff_slash()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return
	var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
	if (istype(BD))
		// In case slash has already landed
		if (!BD.next_slash_buffed)
			return
		BD.next_slash_buffed = FALSE

	to_chat(X, SPAN_XENODANGER("You have waited too long, your slash will no longer deal increased damage!"))



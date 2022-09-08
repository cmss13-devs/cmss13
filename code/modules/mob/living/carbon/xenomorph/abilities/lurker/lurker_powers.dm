/datum/action/xeno_action/onclick/lurker_invisibility/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	animate(xeno, alpha = alpha_amount, time = 0.1 SECONDS, easing = QUAD_EASING)
	button.icon_state = "template_active"
	xeno.update_icons() // callback to make the icon_state indicate invisibility is in lurker/update_icon

	xeno.speed_modifier -= speed_buff
	xeno.recalculate_speed()

	if (xeno.mutation_type == LURKER_NORMAL)
		var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
		behavior.on_invisibility()

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

	var/mob/living/carbon/Xenomorph/xeno = owner
	if (istype(xeno))
		animate(xeno, alpha = initial(xeno.alpha), time = 0.1 SECONDS, easing = QUAD_EASING)
		to_chat(xeno, SPAN_XENOHIGHDANGER("You feel your invisibility end!"))
		button.icon_state = "template"

		xeno.update_icons()

		xeno.speed_modifier += speed_buff
		xeno.recalculate_speed()

		if (xeno.mutation_type == LURKER_NORMAL)
			var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
			if (istype(behavior))
				behavior.on_invisibility_off()

/datum/action/xeno_action/onclick/lurker_invisibility/ability_cooldown_over()
	to_chat(owner, SPAN_XENOHIGHDANGER("You are ready to use your invisibility again!"))
	..()

/datum/action/xeno_action/onclick/lurker_assassinate/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	if (xeno.mutation_type != LURKER_NORMAL)
		return

	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENOHIGHDANGER("Your next slash will deal increased damage!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, .proc/unbuff_slash), buff_duration)
	xeno.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/lurker_assassinate/proc/unbuff_slash()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("You have waited too long, your slash will no longer deal increased damage!"))
	button.icon_state = "template"

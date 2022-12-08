/datum/action/xeno_action/activable/throw_hugger/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.throw_hugger(A)
	..()

/datum/action/xeno_action/activable/retrieve_egg/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/Carrier/X = owner
	X.retrieve_egg(A)
	..()

/datum/action/xeno_action/onclick/plasma_strike/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(!istype(xeno) || !action_cooldown_check() || !check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/reaper_carrier/behavior = xeno.behavior_delegate
	if(istype(behavior))
		behavior.next_slash_buffed = TRUE
		behavior.add_slash_overlay()

	to_chat(xeno, SPAN_XENOHIGHDANGER("Your next slash will inject egg plasma into the target!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, .proc/unbuff_slash), buff_duration)
	xeno.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	..()

/datum/action/xeno_action/onclick/plasma_strike/proc/unbuff_slash()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(!istype(xeno))
		return
	var/datum/behavior_delegate/reaper_carrier/behavior = xeno.behavior_delegate
	if(istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE
		behavior.remove_slash_overlay()

	to_chat(xeno, SPAN_XENODANGER("You have waited too long, your slash will no inject egg plasma!"))
	button.icon_state = "template"

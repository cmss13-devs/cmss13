/datum/action/xeno_action/onclick/plasma_strike/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(!istype(xeno) || !action_cooldown_check() || !check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/base_reaper/behavior = xeno.behavior_delegate
	if(istype(behavior))
		behavior.egg_plasma_primed = TRUE
		behavior.add_egg_plasma_slash_overlay()

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
	var/datum/behavior_delegate/base_reaper/behavior = xeno.behavior_delegate
	if(istype(behavior))
		// In case slash has already landed
		if(!behavior.egg_plasma_primed)
			return
		behavior.egg_plasma_primed = FALSE
		behavior.remove_egg_plasma_slash_overlay()

	to_chat(xeno, SPAN_XENODANGER("You have waited too long, your slash will no inject egg plasma!"))
	button.icon_state = "template"


/datum/action/xeno_action/onclick/claw_toss/use_ability(atom/target)
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(!istype(xeno) || !action_cooldown_check() || !check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/base_reaper/behavior = xeno.behavior_delegate
	if(istype(behavior))
		behavior.claw_toss_primed = TRUE
		behavior.add_claw_toss_slash_overlay()

	to_chat(xeno, SPAN_XENOHIGHDANGER("Your next slash will throw your target away!"))
	button.icon_state = "template_active"

	addtimer(CALLBACK(src, .proc/unbuff_slash), buff_duration)
	xeno.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	..()

/datum/action/xeno_action/onclick/claw_toss/proc/unbuff_slash()
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(!istype(xeno))
		return
	var/datum/behavior_delegate/base_reaper/behavior = xeno.behavior_delegate
	if(istype(behavior))
		// In case slash has already landed
		if(!behavior.claw_toss_primed)
			return
		behavior.claw_toss_primed = FALSE
		behavior.remove_claw_toss_slash_overlay()

	to_chat(xeno, SPAN_XENODANGER("You have waited too long, your slash will no longer throw your target away!"))
	button.icon_state = "template"

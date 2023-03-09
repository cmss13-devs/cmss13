/datum/action/zombie_action
	icon_file = 'icons/mob/hud/actions_xeno.dmi'
	var/action_name /// extremely self explanetory
	var/action_cooldown
	var/action_timer_id = TIMER_ID_NULL //as you may guess, majority of the code was almost completely taken from xenoactions and made to work with zombies, but hey, it works! if you dont know how something works, its a good idea to go in xeno_actions and reading there
	var/cooldown_message // sends when we are ready to bite again etc.
	var/cooldown_message_state //do we want to have it at all?
	var/current_cooldown_start_time = 0 //to allow reducing of cooldown
	var/current_cooldown_duration = 0 //as above


/datum/action/zombie_action/proc/use_ability()
	if(!owner)
		return FALSE
	return TRUE

/datum/action/zombie_action/can_use_action()
	var/mob/living/carbon/human/zombie = owner
	if(zombie && !zombie.is_mob_incapacitated() && !zombie.lying && !zombie.buckled)
		return TRUE
	else
		return FALSE

/datum/action/zombie_action/proc/apply_cooldown(cooldown_modifier = 1)
	if(!owner)
		return
	if (action_timer_id != TIMER_ID_NULL)
		return

	var/cooldown_to_apply = action_cooldown * cooldown_modifier

	if(!cooldown_to_apply)
		return

	action_timer_id = addtimer(CALLBACK(src, PROC_REF(on_cooldown_end)), cooldown_to_apply, TIMER_UNIQUE|TIMER_STOPPABLE)
	current_cooldown_duration = cooldown_to_apply
	current_cooldown_start_time = world.time

	// Update our button
	update_button_icon()

/datum/action/zombie_action/proc/on_cooldown_end()
	if (action_timer_id == TIMER_ID_NULL)
		return

	action_timer_id = TIMER_ID_NULL
	// Don't need to clean up our timer
	current_cooldown_start_time = 0
	current_cooldown_duration = 0
	ability_cooldown_over()
	return

/datum/action/zombie_action/proc/ability_cooldown_over()
	if(!owner)
		return
	for(var/Z in owner.actions)
		var/datum/action/act = Z
		act.update_button_icon()
	if(cooldown_message_state)
		if(cooldown_message)
			to_chat(owner, SPAN_XENODANGER("[cooldown_message]"))
		else
			to_chat(owner, SPAN_XENODANGER("BRAIINNNSS, you can use [name] again!"))

/datum/action/zombie_action/update_button_icon()
	if(!button)
		return
	if(!can_use_action())
		button.color = rgb(128,0,0,128)
	else if(!action_cooldown_check())
		if(action_timer_id == TIMER_ID_NULL)
			button.color = rgb(200, 65, 115, 200)
		else
			button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/zombie_action/proc/action_cooldown_check()
	return (action_timer_id == TIMER_ID_NULL)

/datum/action/zombie_action/toggable

/datum/action/zombie_action/toggable/action_activate()
	var/mob/living/carbon/human/zomb = owner
	if(!iszombie(zomb)) //shouldnt be possible, but anyways
		return
	if(!owner)
		return
	if(zomb.selected_ability == src)
		if(zomb.last_special > world.time)
			return
		to_chat(zomb, "You will no longer use [action_name] with \
			[zomb.client && zomb.client.prefs && zomb.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		zomb.selected_ability = null
		button.icon_state = "template"
	else
		to_chat(zomb, "You will now use [action_name] with \
			[zomb.client && zomb.client.prefs && zomb.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(zomb.selected_ability)
			button.icon_state = "template"
		zomb.selected_ability = src
		zomb.last_special = world.time + 0.5 SECONDS
		button.icon_state = "template_on"

/datum/action/zombie_action/toggable/bite
	name = "Bite"
	action_name = "bite"
	action_icon_state = "headbite"
	action_cooldown = 10 SECONDS
	cooldown_message = "You feel the thrist for brains again, you can bite again!"
	cooldown_message_state = TRUE

/datum/action/zombie_action/toggable/leap //literally xeno pounce
	name = "Leap"
	action_name = "leap"
	action_icon_state = "pounce"
	action_cooldown = 10 SECONDS
	cooldown_message_state = TRUE
	var/maxdistance = 5 //leap how far again?
	var/throw_speed = SPEED_FAST
	var/windup = FALSE // Is there a do_after before we pounce?
	var/windup_duration = 20 // How long to wind up, if applicable
	var/windup_interruptable = TRUE
	var/leap_distance = 0



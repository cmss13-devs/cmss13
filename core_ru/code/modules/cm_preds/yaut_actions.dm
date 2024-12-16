/datum/action/human_action/yautja_jump
	///How quick you will fly
	var/speed = SPEED_AVERAGE
	///How many tiles you can leap to at once.
	var/max_distance = 6

/datum/action/human_action/yautja_jump/New(mob/living/user, obj/item/holder)
	..()
	name = "Long Jump"
	button.name = name
	button.overlays.Cut()
	var/image/IMG = image('icons/mob/hud/actions.dmi', button, "prepare_position")
	button.overlays += IMG

/datum/action/human_action/yautja_jump/can_use_action()
	var/mob/living/carbon/human/H = owner
	if(!H.is_mob_incapacitated() && !H.body_position == LYING_DOWN)
		return TRUE

/datum/action/human_action/yautja_jump/action_activate()
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(H.selected_ability == src)
		to_chat(H, "You will no longer use [name] with [H.get_ability_mouse_name()].")
		button.icon_state = "template"
		H.set_selected_ability(null)
	else
		to_chat(H, "You will now use [name] with [H.get_ability_mouse_name()].")
		if(H.selected_ability)
			H.selected_ability.button.icon_state = "template"
			H.set_selected_ability(null)
		button.icon_state = "template_on"
		H.set_selected_ability(src)

/datum/action/human_action/yautja_jump/proc/use_ability(atom/A)
	var/mob/living/carbon/human/H = owner
	H.jump(A, speed, max_distance)
	update_button_icon()

/mob/living/carbon/human/var/can_jump = TRUE
/mob/living/carbon/human/var/jump_cooldown = 2 SECONDS

/mob/living/carbon/human/proc/jump(atom/A, speed, max_distance)
	if (!A.z)
		return FALSE

	if (is_mob_incapacitated() || body_position == LYING_DOWN)
		to_chat(src, SPAN_WARNING("You're a bit too incapacitated for that."))
		return FALSE

	if (!can_jump)
		to_chat(src, SPAN_WARNING("You cannot jump yet!"))
		return FALSE

	var/turf/t_turf = get_turf(A)
	if (t_turf == get_turf(src))
		return FALSE

	can_jump = FALSE

	var/t_dist = min(get_dist(src, t_turf), max_distance)
	var/delay = 0.05 SECONDS * t_dist - 0.05 SECONDS

	to_chat(src, SPAN_BOLDNOTICE("You prepare to jump"))
	if (!do_after(src, delay, INTERRUPT_ALL|BEHAVIOR_IMMOBILE, BUSY_ICON_GENERIC))
		can_jump = TRUE
		return FALSE

	playsound(src, 'sound/effects/alien_tail_swipe2.ogg', 25, TRUE)
	jump_animation(speed, t_turf, max_distance)

	//has sleep
	RegisterSignal(src, COMSIG_CLIENT_MOB_MOVE, PROC_REF(disable_flying_movement))
	throw_atom(t_turf, max_distance, speed, launch_type = HIGH_LAUNCH)
	addtimer(CALLBACK(src, PROC_REF(end_jump_cooldown)), jump_cooldown)
	UnregisterSignal(src, COMSIG_CLIENT_MOB_MOVE)

/mob/living/carbon/human/proc/jump_animation(speed, turf/t_turf, max_distance)
	set waitfor = FALSE

	var/old_alpha = alpha
	var/new_alpha = 160

	if (alpha < 160)
		new_alpha = old_alpha

	var/anim_s = 0.95
	var/t_dist = min(get_dist(src, t_turf), max_distance)
	var/travel_time = (10 / speed - 0.6) * t_dist / 2 * anim_s
	var/pixel_height = pixel_y + 3 * t_dist - 3

	animate(src, alpha = new_alpha, pixel_y = pixel_y+pixel_height, time = travel_time, easing = SINE_EASING|EASE_OUT)

	sleep(travel_time)

	animate(src, alpha = old_alpha, pixel_y = initial(src.pixel_y), time = travel_time, easing = SINE_EASING)

/mob/living/carbon/human/proc/disable_flying_movement()
	SIGNAL_HANDLER
	return COMPONENT_OVERRIDE_MOVE

/mob/living/carbon/human/proc/end_jump_cooldown()
	can_jump = TRUE
	to_chat(src, SPAN_BOLDNOTICE("You are ready to jump again!"))

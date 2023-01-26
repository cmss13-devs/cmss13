/datum/action/xeno_action/onclick/lurker_invisibility/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	animate(xeno, alpha = alpha_amount, time = 0.1 SECONDS, easing = QUAD_EASING)
	xeno.update_icons() // callback to make the icon_state indicate invisibility is in lurker/update_icon

	xeno.speed_modifier -= speed_buff
	xeno.recalculate_speed()

	if (xeno.mutation_type == LURKER_NORMAL)
		var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
		behavior.on_invisibility()

	// if we go off early, this also works fine.
	invis_timer_id = addtimer(CALLBACK(src, PROC_REF(invisibility_off)), duration, TIMER_STOPPABLE)

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

	var/mob/living/carbon/xenomorph/xeno = owner
	if (istype(xeno))
		animate(xeno, alpha = initial(xeno.alpha), time = 0.1 SECONDS, easing = QUAD_EASING)
		to_chat(xeno, SPAN_XENOHIGHDANGER("You feel your invisibility end!"))

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

/datum/action/xeno_action/onclick/lurker_assassinate/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

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

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)
	xeno.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/lurker_assassinate/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("You have waited too long, your slash will no longer deal increased damage!"))


// VAMPIRE LURKER

/datum/action/xeno_action/activable/pounce/rush/additional_effects(mob/living/living_target) //pounce effects
	var/mob/living/carbon/target = living_target
	var/mob/living/carbon/xenomorph/xeno = owner
	target.apply_effect(5, DAZE)
	target.sway_jitter(times = 2)
	xeno.flick_attack_overlay(target, "slash")   //fake slash to prevent disarm abuse
	target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	target.apply_armoured_damage(30, ARMOR_MELEE, BRUTE)
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh3.ogg', 30, TRUE)
	shake_camera(target, 2, 1)
	apply_cooldown_override(40)

/datum/action/xeno_action/activable/flurry/use_ability(atom/targeted_atom) //flurry ability
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	if (!xeno.check_state())
		return
	if (!action_cooldown_check())
		return

	xeno.visible_message(SPAN_DANGER("[xeno] slashes frantically the area in front of it!"), \
	SPAN_XENOWARNING("You unleash a barrage of slashes!"))
	playsound(xeno, 'sound/effects/alien_tail_swipe2.ogg', 30)
	apply_cooldown()

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 1x3 area of turfs
	var/turf/root = get_turf(xeno)
	var/facing = get_dir(xeno, targeted_atom)
	var/turf/infront = get_step(root, facing)
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront
	if (!(!infront || infront.density))
		temp_turfs += infront_left
	if (!(!infront || infront.density))
		temp_turfs += infront_right

	for (var/turf/current_turfs in temp_turfs)

		if (!istype(current_turfs))
			continue

		if (current_turfs.density)
			continue

		target_turfs += current_turfs
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(current_turfs, 2)

	for (var/turf/current_turfs in target_turfs)
		for (var/mob/living/carbon/target in current_turfs)
			if (target.stat == DEAD)
				continue

			if (!isXenoOrHuman(target) || xeno.can_not_harm(target))
				continue

			xeno.visible_message(SPAN_DANGER("[xeno] scratches [target] all around its body!"), \
			SPAN_XENOWARNING("You slash [target] multiple times!"))
			xeno.flick_attack_overlay(target, "slash")
			target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
			log_attack("[key_name(xeno)] attacked [key_name(target)] with Flurry")
			target.apply_armoured_damage(30, ARMOR_MELEE, BRUTE)
			playsound(get_turf(target), 'sound/weapons/alien_claw_flesh4.ogg', 30, TRUE)
			xeno.flick_heal_overlay(1 SECONDS, "#00B800")
			xeno.gain_health(30)
	xeno.emote("roar")
	..()
	return

/datum/action/xeno_action/activable/tail_jab/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/mob/living/carbon/target = targeted_atom
	var/distance = get_dist(xeno, target)

	if(!action_cooldown_check())
		return

	if(!xeno.check_state())
		return

	if(distance > 2)
		return

	var/list/turf/path = getline2(xeno, target, include_from_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(xeno, SPAN_WARNING("There's something blocking you from striking!"))
			return
		var/atom/barrier = path_turf.handle_barriers(A = xeno , pass_flags = (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			to_chat(xeno, SPAN_WARNING("There's something blocking you from striking!"))
			return
		for(var/obj/structure/current_structure in path_turf)
			if(istype(current_structure, /obj/structure/window/framed))
				var/obj/structure/window/framed/target_window = current_structure
				if(target_window.unslashable)
					return
				playsound(get_turf(target_window),'sound/effects/glassbreak3.ogg', 30, TRUE)
				target_window.shatter_window(TRUE)
				xeno.visible_message(SPAN_XENOWARNING("\The [xeno] strikes the window with their tail!"), SPAN_XENOWARNING("You strike the window with your tail!"))
				apply_cooldown(cooldown_modifier = 0.5)
				return

	if(!isXenoOrHuman(target) || xeno.can_not_harm(target))
		xeno.visible_message(SPAN_XENOWARNING("\The [xeno] swipes their tail through the air!"), SPAN_XENOWARNING("You swipe your tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.2)
		playsound(xeno, 'sound/effects/alien_tail_swipe1.ogg', 50, TRUE)
		return

	if(target.stat == DEAD)
		return

	if(target.knocked_out || target.stat == UNCONSCIOUS) //called knocked out because for some reason .stat seems to have a delay .
		if(!xeno.Adjacent(target))
			to_chat(xeno, SPAN_XENONOTICE("You cannot execute [target] from that far away."))
			return
		if(xeno.action_busy)
			return
		xeno.visible_message(SPAN_DANGER("[xeno] grabs [target]’s head aggressively."), \
		SPAN_XENOWARNING("You grab [target]’s head aggressively."), max_distance = 5)
		if(!do_after(xeno, 10, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
			return
		if(target.stat == DEAD)
			return
		to_chat(xeno, SPAN_XENOHIGHDANGER("You pierce [target]’s head with your inner jaw."))
		xeno.visible_message(SPAN_DANGER("[xeno] pierces [target]’s head with its inner jaw."))
		playsound(target,'sound/weapons/alien_bite2.ogg', 50, 1)
		xeno.flick_attack_overlay(target, "tail")
		target.apply_armoured_damage(80, ARMOR_MELEE, BRUTE, "head", 5)
		target.death() //just in case
		xeno.gain_health(150)
		xeno.xeno_jitter(1 SECONDS)
		xeno.flick_heal_overlay(3 SECONDS, "#00B800")
		target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
		log_attack("[key_name(xeno)] executed [key_name(target)] with a headbite")
		xeno.emote("roar")
		return // no cooldown in executions


	to_chat(xeno, SPAN_XENOHIGHDANGER("You stab [target] with your tail, pushing it backwards."))
	xeno.flick_attack_overlay(target, "tail")
	playsound(target,'sound/weapons/alien_claw_block.ogg', 50, 1)
	target.apply_armoured_damage(30 , ARMOR_MELEE, BRUTE, "chest")
	target.KnockDown(0.5, 0.5)
	target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	log_attack("[key_name(xeno)] attacked [key_name(target)] with Tail Jab")
	step_away(target, xeno, 2, 2)
	apply_cooldown()

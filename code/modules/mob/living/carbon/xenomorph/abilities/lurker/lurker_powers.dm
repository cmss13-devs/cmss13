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
	target.sway_jitter(times = 2)
	xeno.animation_attack_on(target)
	xeno.flick_attack_overlay(target, "slash")   //fake slash to prevent disarm abuse
	target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	target.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, "chest")
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh3.ogg', 30, TRUE)
	shake_camera(target, 2, 1)
	apply_cooldown(0.65)

/datum/action/xeno_action/activable/flurry/use_ability(atom/targeted_atom) //flurry ability
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return
	if (!xeno.check_state())
		return
	if (!action_cooldown_check())
		return

	xeno.visible_message(SPAN_DANGER("[xeno] drags its claws in a wide area in front of it!"), \
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

			if (!isxeno_human(target) || xeno.can_not_harm(target))
				continue

			xeno.visible_message(SPAN_DANGER("[xeno] slashes [target]!"), \
			SPAN_XENOWARNING("You slash [target] multiple times!"))
			xeno.flick_attack_overlay(target, "slash")
			target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
			log_attack("[key_name(xeno)] attacked [key_name(target)] with Flurry")
			target.apply_armoured_damage(get_xeno_damage_slash(target, xeno.caste.melee_damage_upper), ARMOR_MELEE, BRUTE, rand_zone())
			playsound(get_turf(target), 'sound/weapons/alien_claw_flesh4.ogg', 30, TRUE)
			xeno.flick_heal_overlay(1 SECONDS, "#00B800")
			xeno.gain_health(30)
			xeno.animation_attack_on(target)

	xeno.emote("roar")
	..()
	return

/datum/action/xeno_action/activable/tail_jab/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!xeno.check_state())
		return

	if(xeno.mutation_type != LURKER_VAMPIRE)
		return

	xeno.emote("tail")

// Get line of turfs
	var/list/turf/target_turfs = list()

	var/facing = Get_Compass_Dir(xeno, target_atom)
	var/turf/var_turf = xeno.loc
	var/turf/temp = xeno.loc
	var/list/telegraph_atom_list = list()

	var/detached = FALSE

	for (var/x in 1 to 2)
		temp = get_step(var_turf, facing)
		if(facing in diagonals) // check if it goes through corners
			var/reverse_face = reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(S.opacity || (istype(S, /obj/structure/barricade) && S.density))
				blocked = TRUE
				break
		if(blocked)
			break

		var_turf = temp

		if (var_turf in target_turfs)
			break

		if(get_turf(target_atom) == var_turf) // If the turf we're on is the same as the target atom, we 'detach' from the target atom so the ability continues without stopping suddenly.
			detached = TRUE
		if(!detached)
			facing = Get_Compass_Dir(var_turf, target_atom)
		target_turfs += var_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/red(var_turf, 0.25 SECONDS)

	if(length(target_turfs))
		xeno.animation_attack_on(target_turfs[target_turfs.len], pixel_offset = 16)

	var/mob/living/carbon/hit_target
	for (var/turf/target_turf as anything in target_turfs)
		if(hit_target)
			break

		for (var/mob/living/carbon/carbone in target_turf)
			if (carbone.stat == DEAD || xeno.can_not_harm(carbone))
				continue
			hit_target = carbone
			break

	if(!hit_target)
		apply_cooldown()
		return

	// Variable to buff if it's a direct aimed hit.
	var/slam_damage = get_xeno_damage_slash(hit_target, xeno.caste.melee_damage_upper)

	// FX
	var/stab_direction
	var/stab_overlay

	if(hit_target == target_atom) //bonus if they aim!
		to_chat(xeno, SPAN_XENOHIGHDANGER("You directly slam [hit_target] with your tail, throwing it back after impaling it on your tail!"))
		playsound(hit_target,'sound/weapons/alien_tail_attack.ogg', 50, TRUE)

		slam_damage *= 1.5

		stab_direction = turn(get_dir(xeno, hit_target), 180)
		stab_overlay = "tail"

		if(hit_target.mob_size < MOB_SIZE_BIG)
			xeno_throw_human(hit_target, xeno, get_dir(xeno, hit_target), 1) // only a 'real' throw if it's a direct hit. Same distance

	else
		to_chat(xeno, SPAN_XENOHIGHDANGER("You slam [hit_target] with your tail and push it backwards!"))
		playsound(hit_target,'sound/weapons/alien_claw_block.ogg', 50, TRUE)

		stab_direction = turn(xeno.dir, pick(90, -90))
		stab_overlay = "slam"

		if(hit_target.mob_size < MOB_SIZE_BIG)
			step_away(hit_target, xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = xeno.dir

	xeno.setDir(stab_direction)
	xeno.flick_attack_overlay(hit_target, stab_overlay)

	var/new_dir = xeno.dir
	addtimer(CALLBACK(src, PROC_REF(reset_direction), xeno, last_dir, new_dir), 0.5 SECONDS)

	hit_target.apply_armoured_damage(slam_damage, ARMOR_MELEE, BRUTE, "chest")

	if(hit_target.mob_size < MOB_SIZE_BIG)
		hit_target.apply_effect(0.5, WEAKEN)
	else
		hit_target.apply_effect(0.5, SLOW)

	hit_target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	log_attack("[key_name(xeno)] attacked [key_name(hit_target)] with Tail Jab")

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/tail_jab/proc/reset_direction(mob/living/carbon/xenomorph/xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == xeno.dir)
		xeno.setDir(last_dir)

/datum/action/xeno_action/activable/headbite/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!iscarbon(target_atom))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(xeno.can_not_harm(target_carbon))
		return

	if(!(target_carbon.knocked_out || target_carbon.stat == UNCONSCIOUS)) //called knocked out because for some reason .stat seems to have a delay .
		to_chat(xeno, SPAN_XENOHIGHDANGER("You can only headbite an unconscious, adjacent target!"))
		return

	if(!xeno.Adjacent(target_carbon))
		to_chat(xeno, SPAN_XENOHIGHDANGER("You can only headbite an unconscious, adjacent target!"))
		return

	if(xeno.action_busy)
		return

	xeno.visible_message(SPAN_DANGER("[xeno] grabs [target_carbon]’s head aggressively."), \
	SPAN_XENOWARNING("You grab [target_carbon]’s head aggressively."))

	if(!do_after(xeno, 0.8 SECONDS, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 2)) // would be 0.75 but that doesn't really work with numticks
		return

	if(target_carbon.stat == DEAD)
		to_chat(xeno, SPAN_XENODANGER("They died before you could finish headbiting them! Be more careful next time!"))
		return

	to_chat(xeno, SPAN_XENOHIGHDANGER("You pierce [target_carbon]’s head with your inner jaw!"))
	playsound(target_carbon,'sound/weapons/alien_bite2.ogg', 50, TRUE)
	xeno.visible_message(SPAN_DANGER("[xeno] pierces [target_carbon]’s head with its inner jaw!"))
	xeno.flick_attack_overlay(target_carbon, "headbite")
	xeno.animation_attack_on(target_carbon, pixel_offset = 16)
	target_carbon.apply_armoured_damage(60, ARMOR_MELEE, BRUTE, "head", 5) //DIE
	target_carbon.death(create_cause_data("headbite execution", xeno), FALSE)
	xeno.gain_health(150)
	xeno.xeno_jitter(1 SECONDS)
	xeno.flick_heal_overlay(3 SECONDS, "#00B800")
	xeno.emote("roar")
	log_attack("[key_name(xeno)] was executed by [key_name(target_carbon)] with a headbite!")
	return TRUE

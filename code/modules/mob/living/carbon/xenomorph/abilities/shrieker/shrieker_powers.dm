/datum/action/xeno_action/activable/shriek/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_plasma_owner())
		return

	if(!xeno.check_state())
		return

	if (xeno.mutation_type == SHRIEKER_NORMAL)
		var/datum/behavior_delegate/shrieker/behavior_del = xeno.behavior_delegate
		if (!istype(behavior_del))
			return
		if (!behavior_del.use_internal_acid_ability(shriek_cost))
			return

	if (curr_effect_type == SHRIEKER_SHRIEK_BUFF)

		playsound(xeno.loc, shriek_sound_effect, 55, 0, status = 0)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a piercing shriek!"))
		xeno.create_shriekwave(color = "#07f707")
		var/shriek_duration = 15 SECONDS
		var/image/buffed_overlay = get_busy_icon(ACTION_GREEN_POWER_UP)
		var/mob/living/carbon/Xenomorph/Shrieker/shrieker = owner
		if (!(shrieker.shriek_status_flags & SHRIEKER_SHRIEK_ENHANCED))
			shrieker.armor_modifier += XENO_ARMOR_MOD_MED
			shrieker.damage_modifier += XENO_DAMAGE_MOD_SMALL
			shrieker.recalculate_armor()
			shrieker.recalculate_damage()
			shrieker.shriek_status_flags |= SHRIEKER_SHRIEK_ENHANCED
			to_chat(SPAN_XENOWARNING("Your shriek empowers you to strike harder!"))
			buffed_overlay.flick_overlay(shrieker, 15 SECONDS)

			spawn (shriek_duration)
				shrieker.armor_modifier -= XENO_ARMOR_MOD_MED
				shrieker.damage_modifier -= XENO_DAMAGE_MOD_SMALL
				shrieker.recalculate_armor()
				shrieker.recalculate_damage()
				shrieker.shriek_status_flags &= ~SHRIEKER_SHRIEK_ENHANCED
				to_chat(SPAN_XENOWARNING("You feel the power of your shriek wane."))

		else
			to_chat(SPAN_XENOWARNING("Your shriek effects do NOT stack with other shrieks!"))

		for(var/mob/living/carbon/Xenomorph/xenoes in view(buff_range, xeno))
			var/image/xeno_buffed_overlay = get_busy_icon(ACTION_GREEN_POWER_UP)
			if (!(xenoes.shriek_status_flags & SHRIEKER_SHRIEK_ENHANCED))
				xenoes.armor_modifier += XENO_ARMOR_MOD_MED
				xenoes.damage_modifier += XENO_DAMAGE_MOD_SMALL
				xenoes.shriek_status_flags |= SHRIEKER_SHRIEK_ENHANCED
				xenoes.recalculate_armor()
				xenoes.recalculate_damage()
				xeno_buffed_overlay.flick_overlay(xenoes, 15 SECONDS)
				to_chat(xenoes, SPAN_XENOWARNING("You feel empowered after heearing the shriek of [src]!"))

				spawn (shriek_duration)
					xenoes.armor_modifier -= XENO_ARMOR_MOD_MED
					xenoes.damage_modifier -= XENO_DAMAGE_MOD_SMALL
					xenoes.shriek_status_flags &= ~SHRIEKER_SHRIEK_ENHANCED
					xenoes.recalculate_armor()
					xenoes.recalculate_damage()
					to_chat(xenoes, SPAN_XENOWARNING("You feel the effects of [src] wane!"))
			else
				to_chat(xenoes, SPAN_XENOWARNING("You can only be empowered by one shriek at once!"))

	else if (curr_effect_type == SHRIEKER_SHRIEK_DEBUFF)
		playsound(xeno.loc, shriek_sound_effect, 55, 0, status = 0)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a guttural shriek!"))
		xeno.create_shriekwave(color = "#FF0000")
		var/slow_duration = 4 SECONDS

		for(var/mob/living/carbon/human/H in view(debuff_range, xeno))
			to_chat(H, SPAN_HIGHDANGER("[xeno]'s shriek shakes your entire body, causing you to fall over in pain!"))
			if (!(xeno.shriek_status_flags & SHRIEKER_SHRIEK_DEBUFF))
				shake_camera(H, 2, 3)
				H.Daze(debuff_daze)
				H.KnockDown(get_xeno_stun_duration(H, 0.5))
				new /datum/effects/xeno_slow(H, xeno, null, null, get_xeno_stun_duration(H, slow_duration))

	apply_cooldown()
	..()
	return


/datum/action/xeno_action/activable/rooting_slash/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		to_chat(X, SPAN_XENODANGER("You must target a hostile!"))
		return

	var/mob/living/carbon/H = A

	var/dist = get_dist(X, H)

	if (dist > range)
		to_chat(X, SPAN_WARNING("[H] is too far away!"))
		return

	if (dist > 1)
		var/turf/targetTurf = get_step(X, get_dir(X, H))
		if (targetTurf.density)
			to_chat(X, SPAN_WARNING("You can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/I in targetTurf)
				if (I.density && !I.throwpass && !istype(I, /obj/structure/barricade) && !istype(I, /mob/living))
					to_chat(X, SPAN_WARNING("You can't attack through [I]!"))
					return


	if (H.stat == DEAD || HAS_TRAIT(H, TRAIT_NESTED))
		to_chat(X, SPAN_XENODANGER("[H] is dead, why would you want to touch it?"))
		return

	if (X.mutation_type == SHRIEKER_NORMAL)
		var/datum/behavior_delegate/shrieker/BD = X.behavior_delegate
		if (!istype(BD))
			return



	// Flick overlay and play sound
	X.animation_attack_on(A, 10)
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)

	var/root_duration = 1 SECONDS
	var/damage = 15
	X.visible_message(SPAN_XENODANGER("[X] extends with its claws and smashes [A], pinning them to the ground dealing damage!"), SPAN_XENOHIGHDANGER("You extend your claws and smash [A], pinning them to the ground and dealing damage!"))

	H.frozen = TRUE
	H.update_canmove()
	H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 15)

	if (ishuman(H))
		var/mob/living/carbon/human/target = H
		target.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, H), get_xeno_stun_duration(H, root_duration))
		to_chat(H, SPAN_XENOHIGHDANGER("[X] has pinned you to the ground! You cannot move!"))

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/cleave/proc/remove_root()
	buffed = FALSE

/datum/action/xeno_action/activable/pounce/shrieker/additional_effects(mob/living/L)

	var/mob/living/carbon/human/human = L
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno.mutation_type != SHRIEKER_NORMAL)
		return

	var/datum/behavior_delegate/shrieker/BD = xeno.behavior_delegate
	if (!istype(BD))
		return

	xeno.visible_message(SPAN_XENODANGER("The [xeno] dashes forward, its claws extended!"), SPAN_XENODANGER("You dash forward, extending your claws!"))
	human.attack_alien(xeno, 15)


/datum/action/xeno_action/activable/acid_throw/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!X.check_state())
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if (!check_plasma_owner())
		return

	if(!check_clear_path_to_target(X, A, TRUE))
		to_chat(X, SPAN_XENOWARNING("Something is in the way!"))
		return

	if (X.mutation_type == SHRIEKER_NORMAL)
		var/datum/behavior_delegate/shrieker/BD = X.behavior_delegate
		if (!istype(BD))
			return
		if (!BD.use_internal_acid_ability(throw_cost))
			return

	var/turf/T = get_turf(A)
	var/acid_bolt_message = "a barrage of acid"


	X.visible_message(SPAN_XENODANGER("[X] fires " + acid_bolt_message + " at [A]!"), SPAN_XENODANGER("You fire " + acid_bolt_message + " at [A]!"))
	new /obj/effect/xenomorph/acid_delay/shrieker_landmine(T, blinded, delay, "You are blasted with " + acid_bolt_message + "!", X, )

	for (var/turf/targetTurf in orange(1, T))
		new /obj/effect/xenomorph/acid_delay/shrieker_landmine(targetTurf, blinded, delay,  "You are blasted with a " + acid_bolt_message + "!", X)

	apply_cooldown()
	..()
	return

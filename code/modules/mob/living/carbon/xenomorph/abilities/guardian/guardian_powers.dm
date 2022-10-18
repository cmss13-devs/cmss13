/datum/action/xeno_action/activable/roar/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return
	if (!check_plasma_owner())
		return

	if(!xeno.check_state())
		return

	if (xeno.mutation_type == GUARDIAN_NORMAL)
		var/datum/behavior_delegate/guardian/BD = xeno.behavior_delegate
		if (!istype(BD))
			return
		if (!BD.use_internal_acid_ability(screech_cost))
			return

	if (curr_effect_type == GUARDIAN_SCREECH_BUFF)


		playsound(xeno.loc, screech_sound_effectt, 55, 0, status = 0)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a guttural roar!"))
		xeno.create_shriekwave(color = "#07f707")
		var/screech_duration = 150
		var/image/buff_overlay = get_busy_icon(ACTION_GREEN_POWER_UP)
		var/mob/living/carbon/Xenomorph/Praetorian/P = owner
		if (!(P.screech_status_flags & GUARDIAN_ROAR_ENHANCED))
			P.armor_modifier += XENO_ARMOR_MOD_MED
			P.damage_modifier += XENO_DAMAGE_MOD_SMALL
			P.recalculate_armor()
			P.recalculate_damage()
			P.screech_status_flags |= GUARDIAN_ROAR_ENHANCED
			to_chat(src, SPAN_XENOWARNING("Your roar empowers you to strike harder!"))
			buff_overlay.flick_overlay(P, 150)

			spawn (screech_duration)
				P.armor_modifier -= XENO_ARMOR_MOD_MED
				P.damage_modifier -= XENO_DAMAGE_MOD_SMALL
				P.recalculate_armor()
				P.recalculate_damage()
				P.screech_status_flags &= ~GUARDIAN_ROAR_ENHANCED
				to_chat(src, SPAN_XENOWARNING("You feel the power of your roar wane."))

		else
			to_chat(src, SPAN_XENOWARNING("Your roar's effects do NOT stack with other roar's!"))

		for(var/mob/living/carbon/Xenomorph/XX in view(6, xeno))
			var/image/bufff_overlay = get_busy_icon(ACTION_GREEN_POWER_UP)
			if (!(XX.screech_status_flags & GUARDIAN_ROAR_ENHANCED))
				XX.armor_modifier += XENO_ARMOR_MOD_MED
				XX.damage_modifier += XENO_DAMAGE_MOD_SMALL
				XX.screech_status_flags |= GUARDIAN_ROAR_ENHANCED
				XX.recalculate_armor()
				XX.recalculate_damage()
				bufff_overlay.flick_overlay(XX, 150)
				to_chat(XX, SPAN_XENOWARNING("You feel empowered after heearing the roar of [src]!"))

				spawn (screech_duration)
					XX.armor_modifier -= XENO_ARMOR_MOD_MED
					XX.damage_modifier -= XENO_DAMAGE_MOD_SMALL
					XX.screech_status_flags &= ~GUARDIAN_ROAR_ENHANCED
					XX.recalculate_armor()
					XX.recalculate_damage()
					to_chat(XX, SPAN_XENOWARNING("You feel the effects of [src] wane!"))
			else
				to_chat(XX, SPAN_XENOWARNING("You can only be empowered by one roar at once!"))

	else if (curr_effect_type == GUARDIAN_SCREECH_DEBUFF)
		playsound(xeno.loc, screech_sound_effectt, 55, 0, status = 0)
		xeno.visible_message(SPAN_XENOHIGHDANGER("[xeno] emits a guttural roar!"))
		xeno.create_shriekwave(color = "#FF0000")
		var/slow_duration = 40

		for(var/mob/living/carbon/human/human in view(3, xeno))
			human.visible_message(SPAN_DANGER("[xeno]'s roar shakes your entire body, causing you to fall over in pain!"))
			if (!(xeno.screech_status_flags & GUARDIAN_SCREECH_DEBUFF))
				shake_camera(human, 2, 3)
				human.Daze(debuff_daze)
				human.KnockDown(get_xeno_stun_duration(human, 0.5))
				new /datum/effects/xeno_slow(human, xeno, null, null, get_xeno_stun_duration(human, slow_duration))

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


	if (H.stat == DEAD)
		to_chat(X, SPAN_XENODANGER("[H] is dead, why would you want to touch it?"))
		return

	if (X.mutation_type == GUARDIAN_NORMAL)
		var/datum/behavior_delegate/guardian/BD = X.behavior_delegate
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
		var/mob/living/carbon/human/Hu = H
		Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, H), get_xeno_stun_duration(H, root_duration))
		to_chat(H, SPAN_XENOHIGHDANGER("[X] has pinned you to the ground! You cannot move!"))

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/cleave/proc/remove_root()
	buffed = FALSE

/datum/action/xeno_action/activable/pounce/guardian/additional_effects(mob/living/L)

	var/mob/living/carbon/human/H = L
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.mutation_type != GUARDIAN_NORMAL)
		return

	var/datum/behavior_delegate/guardian/BD = X.behavior_delegate
	if (!istype(BD))
		return

	X.visible_message(SPAN_XENODANGER("The [X] dashes forward, its claws extended!"), SPAN_XENODANGER("You dash forward, extending your claws!"))
	H.attack_alien(X, 15)


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

	if (!check_and_use_plasma_owner())
		return

	if(!check_clear_path_to_target(X, A, TRUE))
		to_chat(X, SPAN_XENOWARNING("Something is in the way!"))
		return

	if (X.mutation_type == GUARDIAN_NORMAL)
		var/datum/behavior_delegate/guardian/BD = X.behavior_delegate
		if (!istype(BD))
			return
		if (!BD.use_internal_acid_ability(throw_cost))
			return

	var/turf/T = get_turf(A)
	var/acid_bolt_message = "a barrage of acid"


	X.visible_message(SPAN_XENODANGER("[X] fires " + acid_bolt_message + " at [A]!"), SPAN_XENODANGER("You fire " + acid_bolt_message + " at [A]!"))
	new /obj/effect/xenomorph/acid_delay/guardian_landmine(T, blinded, delay, "You are blasted with " + acid_bolt_message + "!", X, )

	for (var/turf/targetTurf in orange(1, T))
		new /obj/effect/xenomorph/acid_delay/guardian_landmine(targetTurf, blinded, delay,  "You are blasted with a " + acid_bolt_message + "!", X)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/pierce/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if (!check_and_use_plasma_owner())
		return

	// Get list of target mobs
	var/list/target_mobs = list()


	var/list/target_turfs = list()
	var/facing = get_dir(X, A)
	var/turf/T = X.loc
	var/turf/temp = X.loc

	for(var/x in 0 to 2)
		temp = get_step(T, facing)
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(istype(S, /obj/structure/window/framed))
				var/obj/structure/window/framed/W = S
				if(!W.unslashable)
					W.shatter_window(TRUE)

			if(S.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp
		target_turfs += T

	for(var/turf/target_turf in target_turfs)
		for(var/mob/living/carbon/H in target_turf)
			if (!isXenoOrHuman(H) || X.can_not_harm(H))
				continue

			if(!(H in target_mobs))
				target_mobs += H

	X.visible_message(SPAN_XENODANGER("[X] slashes its claws through the area in front of it!"), SPAN_XENODANGER("You slash your claws through the area in front of you!"))
	X.animation_attack_on(A, 15)

	X.emote("roar")

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/mob/living/carbon/H in target_mobs)
		if (!isXenoOrHuman(H) || X.can_not_harm(H))
			continue

		if (H.stat)
			continue

		X.flick_attack_overlay(H, "slash")
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, null, 20)

	if (target_mobs.len >= shield_regen_threshold)
		if (X.mutation_type == PRAETORIAN_VANGUARD)
			var/datum/behavior_delegate/praetorian_vanguard/BD = X.behavior_delegate
			if (istype(BD))
				BD.regen_shield()

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/pounce/prae_dash/use_ability(atom/A)
	if(!activated_once && !action_cooldown_check() || owner.throwing)
		return

	if(!activated_once)
		. = ..()
		activated_once = TRUE
		addtimer(CALLBACK(src, .proc/timeout), time_until_timeout)
	else
		damage_nearby_targets()

/datum/action/xeno_action/activable/pounce/prae_dash/proc/timeout()
	if (activated_once)
		activated_once = FALSE
		damage_nearby_targets()

/datum/action/xeno_action/activable/pounce/prae_dash/ability_cooldown_over()
	update_button_icon()
	return

/datum/action/xeno_action/activable/pounce/prae_dash/proc/damage_nearby_targets()
	var/mob/living/carbon/Xenomorph/X = owner

	if (QDELETED(X) || !X.check_state())
		return

	activated_once = FALSE

	var/list/target_mobs = list()
	var/list/L = orange(1, X)
	for (var/mob/living/carbon/H in L)
		if (!isXenoOrHuman(H) || X.can_not_harm(H))
			continue

		if (!(H in target_mobs))
			target_mobs += H

	X.visible_message(SPAN_XENODANGER("[X] slashes its claws through the area around it!"), SPAN_XENODANGER("You slash your claws through the area around you!"))
	X.spin_circle()

	for (var/mob/living/carbon/H in target_mobs)
		if (H.stat)
			continue

		if (!isXenoOrHuman(H) || X.can_not_harm(H))
			continue


		X.flick_attack_overlay(H, "slash")
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE)
		playsound(get_turf(H), "alien_claw_flesh", 30, 1)

	if (target_mobs.len >= shield_regen_threshold)
		if (X.mutation_type == PRAETORIAN_VANGUARD)
			var/datum/behavior_delegate/praetorian_vanguard/BD = X.behavior_delegate
			if (istype(BD))
				BD.regen_shield()

/datum/action/xeno_action/activable/cleave/use_ability(atom/A)
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

	if (!X.Adjacent(H))
		to_chat(X, SPAN_XENOWARNING("You must be adjacent to your target!"))
		return

	if (H.stat == DEAD)
		to_chat(X, SPAN_XENODANGER("[H] is dead, why would you want to touch it?"))
		return

	// Flick overlay and play sound
	X.animation_attack_on(A, 10)
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)

	if (root_toggle)
		var/root_duration = buffed ? root_duration_buffed : root_duration_unbuffed

		X.visible_message(SPAN_XENODANGER("[X] smashes [A] with its claws, pinning them to the ground!"), SPAN_XENOHIGHDANGER("You smash [A] with your claws, pinning them to the ground!"))

		H.frozen = TRUE
		H.update_canmove()

		if (ishuman(H))
			var/mob/living/carbon/human/Hu = H
			Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, H), get_xeno_stun_duration(H, root_duration))
		to_chat(H, SPAN_XENOHIGHDANGER("[X] has pinned you to the ground! You cannot move!"))

	else
		var/fling_distance = buffed ? fling_dist_buffed : fling_dist_unbuffed

		if(H.mob_size >= MOB_SIZE_BIG)
			fling_distance *= 0.1
		X.visible_message(SPAN_XENODANGER("[X] deals [A] a massive blow, sending them flying!"), SPAN_XENOHIGHDANGER("You deal [A] a massive blow, sending them flying!"))
		xeno_throw_human(H, X, get_dir(X, A) ,fling_distance)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/cleave/proc/remove_buff()
	buffed = FALSE

///////// OPPRESSOR POWERS
/datum/action/xeno_action/activable/prae_abduct/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if(!action_cooldown_check() || X.action_busy)
		return

	if(!X.check_state())
		return

	if(!check_and_use_plasma_owner())
		return

	X.visible_message(SPAN_XENODANGER("[X] prepares to fire its resin spurs at [A]!"), SPAN_XENODANGER("You prepare to fire your resin spurs at [A]!"))
	X.emote("roar")

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(X, A)
	var/turf/T = X.loc
	var/turf/temp = X.loc
	for(var/x in 0 to max_distance)
		temp = get_step(T, facing)
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(S.opacity || ((istype(S, /obj/structure/barricade) || istype(S, /obj/structure/machinery/door)) && S.density))
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp

		if (T in turflist)
			break

		turflist += T
		facing = get_dir(T, A)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/abduct_hook(T, windup)

	var/throw_target_turf = get_step(X.loc, facing)

	X.frozen = TRUE
	X.update_canmove()
	if(!do_after(X, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, null, null, FALSE, 1, FALSE, 1))
		to_chat(X, SPAN_XENOWARNING("You cancel your abduct."))
		apply_cooldown()

		for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)

		X.frozen = FALSE
		X.update_canmove()

		return

	X.frozen = FALSE
	X.update_canmove()

	playsound(get_turf(X), 'sound/effects/bang.ogg', 25, 0)

	var/list/targets = list()
	for (var/turf/target_turf in turflist)
		for (var/mob/living/carbon/H in target_turf)
			if(!isXenoOrHuman(H) || X.can_not_harm(H) || H.is_dead() || H.is_mob_incapacitated(TRUE))
				continue

			targets += H

	if (LAZYLEN(targets) == 1)
		to_chat(X, SPAN_XENOHIGHDANGER("You hit one target! You will slow it."))
	else if (LAZYLEN(targets) == 2)
		to_chat(X, SPAN_XENOHIGHDANGER("You hit two targets! You will daze and root them!"))
	else if (LAZYLEN(targets) >= 3)
		to_chat(X, SPAN_XENOHIGHDANGER("You hit 3 or more targets! You will stun them!"))

	for (var/mob/living/carbon/H in targets)
		to_chat(H, SPAN_XENOHIGHDANGER("You are pulled toward [X]!"))

		H.KnockDown(0.2)

		if (LAZYLEN(targets) == 1)
			new /datum/effects/xeno_slow(H, X, , ,25)
		else if (LAZYLEN(targets) == 2)

			H.frozen = TRUE
			H.update_canmove()
			if (ishuman(H))
				var/mob/living/carbon/human/Hu = H
				Hu.update_xeno_hostile_hud()
			addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, H), get_xeno_stun_duration(H, 25))
			to_chat(H, SPAN_XENOHIGHDANGER("[X] has pinned you to the ground! You cannot move!"))

			H.SetDazed(2)
		else if (LAZYLEN(targets) >= 3)
			H.KnockDown(get_xeno_stun_duration(H, 1.3))
			to_chat(H, SPAN_XENOHIGHDANGER("You are slammed into the other victims of [X]!"))


		shake_camera(H, 10, 1)
		H.throw_atom(throw_target_turf, get_dist(throw_target_turf, H)-1, SPEED_VERY_FAST)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/oppressor_punch/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		return

	if (!X.check_state() || X.agility)
		return

	var/mob/living/carbon/H = A

	if (!X.Adjacent(H))
		return

	if(H.stat == DEAD) return

	var/obj/limb/L = H.get_limb(check_zone(X.zone_selected))

	if (ishuman(H) && (!L || (L.status & LIMB_DESTROYED)))
		return

	if (!check_and_use_plasma_owner())
		return

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_type)

	X.visible_message(SPAN_XENOWARNING("\The [X] hits [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [H] in the [L? L.display_name : "chest"] with a devastatingly powerful punch!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(H,S, 50, 1)

	if (H.frozen || H.slowed || H.knocked_down)
		H.apply_damage(get_xeno_damage_slash(H, damage), BRUTE, L? L.name : "chest")
		H.frozen = TRUE
		H.update_canmove()

		if (ishuman(H))
			var/mob/living/carbon/human/Hu = H
			Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, .proc/unroot_human, H), get_xeno_stun_duration(H, 12))
		to_chat(H, SPAN_XENOHIGHDANGER("[X] has pinned you to the ground! You cannot move!"))

		var/datum/action/xeno_action/activable/prae_abduct/SFA = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/prae_abduct)
		var/datum/action/xeno_action/activable/tail_lash/SFB = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/tail_lash)
		if(SFA && SFA.action_cooldown_check())
			SFA.reduce_cooldown(50)
		if(SFB && SFB.action_cooldown_check())
			SFB.reduce_cooldown(50)
	else
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, L? L.name : "chest")
		step_away(H, X, 2)


	shake_camera(H, 2, 1)



	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/crush/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	// This one is more tightly coupled than I'd like
	// but as it stands, everything to do with slashes is bound up onto the behavior datums.
	if (X.mutation_type != PRAETORIAN_OPPRESSOR)
		return

	var/datum/behavior_delegate/oppressor_praetorian/BD = X.behavior_delegate
	if (istype(BD))
		BD.next_slash_buffed = TRUE

	X.next_move = world.time + 1 // Autoattack reset
	to_chat(X, SPAN_XENOHIGHDANGER("Your click delay has been reset and your next slash will deal additional damage!"))


	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/tail_lash/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if (!check_and_use_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(X)
	var/facing = Get_Compass_Dir(X, A)
	var/turf/infront = get_step(root, facing)
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront
	temp_turfs += infront_left
	temp_turfs += infront_right

	for(var/turf/T in temp_turfs)
		if (!istype(T))
			continue

		if (T.density)
			continue

		target_turfs += T
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/lash(T, windup)

		var/turf/next_turf = get_step(T, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/lash(next_turf, windup)

	if(!do_after(X, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENOWARNING("You cancel your tail lash."))

		for(var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)
		return

	if (!action_cooldown_check())
		return

	apply_cooldown()

	X.visible_message(SPAN_XENODANGER("[X] lashes its tail furiously, hitting everything in front of it!"), SPAN_XENODANGER("You lash your tail furiously, hitting everything in front of you!"))
	X.spin_circle()
	X.emote("tail")

	for (var/turf/T in target_turfs)
		for (var/mob/living/carbon/H in T)
			if (H.stat == DEAD)
				continue

			if(!isXenoOrHuman(H) || X.can_not_harm(H))
				continue

			if(H.mob_size >= MOB_SIZE_BIG)
				continue

			xeno_throw_human(H, X, facing, fling_dist)

			H.KnockDown(get_xeno_stun_duration(H, 0.5))
			new /datum/effects/xeno_slow(H, X, ttl = get_xeno_stun_duration(H, 25))

	..()
	return


/////////// Dancer powers
/datum/action/xeno_action/activable/prae_impale/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!X.check_state())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		to_chat(X, SPAN_XENODANGER("You must target a hostile!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!X.Adjacent(A))
		to_chat(X, SPAN_XENODANGER("You must be adjacent to [A]!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/H = A

	if (H.stat == DEAD)
		to_chat(X, SPAN_XENOWARNING("[A] is dead, why would you want to attack it?"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!check_and_use_plasma_owner())
		return

	var/buffed = FALSE

	if (X.mutation_type == PRAETORIAN_DANCER)
		var/found = FALSE
		for (var/datum/effects/dancer_tag/DT in H.effects_list)
			found = TRUE
			qdel(DT)
			break

		buffed = found

	if(ishuman(H))
		var/mob/living/carbon/human/Hu = H
		Hu.update_xeno_hostile_hud()

	// Hmm today I will kill a marine while looking away from them
	X.face_atom(A)

	var/damage = get_xeno_damage_slash(H, rand(X.melee_damage_lower, X.melee_damage_upper))

	X.visible_message(SPAN_DANGER("\The [X] violently slices [A] with its tail[buffed?" twice":""]!"), \
					SPAN_DANGER("You slice [A] with your tail[buffed?" twice":""]!"))

	if (buffed)
		// Do two attacks instead of one
		X.animation_attack_on(A)
		X.flick_attack_overlay(A, "slash")
		X.emote("roar") // Feedback for the player that we got the magic double impale

		H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
		playsound(get_turf(A), "alien_claw_flesh", 30, 1)

		// Reroll damage
		damage = get_xeno_damage_slash(H, rand(X.melee_damage_lower, X.melee_damage_upper))
		sleep(4) // Short sleep so the animation and sounds will be distinct, but this creates some strange effects if the prae runs away
				 // not entirely happy with this, but I think its benefits outweigh its drawbacks

	X.animation_attack_on(A)
	X.flick_attack_overlay(A, "slash")

	H.last_damage_mob = X
	H.last_damage_source = initial(X.caste_type)
	H.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
	playsound(get_turf(A), "alien_claw_flesh", 30, 1)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_dodge/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!istype(X) || !X.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	if (X.mutation_type != PRAETORIAN_DANCER)
		return

	var/datum/behavior_delegate/praetorian_dancer/BD = X.behavior_delegate
	if (!istype(BD))
		return

	BD.dodge_activated = TRUE
	to_chat(X, SPAN_XENOHIGHDANGER("You can now dodge through mobs!"))
	X.speed_modifier -= speed_buff_amount
	X.add_temp_pass_flags(PASS_MOB_THRU)
	X.recalculate_speed()

	addtimer(CALLBACK(src, .proc/remove_effects), duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/Xenomorph/X = owner

	if (!istype(X))
		return

	if (X.mutation_type != PRAETORIAN_DANCER)
		return

	var/datum/behavior_delegate/praetorian_dancer/BD = X.behavior_delegate
	if (!istype(BD))
		return

	if (BD.dodge_activated)
		BD.dodge_activated = FALSE
		X.speed_modifier += speed_buff_amount
		X.remove_temp_pass_flags(PASS_MOB_THRU)
		X.recalculate_speed()
		to_chat(X, SPAN_XENOHIGHDANGER("You can no longer dodge through mobs!"))

/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner

	if (!action_cooldown_check())
		return

	if (!istype(X) || !X.check_state())
		return

	if (!isXenoOrHuman(A) || X.can_not_harm(A))
		to_chat(X, SPAN_XENODANGER("You must target a hostile!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/T = A

	if (T.stat == DEAD)
		to_chat(X, SPAN_XENOWARNING("[A] is dead, why would you want to attack it?"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!check_and_use_plasma_owner())
		return

	var/buffed = FALSE

	if (X.mutation_type == PRAETORIAN_DANCER)
		var/found = FALSE
		for (var/datum/effects/dancer_tag/DT in T.effects_list)
			found = TRUE
			qdel(DT)
			break

		buffed = found

	if(ishuman(T))
		var/mob/living/carbon/human/Hu = T
		Hu.update_xeno_hostile_hud()

	var/dist = get_dist(X, T)

	if (dist > range)
		to_chat(X, SPAN_WARNING("[T] is too far away!"))
		return

	if (dist > 1)
		var/turf/targetTurf = get_step(X, get_dir(X, T))
		if (targetTurf.density)
			to_chat(X, SPAN_WARNING("You can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/I in targetTurf)
				if (I.density && !I.throwpass && !istype(I, /obj/structure/barricade) && !istype(I, /mob/living))
					to_chat(X, SPAN_WARNING("You can't attack through [I]!"))
					return

	// Hmm today I will kill a marine while looking away from them
	X.face_atom(T)

	if (!buffed)
		new /datum/effects/xeno_slow(T, X, null, null, get_xeno_stun_duration(T, slow_duration))

	var/stun_duration = stun_duration_default
	var/daze_duration = 0

	if (buffed)
		stun_duration = stun_duration_buffed
		daze_duration = daze_duration_buffed

	var/xeno_smashed = FALSE

	if(isXeno(T))
		var/mob/living/carbon/Xenomorph/Xeno = T
		if(Xeno.mob_size >= MOB_SIZE_BIG)
			xeno_smashed = TRUE
			shake_camera(Xeno, 10, 1)
			X.visible_message(SPAN_XENODANGER("[X] smashes [Xeno] with it's tail!"), SPAN_XENODANGER("You smash [Xeno] with your tail!"))
			to_chat(Xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [X] smashes you with their tail!"))

	if(!xeno_smashed)
		if (stun_duration > 0)
			T.KnockDown(stun_duration)
		X.visible_message(SPAN_XENODANGER("[X] trips [A] with it's tail!"), SPAN_XENODANGER("You trip [A] with your tail!"))
		X.spin_circle()
		X.emote("tail")
		to_chat(T, SPAN_XENOHIGHDANGER("You are swept off your feet by [X]!"))

	if (daze_duration > 0)
		T.Daze(daze_duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_acid_ball/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!X.check_state() || X.action_busy)
		return

	if (!action_cooldown_check() && check_and_use_plasma_owner())
		return

	var/turf/current_turf = get_turf(X)

	if (!current_turf)
		return

	if (!do_after(X, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENODANGER("You cancel your acid ball."))
		return

	if (!action_cooldown_check())
		return

	apply_cooldown()

	to_chat(X, SPAN_XENOWARNING("You lob a compressed ball of acid into the air!"))

	var/obj/item/explosive/grenade/xeno_acid_grenade/grenade = new /obj/item/explosive/grenade/xeno_acid_grenade
	grenade.source_mob = X
	grenade.forceMove(get_turf(X))
	grenade.throw_atom(A, 5, SPEED_SLOW, X, TRUE)
	addtimer(CALLBACK(grenade, /obj/item/explosive.proc/prime), prime_delay)

	..()
	return

/datum/action/xeno_action/activable/warden_heal/use_ability(atom/A)
	var/mob/living/carbon/Xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state())
		return

	if (!isXeno(A) || !X.can_not_harm(A))
		to_chat(X, SPAN_XENODANGER("You must target one of your sisters!"))
		return

	if (A == X)
		to_chat(X, SPAN_XENODANGER("You cannot heal yourself!"))
		return

	if (A.z != X.z)
		to_chat(X, SPAN_XENODANGER("That Sister is too far away!"))
		return

	var/mob/living/carbon/Xenomorph/targetXeno = A

	if (!check_plasma_owner())
		return

	var/use_plasma = FALSE

	if (curr_effect_type == WARDEN_HEAL_SHIELD)
		if (SEND_SIGNAL(targetXeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			to_chat(X, SPAN_XENOWARNING("You cannot heal bolster the defenses of this xeno!"))
			return

		var/bonus_shield = 0

		if (X.mutation_type == PRAETORIAN_WARDEN)
			var/datum/behavior_delegate/praetorian_warden/BD = X.behavior_delegate
			if (!istype(BD))
				return

			if (!BD.use_internal_hp_ability(shield_cost))
				return

			bonus_shield = BD.internal_hitpoints/2
			if (!BD.use_internal_hp_ability(bonus_shield))
				bonus_shield = 0

		var/total_shield_amount = shield_amount + bonus_shield

		if (X.observed_xeno != null)
			to_chat(X, SPAN_XENOHIGHDANGER("You cannot shield [targetXeno] as effectively over distance!"))
			total_shield_amount = total_shield_amount/4
			targetXeno.visible_message(SPAN_BOLDNOTICE("[targetXeno]'s exoskeleton shimmers for a fraction of a second."))//marines probably should know if a xeno gets healed
		else //so both visible messages don't appear at the same time
			targetXeno.visible_message(SPAN_BOLDNOTICE("[X] points at [targetXeno], and it shudders as its exoskeleton shimmers for a second!")) //this one is a bit less important than healing and rejuvenating
		to_chat(X, SPAN_XENODANGER("You bolster the defenses of [targetXeno]!"))	//but i imagine it'll be useful for predators, survivors and for battle flavor
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("You feel your defenses bolstered by [X]!"))

		targetXeno.add_xeno_shield(total_shield_amount, XENO_SHIELD_SOURCE_WARDEN_PRAE, duration = shield_duration, decay_amount_per_second = shield_decay)
		targetXeno.xeno_jitter(1 SECONDS)
		targetXeno.flick_heal_overlay(3 SECONDS, "#FFA800") //D9F500
		use_plasma = TRUE

	else if (curr_effect_type == WARDEN_HEAL_HP)
		if (!X.Adjacent(A))
			to_chat(X, SPAN_XENODANGER("You must be within touching distance of [targetXeno]!"))
			return
		if (SEND_SIGNAL(targetXeno, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			to_chat(X, SPAN_XENOWARNING("You cannot heal this xeno!"))
			return

		var/bonus_heal = 0

		if (X.mutation_type == PRAETORIAN_WARDEN)
			var/datum/behavior_delegate/praetorian_warden/BD = X.behavior_delegate
			if (!istype(BD))
				return

			if (!BD.use_internal_hp_ability(heal_cost))
				return

			bonus_heal = BD.internal_hitpoints/2
			if (!BD.use_internal_hp_ability(bonus_heal))
				bonus_heal = 0

		to_chat(X, SPAN_XENODANGER("You heal [targetXeno]!"))
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("You are healed by [X]!"))
		targetXeno.gain_health(heal_amount + bonus_heal)
		targetXeno.visible_message(SPAN_BOLDNOTICE("[X] places its claws on [targetXeno], and its wounds are quickly sealed!"))	//marines probably should know if a xeno gets healed
		use_plasma = TRUE	//it's already hard enough to gauge health without hp showing on the mob
		targetXeno.flick_heal_overlay(3 SECONDS, "#00B800")//so the visible_message and recovery overlay will warn marines and possibly predators that the xenomorph has been healed!

	else if (curr_effect_type == WARDEN_HEAL_DEBUFFS)
		if (X.observed_xeno != null)
			to_chat(X, SPAN_XENOHIGHDANGER("You cannot rejuvenate targets through overwatch!"))
			return

		if (X.mutation_type == PRAETORIAN_WARDEN)
			var/datum/behavior_delegate/praetorian_warden/BD = X.behavior_delegate
			if (!istype(BD))
				return

			if (!BD.use_internal_hp_ability(debuff_cost))
				return

		to_chat(X, SPAN_XENODANGER("You rejuvenate [targetXeno]!"))
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("You are rejuvenated by [X]!"))
		targetXeno.visible_message(SPAN_BOLDNOTICE("[X] points at [targetXeno], and it spasms as it recuperates unnaturally quickly!"))	//marines probably should know if a xeno gets rejuvenated
		targetXeno.xeno_jitter(1 SECONDS) //it might confuse them as to why the queen got up half a second after being AT rocketed, and give them feedback on the Praetorian rejuvenating
		targetXeno.flick_heal_overlay(3 SECONDS, "#F5007A") //therefore making the Praetorian a priority target
		targetXeno.SetKnockedout(0)
		targetXeno.SetStunned(0)
		targetXeno.SetKnockeddown(0)
		targetXeno.SetDazed(0)
		targetXeno.SetSlowed(0)
		targetXeno.SetSuperslowed(0)
		use_plasma = TRUE
	if (use_plasma)
		use_plasma_owner()

	apply_cooldown()
	..()
	return

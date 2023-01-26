/datum/action/xeno_action/activable/prae_acid_ball/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if (!xeno_owner.check_state() || xeno_owner.action_busy)
		return

	if (!action_cooldown_check() && check_and_use_plasma_owner())
		return

	var/turf/current_turf = get_turf(xeno_owner)

	if (!current_turf)
		return

	if (!do_after(xeno_owner, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(xeno_owner, SPAN_XENODANGER("You cancel your acid ball."))
		return

	if (!action_cooldown_check())
		return

	apply_cooldown()

	to_chat(xeno_owner, SPAN_XENOWARNING("You lob a compressed ball of acid into the air!"))

	var/obj/item/explosive/grenade/xeno_acid_grenade/grenade = new /obj/item/explosive/grenade/xeno_acid_grenade
	grenade.cause_data = create_cause_data(initial(xeno_owner.caste_type), xeno_owner)
	grenade.forceMove(get_turf(xeno_owner))
	grenade.throw_atom(A, 5, SPEED_SLOW, xeno_owner, TRUE)
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/explosive, prime)), prime_delay)

	..()
	return

///////// VANGUARD POWERS

/datum/action/xeno_action/activable/pierce/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if (!action_cooldown_check())
		return

	if (!xeno_owner.check_state())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno_owner.loc))
		return

	if (!check_and_use_plasma_owner())
		return

	// Get list of target mobs
	var/list/target_mobs = list()


	var/list/target_turfs = list()
	var/facing = Get_Compass_Dir(xeno_owner, target)
	var/turf/T = xeno_owner.loc
	var/turf/temp = xeno_owner.loc

	for(var/x in 0 to 2)
		temp = get_step(T, facing)
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in temp)
			if(istype(S, /obj/structure/window/framed))
				var/obj/structure/window/framed/W = S
				if(!W.unslashable)
					W.deconstruct(disassembled = FALSE)

			if(S.opacity)
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp
		target_turfs += T

	for(var/turf/target_turf in target_turfs)
		for(var/mob/living/carbon/H in target_turf)
			if (!isXenoOrHuman(H) || xeno_owner.can_not_harm(H))
				continue

			if(!(H in target_mobs))
				target_mobs += H

	xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] slashes its claws through the area in front of it!"), SPAN_XENODANGER("You slash your claws through the area in front of you!"))
	xeno_owner.animation_attack_on(target, 15)

	xeno_owner.emote("roar")

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/mob/living/carbon/H in target_mobs)
		if (!isXenoOrHuman(H) || xeno_owner.can_not_harm(H))
			continue

		if (H.stat == DEAD)
			continue

		xeno_owner.flick_attack_overlay(H, "slash")
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE, null, 20)

	apply_cooldown()
	..()
	return target_mobs.len

/datum/action/xeno_action/activable/pounce/prae_dash/use_ability(atom/A)
	if(!activated_once && !action_cooldown_check() || owner.throwing)
		return

	if(!activated_once)
		. = ..()
		if(.)
			activated_once = TRUE
			addtimer(CALLBACK(src, PROC_REF(timeout)), time_until_timeout)
	else
		return damage_nearby_targets()

/datum/action/xeno_action/activable/pounce/prae_dash/ability_cooldown_over()
	update_button_icon()
	return

/datum/action/xeno_action/activable/pounce/prae_dash/proc/timeout()
	if (activated_once)
		activated_once = FALSE
		damage_nearby_targets()

/datum/action/xeno_action/activable/pounce/prae_dash/proc/damage_nearby_targets()
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (QDELETED(xeno_owner) || !xeno_owner.check_state())
		return

	activated_once = FALSE

	var/list/target_mobs = list()
	var/list/L = orange(1, xeno_owner)
	for (var/mob/living/carbon/H in L)
		if (!isXenoOrHuman(H) || xeno_owner.can_not_harm(H))
			continue

		if (!(H in target_mobs))
			target_mobs += H

	xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] slashes its claws through the area around it!"), SPAN_XENODANGER("You slash your claws through the area around you!"))
	xeno_owner.spin_circle()

	for (var/mob/living/carbon/H in target_mobs)
		if (H.stat)
			continue

		if (!isXenoOrHuman(H) || xeno_owner.can_not_harm(H))
			continue


		xeno_owner.flick_attack_overlay(H, "slash")
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE)
		playsound(get_turf(H), "alien_claw_flesh", 30, TRUE)

	return target_mobs.len

/datum/action/xeno_action/activable/cleave/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/vanguard_user = owner
	if (!action_cooldown_check())
		return

	if (!vanguard_user.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	if (!isXenoOrHuman(target_atom) || vanguard_user.can_not_harm(target_atom))
		to_chat(vanguard_user, SPAN_XENODANGER("You must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (!vanguard_user.Adjacent(target_carbon))
		to_chat(vanguard_user, SPAN_XENOWARNING("You must be adjacent to your target!"))
		return

	if (target_carbon.stat == DEAD)
		to_chat(vanguard_user, SPAN_XENODANGER("[target_carbon] is dead, why would you want to touch it?"))
		return

	// Flick overlay and play sound
	vanguard_user.face_atom(target_carbon)
	vanguard_user.animation_attack_on(target_atom, 10)
	var/hitsound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(target_carbon,hitsound, 50, 1)

	if (root_toggle)
		var/root_duration = buffed ? root_duration_buffed : root_duration_unbuffed

		vanguard_user.visible_message(SPAN_XENODANGER("[vanguard_user] slams [target_atom] into the ground!"), SPAN_XENOHIGHDANGER("You slam [target_atom] into the ground!"))

		target_carbon.frozen = TRUE
		target_carbon.update_canmove()

		if (ishuman(target_carbon))
			var/mob/living/carbon/human/Hu = target_carbon
			Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(unroot_human), target_carbon), get_xeno_stun_duration(target_carbon, root_duration))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("[vanguard_user] has pinned you to the ground! You cannot move!"))
		vanguard_user.flick_attack_overlay(target_carbon, "punch")

	else
		var/fling_distance = buffed ? fling_dist_buffed : fling_dist_unbuffed

		if(target_carbon.mob_size >= MOB_SIZE_BIG)
			fling_distance *= 0.1
		vanguard_user.visible_message(SPAN_XENODANGER("[vanguard_user] deals [target_atom] a massive blow, sending them flying!"), SPAN_XENOHIGHDANGER("You deal [target_atom] a massive blow, sending them flying!"))
		vanguard_user.flick_attack_overlay(target_carbon, "slam")
		xeno_throw_human(target_carbon, vanguard_user, get_dir(vanguard_user, target_atom), fling_distance)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/cleave/proc/remove_buff()
	buffed = FALSE

///////// OPPRESSOR POWERS

/datum/action/xeno_action/activable/tail_stab/tail_seize/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner

	if(!action_cooldown_check())
		return FALSE

	if(!stabbing_xeno.check_state())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	stabbing_xeno.visible_message(SPAN_XENODANGER("\The [stabbing_xeno] uncoils and wildly throws out its tail!"), SPAN_XENODANGER("You uncoil your tail wildly in front of you!"))

	var/obj/item/projectile/hook_projectile = new /obj/item/projectile(stabbing_xeno.loc, create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno))

	var/datum/ammo/ammoDatum = GLOB.ammo_list[/datum/ammo/xeno/oppressor_tail]

	hook_projectile.generate_bullet(ammoDatum, bullet_generator = stabbing_xeno)
	hook_projectile.bound_beam = hook_projectile.beam(stabbing_xeno, "oppressor_tail", 'icons/effects/beam.dmi', 1 SECONDS, 5)

	hook_projectile.fire_at(targetted_atom, stabbing_xeno, stabbing_xeno, ammoDatum.max_range, ammoDatum.shell_speed)
	playsound(stabbing_xeno, 'sound/effects/oppressor_tail.ogg', 40, FALSE)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	..()
	return

/datum/action/xeno_action/activable/prae_abduct/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if(!A || A.layer >= FLY_LAYER || !isturf(xeno_owner.loc))
		return

	if(!action_cooldown_check() || xeno_owner.action_busy)
		return

	if(!xeno_owner.check_state())
		return

	if(!check_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(xeno_owner, A)
	var/turf/T = xeno_owner.loc
	var/turf/temp = xeno_owner.loc
	for(var/x in 0 to max_distance)
		temp = get_step(T, facing)
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
			if(S.opacity || ((istype(S, /obj/structure/barricade) || istype(S, /obj/structure/girder) && S.density || istype(S, /obj/structure/machinery/door)) && S.density))
				blocked = TRUE
				break
		if(blocked)
			break

		T = temp

		if (T in turflist)
			break

		turflist += T
		facing = get_dir(T, A)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/brown/abduct_hook(T, windup)

	if(!length(turflist))
		to_chat(xeno_owner, SPAN_XENOWARNING("You don't have any room to do your abduction!"))
		return

	xeno_owner.visible_message(SPAN_XENODANGER("\The [xeno_owner]'s segmented tail starts coiling..."), SPAN_XENODANGER("You begin coiling your tail, aiming towards \the [A]..."))
	xeno_owner.emote("roar")

	var/throw_target_turf = get_step(xeno_owner.loc, facing)

	xeno_owner.frozen = TRUE
	xeno_owner.update_canmove()
	if(!do_after(xeno_owner, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
		to_chat(xeno_owner, SPAN_XENOWARNING("You relax your tail."))
		apply_cooldown()

		for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)

		xeno_owner.frozen = FALSE
		xeno_owner.update_canmove()

		return

	if(!check_and_use_plasma_owner())
		return

	xeno_owner.frozen = FALSE
	xeno_owner.update_canmove()

	playsound(get_turf(xeno_owner), 'sound/effects/bang.ogg', 25, 0)
	xeno_owner.visible_message(SPAN_XENODANGER("\The [xeno_owner] suddenly uncoils its tail, firing it towards [A]!"), SPAN_XENODANGER("You uncoil your tail, sending it out towards \the [A]!"))

	var/list/targets = list()
	for (var/turf/target_turf in turflist)
		for (var/mob/living/carbon/H in target_turf)
			if(!isXenoOrHuman(H) || xeno_owner.can_not_harm(H) || H.is_dead() || H.is_mob_incapacitated(TRUE))
				continue

			targets += H
	if (LAZYLEN(targets) == 1)
		xeno_owner.balloon_alert(xeno_owner, "your tail catches and slows one target!", text_color = "#51a16c")
	else if (LAZYLEN(targets) == 2)
		xeno_owner.balloon_alert(xeno_owner, "your tail catches and roots two targets!", text_color = "#51a16c")
	else if (LAZYLEN(targets) >= 3)
		xeno_owner.balloon_alert(xeno_owner, "your tail catches and stuns [LAZYLEN(targets)] targets!", text_color = "#51a16c")

	for (var/mob/living/carbon/H in targets)
		xeno_owner.visible_message(SPAN_XENODANGER("\The [xeno_owner]'s hooked tail coils itself around [H]!"), SPAN_XENODANGER("Your hooked tail coils itself around [H]!"))

		H.apply_effect(0.2, WEAKEN)

		if (LAZYLEN(targets) == 1)
			new /datum/effects/xeno_slow(H, xeno_owner, , ,25)
			H.apply_effect(1, SLOW)
		else if (LAZYLEN(targets) == 2)

			H.frozen = TRUE
			H.update_canmove()
			if (ishuman(H))
				var/mob/living/carbon/human/Hu = H
				Hu.update_xeno_hostile_hud()
			addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(unroot_human), H), get_xeno_stun_duration(H, 25))
			to_chat(H, SPAN_XENOHIGHDANGER("[xeno_owner] has pinned you to the ground! You cannot move!"))

			H.set_effect(2, DAZE)
		else if (LAZYLEN(targets) >= 3)
			H.apply_effect(get_xeno_stun_duration(H, 1.3), WEAKEN)
			to_chat(H, SPAN_XENOHIGHDANGER("You are slammed into the other victims of [xeno_owner]!"))


		shake_camera(H, 10, 1)

		var/obj/effect/beam/tail_beam = xeno_owner.beam(H, "oppressor_tail", 'icons/effects/beam.dmi', 0.5 SECONDS, 8)
		var/image/tail_image = image('icons/effects/status_effects.dmi', "hooked")
		H.overlays += tail_image

		H.throw_atom(throw_target_turf, get_dist(throw_target_turf, H)-1, SPEED_VERY_FAST)

		qdel(tail_beam) // hook beam catches target, throws them back, is deleted (throw_atom has sleeps), then hook beam catches another target, repeat
		addtimer(CALLBACK(src, /datum/action/xeno_action/activable/prae_abduct/proc/remove_tail_overlay, H, tail_image), 0.5 SECONDS) //needed so it can actually be seen as it gets deleted too quickly otherwise.

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_abduct/proc/remove_tail_overlay(var/mob/living/carbon/human/overlayed_human, var/image/tail_image)
	overlayed_human.overlays -= tail_image

/datum/action/xeno_action/activable/oppressor_punch/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/oppressor_user = owner

	if (!action_cooldown_check())
		return

	if (!isXenoOrHuman(target_atom) || oppressor_user.can_not_harm(target_atom))
		return

	if (!oppressor_user.check_state() || oppressor_user.agility)
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (!oppressor_user.Adjacent(target_carbon))
		return

	if(target_carbon.stat == DEAD) return

	var/obj/limb/target_limb = target_carbon.get_limb(check_zone(oppressor_user.zone_selected))

	if (ishuman(target_carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		return

	if (!check_and_use_plasma_owner())
		return

	target_carbon.last_damage_data = create_cause_data(oppressor_user.caste_type, oppressor_user)

	oppressor_user.visible_message(SPAN_XENOWARNING("\The [oppressor_user] hits [target_carbon] in the [target_limb? target_limb.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("You hit [target_carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/hitsound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(target_carbon, hitsound, 50, TRUE)

	oppressor_user.face_atom(target_carbon)
	oppressor_user.animation_attack_on(target_carbon)
	oppressor_user.flick_attack_overlay(target_carbon, "punch")

	if (target_carbon.frozen || target_carbon.slowed || target_carbon.knocked_down)
		target_carbon.apply_damage(get_xeno_damage_slash(target_carbon, damage), BRUTE, target_limb? target_limb.name : "chest")
		target_carbon.frozen = TRUE
		target_carbon.update_canmove()

		if (ishuman(target_carbon))
			var/mob/living/carbon/human/Hu = target_carbon
			Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(unroot_human), target_carbon), get_xeno_stun_duration(target_carbon, 12))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("[oppressor_user] has pinned you to the ground! You cannot move!"))

		var/datum/action/xeno_action/activable/prae_abduct/abduct_action = get_xeno_action_by_type(oppressor_user, /datum/action/xeno_action/activable/prae_abduct)
		var/datum/action/xeno_action/activable/tail_lash/tail_lash_action = get_xeno_action_by_type(oppressor_user, /datum/action/xeno_action/activable/tail_lash)
		if(abduct_action && abduct_action.action_cooldown_check())
			abduct_action.reduce_cooldown(5 SECONDS)
		if(tail_lash_action && tail_lash_action.action_cooldown_check())
			tail_lash_action.reduce_cooldown(5 SECONDS)
	else
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")
		step_away(target_carbon, oppressor_user, 2)


	shake_camera(target_carbon, 2, 1)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/tail_lash/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!istype(xeno_owner) || !xeno_owner.check_state() || !action_cooldown_check())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno_owner.loc))
		return

	if (!check_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(xeno_owner)
	var/facing = Get_Compass_Dir(xeno_owner, target)
	var/turf/infront = get_step(root, facing)
	var/turf/left = get_step(root, turn(facing, 90))
	var/turf/right = get_step(root, turn(facing, -90))
	var/turf/infront_left = get_step(root, turn(facing, 45))
	var/turf/infront_right = get_step(root, turn(facing, -45))
	temp_turfs += infront
	if(!(!infront || infront.density) && !(!left || left.density))
		temp_turfs += infront_left
	if(!(!infront || infront.density) && !(!right || right.density))
		temp_turfs += infront_right

	for(var/turf/T in temp_turfs)
		if (!istype(T))
			continue

		if (T.density)
			continue

		target_turfs += T
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/brown/lash(T, windup)

		var/turf/next_turf = get_step(T, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/brown/lash(next_turf, windup)

	if(!length(target_turfs))
		to_chat(xeno_owner, SPAN_XENOWARNING("You don't have any room to do your tail lash!"))
		return

	if(!do_after(xeno_owner, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		to_chat(xeno_owner, SPAN_XENOWARNING("You cancel your tail lash."))

		for(var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	apply_cooldown()

	xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] lashes its tail furiously, hitting everything in front of it!"), SPAN_XENODANGER("You lash your tail furiously, hitting everything in front of you!"))
	xeno_owner.spin_circle()
	xeno_owner.emote("tail")

	for (var/turf/T in target_turfs)
		for (var/mob/living/carbon/H in T)
			if (H.stat == DEAD)
				continue

			if(!isXenoOrHuman(H) || xeno_owner.can_not_harm(H))
				continue

			if(H.mob_size >= MOB_SIZE_BIG)
				continue

			xeno_throw_human(H, xeno_owner, facing, fling_dist)

			H.apply_effect(get_xeno_stun_duration(H, 0.5), WEAKEN)
			new /datum/effects/xeno_slow(H, xeno_owner, ttl = get_xeno_stun_duration(H, 25))

	..()
	return


///////// DANCER POWERS

/datum/action/xeno_action/activable/prae_impale/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!dancer_user.check_state())
		return

	if (!isXenoOrHuman(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("You must target a hostile!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!dancer_user.Adjacent(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("You must be adjacent to [target_atom]!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would you want to attack it?"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!check_and_use_plasma_owner())
		return

	apply_cooldown()
	var/buffed = FALSE
	for (var/datum/effects/dancer_tag/dancer_tag_effect in target_carbon.effects_list)
		buffed = TRUE
		qdel(dancer_tag_effect)
		break

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/Hu = target_carbon
		Hu.update_xeno_hostile_hud()

	// Hmm today I will kill a marine while looking away from them
	dancer_user.face_atom(target_atom)

	var/damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))

	dancer_user.visible_message(SPAN_DANGER("\The [dancer_user] violently slices [target_atom] with its tail[buffed?" twice":""]!"), \
					SPAN_DANGER("You slice [target_atom] with your tail[buffed?" twice":""]!"))

	if(buffed)
		// Do two attacks instead of one
		dancer_user.animation_attack_on(target_atom)
		dancer_user.flick_attack_overlay(target_atom, "tail")
		dancer_user.emote("roar") // Feedback for the player that we got the magic double impale

		target_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
		playsound(target_carbon, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)

		// Reroll damage
		damage = get_xeno_damage_slash(target_carbon, rand(dancer_user.melee_damage_lower, dancer_user.melee_damage_upper))
		sleep(4) // Short sleep so the animation and sounds will be distinct, but this creates some strange effects if the prae runs away. not entirely happy with this, but I think its benefits outweigh its drawbacks

	dancer_user.animation_attack_on(target_atom)
	dancer_user.flick_attack_overlay(target_atom, "tail")

	target_carbon.last_damage_data = create_cause_data(initial(dancer_user.caste_type), dancer_user)
	target_carbon.apply_armoured_damage(damage, ARMOR_MELEE, BRUTE, "chest", 10)
	playsound(target_carbon, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)
	..()
	return

/datum/action/xeno_action/onclick/prae_dodge/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!action_cooldown_check())
		return

	if (!istype(xeno) || !xeno.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	button.icon_state = "template_active"
	to_chat(xeno, SPAN_XENOHIGHDANGER("You can now dodge through mobs!"))
	xeno.speed_modifier -= speed_buff_amount
	xeno.add_temp_pass_flags(PASS_MOB_THRU)
	xeno.recalculate_speed()
	dodge_activated = TRUE
	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	..()
	return TRUE

/datum/action/xeno_action/onclick/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return

	if (dodge_activated)
		dodge_activated = FALSE
		button.icon_state = "template"
		xeno.speed_modifier += speed_buff_amount
		xeno.remove_temp_pass_flags(PASS_MOB_THRU)
		xeno.recalculate_speed()
		to_chat(xeno, SPAN_XENOHIGHDANGER("You can no longer dodge through mobs!"))

/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno_owner = owner

	if (!action_cooldown_check())
		return

	if (!istype(xeno_owner) || !xeno_owner.check_state())
		return

	if (!isXenoOrHuman(target_atom) || xeno_owner.can_not_harm(target_atom))
		to_chat(xeno_owner, SPAN_XENODANGER("You must target a hostile!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(xeno_owner, SPAN_XENOWARNING("[target_atom] is dead, why would you want to attack it?"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!check_and_use_plasma_owner())
		return

	var/buffed = FALSE
	for (var/datum/effects/dancer_tag/dancer_tag_effect in target_carbon.effects_list)
		buffed = TRUE
		qdel(dancer_tag_effect)
		break

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

	var/dist = get_dist(xeno_owner, target_carbon)

	if (dist > range)
		to_chat(xeno_owner, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if (dist > 1)
		var/turf/targetTurf = get_step(xeno_owner, get_dir(xeno_owner, target_carbon))
		if (targetTurf.density)
			to_chat(xeno_owner, SPAN_WARNING("You can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/atom_in_turf in targetTurf)
				if (atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(xeno_owner, SPAN_WARNING("You can't attack through [atom_in_turf]!"))
					return

	// Hmm today I will kill a marine while looking away from them
	xeno_owner.face_atom(target_carbon)
	xeno_owner.flick_attack_overlay(target_carbon, "disarm")

	if (!buffed)
		new /datum/effects/xeno_slow(target_carbon, xeno_owner, ttl = get_xeno_stun_duration(target_carbon, slow_duration))

	var/stun_duration = stun_duration_default
	var/daze_duration = 0

	if (buffed)
		stun_duration = stun_duration_buffed
		daze_duration = daze_duration_buffed

	var/xeno_smashed = FALSE

	if(isXeno(target_carbon))
		var/mob/living/carbon/xenomorph/Xeno = target_carbon
		if(Xeno.mob_size >= MOB_SIZE_BIG)
			xeno_smashed = TRUE
			shake_camera(Xeno, 10, 1)
			xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] smashes [Xeno] with it's tail!"), SPAN_XENODANGER("You smash [Xeno] with your tail!"))
			to_chat(Xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [xeno_owner] smashes you with their tail!"))
			xeno_owner.animation_attack_on(Xeno)

	if(!xeno_smashed)
		if (stun_duration > 0)
			target_carbon.apply_effect(stun_duration, WEAKEN)
		xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] trips [target_atom] with it's tail!"), SPAN_XENODANGER("You trip [target_atom] with your tail!"))
		xeno_owner.spin_circle()
		xeno_owner.emote("tail")
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You are swept off your feet by [xeno_owner]!"))
	if (daze_duration > 0)
		target_carbon.apply_effect(daze_duration, DAZE)

	apply_cooldown()
	..()
	return

///////// WARDEN POWERS

/datum/action/xeno_action/activable/warden_heal/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if (!istype(xeno_owner))
		return

	if (!action_cooldown_check())
		return

	if(!target || target.layer >= FLY_LAYER || !isturf(xeno_owner.loc) || !xeno_owner.check_state(TRUE))
		return

	if (!isXeno(target) || !xeno_owner.can_not_harm(target))
		to_chat(xeno_owner, SPAN_XENODANGER("You must target one of your sisters!"))
		return

	if (target == xeno_owner)
		to_chat(xeno_owner, SPAN_XENODANGER("You cannot heal yourself!"))
		return

	if (target.z != xeno_owner.z)
		to_chat(xeno_owner, SPAN_XENODANGER("That Sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/xeno_target = target

	if(xeno_target.stat == DEAD)
		to_chat(xeno_owner, SPAN_WARNING("[xeno_target] is already dead!"))
		return

	if (!check_plasma_owner())
		return

	var/use_plasma = FALSE

	if (curr_effect_type == WARDEN_HEAL_HP)
		if (!xeno_owner.Adjacent(target))
			to_chat(xeno_owner, SPAN_XENODANGER("You must be within touching distance of [xeno_target]!"))
			return
		if (xeno_target.mutation_type == PRAETORIAN_WARDEN)
			to_chat(xeno_owner, SPAN_XENODANGER("You cannot heal a sister of the same strain!"))
			return
		if (SEND_SIGNAL(xeno_target, COMSIG_XENO_PRE_HEAL) & COMPONENT_CANCEL_XENO_HEAL)
			to_chat(xeno_owner, SPAN_XENOWARNING("You cannot heal this xeno!"))
			return

		var/bonus_heal = 0

		if (internal_hp < heal_cost)
			return
		bonus_heal = max(0, (internal_hp - heal_cost) * 0.5)
		to_chat(xeno_owner, SPAN_XENODANGER("You heal [xeno_target]!"))
		to_chat(xeno_target, SPAN_XENOHIGHDANGER("You are healed by [xeno_owner]!"))
		xeno_target.gain_health(heal_amount + bonus_heal)
		xeno_target.visible_message(SPAN_BOLDNOTICE("[xeno_owner] places its claws on [xeno_target], and its wounds are quickly sealed!")) //marines probably should know if a xeno gets healed
		xeno_owner.gain_health(heal_amount*0.5 + bonus_heal*0.5)
		xeno_owner.flick_heal_overlay(3 SECONDS, "#00B800")
		use_plasma = TRUE //it's already hard enough to gauge health without hp showing on the mob
		xeno_target.flick_heal_overlay(3 SECONDS, "#00B800")//so the visible_message and recovery overlay will warn marines and possibly predators that the xenomorph has been healed!
		. = bonus_heal + heal_cost
	else if (curr_effect_type == WARDEN_HEAL_DEBUFFS)
		if (xeno_owner.observed_xeno != null)
			to_chat(xeno_owner, SPAN_XENOHIGHDANGER("You cannot rejuvenate targets through overwatch!"))
			return
		to_chat(xeno_owner, SPAN_XENODANGER("You rejuvenate [xeno_target]!"))
		to_chat(xeno_target, SPAN_XENOHIGHDANGER("You are rejuvenated by [xeno_owner]!"))
		xeno_target.visible_message(SPAN_BOLDNOTICE("[xeno_owner] points at [xeno_target], and it spasms as it recuperates unnaturally quickly!")) //marines probably should know if a xeno gets rejuvenated
		xeno_target.xeno_jitter(1 SECONDS) //it might confuse them as to why the queen got up half a second after being AT rocketed, and give them feedback on the Praetorian rejuvenating
		xeno_target.flick_heal_overlay(3 SECONDS, "#F5007A") //therefore making the Praetorian a priority target
		xeno_target.set_effect(0, PARALYZE)
		xeno_target.set_effect(0, STUN)
		xeno_target.set_effect(0, WEAKEN)
		xeno_target.set_effect(0, DAZE)
		xeno_target.set_effect(0, SLOW)
		xeno_target.set_effect(0, SUPERSLOW)
		. = debuff_cost
		use_plasma = TRUE

	if (use_plasma)
		use_plasma_owner()

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_retrieve/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/xeno_owner = owner
	if(!istype(xeno_owner))
		return

	if(xeno_owner.observed_xeno != null)
		to_chat(xeno_owner, SPAN_XENOHIGHDANGER("You cannot retrieve sisters through overwatch!"))
		return

	if(!isXeno(target) || !xeno_owner.can_not_harm(target))
		to_chat(xeno_owner, SPAN_XENODANGER("You must target one of your sisters!"))
		return

	if(target == xeno_owner)
		to_chat(xeno_owner, SPAN_XENODANGER("You cannot retrieve yourself!"))
		return

	if(xeno_owner.anchored)
		to_chat(xeno_owner, SPAN_XENODANGER("That sister cannot move!"))
		return

	if(!(target in view(7, xeno_owner)))
		to_chat(xeno_owner, SPAN_XENODANGER("That sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/xeno_target = target

	if(!(xeno_target.resting || xeno_target.stat == UNCONSCIOUS))
		if(xeno_target.mob_size > MOB_SIZE_BIG)
			to_chat(xeno_owner, SPAN_WARNING("[xeno_target] is too big to retrieve while standing up!"))
			return

	if(xeno_target.stat == DEAD)
		to_chat(xeno_owner, SPAN_WARNING("[xeno_target] is already dead!"))
		return

	if(!action_cooldown_check() || xeno_owner.action_busy)
		return

	if(!xeno_owner.check_state())
		return

	if(!check_plasma_owner())
		return

	if(internal_hp < internal_hp_cost)
		return

	if(!check_and_use_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(xeno_owner, target)
	var/reversefacing = get_dir(target, xeno_owner)
	var/turf/T = xeno_owner.loc
	var/turf/temp = xeno_owner.loc
	for(var/x in 0 to max_distance)
		temp = get_step(T, facing)
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
			if(S.opacity || ((istype(S, /obj/structure/barricade) || istype(S, /obj/structure/girder)  && S.density|| istype(S, /obj/structure/machinery/door)) && S.density))
				blocked = TRUE
				break
		if(blocked)
			to_chat(xeno_owner, SPAN_XENOWARNING("You can't reach [xeno_target] with your resin retrieval hook!"))
			return

		T = temp

		if(T in turflist)
			break

		turflist += T
		facing = get_dir(T, target)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/green(T, windup)

	if(!length(turflist))
		to_chat(xeno_owner, SPAN_XENOWARNING("You don't have any room to do your retrieve!"))
		return

	xeno_owner.visible_message(SPAN_XENODANGER("[xeno_owner] prepares to fire its resin retrieval hook at [target]!"), SPAN_XENODANGER("You prepare to fire your resin retrieval hook at [target]!"))
	xeno_owner.emote("roar")

	var/throw_target_turf = get_step(xeno_owner.loc, facing)
	var/turf/behind_turf = get_step(xeno_owner.loc, reversefacing)
	if(!(behind_turf.density))
		throw_target_turf = behind_turf

	xeno_owner.frozen = TRUE
	xeno_owner.update_canmove()
	if(windup)
		if(!do_after(xeno_owner, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
			to_chat(xeno_owner, SPAN_XENOWARNING("You cancel your retrieve."))
			apply_cooldown()

			for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
				telegraph_atom_list -= XT
				qdel(XT)

			xeno_owner.frozen = FALSE
			xeno_owner.update_canmove()

			return

	xeno_owner.frozen = FALSE
	xeno_owner.update_canmove()

	playsound(get_turf(xeno_owner), 'sound/effects/bang.ogg', 25, 0)

	var/successful_retrieve = FALSE
	for(var/turf/target_turf in turflist)
		if(xeno_target in target_turf)
			successful_retrieve = TRUE
			break

	if(!successful_retrieve)
		to_chat(xeno_owner, SPAN_XENOWARNING("You can't reach [xeno_target] with your resin retrieval hook!"))
		return

	to_chat(xeno_target, SPAN_XENOBOLDNOTICE("You are pulled toward [xeno_owner]!"))

	shake_camera(xeno_target, 10, 1)
	var/throw_dist = get_dist(throw_target_turf, xeno_target)-1
	if(throw_target_turf == behind_turf)
		throw_dist++
		to_chat(xeno_owner, SPAN_XENOBOLDNOTICE("You fling [xeno_target] over your head with your resin hook, and they land behind you!"))
	else
		to_chat(xeno_owner, SPAN_XENOBOLDNOTICE("You fling [xeno_target] towards you with your resin hook, and they in front of you!"))
	xeno_target.throw_atom(throw_target_turf, throw_dist, SPEED_VERY_FAST, pass_flags = PASS_MOB_THRU)
	apply_cooldown()
	return internal_hp_cost

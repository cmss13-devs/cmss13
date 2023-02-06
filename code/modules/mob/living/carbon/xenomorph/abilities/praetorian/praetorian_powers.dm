/datum/action/xeno_action/activable/pierce/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
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
	var/facing = Get_Compass_Dir(X, A)
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
			if (!isxeno_human(H) || X.can_not_harm(H))
				continue

			if(!(H in target_mobs))
				target_mobs += H

	X.visible_message(SPAN_XENODANGER("[X] slashes its claws through the area in front of it!"), SPAN_XENODANGER("You slash your claws through the area in front of you!"))
	X.animation_attack_on(A, 15)

	X.emote("roar")

	// Loop through our turfs, finding any humans there and dealing damage to them
	for (var/mob/living/carbon/H in target_mobs)
		if (!isxeno_human(H) || X.can_not_harm(H))
			continue

		if (H.stat == DEAD)
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
		if(.)
			activated_once = TRUE
			addtimer(CALLBACK(src, PROC_REF(timeout)), time_until_timeout)
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
	var/mob/living/carbon/xenomorph/X = owner

	if (QDELETED(X) || !X.check_state())
		return

	activated_once = FALSE

	var/list/target_mobs = list()
	var/list/L = orange(1, X)
	for (var/mob/living/carbon/H in L)
		if (!isxeno_human(H) || X.can_not_harm(H))
			continue

		if (!(H in target_mobs))
			target_mobs += H

	X.visible_message(SPAN_XENODANGER("[X] slashes its claws through the area around it!"), SPAN_XENODANGER("You slash your claws through the area around you!"))
	X.spin_circle()

	for (var/mob/living/carbon/H in target_mobs)
		if (H.stat)
			continue

		if (!isxeno_human(H) || X.can_not_harm(H))
			continue


		X.flick_attack_overlay(H, "slash")
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE)
		playsound(get_turf(H), "alien_claw_flesh", 30, 1)

	if (target_mobs.len >= shield_regen_threshold)
		if (X.mutation_type == PRAETORIAN_VANGUARD)
			var/datum/behavior_delegate/praetorian_vanguard/BD = X.behavior_delegate
			if (istype(BD))
				BD.regen_shield()

/datum/action/xeno_action/activable/cleave/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/vanguard_user = owner
	if (!action_cooldown_check())
		return

	if (!vanguard_user.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	if (!isxeno_human(target_atom) || vanguard_user.can_not_harm(target_atom))
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

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target_carbon), get_xeno_stun_duration(target_carbon, root_duration))
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
	var/mob/living/carbon/xenomorph/X = owner

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if(!action_cooldown_check() || X.action_busy)
		return

	if(!X.check_state())
		return

	if(!check_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(X, A)
	var/turf/T = X.loc
	var/turf/temp = X.loc
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
		to_chat(X, SPAN_XENOWARNING("You don't have any room to do your abduction!"))
		return

	X.visible_message(SPAN_XENODANGER("\The [X]'s segmented tail starts coiling..."), SPAN_XENODANGER("You begin coiling your tail, aiming towards \the [A]..."))
	X.emote("roar")

	var/throw_target_turf = get_step(X.loc, facing)

	X.frozen = TRUE
	X.update_canmove()
	if(!do_after(X, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
		to_chat(X, SPAN_XENOWARNING("You relax your tail."))
		apply_cooldown()

		for (var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)

		X.frozen = FALSE
		X.update_canmove()

		return

	if(!check_and_use_plasma_owner())
		return

	X.frozen = FALSE
	X.update_canmove()

	playsound(get_turf(X), 'sound/effects/bang.ogg', 25, 0)
	X.visible_message(SPAN_XENODANGER("\The [X] suddenly uncoils its tail, firing it towards [A]!"), SPAN_XENODANGER("You uncoil your tail, sending it out towards \the [A]!"))

	var/list/targets = list()
	for (var/turf/target_turf in turflist)
		for (var/mob/living/carbon/H in target_turf)
			if(!isxeno_human(H) || X.can_not_harm(H) || H.is_dead() || H.is_mob_incapacitated(TRUE))
				continue

			targets += H
	if (LAZYLEN(targets) == 1)
		X.balloon_alert(X, "your tail catches and slows one target!", text_color = "#51a16c")
	else if (LAZYLEN(targets) == 2)
		X.balloon_alert(X, "your tail catches and roots two targets!", text_color = "#51a16c")
	else if (LAZYLEN(targets) >= 3)
		X.balloon_alert(X, "your tail catches and stuns [LAZYLEN(targets)] targets!", text_color = "#51a16c")

	for (var/mob/living/carbon/H in targets)
		X.visible_message(SPAN_XENODANGER("\The [X]'s hooked tail coils itself around [H]!"), SPAN_XENODANGER("Your hooked tail coils itself around [H]!"))

		H.apply_effect(0.2, WEAKEN)

		if (LAZYLEN(targets) == 1)
			new /datum/effects/xeno_slow(H, X, , ,25)
			H.apply_effect(1, SLOW)
		else if (LAZYLEN(targets) == 2)

			H.frozen = TRUE
			H.update_canmove()
			if (ishuman(H))
				var/mob/living/carbon/human/Hu = H
				Hu.update_xeno_hostile_hud()
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), H), get_xeno_stun_duration(H, 25))
			to_chat(H, SPAN_XENOHIGHDANGER("[X] has pinned you to the ground! You cannot move!"))

			H.set_effect(2, DAZE)
		else if (LAZYLEN(targets) >= 3)
			H.apply_effect(get_xeno_stun_duration(H, 1.3), WEAKEN)
			to_chat(H, SPAN_XENOHIGHDANGER("You are slammed into the other victims of [X]!"))


		shake_camera(H, 10, 1)

		var/obj/effect/beam/tail_beam = X.beam(H, "oppressor_tail", 'icons/effects/beam.dmi', 0.5 SECONDS, 8)
		var/image/tail_image = image('icons/effects/status_effects.dmi', "hooked")
		H.overlays += tail_image

		H.throw_atom(throw_target_turf, get_dist(throw_target_turf, H)-1, SPEED_VERY_FAST)

		qdel(tail_beam) // hook beam catches target, throws them back, is deleted (throw_atom has sleeps), then hook beam catches another target, repeat
		addtimer(CALLBACK(src, /datum/action/xeno_action/activable/prae_abduct/proc/remove_tail_overlay, H, tail_image), 0.5 SECONDS) //needed so it can actually be seen as it gets deleted too quickly otherwise.

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_abduct/proc/remove_tail_overlay(mob/living/carbon/human/overlayed_human, image/tail_image)
	overlayed_human.overlays -= tail_image

/datum/action/xeno_action/activable/oppressor_punch/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/oppressor_user = owner

	if (!action_cooldown_check())
		return

	if (!isxeno_human(target_atom) || oppressor_user.can_not_harm(target_atom))
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
	playsound(target_carbon,hitsound, 50, 1)

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

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target_carbon), get_xeno_stun_duration(target_carbon, 12))
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

/datum/action/xeno_action/activable/tail_lash/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if (!istype(X) || !X.check_state() || !action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc))
		return

	if (!check_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(X)
	var/facing = Get_Compass_Dir(X, A)
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
		to_chat(X, SPAN_XENOWARNING("You don't have any room to do your tail lash!"))
		return

	if(!do_after(X, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		to_chat(X, SPAN_XENOWARNING("You cancel your tail lash."))

		for(var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	apply_cooldown()

	X.visible_message(SPAN_XENODANGER("[X] lashes its tail furiously, hitting everything in front of it!"), SPAN_XENODANGER("You lash your tail furiously, hitting everything in front of you!"))
	X.spin_circle()
	X.emote("tail")

	for (var/turf/T in target_turfs)
		for (var/mob/living/carbon/H in T)
			if (H.stat == DEAD)
				continue

			if(!isxeno_human(H) || X.can_not_harm(H))
				continue

			if(H.mob_size >= MOB_SIZE_BIG)
				continue

			xeno_throw_human(H, X, facing, fling_dist)

			H.apply_effect(get_xeno_stun_duration(H, 0.5), WEAKEN)
			new /datum/effects/xeno_slow(H, X, ttl = get_xeno_stun_duration(H, 25))

	..()
	return


/////////// Dancer powers
/datum/action/xeno_action/activable/prae_impale/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!dancer_user.check_state())
		return

	if (!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
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

	var/buffed = FALSE
	apply_cooldown()
	if (dancer_user.mutation_type == PRAETORIAN_DANCER)
		var/found = FALSE
		for (var/datum/effects/dancer_tag/dancer_tag_effect in target_carbon.effects_list)
			found = TRUE
			qdel(dancer_tag_effect)
			break

		buffed = found

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

	if (xeno.mutation_type != PRAETORIAN_DANCER)
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = xeno.behavior_delegate
	if (!istype(behavior))
		return

	behavior.dodge_activated = TRUE
	button.icon_state = "template_active"
	to_chat(xeno, SPAN_XENOHIGHDANGER("You can now dodge through mobs!"))
	xeno.speed_modifier -= speed_buff_amount
	xeno.add_temp_pass_flags(PASS_MOB_THRU)
	xeno.recalculate_speed()

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/onclick/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (xeno.mutation_type != PRAETORIAN_DANCER)
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = xeno.behavior_delegate
	if (!istype(behavior))
		return

	if (behavior.dodge_activated)
		behavior.dodge_activated = FALSE
		button.icon_state = "template"
		xeno.speed_modifier += speed_buff_amount
		xeno.remove_temp_pass_flags(PASS_MOB_THRU)
		xeno.recalculate_speed()
		to_chat(xeno, SPAN_XENOHIGHDANGER("You can no longer dodge through mobs!"))

/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!istype(dancer_user) || !dancer_user.check_state())
		return

	if (!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("You must target a hostile!"))
		apply_cooldown_override(click_miss_cooldown)
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would you want to attack it?"))
		apply_cooldown_override(click_miss_cooldown)
		return

	if (!check_and_use_plasma_owner())
		return

	var/buffed = FALSE

	if (dancer_user.mutation_type == PRAETORIAN_DANCER)
		var/found = FALSE
		for (var/datum/effects/dancer_tag/dancer_tag_effect in target_carbon.effects_list)
			found = TRUE
			qdel(dancer_tag_effect)
			break

		buffed = found

	if(ishuman(target_carbon))
		var/mob/living/carbon/human/target_human = target_carbon
		target_human.update_xeno_hostile_hud()

	var/dist = get_dist(dancer_user, target_carbon)

	if (dist > range)
		to_chat(dancer_user, SPAN_WARNING("[target_carbon] is too far away!"))
		return

	if (dist > 1)
		var/turf/targetTurf = get_step(dancer_user, get_dir(dancer_user, target_carbon))
		if (targetTurf.density)
			to_chat(dancer_user, SPAN_WARNING("You can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/atom_in_turf in targetTurf)
				if (atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("You can't attack through [atom_in_turf]!"))
					return

	// Hmm today I will kill a marine while looking away from them
	dancer_user.face_atom(target_carbon)
	dancer_user.flick_attack_overlay(target_carbon, "disarm")

	if (!buffed)
		new /datum/effects/xeno_slow(target_carbon, dancer_user, null, null, get_xeno_stun_duration(target_carbon, slow_duration))

	var/stun_duration = stun_duration_default
	var/daze_duration = 0

	if (buffed)
		stun_duration = stun_duration_buffed
		daze_duration = daze_duration_buffed

	var/xeno_smashed = FALSE

	if(isxeno(target_carbon))
		var/mob/living/carbon/xenomorph/Xeno = target_carbon
		if(Xeno.mob_size >= MOB_SIZE_BIG)
			xeno_smashed = TRUE
			shake_camera(Xeno, 10, 1)
			dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] smashes [Xeno] with it's tail!"), SPAN_XENODANGER("You smash [Xeno] with your tail!"))
			to_chat(Xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [dancer_user] smashes you with their tail!"))
			dancer_user.animation_attack_on(Xeno)

	if(!xeno_smashed)
		if (stun_duration > 0)
			target_carbon.apply_effect(stun_duration, WEAKEN)
		dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] trips [target_atom] with it's tail!"), SPAN_XENODANGER("You trip [target_atom] with your tail!"))
		dancer_user.spin_circle()
		dancer_user.emote("tail")
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You are swept off your feet by [dancer_user]!"))
	if (daze_duration > 0)
		target_carbon.apply_effect(daze_duration, DAZE)

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_acid_ball/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
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
	grenade.cause_data = create_cause_data(initial(X.caste_type), X)
	grenade.forceMove(get_turf(X))
	grenade.throw_atom(A, 5, SPEED_SLOW, X, TRUE)
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/explosive, prime)), prime_delay)

	..()
	return

/datum/action/xeno_action/activable/warden_heal/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (!action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(X.loc) || !X.check_state(TRUE))
		return

	if (!isxeno(A) || !X.can_not_harm(A))
		to_chat(X, SPAN_XENODANGER("You must target one of your sisters!"))
		return

	if (A == X)
		to_chat(X, SPAN_XENODANGER("You cannot heal yourself!"))
		return

	if (A.z != X.z)
		to_chat(X, SPAN_XENODANGER("That Sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/targetXeno = A

	if(targetXeno.stat == DEAD)
		to_chat(X, SPAN_WARNING("[targetXeno] is already dead!"))
		return

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

			bonus_shield = BD.internal_hitpoints*0.5
			if (!BD.use_internal_hp_ability(bonus_shield))
				bonus_shield = 0

		var/total_shield_amount = shield_amount + bonus_shield

		if (X.observed_xeno != null)
			to_chat(X, SPAN_XENOHIGHDANGER("You cannot shield [targetXeno] as effectively over distance!"))
			total_shield_amount = total_shield_amount/4
			targetXeno.visible_message(SPAN_BOLDNOTICE("[targetXeno]'s exoskeleton shimmers for a fraction of a second."))//marines probably should know if a xeno gets healed
		else //so both visible messages don't appear at the same time
			targetXeno.visible_message(SPAN_BOLDNOTICE("[X] points at [targetXeno], and it shudders as its exoskeleton shimmers for a second!")) //this one is a bit less important than healing and rejuvenating
		to_chat(X, SPAN_XENODANGER("You bolster the defenses of [targetXeno]!")) //but i imagine it'll be useful for predators, survivors and for battle flavor
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("You feel your defenses bolstered by [X]!"))

		targetXeno.add_xeno_shield(total_shield_amount, XENO_SHIELD_SOURCE_WARDEN_PRAE, duration = shield_duration, decay_amount_per_second = shield_decay)
		targetXeno.xeno_jitter(1 SECONDS)
		targetXeno.flick_heal_overlay(3 SECONDS, "#FFA800") //D9F500
		X.add_xeno_shield(total_shield_amount*0.5, XENO_SHIELD_SOURCE_WARDEN_PRAE, duration = shield_duration, decay_amount_per_second = shield_decay) // X is the prae itself
		X.xeno_jitter(1 SECONDS)
		X.flick_heal_overlay(3 SECONDS, "#FFA800") //D9F500
		use_plasma = TRUE

	else if (curr_effect_type == WARDEN_HEAL_HP)
		if (!X.Adjacent(A))
			to_chat(X, SPAN_XENODANGER("You must be within touching distance of [targetXeno]!"))
			return
		if (targetXeno.mutation_type == PRAETORIAN_WARDEN)
			to_chat(X, SPAN_XENODANGER("You cannot heal a sister of the same strain!"))
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

			bonus_heal = BD.internal_hitpoints*0.5
			if (!BD.use_internal_hp_ability(bonus_heal))
				bonus_heal = 0

		to_chat(X, SPAN_XENODANGER("You heal [targetXeno]!"))
		to_chat(targetXeno, SPAN_XENOHIGHDANGER("You are healed by [X]!"))
		targetXeno.gain_health(heal_amount + bonus_heal)
		targetXeno.visible_message(SPAN_BOLDNOTICE("[X] places its claws on [targetXeno], and its wounds are quickly sealed!")) //marines probably should know if a xeno gets healed
		X.gain_health(heal_amount*0.5 + bonus_heal*0.5)
		X.flick_heal_overlay(3 SECONDS, "#00B800")
		use_plasma = TRUE //it's already hard enough to gauge health without hp showing on the mob
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
		targetXeno.visible_message(SPAN_BOLDNOTICE("[X] points at [targetXeno], and it spasms as it recuperates unnaturally quickly!")) //marines probably should know if a xeno gets rejuvenated
		targetXeno.xeno_jitter(1 SECONDS) //it might confuse them as to why the queen got up half a second after being AT rocketed, and give them feedback on the Praetorian rejuvenating
		targetXeno.flick_heal_overlay(3 SECONDS, "#F5007A") //therefore making the Praetorian a priority target
		targetXeno.set_effect(0, PARALYZE)
		targetXeno.set_effect(0, STUN)
		targetXeno.set_effect(0, WEAKEN)
		targetXeno.set_effect(0, DAZE)
		targetXeno.set_effect(0, SLOW)
		targetXeno.set_effect(0, SUPERSLOW)
		use_plasma = TRUE
	if (use_plasma)
		use_plasma_owner()

	apply_cooldown()
	..()
	return

/datum/action/xeno_action/activable/prae_retrieve/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	if(!istype(X))
		return

	var/datum/behavior_delegate/praetorian_warden/BD = X.behavior_delegate
	if(!istype(BD))
		return

	if(X.observed_xeno != null)
		to_chat(X, SPAN_XENOHIGHDANGER("You cannot retrieve sisters through overwatch!"))
		return

	if(!isxeno(A) || !X.can_not_harm(A))
		to_chat(X, SPAN_XENODANGER("You must target one of your sisters!"))
		return

	if(A == X)
		to_chat(X, SPAN_XENODANGER("You cannot retrieve yourself!"))
		return

	if(X.anchored)
		to_chat(X, SPAN_XENODANGER("That sister cannot move!"))
		return

	if(!(A in view(7, X)))
		to_chat(X, SPAN_XENODANGER("That sister is too far away!"))
		return

	var/mob/living/carbon/xenomorph/targetXeno = A

	if(!(targetXeno.resting || targetXeno.stat == UNCONSCIOUS))
		if(targetXeno.mob_size > MOB_SIZE_BIG)
			to_chat(X, SPAN_WARNING("[targetXeno] is too big to retrieve while standing up!"))
			return

	if(targetXeno.stat == DEAD)
		to_chat(X, SPAN_WARNING("[targetXeno] is already dead!"))
		return

	if(!action_cooldown_check() || X.action_busy)
		return

	if(!X.check_state())
		return

	if(!check_plasma_owner())
		return

	if(!BD.use_internal_hp_ability(retrieve_cost))
		return

	if(!check_and_use_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(X, A)
	var/reversefacing = get_dir(A, X)
	var/turf/T = X.loc
	var/turf/temp = X.loc
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
			to_chat(X, SPAN_XENOWARNING("You can't reach [targetXeno] with your resin retrieval hook!"))
			return

		T = temp

		if(T in turflist)
			break

		turflist += T
		facing = get_dir(T, A)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/green(T, windup)

	if(!length(turflist))
		to_chat(X, SPAN_XENOWARNING("You don't have any room to do your retrieve!"))
		return

	X.visible_message(SPAN_XENODANGER("[X] prepares to fire its resin retrieval hook at [A]!"), SPAN_XENODANGER("You prepare to fire your resin retrieval hook at [A]!"))
	X.emote("roar")

	var/throw_target_turf = get_step(X.loc, facing)
	var/turf/behind_turf = get_step(X.loc, reversefacing)
	if(!(behind_turf.density))
		throw_target_turf = behind_turf

	X.frozen = TRUE
	X.update_canmove()
	if(windup)
		if(!do_after(X, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
			to_chat(X, SPAN_XENOWARNING("You cancel your retrieve."))
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

	var/successful_retrieve = FALSE
	for(var/turf/target_turf in turflist)
		if(targetXeno in target_turf)
			successful_retrieve = TRUE
			break

	if(!successful_retrieve)
		to_chat(X, SPAN_XENOWARNING("You can't reach [targetXeno] with your resin retrieval hook!"))
		return

	to_chat(targetXeno, SPAN_XENOBOLDNOTICE("You are pulled toward [X]!"))

	shake_camera(targetXeno, 10, 1)
	var/throw_dist = get_dist(throw_target_turf, targetXeno)-1
	if(throw_target_turf == behind_turf)
		throw_dist++
		to_chat(X, SPAN_XENOBOLDNOTICE("You fling [targetXeno] over your head with your resin hook, and they land behind you!"))
	else
		to_chat(X, SPAN_XENOBOLDNOTICE("You fling [targetXeno] towards you with your resin hook, and they in front of you!"))
	targetXeno.throw_atom(throw_target_turf, throw_dist, SPEED_VERY_FAST, pass_flags = PASS_MOB_THRU)
	apply_cooldown()
	return

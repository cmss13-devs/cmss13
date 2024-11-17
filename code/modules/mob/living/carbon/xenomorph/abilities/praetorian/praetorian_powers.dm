/datum/action/xeno_action/activable/pierce/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/pierce_user = owner
	if (!action_cooldown_check())
		return

	if (!pierce_user.check_state())
		return

	if(!targetted_atom || targetted_atom.layer >= FLY_LAYER || !isturf(pierce_user.loc))
		return

	if (!check_and_use_plasma_owner())
		return

	//X = xeno user, A = target atom
	var/list/turf/target_turfs = get_line(pierce_user, targetted_atom, include_start_atom = FALSE)
	var/length_of_line = LAZYLEN(target_turfs)
	if(length_of_line > 3)
		target_turfs = target_turfs.Copy(1, 4)

	// Get list of target mobs
	var/list/target_mobs = list()
	var/blocked = FALSE

	for(var/turf/path_turf as anything in target_turfs)
		if(blocked)
			break
		//Check for walls etc and stop if we encounter one
		if(path_turf.density)
			break

		//Check for structures such as doors
		for(var/atom/path_content as anything in path_turf.contents)
			if(isobj(path_content))
				var/obj/object = path_content
				//If we shouldn't be able to pass through it then stop at this turf
				if(object.density && !object.throwpass)
					blocked = TRUE
					break

				if(istype(object, /obj/structure/window/framed))
					var/obj/structure/window/framed/framed_window = object
					if(!framed_window.unslashable)
						framed_window.deconstruct(disassembled = FALSE)

			//Check for mobs and add them to our target list for damage
			if(iscarbon(path_content))
				var/mob/living/carbon/mob_to_act = path_content
				if(!isxeno_human(mob_to_act) || pierce_user.can_not_harm(mob_to_act))
					continue

				if(!(mob_to_act in target_mobs))
					target_mobs += mob_to_act

	pierce_user.visible_message(SPAN_XENODANGER("[pierce_user] slashes its claws through the area in front of it!"), SPAN_XENODANGER("We slash our claws through the area in front of us!"))
	pierce_user.animation_attack_on(targetted_atom, 15)

	pierce_user.emote("roar")

	// Loop through our mob list, finding any humans there and dealing damage to them
	for (var/mob/living/carbon/current_mob in target_mobs)
		if (!isxeno_human(current_mob) || pierce_user.can_not_harm(current_mob))
			continue

		if (current_mob.stat == DEAD)
			continue

		current_mob.flick_attack_overlay(current_mob, "slash")
		current_mob.apply_armoured_damage(get_xeno_damage_slash(current_mob, damage), ARMOR_MELEE, BRUTE, null, 20)
		playsound(current_mob, 'sound/weapons/alien_tail_attack.ogg', 30, TRUE)

	if (length(target_mobs) >= shield_regen_threshold)
		var/datum/behavior_delegate/praetorian_vanguard/behavior = pierce_user.behavior_delegate
		if (istype(behavior))
			behavior.regen_shield()

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/pounce/prae_dash/use_ability(atom/A)
	if(!activated_once && !action_cooldown_check() || owner.throwing)
		return

	if(!activated_once)
		. = ..()
		if(.)
			activated_once = TRUE
			button.icon_state = "template_active"
			addtimer(CALLBACK(src, PROC_REF(timeout)), time_until_timeout)
	else
		damage_nearby_targets()
		return TRUE

/datum/action/xeno_action/activable/pounce/prae_dash/proc/timeout()
	if (activated_once)
		activated_once = FALSE
		damage_nearby_targets()

/datum/action/xeno_action/activable/pounce/prae_dash/ability_cooldown_over()
	update_button_icon()
	return

/datum/action/xeno_action/activable/pounce/prae_dash/proc/damage_nearby_targets()
	var/mob/living/carbon/xenomorph/dash_user = owner

	if (QDELETED(dash_user) || !dash_user.check_state())
		return

	activated_once = FALSE
	button.icon_state = dash_user.selected_ability == src ? "template_on" : "template"

	var/list/target_mobs = list()
	var/list/L = orange(1, dash_user)
	for (var/mob/living/carbon/H in L)
		if (!isxeno_human(H) || dash_user.can_not_harm(H))
			continue

		if (!(H in target_mobs))
			target_mobs += H

	dash_user.visible_message(SPAN_XENODANGER("[dash_user] slashes its claws through the area around it!"), SPAN_XENODANGER("We slash our claws through the area around us!"))
	dash_user.spin_circle()

	for (var/mob/living/carbon/H in target_mobs)
		if (H.stat)
			continue

		if (!isxeno_human(H) || dash_user.can_not_harm(H))
			continue


		dash_user.flick_attack_overlay(H, "slash")
		H.apply_armoured_damage(get_xeno_damage_slash(H, damage), ARMOR_MELEE, BRUTE)
		playsound(get_turf(H), "alien_claw_flesh", 30, 1)

	if (length(target_mobs) >= shield_regen_threshold)
		var/datum/behavior_delegate/praetorian_vanguard/behavior = dash_user.behavior_delegate
		if (istype(behavior))
			behavior.regen_shield()

/datum/action/xeno_action/activable/cleave/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/cleave_user = owner
	if (!action_cooldown_check())
		return

	if (!cleave_user.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	if (!isxeno_human(target_atom) || cleave_user.can_not_harm(target_atom))
		to_chat(cleave_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (!cleave_user.Adjacent(target_carbon))
		to_chat(cleave_user, SPAN_XENOWARNING("We must be adjacent to our target!"))
		return

	if (target_carbon.stat == DEAD)
		to_chat(cleave_user, SPAN_XENODANGER("[target_carbon] is dead, why would we want to touch it?"))
		return

	// Flick overlay and play sound
	cleave_user.face_atom(target_carbon)
	cleave_user.animation_attack_on(target_atom, 10)
	var/hitsound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(target_carbon,hitsound, 50, 1)

	if (root_toggle)
		var/root_duration = buffed ? root_duration_buffed : root_duration_unbuffed

		cleave_user.visible_message(SPAN_XENODANGER("[cleave_user] slams [target_atom] into the ground!"), SPAN_XENOHIGHDANGER("We slam [target_atom] into the ground!"))
		ADD_TRAIT(target_carbon, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Cleave"))

		if (ishuman(target_carbon))
			var/mob/living/carbon/human/Hu = target_carbon
			Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target_carbon, TRAIT_SOURCE_ABILITY("Cleave")), get_xeno_stun_duration(target_carbon, root_duration))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("[cleave_user] has pinned you to the ground! You cannot move!"))
		cleave_user.flick_attack_overlay(target_carbon, "punch")

	else
		var/fling_distance = buffed ? fling_dist_buffed : fling_dist_unbuffed

		if(target_carbon.mob_size >= MOB_SIZE_BIG)
			fling_distance *= 0.1
		cleave_user.visible_message(SPAN_XENODANGER("[cleave_user] deals [target_atom] a massive blow, sending them flying!"), SPAN_XENOHIGHDANGER("We deal [target_atom] a massive blow, sending them flying!"))
		cleave_user.flick_attack_overlay(target_carbon, "slam")
		cleave_user.throw_carbon(target_atom, null, fling_distance)

	apply_cooldown()
	return ..()

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

	stabbing_xeno.visible_message(SPAN_XENODANGER("\The [stabbing_xeno] uncoils and wildly throws out its tail!"), SPAN_XENODANGER("We uncoil our tail wildly in front of us!"))

	var/obj/projectile/hook_projectile = new /obj/projectile(stabbing_xeno.loc, create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno))

	var/datum/ammo/ammoDatum = GLOB.ammo_list[/datum/ammo/xeno/oppressor_tail]

	hook_projectile.generate_bullet(ammoDatum, bullet_generator = stabbing_xeno)
	hook_projectile.bound_beam = hook_projectile.beam(stabbing_xeno, "oppressor_tail", 'icons/effects/beam.dmi', 1 SECONDS, 5)

	hook_projectile.fire_at(targetted_atom, stabbing_xeno, stabbing_xeno, ammoDatum.max_range, ammoDatum.shell_speed)
	playsound(stabbing_xeno, 'sound/effects/oppressor_tail.ogg', 40, FALSE)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	return ..()

/datum/action/xeno_action/activable/prae_abduct/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/abduct_user = owner

	if(!atom || atom.layer >= FLY_LAYER || !isturf(abduct_user.loc))
		return

	if(!action_cooldown_check() || abduct_user.action_busy)
		return

	if(!abduct_user.check_state())
		return

	if(!check_plasma_owner())
		return

	// Build our turflist
	var/list/turf/turflist = list()
	var/list/telegraph_atom_list = list()
	var/facing = get_dir(abduct_user, atom)
	var/turf/turf = abduct_user.loc
	var/turf/temp = abduct_user.loc
	for(var/distance in 0 to max_distance)
		temp = get_step(turf, facing)
		if(facing in GLOB.diagonals) // check if it goes through corners
			var/reverse_face = GLOB.reverse_dir[facing]
			var/turf/back_left = get_step(temp, turn(reverse_face, 45))
			var/turf/back_right = get_step(temp, turn(reverse_face, -45))
			if((!back_left || back_left.density) && (!back_right || back_right.density))
				break
		if(!temp || temp.density || temp.opacity)
			break

		var/blocked = FALSE
		for(var/obj/structure/structure in temp)
			if(structure.opacity || ((istype(structure, /obj/structure/barricade) || istype(structure, /obj/structure/girder) && structure.density || istype(structure, /obj/structure/machinery/door)) && structure.density))
				blocked = TRUE
				break
		if(blocked)
			break

		turf = temp

		if (turf in turflist)
			break

		turflist += turf
		facing = get_dir(turf, atom)
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/abduct_hook(turf, windup)

	if(!length(turflist))
		to_chat(abduct_user, SPAN_XENOWARNING("We don't have any room to do our abduction!"))
		return

	abduct_user.visible_message(SPAN_XENODANGER("\The [abduct_user]'s segmented tail starts coiling..."), SPAN_XENODANGER("We begin coiling our tail, aiming towards \the [atom]..."))
	abduct_user.emote("roar")

	var/throw_target_turf = get_step(abduct_user.loc, facing)

	ADD_TRAIT(abduct_user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))
	if(!do_after(abduct_user, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE, numticks = 1))
		to_chat(abduct_user, SPAN_XENOWARNING("You relax your tail."))
		apply_cooldown()

		for (var/obj/effect/xenomorph/xeno_telegraph/xenotelegraph in telegraph_atom_list)
			telegraph_atom_list -= xenotelegraph
			qdel(xenotelegraph)

		REMOVE_TRAIT(abduct_user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))

		return

	if(!check_and_use_plasma_owner())
		return

	REMOVE_TRAIT(abduct_user, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))

	playsound(get_turf(abduct_user), 'sound/effects/bang.ogg', 25, 0)
	abduct_user.visible_message(SPAN_XENODANGER("\The [abduct_user] suddenly uncoils its tail, firing it towards [atom]!"), SPAN_XENODANGER("We uncoil our tail, sending it out towards \the [atom]!"))

	var/list/targets = list()
	for (var/turf/target_turf in turflist)
		for (var/mob/living/carbon/target in target_turf)
			if(!isxeno_human(target) || abduct_user.can_not_harm(target) || target.is_dead() || target.is_mob_incapacitated(TRUE) || target.mob_size >= MOB_SIZE_BIG)
				continue

			targets += target
	if (LAZYLEN(targets) == 1)
		abduct_user.balloon_alert(abduct_user, "our tail catches and slows one target!", text_color = "#51a16c")
	else if (LAZYLEN(targets) == 2)
		abduct_user.balloon_alert(abduct_user, "our tail catches and roots two targets!", text_color = "#51a16c")
	else if (LAZYLEN(targets) >= 3)
		abduct_user.balloon_alert(abduct_user, "our tail catches and stuns [LAZYLEN(targets)] targets!", text_color = "#51a16c")

	apply_cooldown()

	for (var/mob/living/carbon/target in targets)
		abduct_user.visible_message(SPAN_XENODANGER("\The [abduct_user]'s hooked tail coils itself around [target]!"), SPAN_XENODANGER("Our hooked tail coils itself around [target]!"))

		target.apply_effect(0.2, WEAKEN)

		if (LAZYLEN(targets) == 1)
			new /datum/effects/xeno_slow(target, abduct_user, , ,25)
			target.apply_effect(1, SLOW)
		else if (LAZYLEN(targets) == 2)
			ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))
			if (ishuman(target))
				var/mob/living/carbon/human/target_human = target
				target_human.update_xeno_hostile_hud()
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target, TRAIT_SOURCE_ABILITY("Abduct")), get_xeno_stun_duration(target, 25))
			to_chat(target, SPAN_XENOHIGHDANGER("[abduct_user] has pinned you to the ground! You cannot move!"))

			target.set_effect(2, DAZE)
		else if (LAZYLEN(targets) >= 3)
			target.apply_effect(get_xeno_stun_duration(target, 1.3), WEAKEN)
			to_chat(target, SPAN_XENOHIGHDANGER("You are slammed into the other victims of [abduct_user]!"))


		shake_camera(target, 10, 1)

		var/obj/effect/beam/tail_beam = abduct_user.beam(target, "oppressor_tail", 'icons/effects/beam.dmi', 0.5 SECONDS, 8)
		var/image/tail_image = image('icons/effects/status_effects.dmi', "hooked")
		target.overlays += tail_image

		target.throw_atom(throw_target_turf, get_dist(throw_target_turf, target)-1, SPEED_VERY_FAST)

		qdel(tail_beam) // hook beam catches target, throws them back, is deleted (throw_atom has sleeps), then hook beam catches another target, repeat
		addtimer(CALLBACK(src, /datum/action/xeno_action/activable/prae_abduct/proc/remove_tail_overlay, target, tail_image), 0.5 SECONDS) //needed so it can actually be seen as it gets deleted too quickly otherwise.

	return ..()

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
		target_limb = target_carbon.get_limb("chest")

	if (!check_and_use_plasma_owner())
		return

	target_carbon.last_damage_data = create_cause_data(oppressor_user.caste_type, oppressor_user)

	oppressor_user.visible_message(SPAN_XENOWARNING("\The [oppressor_user] hits [target_carbon] in the [target_limb? target_limb.display_name : "chest"] with a devastatingly powerful punch!"), \
	SPAN_XENOWARNING("We hit [target_carbon] in the [target_limb ? target_limb.display_name : "chest"] with a devastatingly powerful punch!"))
	var/hitsound = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(target_carbon,hitsound, 50, 1)

	oppressor_user.face_atom(target_carbon)
	oppressor_user.animation_attack_on(target_carbon)
	oppressor_user.flick_attack_overlay(target_carbon, "punch")

	if (!(target_carbon.mobility_flags & MOBILITY_MOVE) || !(target_carbon.mobility_flags & MOBILITY_STAND) || target_carbon.slowed)
		target_carbon.apply_damage(get_xeno_damage_slash(target_carbon, damage), BRUTE, target_limb? target_limb.name : "chest")
		ADD_TRAIT(target_carbon, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Oppressor Punch"))

		if (ishuman(target_carbon))
			var/mob/living/carbon/human/Hu = target_carbon
			Hu.update_xeno_hostile_hud()

		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target_carbon, TRAIT_SOURCE_ABILITY("Oppressor Punch")), get_xeno_stun_duration(target_carbon, 1.2 SECONDS))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("[oppressor_user] has pinned you to the ground! You cannot move!"))
	else
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")
		step_away(target_carbon, oppressor_user, 2)


	shake_camera(target_carbon, 2, 1)
	var/datum/action/xeno_action/activable/prae_abduct/abduct_action = get_action(oppressor_user, /datum/action/xeno_action/activable/prae_abduct)
	var/datum/action/xeno_action/activable/tail_lash/tail_lash_action = get_action(oppressor_user, /datum/action/xeno_action/activable/tail_lash)
	if(abduct_action && !abduct_action.action_cooldown_check())
		abduct_action.reduce_cooldown(5 SECONDS)
	if(tail_lash_action && !tail_lash_action.action_cooldown_check())
		tail_lash_action.reduce_cooldown(5 SECONDS)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/tail_lash/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/lash_user = owner

	if (!istype(lash_user) || !lash_user.check_state() || !action_cooldown_check())
		return

	if(!A || A.layer >= FLY_LAYER || !isturf(lash_user.loc))
		return

	if (!check_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(lash_user)
	var/facing = Get_Compass_Dir(lash_user, A)
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
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/lash(T, windup)

		var/turf/next_turf = get_step(T, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/lash(next_turf, windup)

	if(!length(target_turfs))
		to_chat(lash_user, SPAN_XENOWARNING("We don't have any room to do our tail lash!"))
		return

	if(!do_after(lash_user, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		to_chat(lash_user, SPAN_XENOWARNING("We cancel our tail lash."))

		for(var/obj/effect/xenomorph/xeno_telegraph/XT in telegraph_atom_list)
			telegraph_atom_list -= XT
			qdel(XT)
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	apply_cooldown()

	lash_user.visible_message(SPAN_XENODANGER("[lash_user] lashes its tail furiously, hitting everything in front of it!"), SPAN_XENODANGER("We lash our tail furiously, hitting everything in front of us!"))
	lash_user.spin_circle()
	lash_user.emote("tail")

	for (var/turf/T in target_turfs)
		for (var/mob/living/carbon/H in T)
			if (H.stat == DEAD)
				continue

			if(!isxeno_human(H) || lash_user.can_not_harm(H))
				continue

			if(H.mob_size >= MOB_SIZE_BIG)
				continue

			lash_user.throw_carbon(H, facing, fling_dist)

			H.apply_effect(get_xeno_stun_duration(H, 0.5), WEAKEN)
			new /datum/effects/xeno_slow(H, lash_user, ttl = get_xeno_stun_duration(H, 25))

	return ..()


/////////// Dancer powers
/datum/action/xeno_action/activable/prae_impale/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!dancer_user.check_state())
		return

	if (!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	if (!dancer_user.Adjacent(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must be adjacent to [target_atom]!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
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
					SPAN_DANGER("We slice [target_atom] with our tail[buffed?" twice":""]!"))

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
	return ..()

/datum/action/xeno_action/onclick/prae_dodge/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/dodge_user = owner

	if (!action_cooldown_check())
		return

	if (!istype(dodge_user) || !dodge_user.check_state())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = dodge_user.behavior_delegate
	if (!istype(behavior))
		return

	behavior.dodge_activated = TRUE
	button.icon_state = "template_active"
	to_chat(dodge_user, SPAN_XENOHIGHDANGER("We can now dodge through mobs!"))
	dodge_user.speed_modifier -= speed_buff_amount
	dodge_user.add_temp_pass_flags(PASS_MOB_THRU)
	dodge_user.recalculate_speed()

	addtimer(CALLBACK(src, PROC_REF(remove_effects)), duration)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/prae_dodge/proc/remove_effects()
	var/mob/living/carbon/xenomorph/dodge_remove = owner

	if (!istype(dodge_remove))
		return

	var/datum/behavior_delegate/praetorian_dancer/behavior = dodge_remove.behavior_delegate
	if (!istype(behavior))
		return

	if (behavior.dodge_activated)
		behavior.dodge_activated = FALSE
		button.icon_state = "template"
		dodge_remove.speed_modifier += speed_buff_amount
		dodge_remove.remove_temp_pass_flags(PASS_MOB_THRU)
		dodge_remove.recalculate_speed()
		to_chat(dodge_remove, SPAN_XENOHIGHDANGER("We can no longer dodge through mobs!"))

/datum/action/xeno_action/activable/prae_tail_trip/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/dancer_user = owner

	if (!action_cooldown_check())
		return

	if (!istype(dancer_user) || !dancer_user.check_state())
		return

	if (!isxeno_human(target_atom) || dancer_user.can_not_harm(target_atom))
		to_chat(dancer_user, SPAN_XENODANGER("We must target a hostile!"))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if (target_carbon.stat == DEAD)
		to_chat(dancer_user, SPAN_XENOWARNING("[target_atom] is dead, why would we want to attack it?"))
		return

	if (!check_and_use_plasma_owner())
		return


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
			to_chat(dancer_user, SPAN_WARNING("We can't attack through [targetTurf]!"))
			return
		else
			for (var/atom/atom_in_turf in targetTurf)
				if (atom_in_turf.density && !atom_in_turf.throwpass && !istype(atom_in_turf, /obj/structure/barricade) && !istype(atom_in_turf, /mob/living))
					to_chat(dancer_user, SPAN_WARNING("We can't attack through [atom_in_turf]!"))
					return



	// Hmm today I will kill a marine while looking away from them
	dancer_user.face_atom(target_carbon)
	dancer_user.flick_attack_overlay(target_carbon, "disarm")

	var/buffed = FALSE

	var/datum/effects/dancer_tag/dancer_tag_effect = locate() in target_carbon.effects_list

	if (dancer_tag_effect)
		buffed = TRUE
		qdel(dancer_tag_effect)

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
			dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] smashes [Xeno] with it's tail!"), SPAN_XENODANGER("We smash [Xeno] with your tail!"))
			to_chat(Xeno, SPAN_XENOHIGHDANGER("You feel dizzy as [dancer_user] smashes you with their tail!"))
			dancer_user.animation_attack_on(Xeno)

	if(!xeno_smashed)
		if (stun_duration > 0)
			target_carbon.apply_effect(stun_duration, WEAKEN)
		dancer_user.visible_message(SPAN_XENODANGER("[dancer_user] trips [target_atom] with it's tail!"), SPAN_XENODANGER("We trip [target_atom] with our tail!"))
		dancer_user.spin_circle()
		dancer_user.emote("tail")
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You are swept off your feet by [dancer_user]!"))
	if (daze_duration > 0)
		target_carbon.apply_effect(daze_duration, DAZE)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/prae_acid_ball/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/acidball_user = owner
	if (!acidball_user.check_state() || acidball_user.action_busy)
		return

	if (!action_cooldown_check())
		return
	if (!check_and_use_plasma_owner())
		return

	var/turf/current_turf = get_turf(acidball_user)

	if (!current_turf)
		return

	if (!do_after(acidball_user, activation_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
		to_chat(acidball_user, SPAN_XENODANGER("We cancel our acid ball."))
		return


	apply_cooldown()

	to_chat(acidball_user, SPAN_XENOWARNING("We lob a compressed ball of acid into the air!"))

	var/obj/item/explosive/grenade/xeno_acid_grenade/grenade = new /obj/item/explosive/grenade/xeno_acid_grenade
	grenade.cause_data = create_cause_data(initial(acidball_user.caste_type), acidball_user)
	grenade.forceMove(get_turf(acidball_user))
	grenade.throw_atom(A, 5, SPEED_SLOW, acidball_user, TRUE)
	addtimer(CALLBACK(grenade, TYPE_PROC_REF(/obj/item/explosive, prime)), prime_delay)

	return ..()

/datum/action/xeno_action/activable/valkyrie_rage/use_ability(atom/target)
	var/mob/living/carbon/xenomorph/raging_valkyrie = owner
	var/mob/living/carbon/xenomorph/buffing_target = target
	var/datum/behavior_delegate/praetorian_valkyrie/behavior = raging_valkyrie.behavior_delegate


	if (!raging_valkyrie.check_state() || raging_valkyrie.action_busy)
		return

	if (buffing_target.is_dead())
		to_chat(raging_valkyrie, SPAN_XENOWARNING("No amount of anger can bring our sister back."))
		return

	if (istype(buffing_target.strain, /datum/xeno_strain/valkyrie))
		to_chat(raging_valkyrie, SPAN_XENOWARNING("We can't order another valkyrie with our rage."))
		return

	if (!action_cooldown_check())
		return

	if (!isxeno_human(target))
		return

	if (!behavior.use_internal_fury_ability(rage_cost))
		return

	focus_rage = WEAKREF(buffing_target)
	armor_buffs_active = TRUE
	armor_buffs_active_target = TRUE
	behavior.raging = TRUE

	playsound(get_turf(raging_valkyrie), "alien_roar", 40)
	to_chat(raging_valkyrie, SPAN_XENOHIGHDANGER("Our rage drives us forward, our healing and armor is increased."))
	raging_valkyrie.create_custom_empower(icolor = "#a31010", ialpha = 200, small_xeno = TRUE)
	raging_valkyrie.add_filter("raging", 1, list("type" = "outline", "color" = "#a31010", "size" = 1))
	raging_valkyrie.balloon_alert(raging_valkyrie, "we feel an overwhelming rage", text_color = "#93ec78")
	raging_valkyrie.armor_modifier += armor_buff
	raging_valkyrie.recalculate_armor()

	if(isxeno(buffing_target))
		playsound(get_turf(buffing_target), "alien_roar", 40)
		buffing_target.create_custom_empower(icolor = "#a31010", ialpha = 200, small_xeno = TRUE)
		buffing_target.add_filter("raging", 1, list("type" = "outline", "color" = "#a31010", "size" = 1))
		buffing_target.armor_modifier += target_armor_buff
		buffing_target.recalculate_armor()

	addtimer(CALLBACK(src, PROC_REF(remove_rage)), armor_buffs_duration)
	addtimer(CALLBACK(src, PROC_REF(remove_target_rage)), armor_buffs_targer_dur)

	apply_cooldown()
	return ..()


/datum/action/xeno_action/activable/valkyrie_rage/proc/remove_rage()
	var/mob/living/carbon/xenomorph/raging_valkyrie = owner
	var/datum/behavior_delegate/praetorian_valkyrie/behavior = raging_valkyrie.behavior_delegate
	raging_valkyrie.remove_filter("raging")
	raging_valkyrie.armor_modifier -= armor_buff
	armor_buffs_active = FALSE
	behavior.raging = FALSE
	raging_valkyrie.recalculate_armor()
	to_chat(raging_valkyrie, SPAN_XENOHIGHDANGER("We feel ourselves calm down."))




/datum/action/xeno_action/activable/valkyrie_rage/proc/remove_target_rage()
	var/mob/living/carbon/xenomorph/target_xeno = focus_rage.resolve()
	if(target_xeno) //if the target was qdeleted it would be null so you need to check for it
		var/datum/behavior_delegate/praetorian_valkyrie/behavior = target_xeno.behavior_delegate
		target_xeno.armor_modifier -= target_armor_buff
		target_xeno.remove_filter("raging")
		armor_buffs_active_target = FALSE
		behavior.raging = FALSE
		target_xeno.recalculate_armor()
		to_chat(target_xeno, SPAN_XENOHIGHDANGER("We feel ourselves calm down."))




/datum/action/xeno_action/activable/high_gallop/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/valkyrie = owner
	var/mob/living/carbon/target_carbon = affected_atom //for marine

	if(!action_cooldown_check())
		return

	if (target_carbon.stat == DEAD)
		to_chat(valkyrie, SPAN_XENODANGER("[target_carbon] is dead, why would we want to touch it?"))
		return

	if (affected_atom == valkyrie)
		to_chat(valkyrie, SPAN_XENOWARNING("We must target an ally or a hostile."))
		return

	var/mob/living/carbon/xenomorph/target_ally = affected_atom

	if (isxeno(target_ally))
		valkyrie.throw_atom(get_step_towards(affected_atom, valkyrie), gallop_jumprange, SPEED_FAST, valkyrie)
		apply_cooldown()
		to_chat(valkyrie, SPAN_WARNING("We dash to the aid of an ally."))
		for(var/mob/living/carbon/human in orange(3, valkyrie))

			if(!isxeno_human(human) || valkyrie.can_not_harm(human))
				continue

			if (human.stat == DEAD)
				continue

			if(!check_clear_path_to_target(valkyrie, human))
				continue
			shake_camera(human, 2, 3)
			playsound(valkyrie, 'sound/effects/alien_footstep_charge3.ogg', 75, 0)
			human.apply_effect(get_xeno_stun_duration(human, 1), WEAKEN)
	else
		valkyrie.throw_atom(get_step_towards(affected_atom, valkyrie), gallop_jumprange, SPEED_FAST, valkyrie)
		ADD_TRAIT(target_carbon, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("High Gallop"))
		ADD_TRAIT(valkyrie, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("High Gallop"))
		valkyrie.anchored = TRUE
		if(do_after(valkyrie, gallop_actv_delay, INTERRUPT_ALL | BEHAVIOR_IMMOBILE, BUSY_ICON_HOSTILE))
			valkyrie.visible_message(SPAN_XENOHIGHDANGER("[valkyrie] rips open the guts of [target_carbon]!"), SPAN_XENOHIGHDANGER("We rapidly slice into [target_carbon]!"))
			target_carbon.spawn_gibs()
			playsound(get_turf(target_carbon), 'sound/effects/gibbed.ogg', 50, 1)
			playsound(get_turf(valkyrie), "alien_roar", 40)
			target_carbon.apply_effect(get_xeno_stun_duration(target_carbon, 0.5), WEAKEN)
			target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, gallop_damage), ARMOR_MELEE, BRUTE, "chest", 20)

			valkyrie.animation_attack_on(target_carbon)
			valkyrie.flick_attack_overlay(target_carbon, "tail")

		REMOVE_TRAIT(valkyrie, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("High Gallop"))
		valkyrie.anchored = FALSE
		unroot_human(target_carbon, TRAIT_SOURCE_ABILITY("High Gallop"))
		valkyrie.face_atom(target_carbon)
		valkyrie.animation_attack_on(target_carbon, 10) // i wish we had a way of making multiple slashes appear on the same person.



	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/fight_or_flight/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/valkyrie_flight = owner

	var/datum/behavior_delegate/praetorian_valkyrie/behavior = valkyrie_flight.behavior_delegate
	var/image/effect_overlay = get_busy_icon(ACTION_PURPLE_POWER_UP)


	if (!valkyrie_flight.check_state())
		return

	if (!action_cooldown_check())
		return

	if (!behavior.use_internal_fury_ability(rejuvenate_cost))
		return

	if (behavior.base_fury < 100)
		playsound(valkyrie_flight, 'sound/voice/xenos_roaring.ogg', 125)
		for(var/mob/living/carbon/xenomorph/allied_xenomorphs in range(low_rage_range, valkyrie_flight))
			to_chat(allied_xenomorphs, SPAN_XENOWARNING("Every single inch in our body moves on its own to fight."))
			valkyrie_flight.create_shriekwave(3)
			allied_xenomorphs.xeno_jitter(1 SECONDS,)
			allied_xenomorphs.flick_heal_overlay(3 SECONDS, "#F5007A")
			effect_overlay.flick_overlay(allied_xenomorphs, 20)
	else
		playsound(valkyrie_flight, 'sound/voice/xenos_roaring.ogg', 125)
		for(var/mob/living/carbon/xenomorph/allied_xenomorphs in range(high_rage_range, valkyrie_flight))

			to_chat(allied_xenomorphs, SPAN_XENOWARNING("Every single inch in our body moves on its own to fight."))
			valkyrie_flight.create_shriekwave(3)
			allied_xenomorphs.xeno_jitter(1 SECONDS)
			allied_xenomorphs.flick_heal_overlay(3 SECONDS, "#F5007A")
			effect_overlay.flick_overlay(allied_xenomorphs, 20)

	apply_cooldown()
	return ..()


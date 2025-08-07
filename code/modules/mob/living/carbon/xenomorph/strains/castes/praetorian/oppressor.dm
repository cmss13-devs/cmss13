/datum/xeno_strain/oppressor
	// Dread it, run from it, destiny still arrives... or should I say, I do
	name = PRAETORIAN_OPPRESSOR
	description = "You abandon all of your acid-based abilities, your dash, some speed, and a bit of your slash damage for some resistance against small explosives, slashes that deal extra damage to prone targets, and a powerful hook ability that pulls up to three enemies towards you, slows them, and has varying effects depending on how many enemies you pull. You also gain a powerful punch that reduces your other abilities' cooldowns, pierces through armor, and does double damage in addition to rooting slowed targets. You can also knock enemies back and slow them with your new Tail Lash and quickly grab a tall, slow it, and pull it towards you with your unique Tail Stab."
	flavor_description = "My reach is endless, this one will pull down the heavens."
	icon_state_prefix = "Oppressor"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/xeno_spit/praetorian,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/tail_stab/tail_seize,
		/datum/action/xeno_action/activable/prae_abduct,
		/datum/action/xeno_action/activable/oppressor_punch,
		/datum/action/xeno_action/activable/tail_lash,
	)

	behavior_delegate_type = /datum/behavior_delegate/oppressor_praetorian

/datum/xeno_strain/oppressor/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.damage_modifier -= XENO_DAMAGE_MOD_SMALL
	prae.explosivearmor_modifier += XENO_EXPOSIVEARMOR_MOD_SMALL
	prae.small_explosives_stun = FALSE
	prae.speed_modifier += XENO_SPEED_SLOWMOD_TIER_5
	prae.plasma_types = list(PLASMA_NEUROTOXIN, PLASMA_CHITIN)
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/oppressor_praetorian
	name = "Oppressor Praetorian Behavior Delegate"
	var/tearing_damage = 15

/datum/behavior_delegate/oppressor_praetorian/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(target_carbon.stat == DEAD)
		return

	// impaired in some capacity
	if(!(target_carbon.mobility_flags & MOBILITY_STAND) || !(target_carbon.mobility_flags & MOBILITY_MOVE) || target_carbon.slowed)
		target_carbon.apply_armoured_damage(get_xeno_damage_slash(target_carbon, tearing_damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected ? bound_xeno.zone_selected : "chest")
		target_carbon.visible_message(SPAN_DANGER("[bound_xeno] tears into [target_carbon]!"))
		playsound(bound_xeno, 'sound/weapons/alien_tail_attack.ogg', 25, TRUE)


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

	var/throw_target_turf = get_step(abduct_user, facing)

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
			new /datum/effects/xeno_slow(target, abduct_user, null, null, 2.5 SECONDS)
			target.apply_effect(1, SLOW)
		else if (LAZYLEN(targets) == 2)
			ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ABILITY("Abduct"))
			if (ishuman(target))
				var/mob/living/carbon/human/target_human = target
				target_human.update_xeno_hostile_hud()
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(unroot_human), target, TRAIT_SOURCE_ABILITY("Abduct")), get_xeno_stun_duration(target, 2.5 SECONDS))
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

	if(target_carbon.stat == DEAD)
		return

	var/obj/limb/target_limb = target_carbon.get_limb(check_zone(oppressor_user.zone_selected))

	if (ishuman(target_carbon) && (!target_limb || (target_limb.status & LIMB_DESTROYED)))
		target_limb = target_carbon.get_limb("chest")

	if (!check_and_use_plasma_owner())
		return

	target_carbon.last_damage_data = create_cause_data(oppressor_user.caste_type, oppressor_user)

	oppressor_user.visible_message(SPAN_XENOWARNING("\The [oppressor_user] hits [target_carbon] in the [target_limb? target_limb.display_name : "chest"] with a devastatingly powerful punch!"),
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
			var/mob/living/carbon/human/human_to_update = target_carbon
			human_to_update.update_xeno_hostile_hud()

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

/datum/action/xeno_action/activable/tail_lash/use_ability(atom/atoms)
	var/mob/living/carbon/xenomorph/lash_user = owner

	if (!istype(lash_user) || !lash_user.check_state() || !action_cooldown_check())
		return

	if(!atoms || atoms.layer >= FLY_LAYER || !isturf(lash_user.loc))
		return

	if (!check_plasma_owner())
		return

	// Transient turf list
	var/list/target_turfs = list()
	var/list/temp_turfs = list()
	var/list/telegraph_atom_list = list()

	// Code to get a 2x3 area of turfs
	var/turf/root = get_turf(lash_user)
	var/facing = Get_Compass_Dir(lash_user, atoms)
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

	for(var/turf/turfs_to_check in temp_turfs)
		if (!istype(turfs_to_check))
			continue

		if (turfs_to_check.density)
			continue

		target_turfs += turfs_to_check
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/lash(turfs_to_check, windup)

		var/turf/next_turf = get_step(turfs_to_check, facing)
		if (!istype(next_turf) || next_turf.density)
			continue

		target_turfs += next_turf
		telegraph_atom_list += new /obj/effect/xenomorph/xeno_telegraph/lash(next_turf, windup)

	if(!length(target_turfs))
		to_chat(lash_user, SPAN_XENOWARNING("We don't have any room to do our tail lash!"))
		return

	if(!do_after(lash_user, windup, INTERRUPT_NO_NEEDHAND, BUSY_ICON_HOSTILE))
		to_chat(lash_user, SPAN_XENOWARNING("We cancel our tail lash."))

		for(var/obj/effect/xenomorph/xeno_telegraph/tail_telegraph in telegraph_atom_list)
			telegraph_atom_list -= tail_telegraph
			qdel(tail_telegraph)
		return

	if(!action_cooldown_check() || !check_and_use_plasma_owner())
		return

	apply_cooldown()

	lash_user.visible_message(SPAN_XENODANGER("[lash_user] lashes its tail furiously, hitting everything in front of it!"), SPAN_XENODANGER("We lash our tail furiously, hitting everything in front of us!"))
	lash_user.spin_circle()
	lash_user.emote("tail")

	for (var/turf/targets_in_turf in target_turfs)
		for (var/mob/living/carbon/possible_targets in targets_in_turf)
			if (possible_targets.stat == DEAD)
				continue

			if(!isxeno_human(possible_targets) || lash_user.can_not_harm(possible_targets))
				continue

			if(possible_targets.mob_size >= MOB_SIZE_BIG)
				continue

			lash_user.throw_carbon(possible_targets, facing, fling_dist)

			possible_targets.apply_effect(get_xeno_stun_duration(possible_targets, 0.5), WEAKEN)
			new /datum/effects/xeno_slow(possible_targets, lash_user, ttl = get_xeno_stun_duration(possible_targets, 2.5 SECONDS))

	return ..()

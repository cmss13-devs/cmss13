/datum/xeno_strain/vanguard
	name = PRAETORIAN_VANGUARD
	description = "You forfeit all of your acid-based abilities and some health for some extra speed and a rechargable shield that can block one attack. Use your Pierce from up to three paces away to stab through talls, while stabbing through two or more will completely recharge your shield. Use your charge to plow through enemies and use it again to unleash a powerful AoE slash that reaches up to three paces. You also have a Cleave ability, amplified by your shield, which you can toggle to either immobilize or fling a target away."
	flavor_description = "Fearless you are born, fearless you serve, fearless you die. This one will become my Vanguard"
	icon_state_prefix = "Vanguard"

	actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/activable/pounce/base_prae_dash,
		/datum/action/xeno_action/activable/prae_acid_ball,
		/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid,
		/datum/action/xeno_action/activable/corrosive_acid,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/pierce,
		/datum/action/xeno_action/activable/pounce/prae_dash,
		/datum/action/xeno_action/activable/cleave,
		/datum/action/xeno_action/onclick/toggle_cleave,
	)

	behavior_delegate_type = /datum/behavior_delegate/praetorian_vanguard

/datum/xeno_strain/vanguard/apply_strain(mob/living/carbon/xenomorph/praetorian/prae)
	prae.speed_modifier += XENO_SPEED_FASTMOD_TIER_3
	prae.health_modifier -= XENO_HEALTH_MOD_MED
	prae.claw_type = CLAW_TYPE_SHARP

	prae.recalculate_everything()

/datum/behavior_delegate/praetorian_vanguard
	name = "Praetorian Vanguard Behavior Delegate"

	// Config
	var/shield_recharge_time = 20 SECONDS  // 20 seconds to recharge 1-hit shield
	var/pierce_spin_time = 1 SECONDS   // 1 second to use pierce
	var/shield_decay_cleave_time = 1.5 SECONDS   // How long you have to buffed cleave after the shield fully decays

	// State
	var/last_combat_time = 0
	var/last_shield_regen_time = 0

/datum/behavior_delegate/praetorian_vanguard/on_life()
	if (last_shield_regen_time <= last_combat_time &&  last_combat_time + shield_recharge_time <= world.time)
		regen_shield()


/datum/behavior_delegate/praetorian_vanguard/on_hitby_projectile(ammo)
	last_combat_time = world.time
	return

/datum/behavior_delegate/praetorian_vanguard/melee_attack_additional_effects_self()
	..()

	last_combat_time = world.time

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_spin()
	var/datum/action/xeno_action/activable/pierce/pAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = TRUE

	addtimer(CALLBACK(src, PROC_REF(next_pierce_normal)), pierce_spin_time)
	return

/datum/behavior_delegate/praetorian_vanguard/proc/next_pierce_normal()
	var/datum/action/xeno_action/activable/pierce/pAction = get_action(bound_xeno, /datum/action/xeno_action/activable/pierce)
	if (istype(pAction))
		pAction.should_spin_instead = FALSE
	return

/datum/behavior_delegate/praetorian_vanguard/proc/regen_shield()
	var/mob/living/carbon/xenomorph/praetorian = bound_xeno
	var/datum/xeno_shield/vanguard/found_shield = null
	last_shield_regen_time = world.time
	for (var/datum/xeno_shield/vanguard/vanguard_shield in praetorian.xeno_shields)
		if (vanguard_shield.shield_source == XENO_SHIELD_SOURCE_VANGUARD_PRAE)
			found_shield = vanguard_shield
			break

	if (found_shield)
		qdel(found_shield)

		praetorian.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)

	else
		var/datum/xeno_shield/vanguard/new_shield = praetorian.add_xeno_shield(800, XENO_SHIELD_SOURCE_VANGUARD_PRAE, /datum/xeno_shield/vanguard)
		bound_xeno.explosivearmor_modifier += 1.5*XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
		bound_xeno.recalculate_armor()
		new_shield.explosive_armor_amount = 1.5*XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
		to_chat(praetorian, SPAN_XENOHIGHDANGER("We feel our defensive shell regenerate! It will block one hit!"))

	var/datum/action/xeno_action/activable/cleave/caction = get_action(bound_xeno, /datum/action/xeno_action/activable/cleave)
	if (istype(caction))
		caction.buffed = TRUE


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

		if (HAS_TRAIT(current_mob, TRAIT_NESTED))
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
	var/list/list_of_targets = orange(1, dash_user)
	for (var/mob/living/carbon/targets_in_range in list_of_targets)
		if (!isxeno_human(targets_in_range) || dash_user.can_not_harm(targets_in_range))
			continue

		if (!(targets_in_range in target_mobs))
			target_mobs += targets_in_range

		if (targets_in_range.stat)
			continue
		if (HAS_TRAIT(targets_in_range, TRAIT_NESTED))
			continue

		if (!isxeno_human(targets_in_range) || dash_user.can_not_harm(targets_in_range))
			continue

		dash_user.flick_attack_overlay(targets_in_range, "slash")
		targets_in_range.apply_armoured_damage(get_xeno_damage_slash(targets_in_range, damage), ARMOR_MELEE, BRUTE)
		playsound(get_turf(targets_in_range), "alien_claw_flesh", 30, 1)
	dash_user.visible_message(SPAN_XENODANGER("[dash_user] slashes its claws through the area around it!"), SPAN_XENODANGER("We slash our claws through the area around us!"))
	dash_user.spin_circle()


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


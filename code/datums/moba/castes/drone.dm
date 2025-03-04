/datum/moba_caste/drone
	equivalent_caste_path = /datum/caste_datum/drone
	equivalent_xeno_path = /mob/living/carbon/xenomorph/drone
	name = XENO_CASTE_DRONE
	category = MOBA_ARCHETYPE_CONTROLLER
	icon_state = "drone"
	ideal_roles = list(MOBA_LANE_SUPPORT)
	starting_health = 500
	ending_health = 2000
	starting_health_regen = 1.5
	ending_health_regen = 6
	starting_plasma = 400
	ending_plasma = 800
	starting_plasma_regen = 1.2
	ending_plasma_regen = 3.6
	starting_armor = 0
	ending_armor = 15
	starting_acid_armor = 0
	ending_acid_armor = 10
	speed = 1
	attack_delay_modifier = 0
	starting_attack_damage = 37.5
	ending_attack_damage = 60
	abilities_to_add = list(
		/datum/action/xeno_action/activable/moba/tail_stab,
	)

/datum/action/xeno_action/activable/moba/tail_stab
	name = "Tail Stab"
	desc = "Ready your tail over 1.5 / 1 / 0.7 seconds to stab an enemy. This stab reaches two tiles and does 1.2x / 1.4x / 1.6x your attack damage while dazing the target for 0.2 / 0.3 / 0.4 seconds."
	action_icon_state = "tail_attack"
	action_type = XENO_ACTION_CLICK
	charge_time = 1.5 SECONDS
	xeno_cooldown = 14 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1
	var/stab_range = 2
	var/damage_multiplier = 1.2
	var/daze_length = 0.2 SECONDS

/datum/action/xeno_action/activable/moba/tail_stab/use_ability(atom/targetted_atom)
	var/mob/living/carbon/xenomorph/stabbing_xeno = owner

	if(HAS_TRAIT(stabbing_xeno, TRAIT_ABILITY_BURROWED) || stabbing_xeno.is_ventcrawling)
		to_chat(stabbing_xeno, SPAN_XENOWARNING("We must be above ground to do this."))
		return

	if(!stabbing_xeno.check_state() || stabbing_xeno.cannot_slash)
		return FALSE

	if(!action_cooldown_check())
		return FALSE

	if (world.time <= stabbing_xeno.next_move)
		return FALSE

	var/distance = get_dist(stabbing_xeno, targetted_atom)
	if(distance > stab_range)
		return FALSE

	var/list/turf/path = get_line(stabbing_xeno, targetted_atom, include_start_atom = FALSE)
	for(var/turf/path_turf as anything in path)
		if(path_turf.density)
			to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			return FALSE
		for(var/obj/path_contents in path_turf.contents)
			if(path_contents != targetted_atom && path_contents.density && !path_contents.throwpass)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
				return FALSE

		var/atom/barrier = path_turf.handle_barriers(stabbing_xeno, null, (PASS_MOB_THRU_XENO|PASS_OVER_THROW_MOB|PASS_TYPE_CRAWLER))
		if(barrier != path_turf)
			var/tail_stab_cooldown_multiplier = barrier.handle_tail_stab(stabbing_xeno)
			if(!tail_stab_cooldown_multiplier)
				to_chat(stabbing_xeno, SPAN_WARNING("There's something blocking our strike!"))
			else
				apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
				xeno_attack_delay(stabbing_xeno)
			return FALSE

	var/tail_stab_cooldown_multiplier = targetted_atom.handle_tail_stab(stabbing_xeno)
	if(tail_stab_cooldown_multiplier)
		stabbing_xeno.animation_attack_on(targetted_atom)
		apply_cooldown(cooldown_modifier = tail_stab_cooldown_multiplier)
		xeno_attack_delay(stabbing_xeno)
		return ..()

	if(!isliving(targetted_atom))
		stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] swipes their tail through the air!"), SPAN_XENOWARNING("We swipe our tail through the air!"))
		apply_cooldown(cooldown_modifier = 0.1)
		xeno_attack_delay(stabbing_xeno)
		playsound(stabbing_xeno, "alien_tail_swipe", 50, TRUE)
		return FALSE

	if(stabbing_xeno.can_not_harm(targetted_atom))
		return FALSE

	var/mob/living/target = targetted_atom

	if(target.stat == DEAD)
		return FALSE

	if(!check_and_use_plasma_owner())
		return FALSE

	var/result = ability_act(stabbing_xeno, target)

	apply_cooldown()
	xeno_attack_delay(stabbing_xeno)
	..()
	return result

/datum/action/xeno_action/activable/moba/tail_stab/proc/ability_act(mob/living/carbon/xenomorph/stabbing_xeno, mob/living/carbon/target)

	target.last_damage_data = create_cause_data(initial(stabbing_xeno.caste_type), stabbing_xeno)

	/// To reset the direction if they haven't moved since then in below callback.
	var/last_dir = stabbing_xeno.dir
	/// Direction var to make the tail stab look cool and immersive.
	var/stab_direction

	var/stab_overlay

	stabbing_xeno.visible_message(SPAN_XENOWARNING("\The [stabbing_xeno] skewers [target] with its razor sharp tail!"), SPAN_XENOWARNING("We skewer [target] with our razor sharp tail!"))
	playsound(target, "alien_bite", 50, TRUE)
	// The xeno flips around for a second to impale the target with their tail. These look awsome.
	stab_direction = turn(get_dir(stabbing_xeno, target), 180)
	stab_overlay = "tail"

	if(last_dir != stab_direction)
		stabbing_xeno.setDir(stab_direction)
		stabbing_xeno.emote("tail")
		/// Ditto.
		var/new_dir = stabbing_xeno.dir
		addtimer(CALLBACK(src, PROC_REF(reset_direction), stabbing_xeno, last_dir, new_dir), 0.5 SECONDS)

	stabbing_xeno.animation_attack_on(target)
	stabbing_xeno.flick_attack_overlay(target, stab_overlay)

	var/damage = (stabbing_xeno.melee_damage_upper + stabbing_xeno.frenzy_aura * FRENZY_DAMAGE_MULTIPLIER) * damage_multiplier

	if(stabbing_xeno.behavior_delegate)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_target(target)
		stabbing_xeno.behavior_delegate.melee_attack_additional_effects_self()
		damage = stabbing_xeno.behavior_delegate.melee_attack_modify_damage(damage, target)

	target.apply_armoured_damage(get_xeno_damage_slash(target, damage), ARMOR_MELEE, BRUTE, "chest")
	target.apply_effect(daze_length, DAZE)
	shake_camera(target, 2, 1)

	target.handle_blood_splatter(get_dir(owner.loc, target.loc))
	return target

/datum/action/xeno_action/activable/moba/tail_stab/proc/reset_direction(mob/living/carbon/xenomorph/stabbing_xeno, last_dir, new_dir)
	// If the xenomorph is still holding the same direction as the tail stab animation's changed it to, reset it back to the old direction so the xenomorph isn't stuck facing backwards.
	if(new_dir == stabbing_xeno.dir)
		stabbing_xeno.setDir(last_dir)

/datum/action/xeno_action/activable/moba/tail_stab/level_up_ability(new_level)
	if(new_level == 2)
		charge_time = 1 SECONDS
	else if(new_level == 3)
		charge_time = 0.7 SECONDS
	xeno_cooldown = src::xeno_cooldown - ((3 SECONDS) * (new_level - 1))
	damage_multiplier = src::damage_multiplier + (0.2 * (new_level - 1))
	daze_length = src::daze_length + (0.1 * (new_level - 1))

	desc = "Ready your tail over [new_level == 1 ? "<b>1.5</b>" : "1.5"] / [new_level == 2 ? "<b>1</b>" : "1"] / [new_level == 3 ? "<b>0.7</b>" : "0.7"] seconds to stab an enemy. This stab reaches two tiles and does [new_level == 1 ? "<b>1.2x</b>" : "1.2x"] / [new_level == 2 ? "<b>1.4x</b>" : "1.4x"] / [new_level == 3 ? "<b>1.6x</b>" : "1.6x"] your attack damage while dazing the target for [new_level == 1 ? "<b>0.2</b>" : "0.2"] / [new_level == 2 ? "<b>0.3</b>" : "0.3"] / [new_level == 3 ? "<b>0.4</b>" : "0.4"] seconds."

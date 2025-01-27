/datum/action/xeno_action/activable/warrior_punch/proc/do_boxer_punch(mob/living/carbon/carbon, obj/limb/target_limb)
	var/mob/living/carbon/xenomorph/warrior = owner
	var/damage = rand(base_damage, base_damage + damage_variance)
	if(ishuman(carbon))
		if(isyautja(carbon))
			damage = rand(base_punch_damage_pred, base_punch_damage_pred + damage_variance)
		else if(target_limb.status & (LIMB_ROBOT|LIMB_SYNTHSKIN))
			damage = rand(base_punch_damage_synth, base_punch_damage_synth + damage_variance)

	carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, damage), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")
	step_away(carbon, warrior)
	if(prob(25)) // 25% chance to fly 2 tiles
		step_away(carbon, warrior)

	var/datum/behavior_delegate/boxer/boxer_behaivor = warrior.behavior_delegate
	if(istype(boxer_behaivor))
		boxer_behaivor.melee_attack_additional_effects_target(carbon, 1)

	var/datum/action/xeno_action/activable/jab/ability_jab = get_action(warrior, /datum/action/xeno_action/activable/jab)
	if(istype(ability_jab) && !ability_jab.action_cooldown_check())
		if(isxeno(carbon))
			ability_jab.reduce_cooldown(ability_jab.xeno_cooldown / 2)
		else
			ability_jab.end_cooldown()

/datum/action/xeno_action/activable/jab/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/warrior = owner
	if(!isxeno_human(affected_atom) || warrior.can_not_harm(affected_atom))
		return

	if(!action_cooldown_check())
		return

	if(!warrior.check_state())
		return

	var/distance = get_dist(warrior, affected_atom)
	if(distance > 3)
		return

	var/mob/living/carbon/carbon = affected_atom
	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	if(!check_and_use_plasma_owner())
		return

	if(distance > 2)
		step_towards(warrior, carbon, 1)

	if(distance > 1)
		step_towards(warrior, carbon, 1)

	if(!warrior.Adjacent(carbon))
		return

	carbon.last_damage_data = create_cause_data(initial(warrior.caste_type), warrior)
	warrior.visible_message(SPAN_XENOWARNING("\The [warrior] hits [carbon] with a powerful jab!"), \
	SPAN_XENOWARNING("You hit [carbon] with a powerful jab!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon,S, 50, 1)
	// Check actions list for a warrior punch and reset it's cooldown if it's there
	var/datum/action/xeno_action/activable/warrior_punch/punch_action = null
	for (var/datum/action/xeno_action/activable/warrior_punch/P in warrior.actions)
		punch_action = P
		break

	if(punch_action && !punch_action.action_cooldown_check())
		if(isxeno(carbon))
			punch_action.reduce_cooldown(punch_action.xeno_cooldown / 2)
		else
			punch_action.end_cooldown()

	carbon.Daze(3)
	carbon.Slow(5)
	var/datum/behavior_delegate/boxer/boxer_behaivor = warrior.behavior_delegate
	if(istype(boxer_behaivor))
		boxer_behaivor.melee_attack_additional_effects_target(carbon, 1)
	apply_cooldown()
	..()

/datum/action/xeno_action/activable/uppercut/use_ability(atom/affected_atom)
	var/mob/living/carbon/xenomorph/warrior = owner
	if(!isxeno_human(affected_atom) || warrior.can_not_harm(affected_atom))
		return

	if(!action_cooldown_check())
		return

	if(!warrior.check_state())
		return

	var/datum/behavior_delegate/boxer/boxer_behaivor = warrior.behavior_delegate
	if(!istype(boxer_behaivor))
		return

	if(!boxer_behaivor.punching_bag)
		return

	if(boxer_behaivor.punching_bag != affected_atom)
		return

	var/mob/living/carbon/carbon = boxer_behaivor.punching_bag
	if(carbon.stat == DEAD)
		return

	if(HAS_TRAIT(carbon, TRAIT_NESTED))
		return

	if(!check_and_use_plasma_owner())
		return

	if(!warrior.Adjacent(carbon))
		return

	if(carbon.mob_size >= MOB_SIZE_BIG)
		to_chat(warrior, SPAN_XENOWARNING("[carbon] is too big for you to uppercut!"))
		return

	var/datum/action/xeno_action/activable/jab/ability_jab = get_action(warrior, /datum/action/xeno_action/activable/jab)
	if(istype(ability_jab))
		ability_jab.apply_cooldown_override(ability_jab.xeno_cooldown)
	var/datum/action/xeno_action/activable/warrior_punch/punch = get_action(warrior, /datum/action/xeno_action/activable/warrior_punch)
	if(istype(punch))
		punch.apply_cooldown_override(punch.xeno_cooldown)

	carbon.last_damage_data = create_cause_data(initial(warrior.caste_type), warrior)
	var/ko_counter = boxer_behaivor.ko_counter
	var/damage = ko_counter >= 1
	var/knockback = ko_counter >= 3
	var/knockdown = ko_counter >= 6
	var/knockout = ko_counter >= 9
	var/message = (!damage) ? "weak" : (!knockback) ? "good" : (!knockdown) ? "powerful" : (!knockout) ? "gigantic" : "titanic"
	warrior.visible_message(SPAN_XENOWARNING("\The [warrior] hits [carbon] with a [message] uppercut!"), \
	SPAN_XENOWARNING("You hit [carbon] with a [message] uppercut!"))
	var/S = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
	playsound(carbon,S, 50, 1)
	if(boxer_behaivor.ko_reset_timer != TIMER_ID_NULL)
		deltimer(boxer_behaivor.ko_reset_timer)

	boxer_behaivor.remove_ko()
	var/obj/limb/target_limb = carbon.get_limb(check_zone(warrior.zone_selected))
	if(damage)
		carbon.apply_armoured_damage(get_xeno_damage_slash(carbon, base_damage * ko_counter), ARMOR_MELEE, BRUTE, target_limb? target_limb.name : "chest")
	if(knockout)
		carbon.KnockOut(knockout_power)
		boxer_behaivor.display_ko_message(carbon)
		playsound(carbon,'sound/effects/dingding.ogg', 75, 1)

	if(knockback)
		carbon.explosion_throw(base_knockback * ko_counter, get_dir(warrior, carbon))
	if(knockdown)
		carbon.KnockDown(base_knockdown * ko_counter)
	var/mob_multiplier = 1
	if(isxeno(carbon))
		mob_multiplier = XVX_WARRIOR_HEALMULT
	if(ko_counter > 0)
		warrior.gain_health(mob_multiplier * ko_counter * base_healthgain * warrior.maxHealth / 100)
	apply_cooldown()
	..()

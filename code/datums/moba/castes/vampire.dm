/datum/moba_caste/vampire
	equivalent_caste_path = /datum/caste_datum/lurker
	equivalent_xeno_path = /mob/living/carbon/xenomorph/lurker/vampire
	name = "Vampire"
	desc = {"
		Aggressive melee combat caste focused on lifesteal and scaling.<br>
		<b>P:</b> Gain permanent stacks of bloodlust from landing your abilities. Every 10 stacks of bloodlust grants lifesteal.<br>
		<b>1:</b> Rush towards a target within 4 tiles.<br>
		<b>2:</b> Slash in a wide area in front of you, healing for each target hit.<br>
		<b>3:</b> Quickly stab a target with your tail, ignoring some armor.<br>
		<b>U:</b> Headbite a low-health target, executing them and healing a large amount of health.
	"}
	category = MOBA_ARCHETYPE_FIGHTER
	icon_state = "vampire"
	ideal_roles = list(MOBA_LANE_TOP, MOBA_LANE_JUNGLE)
	starting_health = 500
	ending_health = 2000
	starting_health_regen = 1.5
	ending_health_regen = 6
	starting_plasma = 400
	ending_plasma = 800
	starting_plasma_regen = 1.2
	ending_plasma_regen = 3.6
	starting_armor = 0
	ending_armor = 20
	starting_acid_armor = 0
	ending_acid_armor = 15
	speed = 0.8
	attack_delay_modifier = 0
	starting_attack_damage = 40
	ending_attack_damage = 65
	abilities_to_add = list(
		/datum/action/xeno_action/activable/pounce/rush/moba,
		/datum/action/xeno_action/activable/flurry/moba,
		/datum/action/xeno_action/activable/tail_jab/moba,
		/datum/action/xeno_action/activable/moba_headbite,
	)

/datum/moba_caste/vampire/apply_caste(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum)
	. = ..()
	xeno.apply_status_effect(/datum/status_effect/stacking/bloodlust)
	xeno.AddComponent(/datum/component/moba_vampire_execute_tracker, player_datum, player_component.map_id, player_component.right_side)

/datum/action/xeno_action/activable/pounce/rush/moba
	desc = "Rush towards a targeted tile or creature. Cooldown 8/7/6 seconds."
	xeno_cooldown = 8 SECONDS
	plasma_cost = 60

/datum/action/xeno_action/activable/pounce/rush/moba/level_up_ability(new_level)
	plasma_cost = src::plasma_cost - ((new_level - 1) * 5)
	xeno_cooldown = src::xeno_cooldown - (new_level - 1)

	desc = "Rush towards a targeted tile or creature. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 8, 7, 6)] seconds."


/datum/action/xeno_action/activable/flurry/moba
	desc = "1x3 attack that damages everyone hit for 30/40/50 (+40% AD) (+Bloodlust) physical damage. You heal for 15/20/25% (+5% AD) of the damage done. Each player hit grants 1 stack of bloodlust (2 against players). Cooldown 4 seconds."
	xeno_cooldown = 3 SECONDS
	var/base_damage = 30
	var/heal_percentage = 0.15

/datum/action/xeno_action/activable/flurry/moba/handle_attack(mob/living/target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/status_effect/stacking/bloodlust_effect = xeno.has_status_effect(/datum/status_effect/stacking/bloodlust)
	var/total_damage = base_damage + (xeno.melee_damage_upper * 0.4) + (bloodlust_effect ? bloodlust_effect.stacks : 0)
	xeno.visible_message(SPAN_DANGER("[xeno] slashes [target]!"),
	SPAN_XENOWARNING("We slash [target] multiple times!"))
	xeno.flick_attack_overlay(target, "slash")
	target.last_damage_data = create_cause_data(xeno.caste_type, xeno)
	log_attack("[key_name(xeno)] attacked [key_name(target)] with Flurry")
	target.apply_armoured_damage(total_damage, ARMOR_MELEE, BRUTE, rand_zone())
	playsound(get_turf(target), 'sound/weapons/alien_claw_flesh4.ogg', 30, TRUE)
	xeno.flick_heal_overlay(1 SECONDS, "#00B800")
	xeno.gain_health(total_damage * (heal_percentage + (xeno.melee_damage_upper * 0.05)))
	xeno.animation_attack_on(target)
	if(!bloodlust_effect)
		bloodlust_effect = xeno.apply_status_effect(/datum/status_effect/stacking/bloodlust)
	if(HAS_TRAIT(target, TRAIT_MOBA_PARTICIPANT))
		bloodlust_effect.add_stacks(2)
	else
		bloodlust_effect.add_stacks(1)
	SEND_SIGNAL(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, target)

/datum/action/xeno_action/activable/flurry/moba/level_up_ability(new_level)
	base_damage = src::base_damage + ((new_level - 1) * 10)
	heal_percentage = src::heal_percentage + ((new_level - 1) * 0.05)

	desc = "1x3 attack that damages everyone hit for [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 30, 40, 50)] (+40% AD) (+Bloodlust) physical damage. You heal for [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "15%", "20%", "25%")] (+5% AD) of the damage done. Each creature hit grants 1 stack of bloodlust (2 against players). Cooldown 4 seconds."

/datum/action/xeno_action/activable/tail_jab/moba
	desc = "Quickly stab your tail at a target within 2 tiles, dealing 1.2/1.3/1.4x (+Bloodlust) your standard attack's damage with +0/5/10 armor penetration in addition to slowing the target for 0.5 seconds and shoving them back a tile. Hitting a creature grants 2 stacks of bloodlust (4 against players). Cooldown 8 seconds."
	xeno_cooldown = 8 SECONDS
	direct_hit_bonus = FALSE
	plasma_cost = 80
	var/damage_mult = 1.2
	var/bonus_pen = 0

/datum/action/xeno_action/activable/tail_jab/moba/apply_damage_effects(mob/living/hit_target)
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/status_effect/stacking/bloodlust_effect = xeno.has_status_effect(/datum/status_effect/stacking/bloodlust)
	hit_target.apply_armoured_damage((xeno.melee_damage_upper * damage_mult) + (bloodlust_effect ? bloodlust_effect.stacks : 0), ARMOR_MELEE, BRUTE, "chest", bonus_pen)
	hit_target.Slow(0.5)
	if(!bloodlust_effect)
		bloodlust_effect = xeno.apply_status_effect(/datum/status_effect/stacking/bloodlust)
	if(HAS_TRAIT(hit_target, TRAIT_MOBA_PARTICIPANT))
		bloodlust_effect.add_stacks(4)
	else
		bloodlust_effect.add_stacks(2)
	SEND_SIGNAL(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, hit_target)

/datum/action/xeno_action/activable/tail_jab/moba/level_up_ability(new_level)
	damage_mult = src::damage_mult + ((new_level - 1) * 0.2)
	bonus_pen = src::bonus_pen + ((new_level - 1) * 5)

	desc = "Quickly stab your tail at a target within 2 tiles, dealing [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, "1.2x", "1.4x", "1.6x")] (+Bloodlust) your standard attack's damage with +[MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 0, 5, 10)] armor penetration in addition to slowing the target for 0.5 seconds and shoving them back a tile. Hitting a creature grants 2 stacks of bloodlust (4 against players). Cooldown 8 seconds."


/datum/action/xeno_action/activable/moba_headbite // not inheriting for this, too much is different
	name = "Headbite"
	action_icon_state = "headbite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	desc = "Deals 150/200/250 (+70% AD) +(Bloodlust x3) true damage to a target. Can only be used if the damage would kill (indicator will be present on target if so). On kill, grants 5 stacks of bloodlust (10 against players) and heals for the damage dealt. Cooldown 120/100/80 seconds."
	xeno_cooldown = 120 SECONDS
	plasma_cost = 120
	var/true_damage_to_deal = 150

/datum/action/xeno_action/activable/moba_headbite/use_ability(atom/target_atom)
	if(!action_cooldown_check())
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/status_effect/stacking/bloodlust_effect = xeno.has_status_effect(/datum/status_effect/stacking/bloodlust)
	var/damage_to_deal = true_damage_to_deal + (xeno.melee_damage_upper * 0.7) + (bloodlust_effect ? bloodlust_effect.stacks * 3 : 0)

	if(!iscarbon(target_atom) || !HAS_TRAIT(target_atom, TRAIT_MOBA_PARTICIPANT))
		return

	var/mob/living/carbon/target_carbon = target_atom

	if(xeno.can_not_harm(target_carbon))
		return

	if(!xeno.Adjacent(target_carbon) || (xeno.health > damage_to_deal))
		to_chat(xeno, SPAN_XENOHIGHDANGER("We can only headbite an adjacent, low-health target!"))
		return

	if(!xeno.check_state())
		return

	to_chat(xeno, SPAN_XENOHIGHDANGER("We pierce [target_carbon]’s carapace head with our inner jaw!"))
	playsound(target_carbon,'sound/weapons/alien_bite2.ogg', 50, TRUE)
	xeno.visible_message(SPAN_DANGER("[xeno] pierces [target_carbon]’s carapace head with its inner jaw!"))
	xeno.flick_attack_overlay(target_carbon, "headbite")
	xeno.animation_attack_on(target_carbon, pixel_offset = 16)
	target_carbon.apply_damage(damage_to_deal, BRUTE, "chest") // Ignores armor since it's true damage
	target_carbon.death(create_cause_data("headbite execution", xeno), FALSE)
	xeno.gain_health(damage_to_deal)
	xeno.xeno_jitter(1 SECONDS)
	xeno.flick_heal_overlay(3 SECONDS, "#00B800")
	xeno.emote("roar")
	log_attack("[key_name(xeno)] was executed by [key_name(target_carbon)] with a headbite!")

	if(!bloodlust_effect)
		bloodlust_effect = xeno.apply_status_effect(/datum/status_effect/stacking/bloodlust)

	if(HAS_TRAIT(target_carbon, TRAIT_MOBA_PARTICIPANT))
		bloodlust_effect.add_stacks(10)
	else
		bloodlust_effect.add_stacks(5)
	SEND_SIGNAL(xeno, COMSIG_XENO_PHYSICAL_ABILITY_HIT, target_carbon)

	apply_cooldown()
	return ..()

/datum/action/xeno_action/activable/moba_headbite/level_up_ability(new_level)
	true_damage_to_deal = src::true_damage_to_deal + ((new_level - 1) * 50)
	xeno_cooldown = src::xeno_cooldown - ((new_level - 1) * (20 SECONDS))

	desc = "Deals [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 150, 200, 250)] (+70% AD) +(Bloodlust x3) true damage to a target. Can only be used if the damage would kill (indicator will be present on target if so). On kill, grants 5 stacks of bloodlust (10 against players) and heals for the damage dealt. Cooldown [MOBA_LEVEL_ABILITY_DESC_HELPER(new_level, 120, 100, 80)] seconds."

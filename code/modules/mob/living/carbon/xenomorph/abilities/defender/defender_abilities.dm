/datum/action/xeno_action/onclick/toggle_crest
	ability_stats_type = /datum/xeno_ability_stats/onclick_toggle_crest
	ability_description = "Raise or lower your crest to trade mobility for protection."
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_crest
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/armor_buff = 5
	var/speed_debuff = 1

XENO_ABILITY_STATS(onclick_toggle_crest, datum/action/xeno_action/onclick/toggle_crest)
	return list(
		XENO_STAT_NUMBER(armor_buff, "Armor gained"),
	)

/datum/action/xeno_action/activable/headbutt
	ability_description = "With your crest raised, lunge into range and knock the target back. Lowering your crest trades the lunge and damage for extra knockback."
	ability_stats_type = /datum/xeno_ability_stats/headbutt
	name = "Headbutt"
	action_icon_state = "headbutt"
	macro_path = /datum/action/xeno_action/verb/verb_headbutt
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

	var/base_damage = 30
	var/lowered_crest_damage_penalty = 10
	var/knockback_distance = 1
	var/lowered_crest_extra_knockback = 2
	var/usable_while_fortified = FALSE
	cooldown_message = "Our head and neck are primed for another headbutt."

XENO_ABILITY_STATS(headbutt, datum/action/xeno_action/activable/headbutt)
	return list(
		XENO_STAT_BRUTE(base_damage, "Raised crest brute damage"),
		XENO_STAT_VALUE("Lowered crest brute damage", XENO_ABILITY_VALUE(ability, base_damage) - XENO_ABILITY_VALUE(ability, lowered_crest_damage_penalty), "brute", "."),
		XENO_STAT_VALUE("Raised crest knockback", XENO_ABILITY_VALUE(ability, knockback_distance), "crowd_control", " tiles."),
		XENO_STAT_VALUE("Lowered crest knockback", XENO_ABILITY_VALUE(ability, knockback_distance) + XENO_ABILITY_VALUE(ability, lowered_crest_extra_knockback), "crowd_control", " tiles."),
	)

/datum/action/xeno_action/activable/headbutt/steel_crest
	ability_stats_type = /datum/xeno_ability_stats/steel_crest_headbutt
	ability_description = "Deliver a stronger headbutt with extra knockback, even while fortified."
	base_damage = 37.5
	usable_while_fortified = TRUE

XENO_ABILITY_STATS(steel_crest_headbutt, datum/action/xeno_action/activable/headbutt/steel_crest)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage with crest raised"),
	)

/datum/action/xeno_action/onclick/tail_sweep
	ability_stats_type = /datum/xeno_ability_stats/tail_sweep
	var/sweep_range = 1
	var/base_damage = 15
	var/knockdown_duration = 1
	ability_description = "Sweep your tail to knock down nearby enemies. Raise your crest and leave Fortify before sweeping."
	name = "Tail Sweep"
	action_icon_state = "tail_sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_sweep
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 10
	xeno_cooldown = 11 SECONDS
	cooldown_message = "Our tail is no longer tired. We can now sweep or slam it again."

XENO_ABILITY_STATS(tail_sweep, datum/action/xeno_action/onclick/tail_sweep)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_CONTROL_LEGACY(knockdown_duration, "Knockdown"),
	)

/datum/action/xeno_action/activable/fortify
	ability_stats_type = /datum/xeno_ability_stats/activable_fortify
	ability_description = "Brace in place to resist incoming damage."
	name = "Fortify"
	action_icon_state = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_fortify
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 5 SECONDS

	/// Extra armor when fortified and facing bullets.
	var/frontal_armor = 5
	cooldown_message = "We have regained enough stamina to curl up and take damage for our sisters."

XENO_ABILITY_STATS(activable_fortify, datum/action/xeno_action/activable/fortify)
	return list(
		XENO_STAT_NUMBER(frontal_armor, "Frontal armor gained"),
	)

/datum/action/xeno_action/activable/fortify/steel_crest
	ability_description = "Brace for increased protection while retaining the ability to move slowly and headbutt."
	frontal_armor = 15

/datum/action/xeno_action/activable/tail_stab/slam
	ability_description = "Smash a nearby target with a blunt tail strike."
	name = "Tail Slam"
	action_icon_state = "tail_slam"
	blunt_stab = TRUE

/datum/action/xeno_action/onclick/soak
	ability_stats_type = /datum/xeno_ability_stats/onclick_soak
	ability_description = "Absorb incoming damage to recover health and refresh Tail Slam."
	name = "Soak"
	action_icon_state = "soak"
	macro_path = /datum/action/xeno_action/verb/verb_soak
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 20
	xeno_cooldown = 17 SECONDS

	/// Requires 140 damage taken within 6 seconds to activate the ability
	var/damage_threshold = 140
	/// Initially zero, gets damage added when the ability is activated
	var/damage_accumulated = 0
	cooldown_message = "Our armor is ready to soak up an extreme amount of damage."

XENO_ABILITY_STATS(onclick_soak, datum/action/xeno_action/onclick/soak)
	return list(
		XENO_STAT_NUMBER(damage_threshold, "Damage needed"),
	)

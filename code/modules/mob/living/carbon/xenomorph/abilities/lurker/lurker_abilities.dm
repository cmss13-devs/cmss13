/datum/action/xeno_action/activable/pounce/lurker
	ability_stats_type = /datum/xeno_ability_stats/activable_pounce_lurker
	ability_description = "Leap at prey. Pouncing from stealth can knock the target down, but momentarily roots you in place. Slash the target to move immediately."
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 6 SECONDS
	plasma_cost = 20

	// Config options
	knockdown = FALSE
	knockdown_duration = 2.5
	freeze_time = 1.5 SECONDS
	can_be_shield_blocked = TRUE

XENO_ABILITY_STATS(activable_pounce_lurker, datum/action/xeno_action/activable/pounce/lurker)
	return list(
		XENO_STAT_CONTROL_LEGACY(knockdown_duration, "Stealth knockdown"),
		XENO_STAT_CONTROL_DURATION(freeze_time, "Self root"),
	)

/datum/action/xeno_action/onclick/lurker_invisibility
	ability_stats_type = /datum/xeno_ability_stats/onclick_lurker_invisibility
	ability_description = "Enter stealth to approach prey unseen and set up an ambush. Slashing ends it early."
	name = "Turn Invisible"
	action_icon_state = "lurker_invisibility"
	macro_path = /datum/action/xeno_action/verb/verb_lurker_invisibility
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	plasma_cost = 20

	var/duration = 30 SECONDS // 30 seconds base
	var/invis_timer_id = TIMER_ID_NULL
	var/alpha_amount = 25
	var/speed_buff = 0.20

XENO_ABILITY_STATS(onclick_lurker_invisibility, datum/action/xeno_action/onclick/lurker_invisibility)
	return list(
		XENO_STAT_DURATION(duration, "Maximum duration"),
	)

// tightly coupled 'buff next slash' action
/datum/action/xeno_action/onclick/lurker_assassinate
	ability_description = "Prime your next slash to deal increased damage and slow the target."
	ability_stats_type = /datum/xeno_ability_stats/lurker_assassinate
	name = "Crippling Strike"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_crippling_strike
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 10 SECONDS
	plasma_cost = 20
	cooldown_message = "We can clearly see the weakpoints of fallen talls again."

	var/buff_duration = 5 SECONDS

XENO_ABILITY_STATS(lurker_assassinate, datum/action/xeno_action/onclick/lurker_assassinate)
	var/duration = /datum/behavior_delegate/lurker_base::slash_slow_duration
	return list(
		XENO_STAT_VALUE("Melee damage multiplier", /datum/behavior_delegate/lurker_base::buffed_slash_damage_ratio, "brute", "x."),
		XENO_STAT_VALUE("Slow", duration * 0.1, "crowd_control", "s."),
	)

// VAMP LURKER ABILITIES

/datum/action/xeno_action/activable/pounce/rush
	ability_stats_type = /datum/xeno_ability_stats/activable_pounce_rush
	ability_description = "Rush into an opponent to disorient them."
	name = "Rush"
	action_icon_state = "pounce"
	action_text = "rush"
	macro_path = /datum/action/xeno_action/verb/verb_rush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 6 SECONDS
	plasma_cost = 0

	// Config options
	distance = 4
	knockdown = FALSE
	freeze_self = FALSE

XENO_ABILITY_STATS(activable_pounce_rush, datum/action/xeno_action/activable/pounce/rush)
	return list(
		XENO_STAT_TILES(distance, "Range"),
		xeno_stat_row("Base brute damage", melee_damage(ability, /datum/caste_datum/lurker, use_caste_upper = TRUE)),
	)

/datum/action/xeno_action/activable/flurry
	ability_stats_type = /datum/xeno_ability_stats/flurry
	var/healing_per_target = 30
	ability_description = "Sweep the area in front of you and heal for each enemy hit."
	name = "Flurry"
	action_icon_state = "rav_spike"
	macro_path = /datum/action/xeno_action/verb/verb_flurry
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 3 SECONDS

XENO_ABILITY_STATS(flurry, datum/action/xeno_action/activable/flurry)
	return list(
		XENO_STAT_HEALTH(healing_per_target, "Healing per target"),
		xeno_stat_row("Base brute damage", melee_damage(ability, /datum/caste_datum/lurker, use_caste_upper = TRUE)),
	)

/datum/action/xeno_action/activable/tail_jab
	ability_stats_type = /datum/xeno_ability_stats/tail_jab
	var/direct_hit_bonus = 15
	ability_description = "Sweep enemies back with your tail. Direct hits deal more damage, and wall impacts can stun."
	name = "Tail Jab"
	action_icon_state = "prae_pierce"
	macro_path = /datum/action/xeno_action/verb/verb_tail_jab
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 7 SECONDS

XENO_ABILITY_STATS(tail_jab, datum/action/xeno_action/activable/tail_jab)
	return list(
		XENO_STAT_BRUTE(direct_hit_bonus, "Direct hit bonus brute damage"),
		XENO_STAT_VALUE("Wall impact brute damage", MELEE_FORCE_TIER_2, "brute", "."),
		xeno_stat_row("Base brute damage", melee_damage(ability, /datum/caste_datum/lurker, use_caste_upper = TRUE)),
	)

/datum/action/xeno_action/activable/headbite
	ability_stats_type = /datum/xeno_ability_stats/headbite
	var/base_damage = 60
	var/kill_healing = 150
	ability_description = "Execute an unconscious enemy with a bite to recover health."
	name = "Headbite"
	action_icon_state = "headbite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS
	cooldown_message = "Both of our mouths thirst for blood!"

XENO_ABILITY_STATS(headbite, datum/action/xeno_action/activable/headbite)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_HEALTH(kill_healing, "Healing on kill"),
	)

/datum/action/xeno_action/onclick/toggle_crest
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	ability_name = "toggle crest defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_crest
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/armor_buff = 5
	var/speed_debuff = 1

/datum/action/xeno_action/activable/headbutt
	name = "Headbutt"
	action_icon_state = "headbutt"
	ability_name = "headbutt"
	macro_path = /datum/action/xeno_action/verb/verb_headbutt
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

	var/base_damage = 30
	var/usable_while_fortified = FALSE

/datum/action/xeno_action/activable/headbutt/steel_crest
	base_damage = 37.5
	usable_while_fortified = TRUE

/datum/action/xeno_action/onclick/tail_sweep
	name = "Tail Sweep"
	action_icon_state = "tail_sweep"
	ability_name = "tail sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_sweep
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 10
	xeno_cooldown = 11 SECONDS

/datum/action/xeno_action/activable/fortify
	name = "Fortify"
	action_icon_state = "fortify"
	ability_name = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_fortify
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 5 SECONDS

	/// Extra armor when fortified and facing bullets.
	var/frontal_armor = 5

/datum/action/xeno_action/activable/fortify/steel_crest
	frontal_armor = 15

/datum/action/xeno_action/activable/tail_stab/slam
	name = "Tail Slam"
	ability_name = "tail slam"
	blunt_stab = TRUE

/datum/action/xeno_action/onclick/soak
	name = "Soak"
	action_icon_state = "soak"
	ability_name = "soak"
	macro_path = /datum/action/xeno_action/verb/verb_soak
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5
	plasma_cost = 20
	xeno_cooldown = 17 SECONDS

	/// Requires 140 damage taken within 6 seconds to activate the ability
	var/damage_threshold = 140
	/// Initially zero, gets damage added when the ability is activated
	var/damage_accumulated = 0

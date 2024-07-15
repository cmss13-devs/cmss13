/datum/action/xeno_action/activable/pounce/lurker
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 6 SECONDS
	plasma_cost = 20

	// Config options
	knockdown = FALSE
	knockdown_duration = 2.5
	freeze_time = 15
	can_be_shield_blocked = TRUE

/datum/action/xeno_action/onclick/lurker_invisibility
	name = "Turn Invisible"
	action_icon_state = "lurker_invisibility"
	ability_name = "turn invisible"
	macro_path = /datum/action/xeno_action/verb/verb_lurker_invisibility
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	plasma_cost = 20

	var/duration = 30 SECONDS // 30 seconds base
	var/invis_timer_id = TIMER_ID_NULL
	var/alpha_amount = 25
	var/speed_buff = 0.20

// tightly coupled 'buff next slash' action
/datum/action/xeno_action/onclick/lurker_assassinate
	name = "Crippling Strike"
	action_icon_state = "lurker_inject_neuro"
	ability_name = "crippling strike"
	macro_path = /datum/action/xeno_action/verb/verb_crippling_strike
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 10 SECONDS
	plasma_cost = 20

	var/buff_duration = 50

// VAMP LURKER ABILITIES

/datum/action/xeno_action/activable/pounce/rush
	name = "Rush"
	action_icon_state = "pounce"
	ability_name = "rush"
	macro_path = /datum/action/xeno_action/verb/verb_rush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 6 SECONDS
	plasma_cost = 0

	// Config options
	distance = 4
	knockdown = FALSE
	freeze_self = FALSE

/datum/action/xeno_action/activable/flurry
	name = "Flurry"
	action_icon_state = "rav_spike"
	ability_name = "flurry"
	macro_path = /datum/action/xeno_action/verb/verb_flurry
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 3 SECONDS

/datum/action/xeno_action/activable/tail_jab
	name = "Tail Jab"
	action_icon_state = "prae_pierce"
	ability_name = "tail jab"
	macro_path = /datum/action/xeno_action/verb/verb_tail_jab
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 7 SECONDS

/datum/action/xeno_action/activable/headbite
	name = "Headbite"
	action_icon_state = "headbite"
	ability_name = "headbite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS

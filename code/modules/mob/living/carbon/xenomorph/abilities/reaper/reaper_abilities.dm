/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	ability_name = "flesh harvest"
	action_icon_state = "gut"
	//macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 5 SECONDS
	plasma_cost = 50

/datum/action/xeno_action/activable/flesh_bolster
	name = "Flesh Bolster"
	ability_name = "flesh bolster"
	action_icon_state = "empower"
	//macro_path = /datum/action/xeno_action/verb/verb_flesh_bolster
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS
	plasma_cost = 100
	var/resin_cost = 100
	var/self_duration = 30 SECONDS
	var/max_range = 3
	var/fren_heal = 150

/datum/action/xeno_action/activable/claw_strike
	name = "Claw Strike"
	ability_name = "claw strike"
	action_icon_state = "claw_strike"
	//macro_path = /datum/action/xeno_action/verb/verb_claw_strike
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 15 SECONDS
	var/strike_range = 2

/datum/action/xeno_action/activable/raise_servant
	name = "Raise Servant"
	ability_name = "raise servant"
	action_icon_state = "empower"
	//macro_path = /datum/action/xeno_action/verb/verb_raise_servant
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 20 SECONDS
	plasma_cost = 100
	var/resin_cost = 0
	var/creattime = 20 SECONDS
	var/making_servant = FALSE // So we can't make multiple at once


/datum/action/xeno_action/activable/command_servants
	name = "Command Servants"
	ability_name = "command servants"
	action_icon_state = "empower"
	//macro_path = /datum/action/xeno_action/verb/verb_command_servants
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5


/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	ability_name = "flesh harvest"
	action_icon_state = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 5 SECONDS
	plasma_cost = 50

/datum/action/xeno_action/activable/claw_strike
	name = "Rapture"
	ability_name = "rapture"
	action_icon_state = "claw_strike"
	macro_path = /datum/action/xeno_action/verb/verb_rapture
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS
	var/strike_range = 3

/datum/action/xeno_action/onclick/raise_servant
	name = "Raise Servant"
	ability_name = "raise servant"
	action_icon_state = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_raise_servant
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 20 SECONDS
	plasma_cost = 100
	var/resin_cost = 200
	var/creattime = 20 SECONDS
	var/making_servant = FALSE // So we can't make multiple at once


/datum/action/xeno_action/activable/command_servants
	name = "Command Servants"
	ability_name = "command servants"
	action_icon_state = "empower"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4


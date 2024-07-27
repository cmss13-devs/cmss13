/datum/action/xeno_action/activable/secrete_resin/reaper
	name = "Compel Resin"
	ability_name = "compel resin"
	action_icon_state = "secrete_resin"
	macro_path = /datum/action/xeno_action/verb/verb_compel_resin
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	thick = TRUE
	build_speed_mod = 0.5
	var/resin_cost = 30

/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	ability_name = "flesh harvest"
	action_icon_state = "flesh_harvest"
	macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 5 SECONDS
	plasma_cost = 50
	var/pause_duration = 30 SECONDS

/datum/action/xeno_action/activable/claw_strike
	name = "Rapture"
	ability_name = "rapture"
	action_icon_state = "claw_strike"
	macro_path = /datum/action/xeno_action/verb/verb_rapture
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS
	var/strike_range = 3
	var/envenomed = TRUE
	var/pause_duration = 10 SECONDS

/datum/action/xeno_action/activable/raise_servant
	name = "Raise Servant"
	ability_name = "raise servant"
	action_icon_state = "unburrow"
	macro_path = /datum/action/xeno_action/verb/verb_raise_servant
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 20 SECONDS
	plasma_cost = 100
	var/resin_cost = 200
	var/creattime = 10 SECONDS
	var/pause_duration = 20 SECONDS

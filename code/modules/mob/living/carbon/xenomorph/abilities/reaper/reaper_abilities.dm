/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	ability_name = "flesh harvest"
	action_icon_state = "gut"
	/macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 5 SECONDS
	plasma_cost = 50

/datum/action/xeno_action/activable/flesh_bolster
	name = "Flesh Bolster"
	ability_name = "flesh bolster"
	action_icon_state = "empower"
	/macro_path = /datum/action/xeno_action/verb/verb_flesh_bolster
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS
	plasma_cost = 100
	var/resin_cost = 100
	var/self_duration = 30 SECONDS
	var/max_range = 4
	var/fren_heal = 150


/datum/action/xeno_action/activable/meat_shield
	name = "Meat Shield"
	ability_name = "meat shield"
	action_icon_state = "rav_shard_shield"
	/macro_path = /datum/action/xeno_action/verb/verb_meat_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 20 SECONDS
	plasma_cost = 100
	var/resin_cost = 200
	var/max_range = 4

/datum/action/xeno_action/activable/claw_strike
	name = "Claw Strike"
	ability_name = "claw strike"
	action_icon_state = "claw_strike"
	/macro_path = /datum/action/xeno_action/verb/verb_claw_strike
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 10 SECONDS
	var/strike_range = 2

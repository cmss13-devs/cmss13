/datum/action/xeno_action/activable/haul_corpse
	name = "Haul Corpse"
	ability_name = "haul corpse"
	action_icon_state = "flesh_harvest"
	macro_path = /datum/action/xeno_action/verb/verb_haul_corpse
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 1 SECONDS

/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	ability_name = "flesh harvest"
	action_icon_state = "flesh_harvest"
	macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 1 SECONDS
	var/harvest_gain = 30
	var/affect_living = FALSE // Option to let it be used on living if staff want it to for an event

/datum/action/xeno_action/activable/reap
	name = "Reap"
	ability_name = "reap"
	action_icon_state = "claw_strike"
	macro_path = /datum/action/xeno_action/verb/verb_reap
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50
	var/range = 2
	var/toxin_amount = 1

/datum/action/xeno_action/onclick/emit_mist
	name = "Emit Mist"
	ability_name = "Emit Mist"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_mist
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5
	xeno_cooldown = 20 SECONDS
	plasma_cost = 100
	var/flesh_plasma_cost = 150


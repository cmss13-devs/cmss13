/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	ability_name = "flesh harvest"
	action_icon_state = "flesh_harvest"
	macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1

/datum/action/xeno_action/activable/rapture
	name = "Rapture"
	ability_name = "rapture"
	action_icon_state = "claw_strike"
	macro_path = /datum/action/xeno_action/verb/verb_rapture
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS
	var/normal_range = 2
	var/max_range = 4
	var/toxin_amount = 3

/datum/action/xeno_action/onclick/emit_miasma
	name = "Emit Miasma"
	ability_name = "Emit Miasma"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_miasma
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 15 SECONDS
	plasma_cost = 100
	var/flesh_plasma_cost = 100


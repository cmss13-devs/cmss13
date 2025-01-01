/datum/action/xeno_action/activable/retrieve_hugger_egg
	name = "Retrieve Hugger/Egg"
	action_icon_state = "throw_hugger"
	macro_path = /datum/action/xeno_action/verb/verb_retrieve_hugger_egg
	action_type = XENO_ACTION_CLICK

	var/getting_egg = FALSE

/datum/action/xeno_action/onclick/set_hugger_reserve_reaper
	name = "Set Hugger Reserve"
	action_icon_state = "xeno_banish"

/datum/action/xeno_action/activable/haul_corpse
	name = "Haul Corpse"
	action_icon_state = "haul_corpse"
	macro_path = /datum/action/xeno_action/verb/verb_haul_corpse
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/activable/flesh_harvest
	name = "Flesh Harvest"
	action_icon_state = "flesh_harvest"
	macro_path = /datum/action/xeno_action/verb/verb_flesh_harvest
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 1 SECONDS

	var/harvest_gain = 30
	var/affect_living = FALSE // Option to let it be used on living

/datum/action/xeno_action/activable/replenish
	name = "Replenish"
	action_icon_state = "warden_heal"
	macro_path = /datum/action/xeno_action/verb/verb_replenish
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 5 SECONDS
	plasma_cost = 100

	var/range = 3
	var/flesh_plasma_cost = 100
	var/plas_mod = 0.5
	var/heal_message = 0

/datum/action/xeno_action/onclick/emit_mist
	name = "Emit Mist"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_mist
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 20 SECONDS
	plasma_cost = 100

	var/flesh_plasma_cost = 150

// Strain Abilities

/datum/action/xeno_action/activable/reap
	name = "Reap"
	action_icon_state = "claw_strike"
	macro_path = /datum/action/xeno_action/verb/verb_reap
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50

	var/range = 2
	var/toxin_amount = 1

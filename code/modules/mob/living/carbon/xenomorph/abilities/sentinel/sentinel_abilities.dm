//Slowing spit
/datum/action/xeno_action/activable/slowing_spit
	name = "Slowing Spit"
	action_icon_state = "xeno_spit"
	macro_path = /datum/action/xeno_action/verb/verb_slowing_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 2 SECONDS
	plasma_cost = 20

// Scatterspit
/datum/action/xeno_action/activable/scattered_spit
	name = "Scattered Spit"
	action_icon_state = "acid_shotgun"
	macro_path = /datum/action/xeno_action/verb/verb_scattered_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 7 SECONDS
	plasma_cost = 30

// Paralyzing slash
/datum/action/xeno_action/onclick/paralyzing_slash
	name = "Paralyzing Slash"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_paralyzing_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50

	var/buff_duration = 50

// Mangonel Abilities

// Entrench
/datum/action/xeno_action/onclick/entrench
	name = "Entrench"
	action_icon_state = "agility_on"
	macro_path = /datum/action/xeno_action/verb/verb_entrench
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 5 SECONDS
	plasma_cost = 15

// Adaptive Spit
/datum/action/xeno_action/activable/adaptive_spit
	name = "Adaptive Spit"
	action_icon_state = "xeno_spit"
	macro_path = /datum/action/xeno_action/verb/verb_adaptive_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 5 SECONDS
	plasma_cost = 30

// Gas Shroud
/datum/action/xeno_action/onclick/gas_shroud
	name = "Gas Shroud"
	action_icon_state = "acid_shroud"
	macro_path = /datum/action/xeno_action/verb/verb_gas_shroud
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 15 SECONDS
	plasma_cost = 20

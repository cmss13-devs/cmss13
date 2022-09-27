//Slowing spit
/datum/action/xeno_action/activable/slowing_spit
	name = "Slowing Spit"
	action_icon_state = "xeno_spit"
	ability_name = "slowing spit"
	macro_path = /datum/action/xeno_action/verb/verb_slowing_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 20

// Scatterspit
/datum/action/xeno_action/activable/scattered_spit
	name = "Scattered Spit"
	action_icon_state = "acid_shotgun"
	ability_name = "scattered spit"
	macro_path = /datum/action/xeno_action/verb/verb_scattered_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 8 SECONDS
	plasma_cost = 30

// Paralyzing slash
/datum/action/xeno_action/onclick/paralyzing_slash
	name = "Paralyzing Slash"
	action_icon_state = "lurker_inject_neuro"
	ability_name = "paralyzing slash"
	macro_path = /datum/action/xeno_action/verb/verb_paralyzing_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 12 SECONDS
	plasma_cost = 50

	var/buff_duration = 50

// Toxic Slash

/datum/action/xeno_action/onclick/toggle_toxic_slash
	name = "Toggle Toxic Slash"
	action_icon_state = "lurker_inject_neuro"
	ability_name = "toxic slash"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_toxic_slash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

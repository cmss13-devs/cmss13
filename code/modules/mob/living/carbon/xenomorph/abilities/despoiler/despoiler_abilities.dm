/datum/action/xeno_action/activable/xeno_spit/despoiler
	cooldown = 5 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

/datum/action/xeno_action/onclick/despoiler_empower_slash
	name = "Crippling Strike"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_crippling_strike
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 12 SECONDS
	plasma_cost = 100

	var/buff_duration = 50

/datum/action/xeno_action/activable/tail_stab/despoiler
	name = "Finishing Stab"
	charge_time = 3 SECONDS


/datum/action/xeno_action/activable/decomposing_enzymes
	name = "Decomposition Enzymes"
	action_icon_state = "screech"
	macro_path = /datum/action_xeno_action/verb/verb_doom
	xeno_cooldown = 18 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3


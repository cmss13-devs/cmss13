/datum/action/xeno_action/activable/xeno_spit/despoiler
	cooldown = 5 SECONDS

/datum/action/xeno_action/onclick/despoiler_empower_slash
	name = "Crippling Strike"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_crippling_strike
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 10 SECONDS
	plasma_cost = 20

	var/buff_duration = 50

/datum/action/xeno_action/activable/xeno_spit/despoiler
	xeno_cooldown = 5 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 75

/datum/action/xeno_action/onclick/corrosive_slash
	name = "Corrosive Slash"
	action_icon_state = "corrosive_slash"
	macro_path = /datum/action/xeno_action/verb/corrosive_slash
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 12 SECONDS
	plasma_cost = 100

	var/buff_duration = 5 SECONDS
	var/slash_speedup = 2

/datum/action/xeno_action/activable/tail_stab/despoiler
	name = "Finishing Acid Stab"
	charge_time = 2 SECONDS


/datum/action/xeno_action/onclick/decomposing_enzymes
	name = "Decomposing Enzymes"
	action_icon_state = "decomposing_enzymes"
	macro_path = /datum/action_xeno_action/verb/decomposing_enzymes
	xeno_cooldown = 24 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3


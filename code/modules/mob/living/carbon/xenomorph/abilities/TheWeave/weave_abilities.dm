/datum/action/xeno_action/onclick/plant_resin_fruit/weave
	name = "Weave Garden (150)"
	plasma_cost = 150
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/onclick/plant_resin_fruit/weave/pure
	name = "Pure Weave Garden (1000)"
	plasma_cost = 1000
	ability_primacy = XENO_PRIMARY_ACTION_2

/datum/action/xeno_action/onclick/change_fruit/weave
	name = "Change Garden"
	plasma_cost = 0
	xeno_cooldown = 0
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION

/datum/action/xeno_action/onclick/exude_energy
	name = "Exude Energy"
	action_icon_state = "empower"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 60 SECONDS
	plasma_cost = 500
	var/exchange_rate = 0.1


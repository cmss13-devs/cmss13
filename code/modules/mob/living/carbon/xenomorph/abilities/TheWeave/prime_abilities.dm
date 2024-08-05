/datum/action/xeno_action/activable/weave_bless
	name = "Weave Blessing"
	action_icon_state = "queen_give_plasma"
	ability_name = "weave blessing"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 20 SECONDS
	plasma_cost = 500

	var/activation_delay = 20 SECONDS

/datum/action/xeno_action/onclick/weave_heal
	name = "Regeneration Aura"
	action_icon_state = "screech"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 5 MINUTES
	plasma_cost = 750

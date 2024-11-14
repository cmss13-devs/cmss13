/datum/action/xeno_action/activable/weave_bless
	name = "Weave Blessing"
	action_icon_state = "queen_give_plasma"
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
	var/heal_amt = 40

/datum/action/xeno_action/activable/create_pool
	name = "Create Flux Pool (400)"
	action_icon_state = "morph_resin"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION

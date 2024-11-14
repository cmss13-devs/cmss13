/datum/action/xeno_action/activable/spray_acid/weaveguard
	name = "Spray Fey Acid"
	action_icon_state = "spray_acid"
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

	plasma_cost = 80
	xeno_cooldown = 5 SECONDS

	// Configurable options
	spray_type = ACID_SPRAY_LINE
	spray_distance = 7
	spray_effect_type = /obj/effect/xenomorph/spray/praetorian/weave
	activation_delay = TRUE
	activation_delay_length = 2

/datum/action/xeno_action/activable/spray_acid/weaveguard/prime
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	xeno_cooldown = 3 SECONDS
	activation_delay = FALSE
	spray_type = ACID_SPRAY_CONE
	spray_distance = 7

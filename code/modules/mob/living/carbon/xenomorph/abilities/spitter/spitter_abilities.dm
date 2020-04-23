/datum/action/xeno_action/onclick/spitter_frenzy
	name = "Frenzy"
	action_icon_state = "spitter_frenzy"
	ability_name = "dodge"
	macro_path = /datum/action/xeno_action/verb/verb_spitter_frenzy
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 20
	cooldowns = list(90, 85, 80, 75)

	// Config
	var/duration = 35
	var/speed_buff_amount = 1.0 // Go from shit slow to superfast

	var/buffs_active = FALSE

/datum/action/xeno_action/activable/spray_acid/spitter
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	
	plasma_cost = 80
	cooldowns = list(100, 90, 80, 70)

	// Configurable options
	spray_type = ACID_SPRAY_LINE	// Enum for the shape of spray to do
	spray_distance = 6 				// Distance to spray
	spray_effect_type = /obj/effect/xenomorph/spray/spitter
	activation_delay = FALSE		    // Is there an activation delay?
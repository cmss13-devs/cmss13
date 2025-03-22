


/datum/action/xeno_action/activable/xeno_spit/spitter
	name = "Spit Acid"
	action_icon_state = "xeno_spit"
	macro_path = /datum/action/xeno_action/verb/verb_xeno_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	cooldown_message = "We feel our corrosive glands swell with acid. We can spit again."
	//xeno_cooldown = 60 SECONDS useless var. funny shitcode

/datum/action/xeno_action/onclick/charge_spit
	name = "Charge Spit"
	action_icon_state = "charge_spit"
	macro_path = /datum/action/xeno_action/verb/verb_charge_spit
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 50
	xeno_cooldown = 12 SECONDS

	// Config
	var/duration = 35
	var/speed_buff_amount = 0.8 // Go from shit slow to kindafast
	var/armor_buff_amount = 5 // hopefully-minor buff so they can close the distance

	var/buffs_active = FALSE

/datum/action/xeno_action/activable/spray_acid/spitter
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK

	plasma_cost = 50
	xeno_cooldown = 8 SECONDS

	// Configurable options
	spray_type = ACID_SPRAY_LINE // Enum for the shape of spray to do
	spray_distance = 6 // Distance to spray
	spray_effect_type = /obj/effect/xenomorph/spray/weak
	activation_delay = FALSE // Is there an activation delay?

/datum/action/xeno_action/activable/tail_stab/spitter
	name = "Corrosive Tail Stab"

// Alchemist Abilities

/datum/action/xeno_action/activable/tail_inject
	name = "Tail Injection"
	action_icon_state = "tail_attack"
	macro_path = /datum/action/xeno_action/verb/verb_tail_injection
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 50
	xeno_cooldown = 12 SECONDS

	var/alchem_cooldown_modifier = 1

/datum/action/xeno_action/onclick/select_alchem
	name = "Select Chemical"
	action_icon_state = "emit_pheromones"
	macro_path = /datum/action/xeno_action/verb/verb_select_alchem
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/produce_alchem
	name = "Produce Chemical"
	action_icon_state = "emit_pheromones"
	macro_path = /datum/action/xeno_action/verb/verb_produce_alchem
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	plasma_cost = 50
	xeno_cooldown = 20 SECONDS

	var/amount = 10

/datum/action/xeno_action/onclick/remove_alchem
	name = "Remove Chemical"
	action_icon_state = "emit_pheromones"
	macro_path = /datum/action/xeno_action/verb/verb_remove_alchem
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	plasma_cost = 25

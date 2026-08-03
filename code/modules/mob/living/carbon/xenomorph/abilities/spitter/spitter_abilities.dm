


/datum/action/xeno_action/activable/xeno_spit/spitter
	name = "Spit Acid"

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

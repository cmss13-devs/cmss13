/datum/action/xeno_action/onclick/deevolve
	name = "De-Evolve a Xenomorph"
	action_icon_state = "xeno_deevolve"
	plasma_cost = 500

/datum/action/xeno_action/onclick/remove_eggsac
	name = "Remove Eggsac"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 0


/datum/action/xeno_action/onclick/grow_ovipositor
	name = "Grow Ovipositor (500)"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 500

/datum/action/xeno_action/onclick/set_xeno_lead
	name = "Choose/Follow Xenomorph Leaders"
	action_icon_state = "xeno_lead"
	plasma_cost = 0
	xeno_cooldown = 3 SECONDS


/datum/action/xeno_action/activable/queen_heal
	name = "Heal Xenomorph (600)"
	action_icon_state = "heal_xeno"
	ability_name = "xenomorph heal"
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_heal_xeno
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 8 SECONDS

/datum/action/xeno_action/activable/expand_weeds
	name = "Expand Weeds"
	action_icon_state = "plant_weeds"
	ability_name = "weed expansion"
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 0.5 SECOND

	var/node_plant_cooldown = 7 SECONDS
	var/node_plant_plasma_cost = 300

	var/turf_build_cooldown = 7 SECONDS

/datum/action/xeno_action/onclick/banish
	name = "Banish a Xenomorph"
	action_icon_state = "xeno_banish"
	plasma_cost = 500


/datum/action/xeno_action/onclick/readmit
	name = "Readmit a Xenomorph"
	action_icon_state = "xeno_readmit"
	plasma_cost = 100

/datum/action/xeno_action/activable/secrete_resin/ovipositor
	name = "Projected Resin (100)"
	action_icon_state = "secrete_resin"
	ability_name = "projected resin"
	var/last_use = 0
	plasma_cost = 100
	cooldown = 20
	thick = FALSE
	make_message = FALSE

	macro_path = /datum/action/xeno_action/verb/verb_projected_resin
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/eye
	name = "Enter Eye Form"
	action_icon_state = "queen_eye"
	plasma_cost = 0

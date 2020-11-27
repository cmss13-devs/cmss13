/datum/action/xeno_action/onclick/deevolve
	name = "De-Evolve a Xenomorph"
	action_icon_state = "xeno_deevolve"
	plasma_cost = 500
	ability_primacy = XENO_PRIMARY_ACTION_4

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
	ability_primacy = XENO_PRIMARY_ACTION_1


/datum/action/xeno_action/onclick/queen_heal
	name = "Heal Xenomorph (600)"
	action_icon_state = "heal_xeno"
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_heal_xeno
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 20 SECONDS

/datum/action/xeno_action/onclick/toggle_queen_zoom
	name = "Toggle Queen Zoom"
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0


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
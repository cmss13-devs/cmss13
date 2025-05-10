// Unrestricted, some might be unusble while on ovi
/datum/action/xeno_action/onclick/queen_word
	name = "Word of the Queen (50)"
	action_icon_state = "queen_word"
	plasma_cost = 50
	xeno_cooldown = 10 SECONDS

/datum/action/xeno_action/onclick/send_thoughts // and prayers
	name = "Psychic Communication"
	action_icon_state = "psychic_whisper"
	plasma_cost = 0

/datum/action/xeno_action/onclick/manage_hive
	name = "Manage The Hive"
	action_icon_state = "xeno_readmit"
	plasma_cost = 0

/datum/action/xeno_action/onclick/screech
	name = "Screech (250)"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_screech
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 50 SECONDS
	plasma_cost = 250
	cooldown_message = "You feel your throat muscles vibrate. You are ready to screech again."
	no_cooldown_msg = FALSE // Needed for onclick actions
	ability_primacy = XENO_SCREECH
	maturity_restricted = TRUE

// Restricted to off Ovi
/datum/action/xeno_action/onclick/grow_ovipositor
	name = "Grow Ovipositor (500)"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 500
	xeno_cooldown = 5 MINUTES
	cooldown_message = "You are ready to grow an ovipositor again."
	no_cooldown_msg = FALSE // Needed for onclick actions
	hide_on_special_state = TRUE


/datum/action/xeno_action/activable/frontal_assault
	name = "Frontal Assault"
	action_icon_state = "rav_eviscerate"
	//macro_path = /datum/action/xeno_action/verb/
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 6 SECONDS
	plasma_cost = 25
	hide_on_special_state = TRUE

/datum/action/xeno_action/onclick/disarming_sweep
	name = "Disarming Sweep"
	action_icon_state = "tail_sweep"
	//macro_path = /datum/action/xeno_action/verb/
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 8 SECONDS
	plasma_cost = 35
	hide_on_special_state = TRUE

/datum/action/xeno_action/activable/ram
	name = "Ram"
	action_icon_state = "ram"
	//macro_path = /datum/action/xeno_action/verb/verb_ram
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 14 SECONDS
	plasma_cost = 50
	maturity_restricted = TRUE
	hide_on_special_state = TRUE
	// Configs
	var/max_distance = 5
	var/windup_duration = 3 SECONDS
	var/list/ram_callbacks = null
	var/impassable_collide = FALSE

/datum/action/xeno_action/activable/ram/New()
	. = ..()
	ram_callbacks = list()
	ram_callbacks[/mob] = DYNAMIC(/mob/living/carbon/xenomorph/queen/proc/ram_mob)
	ram_callbacks[/obj] = DYNAMIC(/mob/living/carbon/xenomorph/queen/proc/ram_obj)
	ram_callbacks[/turf] = DYNAMIC(/mob/living/carbon/xenomorph/queen/proc/ram_turf)

/datum/action/xeno_action/activable/brutality
	name = "Brutality"
	action_icon_state = "lunge"
	//macro_path = /datum/action/xeno_action/verb/verb_brutality
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 30 SECONDS
	plasma_cost = 200
	maturity_restricted = TRUE
	hide_on_special_state = TRUE
	// Configs
	var/max_range = 3
/*
/datum/aciton/xeno_action/activable/resin_spit
	name = "Resin Spit"
	action_icon_state = "shift_spit_sticky"
	//macro_path = /datum/action/xeno_action/verb/verb_resin_spit
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5
	xeno_cooldown = 3 SECONDS
	plasma_cost = 25

*/

/datum/action/xeno_action/activable/gut
	name = "Gut (200)"
	action_icon_state = "gut"
	macro_path = /datum/action/xeno_action/verb/verb_gut
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 MINUTES
	plasma_cost = 200
	cooldown_message = "You feel your anger return. You are ready to gut again."
	hide_on_special_state = TRUE

// Restricted to on Ovi

/datum/action/xeno_action/onclick/remove_eggsac
	name = "Remove Eggsac"
	action_icon_state = "grow_ovipositor"
	plasma_cost = 0
	hide_off_special_state = TRUE

/datum/action/xeno_action/activable/expand_weeds
	name = "Expand Weeds (50)"
	action_icon_state = "plant_weeds"
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 0.5 SECONDS
	hide_off_special_state = TRUE

	var/node_plant_cooldown = 7 SECONDS
	var/node_plant_plasma_cost = 300
	var/turf_build_cooldown = 10 SECONDS

/datum/action/xeno_action/activable/secrete_resin/remote/queen
	name = "Projected Resin (100)"
	action_icon_state = "secrete_resin"
	plasma_cost = 100
	xeno_cooldown = 2 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_5
	hide_off_special_state = TRUE

	care_about_adjacency = FALSE
	build_speed_mod = 1.2

	var/boosted = FALSE

/datum/action/xeno_action/onclick/set_xeno_lead
	name = "Choose/Follow Xenomorph Leaders"
	action_icon_state = "xeno_lead"
	plasma_cost = 0
	xeno_cooldown = 3 SECONDS
	hide_off_special_state = TRUE

/datum/action/xeno_action/activable/queen_heal
	name = "Heal Xenomorph (600)"
	action_icon_state = "heal_xeno"
	plasma_cost = 600
	macro_path = /datum/action/xeno_action/verb/verb_heal_xeno
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 8 SECONDS
	hide_off_special_state = TRUE

/datum/action/xeno_action/activable/queen_give_plasma
	name = "Give Plasma (400)"
	action_icon_state = "queen_give_plasma"
	plasma_cost = 400
	macro_path = /datum/action/xeno_action/verb/verb_plasma_xeno
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 12 SECONDS
	hide_off_special_state = TRUE

/datum/action/xeno_action/onclick/queen_tacmap
	name = "View Xeno Tacmap"
	action_icon_state = "toggle_queen_zoom"
	plasma_cost = 0
	hide_off_special_state = TRUE

// Queen variants of basic abilities for special state restrictions

/datum/action/xeno_action/activable/corrosive_acid/queen
	block_on_special_state = TRUE

/datum/action/xeno_action/activable/info_marker/queen
	max_markers = 5

/datum/action/xeno_action/onclick/xeno_resting/queen
	block_on_special_state = TRUE

/datum/action/xeno_action/onclick/plant_weeds/queen
	hide_on_special_state = TRUE

/datum/action/xeno_action/onclick/choose_resin/queen_macro
	ability_primacy = XENO_PRIMARY_ACTION_4
	hide_off_special_state = TRUE

/datum/action/xeno_action/activable/secrete_resin/queen_macro
	ability_primacy = XENO_PRIMARY_ACTION_5
	hide_off_special_state = TRUE

/datum/action/xeno_action/activable/place_construction/queen
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	hide_off_special_state = TRUE

/datum/action/xeno_action/activable/tail_stab/queen
	block_on_special_state = TRUE

/datum/action/xeno_action/activable/pounce/lurker
	ability_description = "Leap at prey. Pouncing from stealth can knock the target down, but momentarily roots you in place. Slash the target to move immediately."
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 6 SECONDS
	plasma_cost = 20

	// Config options
	knockdown = FALSE
	knockdown_duration = 2.5
	freeze_time = 15
	can_be_shield_blocked = TRUE

/datum/action/xeno_action/onclick/lurker_invisibility
	ability_description = "Enter stealth to approach prey unseen and set up an ambush. Slashing ends it early."
	name = "Turn Invisible"
	action_icon_state = "lurker_invisibility"
	macro_path = /datum/action/xeno_action/verb/verb_lurker_invisibility
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	plasma_cost = 20

	var/duration = 30 SECONDS // 30 seconds base
	var/invis_timer_id = TIMER_ID_NULL
	var/alpha_amount = 25
	var/speed_buff = 0.20

// tightly coupled 'buff next slash' action
/datum/action/xeno_action/onclick/lurker_assassinate
	ability_description = "Prime your next slash to deal increased damage and heavily slow the target for 3 seconds."
	name = "Crippling Strike"
	action_icon_state = "lurker_inject_neuro"
	macro_path = /datum/action/xeno_action/verb/verb_crippling_strike
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 10 SECONDS
	plasma_cost = 20
	cooldown_message = "We can clearly see the weakpoints of fallen talls again."

	var/buff_duration = 50

// VAMP LURKER ABILITIES

/datum/action/xeno_action/activable/pounce/rush
	ability_description = "Rush into an opponent to disorient them."
	name = "Rush"
	action_icon_state = "pounce"
	action_text = "rush"
	macro_path = /datum/action/xeno_action/verb/verb_rush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 6 SECONDS
	plasma_cost = 0

	// Config options
	distance = 4
	knockdown = FALSE
	freeze_self = FALSE

/datum/action/xeno_action/activable/flurry
	ability_description = "Sweep the area in front of you, slowing enemies and healing for each one hit."
	name = "Flurry"
	action_icon_state = "rav_spike"
	macro_path = /datum/action/xeno_action/verb/verb_flurry
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 3 SECONDS

/datum/action/xeno_action/activable/tail_jab
	ability_description = "Sweep enemies back with your tail. Direct hits deal more damage, and wall impacts can stun."
	name = "Tail Jab"
	action_icon_state = "prae_pierce"
	macro_path = /datum/action/xeno_action/verb/verb_tail_jab
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 7 SECONDS

/datum/action/xeno_action/activable/headbite
	ability_description = "Execute an unconscious enemy with a bite to recover health."
	name = "Headbite"
	action_icon_state = "headbite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS
	cooldown_message = "Both of our mouths thirst for blood!"

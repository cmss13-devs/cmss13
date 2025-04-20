/datum/action/xeno_action/activable/pounce/facehugger
	name = "Leap"
	action_icon_state = "pounce"
	action_text = "leap"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 3 SECONDS
	plasma_cost = 0

	// Config options
	knockdown = TRUE
	knockdown_duration = 0.5
	windup = TRUE
	windup_duration = FACEHUGGER_LEAP_DURATION
	freeze_self = TRUE
	freeze_time = 5
	freeze_play_sound = FALSE
	can_be_shield_blocked = TRUE

/datum/action/xeno_action/onclick/toggle_long_range/facehugger
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_3

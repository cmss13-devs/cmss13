/datum/action/xeno_action/activable/uppercut
	name = "Uppercut"
	action_icon_state = "rav_clothesline"
	macro_path = /datum/action/xeno_action/verb/verb_uppercut
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 100
	var/base_damage = 15
	var/base_knockback = 40
	var/base_knockdown = 0.25
	var/knockout_power = 11 // 11 seconds
	var/base_healthgain = 5 // in percents of health per ko point

/datum/action/xeno_action/activable/jab
	name = "Jab"
	action_icon_state = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_jab
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 40


// toggle agility
/datum/action/xeno_action/onclick/toggle_agility
	name = "Toggle Agility"
	action_icon_state = "agility_on"
	ability_name = "toggle agility"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_agility
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10

/datum/action/xeno_action/onclick/toggle_agility/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

// Warrior Fling
/datum/action/xeno_action/activable/fling
	name = "Fling"
	action_icon_state = "fling"
	ability_name = "Fling"
	macro_path = /datum/action/xeno_action/verb/verb_fling
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 55

	// Configurables
	var/fling_distance = 4
	var/stun_power = 1
	var/weaken_power = 1


// Warrior Lunge
/datum/action/xeno_action/activable/lunge
	name = "Lunge"
	action_icon_state = "lunge"
	ability_name = "lunge"
	macro_path = /datum/action/xeno_action/verb/verb_lunge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 100
	
	// Configurables
	var/grab_range = 6
	var/click_miss_cooldown = 15

// Warrior Agility

/datum/action/xeno_action/activable/warrior_punch
	name = "Punch"
	action_icon_state = "punch"
	ability_name = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 40

	// Configurables
	var/base_damage = 20
	var/boxer_punch_damage = 20
	var/base_punch_damage_synth = 30
	var/boxer_punch_damage_synth = 30
	var/base_punch_damage_pred = 25
	var/boxer_punch_damage_pred = 25
	var/damage_variance = 5

/datum/action/xeno_action/activable/uppercut
	name = "Uppercut"
	action_icon_state = "rav_clothesline"
	ability_name = "uppercut"
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
	ability_name = "jab"
	macro_path = /datum/action/xeno_action/verb/verb_jab
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 40


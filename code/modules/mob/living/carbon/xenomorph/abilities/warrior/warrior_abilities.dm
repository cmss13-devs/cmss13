// Warrior Fling
/datum/action/xeno_action/activable/fling
	name = "Fling"
	action_icon_state = "fling"
	macro_path = /datum/action/xeno_action/verb/verb_fling
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 6 SECONDS

	// Configurables
	var/fling_distance = 4
	var/stun_power = 0.5
	var/weaken_power = 0.5
	var/slowdown = 2

// Warrior Lunge
/datum/action/xeno_action/activable/lunge
	name = "Lunge"
	action_icon_state = "lunge"
	macro_path = /datum/action/xeno_action/verb/verb_lunge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS

	// Configurables
	var/grab_range = 4
	var/click_miss_cooldown = 15
	var/twitch_message_cooldown = 0 //apparently this is necessary for a tiny code that makes the lunge message on cooldown not be spammable, doesn't need to be big so 5 will do.

/datum/action/xeno_action/activable/warrior_punch
	name = "Punch"
	action_icon_state = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 4.5 SECONDS

	// Configurables
	var/base_damage = 25
	var/base_punch_damage_synth = 30
	var/base_punch_damage_pred = 25
	var/damage_variance = 5

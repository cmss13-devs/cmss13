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

///Bulwark Strain

/datum/action/xeno_action/onclick/toggle_plates
	name = "Toggle Encasing Plates"
	action_icon_state = "encased_plates"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_plates
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 2 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/speed_debuff = 0.5

/datum/action/xeno_action/activable/plate_bash
	name = "Plate Bash"
	action_icon_state = "plate_bash"
	macro_path = /datum/action/xeno_action/verb/verb_plate_bash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

	var/base_damage = 20

/datum/action/xeno_action/onclick/tail_swing
	name = "Tail Swing"
	action_icon_state = "tail_swing"
	macro_path = /datum/action/xeno_action/verb/verb_tail_swing
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 20
	xeno_cooldown = 10 SECONDS

	var/swing_range = 1
	var/hit_enemy = FALSE
	var/hit_grenade = FALSE

/datum/action/xeno_action/onclick/reflective_shield
	name = "Reflective Shield"
	action_icon_state = "reflective_shield"
	macro_path = /datum/action/xeno_action/verb/verb_reflective_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

	/// used to calculate reflective plates refunding.
	var/duration = BULWARK_REFLECTIVE_TIME
	/// reflective plates addtimer ID (for deletion)
	var/reflective_shield_timer_id = TIMER_ID_NULL
	/// Used to countdown BULWARK_REFLECTIVE_TIME.
	var/reflective_start_time = -1
	/// How much refund we want to get back? 1.0 is 1s used to 1s cooldown, 2.0 is 1s used 2s cooldown.
	var/reflective_refund_multiplier = 2.0
	/// Used in calculation, finalized number will be displayed as cooldown.
	var/reflective_recharge_time = null
	/// Cooldown after activation to prevent accidental double click.
	var/reflective_safe_click_cooldown = 0

/datum/action/xeno_action/activable/plate_slam
	name = "Plate Slam"
	action_icon_state = "plate_slam"
	macro_path = /datum/action/xeno_action/verb/verb_plate_slam
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_5
	plasma_cost = 80
	xeno_cooldown = 20 SECONDS

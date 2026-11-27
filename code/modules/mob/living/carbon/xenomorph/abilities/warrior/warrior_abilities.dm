// Warrior Fling
/datum/action/xeno_action/activable/fling
	ability_stats_type = /datum/xeno_ability_stats/activable_fling
	ability_description = "Throw an adjacent enemy away and slow them."
	name = "Fling"
	action_icon_state = "fling"
	macro_path = /datum/action/xeno_action/verb/verb_fling
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 6 SECONDS

	// Configurables
	var/fling_distance = 4
	var/stun_duration = 0.5
	var/knockdown_duration = 0.5
	var/slow_duration = 2

XENO_ABILITY_STATS(activable_fling, datum/action/xeno_action/activable/fling)
	return list(
		XENO_STAT_VALUE("Knockback", XENO_ABILITY_VALUE(ability, fling_distance), "crowd_control", " tiles."),
		XENO_STAT_CONTROL_LEGACY(stun_duration, "Stun"),
		XENO_STAT_CONTROL_LEGACY(knockdown_duration, "Knockdown"),
	)

// Warrior Lunge
/datum/action/xeno_action/activable/lunge
	ability_stats_type = /datum/xeno_ability_stats/activable_lunge
	ability_description = "Leap toward an enemy and grab them."
	name = "Lunge"
	action_icon_state = "lunge"
	macro_path = /datum/action/xeno_action/verb/verb_lunge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 10 SECONDS

	// Configurables
	var/grab_range = 4
	var/click_miss_cooldown = 1.5 SECONDS
	var/twitch_message_cooldown = 0 //apparently this is necessary for a tiny code that makes the lunge message on cooldown not be spammable, doesn't need to be big so 5 will do.

XENO_ABILITY_STATS(activable_lunge, datum/action/xeno_action/activable/lunge)
	return list(
		XENO_STAT_TILES(grab_range, "Range"),
	)

/datum/action/xeno_action/activable/warrior_punch
	ability_stats_type = /datum/xeno_ability_stats/activable_warrior_punch
	ability_description = "Deliver a heavy punch to a target at close range."
	name = "Punch"
	action_icon_state = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 4.5 SECONDS

	// Configurables
	var/base_damage = 25
	var/base_damage_synth = 30
	var/base_damage_pred = 25
	var/damage_variance = 5

XENO_ABILITY_STATS(activable_warrior_punch, datum/action/xeno_action/activable/warrior_punch)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_BRUTE(damage_variance, "Damage variance"),
	)

///Bulwark Strain

/datum/action/xeno_action/onclick/toggle_plates
	ability_description = "Encase your plates to resist knockback, strengthen directional armor and tear openings in walls. Movement slows."
	name = "Toggle Encasing Plates"
	action_icon_state = "encased_plates"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_plates
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/speed_debuff = 1.35

/datum/action/xeno_action/activable/plate_bash
	ability_stats_type = /datum/xeno_ability_stats/activable_plate_bash
	ability_description = "Dash into a target and strike it. With plates encased, launch the target away and knock it down."
	name = "Plate Bash"
	action_icon_state = "plate_bash"
	macro_path = /datum/action/xeno_action/verb/verb_plate_bash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 4 SECONDS

	var/base_damage = 20

XENO_ABILITY_STATS(activable_plate_bash, datum/action/xeno_action/activable/plate_bash)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
	)

/datum/action/xeno_action/onclick/tail_swing
	ability_stats_type = /datum/xeno_ability_stats/onclick_tail_swing
	ability_description = "Trip nearby enemies or bat a grenade away with your tail."
	name = "Tail Swing"
	action_icon_state = "tail_swing"
	macro_path = /datum/action/xeno_action/verb/verb_tail_swing
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 20
	xeno_cooldown = 10 SECONDS

	var/swing_range = 1

XENO_ABILITY_STATS(onclick_tail_swing, datum/action/xeno_action/onclick/tail_swing)
	return list(
		XENO_STAT_TILES(swing_range, "Radius"),
	)

/datum/action/xeno_action/onclick/reflective_shield
	ability_stats_type = /datum/xeno_ability_stats/onclick_reflective_shield
	ability_description = "Lock your facing and reflect incoming fire from the front. Longer use extends the cooldown."
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
	/// How much refund we want to get back? 1 is 1s used to 1s cooldown, 2 is 1s used 2s cooldown.
	var/reflective_refund_multiplier = 2
	/// Used in calculation, finalized number will be displayed as cooldown.
	var/reflective_recharge_time = null
	/// Cooldown after activation to prevent accidental double click.
	var/reflective_safe_click_cooldown = 0

XENO_ABILITY_STATS(onclick_reflective_shield, datum/action/xeno_action/onclick/reflective_shield)
	return list(
		XENO_STAT_DURATION(duration, "Maximum duration"),
	)

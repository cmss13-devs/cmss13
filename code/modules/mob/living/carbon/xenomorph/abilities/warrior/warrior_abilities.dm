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
	var/slowdown = FALSE


// Warrior Lunge
/datum/action/xeno_action/activable/lunge
	name = "Lunge"
	action_icon_state = "lunge"
	ability_name = "lunge"
	macro_path = /datum/action/xeno_action/verb/verb_lunge
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 100

	// Configurables
	var/grab_range = 6
	var/click_miss_cooldown = 15
	var/twitch_message_cooldown = 0 //apparently this is necessary for a tiny code that makes the lunge message on cooldown not be spammable, doesn't need to be big so 5 will do.

// Warrior Agility

/datum/action/xeno_action/activable/warrior_punch
	name = "Punch"
	action_icon_state = "punch"
	ability_name = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 40

	// Configurables
	var/base_damage = 25
	var/base_punch_damage_synth = 30
	var/base_punch_damage_pred = 25
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

// - - knight strain

/datum/action/xeno_action/activable/tail_stab/tail_trip
	name = "Tail Trip"
	action_icon_state = "tail_attack"
	ability_name = "tail trip"
	charge_time = 0.5 SECONDS
	xeno_cooldown = 15 SECONDS

	max_stab_dist = 2

	var/trip_dur = 0.5 //SECONDS - uses apply_effect, already is seconds

/datum/action/xeno_action/activable/pike
	name = "Pike"
	action_icon_state = "prae_pierce"
	ability_name = "pike"
	macro_path = /datum/action/xeno_action/verb/verb_pike
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 10 //4 SECONDS

	//Config

	 /// Basic ability damage.
	var/pike_damage = 30
	 /// Reach of the ability in tiles.
	var/pike_len = 3
	 /// Extra damage on every additional enemy hit by the pike.
	var/bonus_dmg = 15

	// Duration of on-pike effects.

	var/slow_dur = 1.5 SECONDS
	var/sslow_dur = 2 SECONDS
	var/paralyze_dur = 2.5 SECONDS

/datum/action/xeno_action/onclick/bulwark
	name = "Bulwark"
	action_icon_state = "rav_shard_shield"
	ability_name = "bulwark"
	macro_path = /datum/action/xeno_action/verb/verb_bulwark
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 10//15 SECONDS

	/// Config

	var/dmg_reduc_duration = 10 SECONDS
	var/normal_damage_reduction = 0.8
	var/enhanced_damage_reduction = 0.6

/datum/action/xeno_action/activable/pounce/leap
	name = "Leap"
	action_icon_state = "prae_dash"
	ability_name = "leap"
	macro_path = /datum/action/xeno_action/verb/verb_knight_leap
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 10 //9 SECONDS

	freeze_self = FALSE
	distance = 3 //tiles
	slash = TRUE
	can_be_shield_blocked = TRUE
	knockdown = FALSE
	knockdown_duration = 0.5 // i'll be real this is jank bypass (more jank)

	var/leap_knock_dur = 0.5 //SECONDS - already ran as seconds in proc
	var/leap_slow_dur = 1 SECONDS

	var/atom/pounce_to
	var/atom/pounce_from

//todo animate the leap so it looks like a leap. itd go hard
//todo make anim marker at the target also this doesnt work
/datum/action/xeno_action/activable/pounce/knight_leap/initialize_pounce_pass_flags()
	pounce_pass_flags = PASS_MOB_THRU|PASS_OVER_THROW_MOB

/datum/action/xeno_action/activable/plant_holdfast
	name = "Plant Holdfast"
	action_icon_state = "morph_resin"
	ability_name = "holdfast"
	macro_path = /datum/action/xeno_action/verb/place_construction
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

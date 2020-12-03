// Base ravager shield ability
/datum/action/xeno_action/activable/empower
	name = "Empower"
	action_icon_state = "empower"
	ability_name = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_empower
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 50
	xeno_cooldown = 180

	// Config values (mutable)
	var/empower_range = 3
	var/max_shield = 300
	var/baseline_shield = 75
	var/shield_per_human = 50
	var/initial_shield = 100
	var/time_until_timeout = 100

	// State
	var/activated_once = FALSE

// Rav charge
/datum/action/xeno_action/activable/pounce/charge
	name = "Charge"
	action_icon_state = "charge"
	ability_name = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_charge_rav
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 140
	plasma_cost = 25

	// Pounce config
	distance = 5					
	knockdown = FALSE				// Should we knock down the target?
	slash = FALSE					// Do we slash upon reception?
	freeze_self = FALSE				// Should we freeze ourselves after the lunge?
	should_destroy_objects = TRUE   // Only used for ravager charge

// Rav "Scissor Cut"
/datum/action/xeno_action/activable/scissor_cut
	name = "Scissor Cut"
	ability_name = "scissor cut"
	action_icon_state = "rav_scissor_cut"
	macro_path = /datum/action/xeno_action/verb/verb_scissorcut
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 100
	plasma_cost = 25

	// Config
	var/damage = 45

	var/daze_duration = 2 // If we daze, daze for this duration

//// BERSERKER ACTIONS

/datum/action/xeno_action/activable/apprehend
	name = "Apprehend"
	action_icon_state = "rav_enrage"
	ability_name = "enrage"
	macro_path = /datum/action/xeno_action/verb/verb_apprehend
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 200

	// Config values
	var/max_distance = 6 // 5 tiles between
	var/windup_duration = 10


/datum/action/xeno_action/activable/clothesline
	name = "Clothesline"
	action_icon_state = "rav_clothesline"
	ability_name = "clothesline"
	macro_path = /datum/action/xeno_action/verb/verb_clothesline
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 140

	// Config values
	var/heal_per_rage = 150
	var/damage = 20
	var/fling_dist_base = 4
	var/daze_amount = 2

/datum/action/xeno_action/activable/eviscerate
	name = "Eviscerate"
	action_icon_state = "rav_eviscerate"
	ability_name = "eviscerate"
	macro_path = /datum/action/xeno_action/verb/verb_eviscerate
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 230

	// Config values
	var/activation_delay = 20

	var/base_damage = 25
	var/damage_at_rage_levels = list(5, 10, 25, 45, 70)
	var/range_at_rage_levels = list(1, 1, 1, 2, 2)
	var/windup_reduction_at_rage_levels = list(0, 2, 4, 6, 10)


////// HEDGEHOG ABILITIES

/datum/action/xeno_action/activable/spike_shield
	name = "Spike Shield (150 shards)"
	action_icon_state = "rav_shard_shield"
	ability_name = "spike shield"
	macro_path = /datum/action/xeno_action/verb/verb_spike_shield
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = SECONDS_9 + SECONDS_2 // Left operand is the actual CD, right operand is the buffer for the shield duration

	// Config values
	var/shield_duration = 20  		// Shield lasts 2 seconds by default.
	var/shield_amount = 500 		// Shield HP amount
	var/shield_shrapnel_amount = 7  // How much shrapnel each shield hit should spawn
	var/shard_cost = 150 			// Minimum spikes to use this ability
	var/shield_active = FALSE 		// Is our shield active.
	var/real_hp_per_shield_hp = 0.5	// How many real HP we get for each shield HP

/datum/action/xeno_action/activable/rav_spikes
	name = "Fire Spikes (75 shards)"
	action_icon_state = "rav_spike"
	ability_name = "fire spikes"
	macro_path = /datum/action/xeno_action/verb/verb_fire_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 130

	// Config
	var/shard_cost = 75
	var/ammo_type = /datum/ammo/xeno/bone_chips

/datum/action/xeno_action/activable/spike_shed
	name = "Spike Shed (50 shards)"
	action_icon_state = "rav_shard_shed"
	ability_name = "spike shed"
	macro_path = /datum/action/xeno_action/verb/verb_shed_spikes
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 300

	// Config values
	var/shard_cost = 50
	var/ammo_type = /datum/ammo/xeno/bone_chips/spread
	var/shrapnel_amount = 20




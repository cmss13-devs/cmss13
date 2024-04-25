
// Rav charge
/datum/action/xeno_action/activable/pounce/charge
	name = "Charge"
	action_icon_state = "charge"
	ability_name = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_charge_rav
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 14 SECONDS
	plasma_cost = 25

	// Pounce config
	distance = 5
	knockdown = FALSE // Should we knock down the target?
	slash = FALSE // Do we slash upon reception?
	freeze_self = FALSE // Should we freeze ourselves after the lunge?
	should_destroy_objects = TRUE   // Only used for ravager charge

// Base ravager shield ability
/datum/action/xeno_action/onclick/empower
	name = "Empower"
	action_icon_state = "empower"
	ability_name = "empower"
	macro_path = /datum/action/xeno_action/verb/verb_empower
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 50
	xeno_cooldown = 18 SECONDS

	// Config values (mutable)
	var/empower_range = 3
	var/max_targets = 6
	var/main_empower_base_shield = 0
	var/initial_activation_shield = 50
	var/shield_per_human = 50
	var/time_until_timeout = 6 SECONDS

	// State
	var/activated_once = FALSE

// Rav "Scissor Cut"
/datum/action/xeno_action/activable/scissor_cut
	name = "Scissor Cut"
	ability_name = "scissor cut"
	action_icon_state = "rav_scissor_cut"
	macro_path = /datum/action/xeno_action/verb/verb_scissorcut
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 6 SECONDS
	plasma_cost = 25

	// Config
	var/damage = 40

	var/superslow_duration = 3 SECONDS

//// BERSERKER ACTIONS

/datum/action/xeno_action/onclick/apprehend
	name = "Apprehend"
	action_icon_state = "rav_enrage"
	ability_name = "apprehend"
	macro_path = /datum/action/xeno_action/verb/verb_apprehend
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 18 SECONDS

	// Config values
	var/speed_buff = 0.75
	var/buff_duration = 5 SECONDS


/datum/action/xeno_action/activable/clothesline
	name = "Clothesline"
	action_icon_state = "rav_clothesline"
	ability_name = "clothesline"
	macro_path = /datum/action/xeno_action/verb/verb_clothesline
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 16 SECONDS

	// Config values
	var/base_heal = 75
	var/additional_healing_enraged = 100
	var/damage = 20
	var/fling_dist_base = 4
	var/daze_amount = 2

/datum/action/xeno_action/activable/eviscerate
	name = "Eviscerate"
	action_icon_state = "rav_eviscerate"
	ability_name = "eviscerate"
	macro_path = /datum/action/xeno_action/verb/verb_eviscerate
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 23 SECONDS

	// Config values
	var/activation_delay = 20

	var/base_damage = 25
	var/damage_at_rage_levels = list(5, 10, 25, 45, 70)
	var/range_at_rage_levels = list(1, 1, 1, 2, 2)
	var/windup_reduction_at_rage_levels = list(0, 2, 4, 6, 10)


////// HEDGEHOG ABILITIES

/datum/action/xeno_action/onclick/spike_shield
	name = "Spike Shield (150 shards)"
	action_icon_state = "rav_shard_shield"
	ability_name = "spike shield"
	macro_path = /datum/action/xeno_action/verb/verb_spike_shield
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 0
	xeno_cooldown = 9 SECONDS + 2.5 SECONDS // Left operand is the actual CD, right operand is the buffer for the shield duration

	// Config values
	var/shield_duration = 15 // Shield lasts 1.5 seconds by default.
	var/shield_amount = 500 // Shield HP amount
	var/shield_shrapnel_amount = 6  // How much shrapnel each shield hit should spawn
	var/shard_cost = 200 // Minimum spikes to use this ability
	var/shield_active = FALSE // Is our shield active.
	var/real_hp_per_shield_hp = 0.5 // How many real HP we get for each shield HP

/datum/action/xeno_action/activable/rav_spikes
	name = "Fire Spikes (75 shards)"
	action_icon_state = "rav_spike"
	ability_name = "fire spikes"
	macro_path = /datum/action/xeno_action/verb/verb_fire_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 0
	xeno_cooldown = 10 SECONDS

	// Config
	var/shard_cost = 75
	var/ammo_type = /datum/ammo/xeno/bone_chips

/datum/action/xeno_action/onclick/spike_shed
	name = "Spike Shed (50 shards)"
	action_icon_state = "rav_shard_shed"
	ability_name = "spike shed"
	macro_path = /datum/action/xeno_action/verb/verb_shed_spikes
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 0
	xeno_cooldown = 30 SECONDS

	// Config values
	var/shard_cost = 50
	var/ammo_type = /datum/ammo/xeno/bone_chips/spread
	var/shrapnel_amount = 40



/datum/action/xeno_action/onclick/toggle_long_range/boiler
	should_delay = TRUE
	delay = 5
	ability_primacy = XENO_PRIMARY_ACTION_4
	handles_movement = FALSE
	movement_slowdown = XENO_SPEED_SLOWMOD_ZOOM

/datum/action/xeno_action/activable/acid_lance
	name = "Acid Lance"
	ability_name = "acid lance"
	action_icon_state = "acid_lance"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_acid_lance
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 190

	// Config
	var/stack_time = 10
	var/base_range = 6
	var/range_per_stack = 1
	var/base_damage = 35
	var/damage_per_stack = 15
	var/movespeed_per_stack = 1.25

	var/time_after_max_before_end = 25

	// State
	var/stacks = 0
	var/max_stacks = 5
	var/movespeed_nerf_applied = 0
	var/activated_once = FALSE

/datum/action/xeno_action/onclick/shift_spits/boiler
	name = "Toggle Gas Type"
	action_icon_state = "shift_spit_acid_glob"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_spit_type
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 1 SECONDS // Spam preventionv

/datum/action/xeno_action/activable/spray_acid/boiler
	plasma_cost = 40
	xeno_cooldown = 10 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_3
	// Configurable options
	spray_type = ACID_SPRAY_LINE	// Enum for the shape of spray to do
	spray_distance = 6 				// Distance to spray


/datum/action/xeno_action/activable/xeno_spit/bombard
	name = "Bombard"
	ability_name = "Bombard"
	action_icon_state = "bombard"
	cooldown_message = "Your belly fills with another gas glob. You are are ready to bombard again."
	sound_to_play = 'sound/effects/blobattack.ogg'
	aim_turf = TRUE
	/// These are actions that will be placed on cooldown for the cooldown_duration when activates. Added acid shroud for now because it can be abused
	var/action_types_to_cd = list(
		/datum/action/xeno_action/onclick/acid_shroud,
	)

	/// Duration for the cooldown of abilities affected by bombard
	var/cooldown_duration = 20 SECONDS

/datum/action/xeno_action/onclick/acid_shroud  // acid dump alternative
	name = "Acid Shroud"
	ability_name = "Acid Shroud"
	action_icon_state = "acid_shroud"
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_cost = 10
	macro_path = /datum/action/xeno_action/verb/verb_acid_shroud
	/// Allows the sound to play. Flipped to false when sound is triggered and true after a timer. This prevents soundspam
	var/sound_play = TRUE

	/// These are actions that will be placed on cooldown for the cooldown_duration when activates
	var/action_types_to_cd = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/acid_shroud,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
	)
	xeno_cooldown = 34 SECONDS

	/// Duration for the cooldown of abilities affected by acid shroud
	var/cooldown_duration = 30 SECONDS

/datum/action/xeno_action/onclick/dump_acid
	name = "Dump Acid"
	ability_name = "dump acid"
	action_icon_state = "dump_acid"
	plasma_cost = 10
	macro_path = /datum/action/xeno_action/verb/verb_dump_acid
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 34 SECONDS

	var/buffs_duration = 6 SECONDS
	var/cooldown_duration = 30 SECONDS

	var/speed_buff_amount = 0.5
	var/movespeed_buff_applied = FALSE

	/// List of types of actions to place on 20-second CD,if you ever want to subtype this for a strain or whatever, just change this var on the subtype
	var/action_types_to_cd = list(
		/datum/action/xeno_action/activable/xeno_spit/bombard,
		/datum/action/xeno_action/onclick/dump_acid,
		/datum/action/xeno_action/onclick/toggle_long_range/boiler,
		/datum/action/xeno_action/activable/spray_acid/boiler,
	)

//////////////////////////// Trapper boiler abilities

/datum/action/xeno_action/activable/boiler_trap
	name = "Deploy Trap"
	ability_name = "deploy trap"
	action_icon_state = "resin_pit"
	plasma_cost = 60
	macro_path = /datum/action/xeno_action/verb/verb_boiler_trap
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 205

	/// Config
	var/trap_ttl = 100
	var/empowered = FALSE
	var/empowering_charge_counter = 0
	var/empower_charge_max = 10

/datum/action/xeno_action/activable/acid_mine
	name = "Acid Mine"
	ability_name = "acid mine"
	action_icon_state = "acid_mine"
	plasma_cost = 40
	macro_path = /datum/action/xeno_action/verb/verb_acid_mine
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 55

	var/empowered = FALSE

	var/damage = 45
	var/delay = 13.5

/datum/action/xeno_action/activable/acid_shotgun
	name = "Acid Shotgun"
	ability_name = "acid shotgun"
	action_icon_state = "acid_shotgun"
	plasma_cost = 60
	macro_path = /datum/action/xeno_action/verb/verb_acid_shotgun
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 130

	var/ammo_type = /datum/ammo/xeno/acid_shotgun

/datum/action/xeno_action/onclick/toggle_long_range/trapper
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/activable/tail_stab/boiler
	name = "Toxic Tail Stab"

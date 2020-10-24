/datum/action/xeno_action/onclick/toggle_long_range/boiler
	movement_datum_type = /datum/event_handler/xeno_zoom_onmovement/buffer
	should_delay = TRUE
	delay = 20

/datum/action/xeno_action/activable/bombard
	name = "Bombard"
	ability_name = "bombard"
	action_icon_state = "bombard"
	plasma_cost = 75
	macro_path = /datum/action/xeno_action/verb/verb_bombard
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 245

	// Range and other config
	var/effect_range = 3
	var/effect_type = /obj/effect/xenomorph/boiler_bombard
	var/activation_delay = 15
	var/range = 15

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

/datum/action/xeno_action/onclick/dump_acid
	name = "Dump Acid"
	ability_name = "dump acid"
	action_icon_state = "dump_acid"
	plasma_cost = 10
	macro_path = /datum/action/xeno_action/verb/verb_dump_acid
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 340

	var/buffs_duration = 60
	var/cooldown_duration = 350

	var/speed_buff_amount = 0.5

	// List of types of actions to place on 20-second CD
	// if you ever want to subtype this for a strain or whatever, just change this var on the subtype
	var/action_types_to_cd = list(/datum/action/xeno_action/activable/bombard, /datum/action/xeno_action/activable/acid_lance)

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
	movement_datum_type = XENOZOOM_NO_MOVEMENT_HANDLER
	should_delay = FALSE
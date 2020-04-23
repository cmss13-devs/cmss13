/datum/action/xeno_action/activable/pounce/runner
	name = "Pounce"
	action_icon_state = "pounce"
	ability_name = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	cooldowns = list(40, 35, 30, 25)
	plasma_cost = 10

	// Config options
	knockdown = TRUE				// Should we knock down the target?
	knockdown_duration = 1
	slash = FALSE					// Do we slash upon reception?
	freeze_self = TRUE				// Should we freeze ourselves after the lunge?
	freeze_time = 5					// 5 for runners
	can_be_shield_blocked = TRUE	// Some legacy stuff, self explanatory

/datum/action/xeno_action/onclick/toggle_long_range/runner
	movement_datum_type = XENOZOOM_NO_MOVEMENT_HANDLER
	should_delay = FALSE

/datum/action/xeno_action/activable/runner_skillshot
	name = "Bone Spur"
	action_icon_state = "runner_bonespur"
	ability_name = "bone spur"
	macro_path = /datum/action/xeno_action/verb/verb_runner_bonespurs
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	cooldowns = list(130, 120, 110, 100)
	plasma_cost = 30

	var/ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot

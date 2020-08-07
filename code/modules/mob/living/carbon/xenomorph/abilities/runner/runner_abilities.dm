/datum/action/xeno_action/activable/pounce/runner
	name = "Pounce"
	action_icon_state = "pounce"
	ability_name = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 30
	plasma_cost = 0

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
	xeno_cooldown = 110
	plasma_cost = 0

	var/ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot

/datum/action/xeno_action/activable/acider_acid
	name = "Corrosive Acid"
	action_icon_state = "corrosive_acid"
	ability_name = "acider acid"
	var/acid_type = /obj/effect/xenomorph/acid/strong
	macro_path = /datum/action/xeno_action/verb/verb_acider_acid
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	var/acid_cost = 100

/datum/action/xeno_action/activable/acider_for_the_hive
	name = "For the Hive!"
	action_icon_state = "screech"
	ability_name = "for the hive"
	macro_path = /datum/action/xeno_action/verb/verb_acider_sacrifice
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	var/minimal_acid = 200
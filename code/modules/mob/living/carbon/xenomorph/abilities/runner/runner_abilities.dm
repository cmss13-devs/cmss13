/datum/action/xeno_action/activable/pounce/runner
	name = "Pounce"
	action_icon_state = "pounce"
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 3 SECONDS
	plasma_cost = 0

	// Config options
	knockdown = TRUE // Should we knock down the target?
	knockdown_duration = 1
	slash = FALSE // Do we slash upon reception?
	freeze_self = TRUE // Should we freeze ourselves after the lunge?
	freeze_time = 5 // 5 for runners
	can_be_shield_blocked = TRUE // Some legacy stuff, self explanatory

/datum/action/xeno_action/onclick/toggle_long_range/runner
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/runner_skillshot
	name = "Bone Spur"
	action_icon_state = "runner_bonespur"
	macro_path = /datum/action/xeno_action/verb/verb_runner_bonespurs
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 11 SECONDS
	plasma_cost = 0

	var/ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot

/datum/action/xeno_action/activable/acider_acid
	name = "Corrosive Acid"
	action_icon_state = "corrosive_acid"
	var/acid_type = /obj/effect/xenomorph/acid/strong
	macro_path = /datum/action/xeno_action/verb/verb_acider_acid
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	var/acid_cost = 100

/datum/action/xeno_action/activable/acider_for_the_hive
	name = "For the Hive!"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_acider_sacrifice
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/minimal_acid = 200

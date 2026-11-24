/datum/action/xeno_action/activable/pounce/runner
	ability_stats_type = /datum/xeno_ability_stats/activable_pounce_runner
	ability_description = "Leap toward a target to knock them down, briefly rooting you in place."
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
	freeze_time = 0.5 SECONDS
	can_be_shield_blocked = TRUE // Some legacy stuff, self explanatory

XENO_ABILITY_STATS(activable_pounce_runner, datum/action/xeno_action/activable/pounce/runner)
	return list(
		XENO_STAT_TILES(distance, "Range"),
		XENO_STAT_CONTROL_LEGACY(knockdown_duration, "Knockdown"),
		XENO_STAT_CONTROL_DURATION(freeze_time, "Self root"),
	)

/datum/action/xeno_action/onclick/toggle_long_range/runner
	handles_movement = FALSE
	should_delay = FALSE
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/runner_skillshot
	ability_stats_type = /datum/xeno_ability_stats/runner_skillshot
	ability_description = "Fire a burst of bone chips at a distant target, slowing on hit."
	name = "Bone Spur"
	action_icon_state = "runner_bonespur"
	macro_path = /datum/action/xeno_action/verb/verb_runner_bonespurs
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 11 SECONDS
	plasma_cost = 0
	cooldown_message = "Our bone spurs grew back."

	var/ammo_type = /datum/ammo/xeno/bone_chips/spread/runner_skillshot

XENO_ABILITY_STATS(runner_skillshot, datum/action/xeno_action/activable/runner_skillshot)
	var/datum/ammo/xeno/bone_chips/ammo = XENO_ABILITY_VALUE(ability, ammo_type)
	return projectile_stats(ammo) + list(
		XENO_STAT_VALUE("Base slow duration", initial(ammo.slow_duration) * /datum/controller/subsystem/human::wait * 0.1, "crowd_control", "s."),
	)

/datum/action/xeno_action/activable/acider_acid
	ability_stats_type = /datum/xeno_ability_stats/activable_acider_acid
	ability_description = "Spend stored acid to dissolve an obstacle with a fast, powerful secretion."
	name = "Corrosive Acid"
	action_icon_state = "corrosive_acid"
	var/acid_type = /obj/effect/xenomorph/acid/strong
	macro_path = /datum/action/xeno_action/verb/verb_acider_acid
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	var/acid_cost = 100

XENO_ABILITY_STATS(activable_acider_acid, datum/action/xeno_action/activable/acider_acid)
	return list(
		XENO_STAT_NUMBER(acid_cost, "Acid cost"),
	)

/datum/action/xeno_action/activable/acider_for_the_hive
	ability_stats_type = /datum/xeno_ability_stats/activable_acider_for_the_hive
	ability_description = "Start a delayed acid explosion. More stored acid increases its reach and power."
	name = "For the Hive!"
	action_icon_state = "screech"
	macro_path = /datum/action/xeno_action/verb/verb_acider_sacrifice
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	var/minimal_acid = 200

XENO_ABILITY_STATS(activable_acider_for_the_hive, datum/action/xeno_action/activable/acider_for_the_hive)
	var/capacity = /datum/behavior_delegate/runner_acider::resource_capacity
	var/damage_ratio = /datum/behavior_delegate/runner_acider::caboom_burn_damage_ratio
	var/range_ratio = /datum/behavior_delegate/runner_acider::caboom_burn_range_ratio
	return list(
		XENO_STAT_NUMBER(minimal_acid, "Minimum acid"),
		XENO_STAT_VALUE("Center burn damage at minimum acid", XENO_ABILITY_VALUE(ability, minimal_acid) / damage_ratio, "burn", "."),
		XENO_STAT_VALUE("Center burn damage at full acid", capacity / damage_ratio, "burn", "."),
		XENO_STAT_VALUE("Blast radius at full acid", capacity / range_ratio, null, " tiles (damage falls with distance)."),
	)

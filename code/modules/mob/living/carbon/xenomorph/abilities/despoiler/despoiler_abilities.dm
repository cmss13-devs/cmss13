/datum/action/xeno_action/activable/acid_barrage
	ability_description = "Hold to charge acid shots, then release to fire. Charging consumes Hypertension stacks to add extra shots to the volley."
	ability_stats_type = /datum/xeno_ability_stats/acid_barrage
	name = "Acid Barrage"
	action_icon_state = "volley"
	macro_path = /datum/action/xeno_action/verb/acid_barrage
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 100
	ability_uses_acid_overlay = TRUE
	cooldown_message = "We have replenished our acid stores and are ready to Barrage."

	var/start_time
	var/min_volley = 1
	var/max_volley = 6
	var/max_charge_time = 3 SECONDS
	var/scatter = 30 // Degrees
	var/image/charge_overlay
	var/list/timers = list()

XENO_ABILITY_STATS(acid_barrage, datum/action/xeno_action/activable/acid_barrage)
	return list(
		XENO_STAT_NUMBER(max_volley, "Maximum shots"),
		XENO_STAT_VALUE("Maximum Hypertension bonus shots", 12, null, "."),
	) + projectile_stats(/datum/ammo/xeno/acid/despoiler)

/datum/action/xeno_action/activable/pounce/caustic_embrace
	ability_description = "Lunge and splash acid around your landing. Hold to charge and consume Hypertension stacks to extend the leap, knock down and slash the target, and intensify its acid."
	ability_stats_type = /datum/xeno_ability_stats/caustic_embrace
	name = "Caustic Embrace"
	action_icon_state = "embrace"
	macro_path = /datum/action/xeno_action/verb/caustic_embrace
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 50
	cooldown_message = "We have replenished our acid stores. We can now slash and leave puddles."

	// Pounce config
	distance = 1
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE
	windup_duration = 0.5 SECONDS

	var/weaken_duration = 1
	var/base_damage = 30
	var/image/charge_overlay
	var/max_charge_time = 2 SECONDS
	var/stage = 0
	var/timer
	var/speed_buff_amount = 0.15
	var/speed_buff_per_stack = 0.1
	var/speed_buff_duration = 3 SECONDS
	var/active_speed_buff = 0

XENO_ABILITY_STATS(caustic_embrace, datum/action/xeno_action/activable/pounce/caustic_embrace)
	return list(
		XENO_STAT_TILES(distance, "Range"),
		XENO_STAT_VALUE("Fully charged range", XENO_ABILITY_VALUE(ability, distance) + 4, null, " tiles."),
		XENO_STAT_BURN(base_damage, "Maximum splash burn damage"),
	)

/datum/action/xeno_action/onclick/oozing_wounds
	ability_stats_type = /datum/xeno_ability_stats/oozing_wounds
	ability_description = "Spread acid around yourself. The more wounded you are, the farther it reaches."
	name = "Oozing Wounds"
	action_icon_state = "oozing_wounds"
	macro_path = /datum/action/xeno_action/verb/oozing_wounds
	xeno_cooldown = 25 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 100
	cooldown_message = "We have regained enough energy to spill our blood for the Hive."

XENO_ABILITY_STATS(oozing_wounds, datum/action/xeno_action/onclick/oozing_wounds)
	return spray_stats(/obj/effect/xenomorph/spray/despoiler)

/datum/action/xeno_action/activable/tail_stab/despoiler
	ability_stats_type = /datum/xeno_ability_stats/activable_tail_stab/despoiler
	var/burn_damage_per_acid_level = 15
	ability_description = "Strike an acid coated target to deal extra burn damage based on its acid level."
	name = "Finishing Acid Stab"

XENO_ABILITY_STATS(activable_tail_stab/despoiler, datum/action/xeno_action/activable/tail_stab/despoiler)
	return ..() + list(
		XENO_STAT_BURN(burn_damage_per_acid_level, "Bonus burn damage per acid level"),
	)




/datum/action/xeno_action/activable/xeno_spit/spitter
	ability_stats_type = /datum/xeno_ability_stats/spitter_spit
	ability_description = "Fire a glob of acid at a distant enemy."
	name = "Spit Acid"

XENO_ABILITY_STATS(spitter_spit, datum/action/xeno_action/activable/xeno_spit/spitter)
	return list(
		xeno_stat_row("Uncharged shot", list()),
	) + projectile_stats(/datum/ammo/xeno/acid) + list(
		xeno_stat_row("Charged shot", list()),
	) + projectile_stats(/datum/ammo/xeno/acid/spatter)

/datum/action/xeno_action/onclick/charge_spit
	ability_stats_type = /datum/xeno_ability_stats/onclick_charge_spit
	ability_description = "Empower your next spit at the cost of range and briefly gain speed and armor."
	name = "Charge Spit"
	action_icon_state = "charge_spit"
	macro_path = /datum/action/xeno_action/verb/verb_charge_spit
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 50
	xeno_cooldown = 12 SECONDS

	// Config
	var/duration = 3.5 SECONDS
	var/speed_buff_amount = 0.8 // Go from shit slow to kindafast
	var/armor_buff_amount = 5 // hopefully-minor buff so they can close the distance

	var/buffs_active = FALSE

XENO_ABILITY_STATS(onclick_charge_spit, datum/action/xeno_action/onclick/charge_spit)
	return list(
		XENO_STAT_NUMBER(armor_buff_amount, "Armor gained"),
		XENO_STAT_DURATION(duration, "Buff duration"),
	)

/datum/action/xeno_action/activable/spray_acid/spitter
	ability_stats_type = /datum/xeno_ability_stats/activable_spray_acid/spitter
	ability_description = "Spray acid in a line. Acid coated targets take extra damage and are knocked down. Repeated contact deals less damage with each hit."
	macro_path = /datum/action/xeno_action/verb/verb_spray_acid
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK

	plasma_cost = 50
	xeno_cooldown = 8 SECONDS

	// Configurable options
	spray_type = ACID_SPRAY_LINE // Enum for the shape of spray to do
	spray_distance = 6 // Distance to spray
	spray_effect_type = /obj/effect/xenomorph/spray/weak
	activation_delay = FALSE // Is there an activation delay?

/datum/xeno_ability_stats/activable_spray_acid/spitter/spray_stats(obj/effect/xenomorph/spray/weak/spray)
	return list(
		XENO_STAT_VALUE("First contact burn damage", initial(spray.damage_amount), "burn", "."),
		XENO_STAT_VALUE("Bonus burn damage against acid coated targets", initial(spray.bonus_damage), "burn", "."),
		XENO_STAT_VALUE("Acid coated target knockdown", initial(spray.stun_duration) * GLOBAL_STATUS_MULTIPLIER * 0.1, "crowd_control", "s."),
	)

/datum/action/xeno_action/activable/tail_stab/spitter
	ability_description = "Stab a nearby target and inject molecular acid."
	name = "Corrosive Tail Stab"

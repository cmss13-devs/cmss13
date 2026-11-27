
/// 3 x 3 damage centred on the xenomorph
/datum/action/xeno_action/onclick/rend
	ability_stats_type = /datum/xeno_ability_stats/onclick_rend
	name = "Rend"
	ability_description = "Slash every enemy around you."
	action_icon_state = "rav_eviscerate"
	macro_path = /datum/action_xeno_action/verb/verb_rend
	xeno_cooldown = 2.5 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/base_damage = 25

	var/slash_sounds = list('sound/weapons/alien_claw_flesh1.ogg', 'sound/weapons/alien_claw_flesh2.ogg', 'sound/weapons/alien_claw_flesh3.ogg', 'sound/weapons/alien_claw_flesh4.ogg', 'sound/weapons/alien_claw_flesh5.ogg', 'sound/weapons/alien_claw_flesh6.ogg')
XENO_ABILITY_STATS(onclick_rend, datum/action/xeno_action/onclick/rend)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
	)

/// Screech which puts out lights in a 7 tile radius, slows and dazes.
/datum/action/xeno_action/activable/doom
	ability_stats_type = /datum/xeno_ability_stats/activable_doom
	name = "Doom"
	ability_description = "Extinguish nearby lights and flares, blur enemy vision, daze and heavily slow nearby foes."
	action_icon_state = "screech"
	macro_path = /datum/action_xeno_action/verb/verb_doom
	xeno_cooldown = 45 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_2
	cooldown_message = "Our throat has recovered its strength."

	var/daze_duration = 1
	var/blur_ticks = 1
	var/slow_duration = 4

XENO_ABILITY_STATS(activable_doom, datum/action/xeno_action/activable/doom)
	return list(
		XENO_STAT_CONTROL_LEGACY(daze_duration, "Daze"),
		XENO_STAT_VALUE("Heavy slow", XENO_ABILITY_VALUE(ability, slow_duration) * /datum/controller/subsystem/human::wait * 0.1, "crowd_control", "s."),
	)

/// Leap ability, crashing down dealing major damage to mobs and structures in the area.
/datum/action/xeno_action/activable/destroy
	ability_stats_type = /datum/xeno_ability_stats/activable_destroy
	name = "Destroy"
	ability_description = "Wind up, then leap onto the target area, gibbing enemies beneath you and crushing structures."
	action_icon_state = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_destroy
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 60 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_3
	cooldown_message = "We are ready to crush, destroy, and kill!"

	var/range = 7
	var/leaping = FALSE

XENO_ABILITY_STATS(activable_destroy, datum/action/xeno_action/activable/destroy)
	return list(
		XENO_STAT_TILES(range, "Range"),
	)

/// Shield ability, limits the amount of damage from a single instance of damage to 10% of the xenomorph's max health.
/datum/action/xeno_action/onclick/king_shield
	ability_stats_type = /datum/xeno_ability_stats/onclick_king_shield
	name = "Bulwark of the Hive"
	ability_description = "Shield yourself and nearby allied xenomorphs, limiting the maximum amount of damage taken from hits."
	action_icon_state = "soak"
	macro_path = /datum/action_xeno_action/verb/king_shield
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 60 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_4
	cooldown_message = "We are ready to become a living hiveshield."

	var/shield_duration = 10 SECONDS
	var/area_of_effect = 6
	var/shield_amount = 200

XENO_ABILITY_STATS(onclick_king_shield, datum/action/xeno_action/onclick/king_shield)
	return list(
		XENO_STAT_SHIELD(shield_amount, "Shield"),
		XENO_STAT_VALUE("Duration", XENO_ABILITY_VALUE(ability, shield_duration) * 0.1, "shield", "s."),
		XENO_STAT_TILES(area_of_effect, "Radius"),
	)

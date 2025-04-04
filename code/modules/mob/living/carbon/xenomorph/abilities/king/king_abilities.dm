
/// 3 x 3 damage centred on the xenomorph
/datum/action/xeno_action/onclick/rend
	name = "Rend"
	action_icon_state = "rav_eviscerate"
	macro_path = /datum/action_xeno_action/verb/verb_rend
	xeno_cooldown = 2.5 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/damage = 25

	var/slash_sounds = list('sound/weapons/alien_claw_flesh1.ogg', 'sound/weapons/alien_claw_flesh2.ogg', 'sound/weapons/alien_claw_flesh3.ogg', 'sound/weapons/alien_claw_flesh4.ogg', 'sound/weapons/alien_claw_flesh5.ogg', 'sound/weapons/alien_claw_flesh6.ogg')

/// Screech which puts out lights in a 7 tile radius, slows and dazes.
/datum/action/xeno_action/activable/doom
	name = "Doom"
	action_icon_state = "screech"
	macro_path = /datum/action_xeno_action/verb/verb_doom
	xeno_cooldown = 45 SECONDS
	plasma_cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_2

	var/daze_length_seconds = 1
	var/slow_length_seconds = 4

/// Leap ability, crashing down dealing major damage to mobs and structures in the area.
/datum/action/xeno_action/activable/destroy
	name = "Destroy"
	action_icon_state = "charge"
	macro_path = /datum/action/xeno_action/verb/verb_destroy
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 60 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/range = 7
	var/leaping = FALSE

/// Shield ability, limits the amount of damage from a single instance of damage to 10% of the xenomorph's max health.
/datum/action/xeno_action/onclick/king_shield
	name = "Bulwark of the Hive"
	action_icon_state = "soak"
	macro_path = /datum/action_xeno_action/verb/king_shield
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 60 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_4

	var/shield_duration = 10 SECONDS
	var/area_of_effect = 6
	var/shield_amount = 200

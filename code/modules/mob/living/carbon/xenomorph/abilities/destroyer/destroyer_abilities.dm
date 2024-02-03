
/// 3 x 3 damage centred on the xenomorph
/datum/action/xeno_action/onclick/rend
	name = "Rend"
	action_icon_state = "crest_defense"
	ability_name = "rend"
	macro_path = /datum/action_xeno_action/verb/verb_rend
	xeno_cooldown = 2.5 SECONDS
	plasma cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/damage = 25

	var/slash_sounds = list('sound/weapons/alien_claw_flesh1.ogg',
						'sound/weapons/alien_claw_flesh2.ogg',
						'sound/weapons/alien_claw_flesh3.ogg',
						'sound/weapons/alien_claw_flesh4.ogg',
						'sound/weapons/alien_claw_flesh5.ogg',
						'sound/weapons/alien_claw_flesh6.ogg')

/// Screech which puts out lights in a 7 tile radius, slows and dazes.
/datum/action/xeno_action/activable/doom
	name = "Doom"
	action_icon_state = "crest_defense"
	ability_name = "doom"
	macro_path = /datum/action_xeno_action/verb/verb_doom
	xeno_cooldown = 2.5 SECONDS
	plasma cost = 50
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/daze_length_seconds = 1
	var/slow_length_seconds = 2

	var/extinguish_light_range = 7

/// Leap ability, crashing down dealing major damage to mobs and structures in the area.
/datum/action/xeno_action/activable/destroy
	name = "Destroy"
	action_icon_state = "crest_defense"
	ability_name = "destroy"
	macro_path = /datum/action/xeno_action/verb/verb_destroy
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_4

	var/leaping = FALSE

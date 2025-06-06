/datum/action/xeno_action/activable/bludgeon
	name = "Bludgeon"
	action_icon_state = "bludgeon"
	macro_path = /datum/action/xeno_action/verb/verb_bludgeon
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 8 SECONDS

	var/base_damage = 25
	var/damage_variance = 5

/datum/action/xeno_action/activable/fling/bash
	name = "Bash"
	action_icon_state = "bash"
	macro_path = /datum/action/xeno_action/verb/verb_bash
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 8 SECONDS

	fling_distance = 4
	stun_power = 1
	weaken_power = 1
	slowdown = 2
	fling_damage = 30
	range = 2

/datum/action/xeno_action/activable/pounce/blitz
	name = "Blitz"
	action_icon_state = "blitz1"
	macro_path = /datum/action/xeno_action/verb/verb_blitz
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 15 SECONDS
	plasma_cost = 0

	distance = 4
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE
	can_be_shield_blocked = FALSE

	var/list/datum/weakref/unique_hits = list()
	var/resets = 0
	var/max_resets = 2
	var/reset_timer

/datum/action/xeno_action/activable/brutalize
	name = "Brutalize"
	action_icon_state = "brutalize"
	macro_path = /datum/action/xeno_action/verb/verb_brutalize
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 5 SECONDS
	plasma_cost = 0

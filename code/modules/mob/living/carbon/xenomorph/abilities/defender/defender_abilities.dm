/datum/action/xeno_action/onclick/toggle_crest
	name = "Toggle Crest Defense"
	action_icon_state = "crest_defense"
	ability_name = "toggle crest defense"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_crest
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 1.5 SECONDS
	plasma_cost = 0
	ability_primacy = XENO_PRIMARY_ACTION_1

	var/armor_buff = 5
	var/speed_debuff = 1

/datum/action/xeno_action/activable/headbutt
	name = "Headbutt"
	action_icon_state = "headbutt"
	ability_name = "headbutt"
	macro_path = /datum/action/xeno_action/verb/verb_headbutt
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 40

/datum/action/xeno_action/onclick/tail_sweep
	name = "Tail Sweep"
	action_icon_state = "tail_sweep"
	ability_name = "tail sweep"
	macro_path = /datum/action/xeno_action/verb/verb_tail_sweep
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 10
	xeno_cooldown = 110

/datum/action/xeno_action/activable/fortify
	name = "Fortify"
	action_icon_state = "fortify"
	ability_name = "fortify"
	macro_path = /datum/action/xeno_action/verb/verb_fortify
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 100


/datum/action/xeno_action/activable/tail_slam
	name = "Tail Slam"
	action_icon_state = "tail_slam"
	ability_name = "tail_slam"
	macro_path = /datum/action/xeno_action/verb/verb_tail_slam
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 10
	xeno_cooldown = 80

	var/tail_slam = 3

/datum/action/xeno_action/activable/tail_swing
	name = "Tail Swing"
	action_icon_state = "tail_sweep"
	ability_name = "tail swing"
	macro_path = /datum/action/xeno_action/verb/verb_tail_swing
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 10
	xeno_cooldown = 120

	var/fling_dist = 3
	var/windup = 1

/datum/action/xeno_action/activable/tail_fling
	name = "Tail Fling"
	action_icon_state = "fling"
	ability_name = "Tail Fling"
	macro_path = /datum/action/xeno_action/verb/verb_tail_fling
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 10
	xeno_cooldown = 130

	var/fling_distance = 2
	var/tail_fling_miss = 140

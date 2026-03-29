/datum/action/xeno_action/activable/acid_barrage
	name = "Acid Barrage"
	action_icon_state = "volley"
	macro_path = /datum/action/xeno_action/verb/acid_barrage
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_1
	plasma_cost = 100
	ability_uses_acid_overlay = TRUE

	var/start_time
	var/min_volley = 1
	var/max_volley = 8
	var/empower_modifier = 6
	var/max_charge_time = 3 SECONDS
	var/scatter = 30 // Degrees
	var/image/charge_overlay
	var/list/timers = list()

/datum/action/xeno_action/activable/pounce/caustic_embrace
	name = "Caustic Embrace"
	action_icon_state = "embrace"
	macro_path = /datum/action/xeno_action/verb/caustic_embrace
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 12 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_2
	plasma_cost = 100

	// Pounce config
	distance = 1
	knockdown = FALSE
	slash = FALSE
	freeze_self = FALSE

	var/empowered_distance = 5
	var/weaken_duration = 1
	var/damage = 30

/datum/action/xeno_action/onclick/oozing_wounds
	name = "Oozing wounds"
	action_icon_state = "oozing_wounds"
	macro_path = /datum/action/xeno_action/verb/oozing_wounds
	xeno_cooldown = 25 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_3
	plasma_cost = 100

/datum/action/xeno_action/onclick/catalyze
	name = "Catalyze"
	action_icon_state = "catalyze"
	macro_path = /datum/action/xeno_action/verb/catalyze
	xeno_cooldown = 20 SECONDS
	ability_primacy = XENO_PRIMARY_ACTION_4
	plasma_cost = 0

	var/duration = 10 SECONDS

/datum/action/xeno_action/activable/tail_stab/despoiler
	name = "Finishing Acid Stab"
	charge_time = 2 SECONDS


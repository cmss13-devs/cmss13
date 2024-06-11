// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	ability_name = "burrow"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/burrow/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner

	if(SSticker?.mode?.hardcore)
		to_chat(X, SPAN_XENOWARNING("A certain presence is preventing us from burrowing here."))
		return

	if(HAS_TRAIT(X, TRAIT_ABILITY_BURROWED))
		X.tunnel(get_turf(A))
	else
		X.burrow()
	return ..()

/datum/action/xeno_action/onclick/tremor
	name = "Tremor (100)"
	action_icon_state = "stomp"
	ability_name = "tremor"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/tremor/use_ability()
	var/mob/living/carbon/xenomorph/X = owner
	X.tremor()
	return ..()

// Sapper
/datum/action/xeno_action/activable/sapper_punch
	name = "Punch"
	action_icon_state = "punch"
	ability_name = "punch"
	macro_path = /datum/action/xeno_action/verb/verb_punch
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 4 SECONDS

	var/base_damage = 20
	var/damage_variance = 10

/datum/action/xeno_action/onclick/demolish
	name = "Demolish"
	action_icon_state = "rav_enrage"
	ability_name = "demolish"
	macro_path = /datum/action/xeno_action/verb/verb_demolish
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 45 SECONDS
	plasma_cost = 100

/datum/action/xeno_action/onclick/earthquake
	name = "Earthquake"
	action_icon_state = "stomp"
	ability_name = "earthquake"
	macro_path = /datum/action/xeno_action/verb/verb_earthquake
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 40 SECONDS
	plasma_cost = 100

/datum/action/xeno_action/activable/boulder_toss
	name = "Boulder Toss"
	action_icon_state = "bombard"
	ability_name = "boulder toss"
	macro_path = /datum/action/xeno_action/verb/verb_boulder_toss
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 90 SECONDS
	plasma_cost = 100

	var/aim_turf = FALSE
	var/ammo_type = /datum/ammo/xeno/sapper_stone

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
/datum/action/xeno_action/onclick/demolish
	name = "Demolish"
	action_icon_state = "rav_enrage"
	ability_name = "demolish"
	macro_path = /datum/action/xeno_action/verb/verb_demolish
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 45 SECONDS
	plasma_cost = 100

/datum/action/xeno_action/activable/tail_axe
	name = "Tail Axe"
	action_icon_state = "prae_impale"
	ability_name = "tail axe"
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 8 SECONDS
	ability_primacy = XENO_TAIL_STAB

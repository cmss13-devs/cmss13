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

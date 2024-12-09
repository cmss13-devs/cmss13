// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/burrow/use_ability(atom/atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(SSticker?.mode?.hardcore)
		to_chat(xeno, SPAN_XENOWARNING("A certain presence is preventing us from burrowing here."))
		return

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		xeno.tunnel(get_turf(atom))
	else
		xeno.burrow()
	return ..()

/datum/action/xeno_action/onclick/tremor
	name = "Tremor (100)"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/tremor/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.tremor()
	return ..()
	xeno_cooldown = 45 SECONDS
	plasma_cost = 100

// Resin Shark Abilities

/datum/action/xeno_action/activable/sweep
	name = "Tail Sweep"
	action_icon_state = "agility_on"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 2 SECONDS

/datum/action/xeno_action/activable/chomp
	name = "Chomp"
	action_icon_state = "headbite"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 2 SECONDS

/datum/action/xeno_action/onclick/submerge
	name = "Submerge"
	action_icon_state = "stomp"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/resin_plasma_per_step = 2
	var/ground_plasma_per_step = 15


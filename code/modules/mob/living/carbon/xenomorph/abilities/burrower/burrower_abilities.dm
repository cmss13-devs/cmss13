// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/burrow/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/xenomorph = owner

	if(SSticker?.mode?.hardcore)
		to_chat(xenomorph, SPAN_XENOWARNING("A certain presence is preventing us from burrowing here."))
		return

	if(HAS_TRAIT(xenomorph, TRAIT_ABILITY_BURROWED))
		xenomorph.tunnel(get_turf(A))
	else
		xenomorph.burrow()
	return ..()

/datum/action/xeno_action/onclick/tremor
	name = "Tremor (100)"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 45 SECONDS
	plasma_cost = 100

/datum/action/xeno_action/onclick/build_tunnel
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro
	xeno_cooldown =  4 MINUTES
	cooldown_message = "We can dig a tunnel again."


// Burrower Abilities

// Burrow
/datum/action/xeno_action/activable/burrow
	name = "Burrow"
	action_icon_state = "agility_on"
	macro_path = /datum/action/xeno_action/verb/verb_burrow
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

	var/used_digging = FALSE
	var/digging_timer = 2 SECONDS
	var/burrow_timer = 20 SECONDS

	var/burrow_cooldown = 2 SECONDS
	var/digging_cooldown = 7 SECONDS

/datum/action/xeno_action/activable/burrow/use_ability(atom/target_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	XENO_ACTION_CHECK(xeno)

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_BURROWED))
		digging(get_turf(target_atom))
	else
		burrow()
	return ..()

/datum/action/xeno_action/onclick/tremor
	name = "Tremor (100)"
	action_icon_state = "stomp"
	macro_path = /datum/action/xeno_action/verb/verb_tremor
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 30 SECONDS
	plasma_cost = 100

/datum/action/xeno_action/onclick/build_tunnel
	name = "Dig Tunnel (200)"
	action_icon_state = "build_tunnel"
	plasma_cost = 200
	macro_path = /datum/action/xeno_action/verb/verb_dig_tunnel
	action_type = XENO_ACTION_ACTIVATE //doesn't really need a macro
	xeno_cooldown =  4 MINUTES
	cooldown_message = "We can dig a tunnel again."

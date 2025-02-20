/datum/action/xeno_action/activable/throw_hugger
	name = "Use/Throw Facehugger"
	action_icon_state = "throw_hugger"
	macro_path = /datum/action/xeno_action/verb/verb_throw_facehugger
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3

/datum/action/xeno_action/activable/throw_hugger/action_cooldown_check()
	if(owner)
		var/mob/living/carbon/xenomorph/carrier/X = owner
		return !X.threw_a_hugger
	return TRUE //When we first add the ability we still do this check, but owner is null, so a workaround

/datum/action/xeno_action/activable/retrieve_egg
	name = "Retrieve Egg"
	action_icon_state = "retrieve_egg"
	macro_path = /datum/action/xeno_action/verb/verb_retrieve_egg
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/set_hugger_reserve
	name = "Set Hugger Reserve"
	action_icon_state = "xeno_banish"

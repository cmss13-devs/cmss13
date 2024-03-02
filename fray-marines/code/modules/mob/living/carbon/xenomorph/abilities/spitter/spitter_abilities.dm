//////////////////////////// SUPPRESSOR ABILITIES

/datum/action/xeno_action/onclick/shift_spits/suppressor
	action_icon_state = "prae_aid"
	macro_path = /datum/action/xeno_action/verb/verb_toggle_spit_type
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 1 SECONDS // Spam prevention

/datum/action/xeno_action/onclick/shift_spits/suppressor/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(..() == TRUE && action_cooldown_check() && (X.ammo.type in X.spit_types))
		return TRUE
	return FALSE

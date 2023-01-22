/datum/action/xeno_action/activable/pounce/lurker
	macro_path = /datum/action/xeno_action/verb/verb_pounce
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 60
	plasma_cost = 20

	// Config options
	distance = 6
	knockdown = FALSE
	knockdown_duration = 2.5
	freeze_self = FALSE
	freeze_time = 15
	can_be_shield_blocked = TRUE

/datum/action/xeno_action/activable/pounce/lurker/additional_effects_always()
	var/mob/living/carbon/Xenomorph/xeno_owner = owner
	if (!istype(xeno_owner))
		return

	var/datum/action/xeno_action/onclick/lurker_invisibility/invisibility_action = get_xeno_action_by_type(xeno_owner, /datum/action/xeno_action/onclick/lurker_invisibility)
	if (!invisibility_action)
		return

	for(var/mob/living/carbon/carbon_hit in get_turf(xeno_owner))
		if(!carbon_hit.ally_of_hivenumber(xeno_owner.hivenumber))
			invisibility_action.invisibility_off()
			return

/datum/action/xeno_action/activable/pounce/lurker/additional_effects(mob/living/L)
	var/mob/living/carbon/Xenomorph/xeno_owner = owner
	if (!istype(xeno_owner))
		return
	var/datum/action/xeno_action/onclick/lurker_invisibility/invisibility_action = get_xeno_action_by_type(xeno_owner, /datum/action/xeno_action/onclick/lurker_invisibility)
	if (invisibility_action && freeze_self)
		RegisterSignal(xeno_owner, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF, PROC_REF(unregister_and_unfreeze))
		addtimer(CALLBACK(src, PROC_REF(unregister_and_unfreeze)), freeze_time + 1)

/datum/action/xeno_action/activable/pounce/lurker/proc/unregister_and_unfreeze()
	SIGNAL_HANDLER
	if(owner.frozen)
		end_pounce_freeze()
		return
	UnregisterSignal(owner, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF)

/datum/action/xeno_action/onclick/lurker_invisibility
	name = "Turn Invisible"
	action_icon_state = "lurker_invisibility"
	ability_name = "turn invisible"
	macro_path = /datum/action/xeno_action/verb/verb_lurker_invisibility
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 15 SECONDS //The cooldown starts AFTER the invisibility ends, not when the ability is first used
	plasma_cost = 20
	var/duration = 30 SECONDS
	var/alpha_amount = 25
	var/speed_buff = 0.20
	COOLDOWN_DECLARE(invisibility_start)

// tightly coupled 'buff next slash' action
/datum/action/xeno_action/onclick/lurker_assassinate
	name = "Crippling Strike"
	action_icon_state = "lurker_inject_neuro"
	ability_name = "crippling strike"
	macro_path = /datum/action/xeno_action/verb/verb_crippling_strike
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 100
	plasma_cost = 20

	var/buff_duration = 50

// VAMP LURKER ABILITIES

/datum/action/xeno_action/activable/pounce/rush
	name = "Rush"
	action_icon_state = "pounce"
	ability_name = "Rush"
	macro_path = /datum/action/xeno_action/verb/verb_rush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 60
	plasma_cost = 0

	// Config options
	distance = 4
	knockdown = FALSE
	freeze_self = FALSE

/datum/action/xeno_action/activable/flurry
	name = "Flurry"
	action_icon_state = "rav_spike"
	ability_name = "Flurry"
	macro_path = /datum/action/xeno_action/verb/verb_flurry
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 30

/datum/action/xeno_action/activable/tail_jab
	name = "Tail Jab"
	action_icon_state = "prae_pierce"
	ability_name = "Tail Jab"
	macro_path = /datum/action/xeno_action/verb/verb_tail_jab
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 70

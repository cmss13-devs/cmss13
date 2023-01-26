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
	freeze_self = TRUE
	freeze_time = 15
	can_be_shield_blocked = TRUE

/datum/action/xeno_action/activable/pounce/lurker/additional_effects_always()
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (X.mutation_type == LURKER_NORMAL)
		var/found = FALSE
		for (var/mob/living/carbon/human/H in get_turf(X))
			found = TRUE
			break

		if (found)
			var/datum/action/xeno_action/onclick/lurker_invisibility/LIA = get_xeno_action_by_type(X, /datum/action/xeno_action/onclick/lurker_invisibility)
			if (istype(LIA))
				LIA.invisibility_off()

/datum/action/xeno_action/activable/pounce/lurker/additional_effects(mob/living/L)
	var/mob/living/carbon/xenomorph/X = owner
	if (!istype(X))
		return

	if (X.mutation_type == LURKER_NORMAL)
		RegisterSignal(X, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF, PROC_REF(remove_freeze))

/datum/action/xeno_action/activable/pounce/lurker/proc/remove_freeze(mob/living/carbon/xenomorph/X)
	SIGNAL_HANDLER

	var/datum/behavior_delegate/lurker_base/BD = X.behavior_delegate
	if (istype(BD))
		UnregisterSignal(X, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF)
		end_pounce_freeze()

/datum/action/xeno_action/onclick/lurker_invisibility
	name = "Turn Invisible"
	action_icon_state = "lurker_invisibility"
	ability_name = "turn invisible"
	macro_path = /datum/action/xeno_action/verb/verb_lurker_invisibility
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 1 // This ability never goes off cooldown 'naturally'. Cooldown is applied manually as a super-large value in the use_ability proc
					// and reset by the behavior_delegate whenever the ability ends (because it can be ended by things like slashes, that we can't easily track here)
	plasma_cost = 20

	var/duration = 30 SECONDS // 30 seconds base
	var/invis_timer_id = TIMER_ID_NULL
	var/alpha_amount = 25
	var/speed_buff = 0.20

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
	ability_name = "rush"
	macro_path = /datum/action/xeno_action/verb/verb_rush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 6 SECONDS
	plasma_cost = 0

	// Config options
	distance = 4
	knockdown = FALSE
	freeze_self = FALSE

/datum/action/xeno_action/activable/flurry
	name = "Flurry"
	action_icon_state = "rav_spike"
	ability_name = "flurry"
	macro_path = /datum/action/xeno_action/verb/verb_flurry
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 3 SECONDS

/datum/action/xeno_action/activable/tail_jab
	name = "Tail Jab"
	action_icon_state = "prae_pierce"
	ability_name = "tail jab"
	macro_path = /datum/action/xeno_action/verb/verb_tail_jab
	ability_primacy = XENO_PRIMARY_ACTION_3
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 7 SECONDS

/datum/action/xeno_action/activable/headbite
	name = "Headbite"
	action_icon_state = "headbite"
	ability_name = "headbite"
	macro_path = /datum/action/xeno_action/verb/verb_headbite
	ability_primacy = XENO_PRIMARY_ACTION_4
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 0 SECONDS

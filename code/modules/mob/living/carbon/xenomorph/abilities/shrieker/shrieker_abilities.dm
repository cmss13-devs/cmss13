/datum/action/xeno_action/activable/shriek
	name = "Shriek"
	action_icon_state = "screech"
	ability_name = "Shriek"
	macro_path = /datum/action/xeno_action/verb/verb_shriek
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 50 SECONDS
	plasma_cost = 300

	// Config

	// These values are used to determine the
	// Shriek cost and the switching of different types of shriek

	var/shriek_sound_effect  = "sound/voice/xeno_praetorian_screech.ogg"
	var/curr_effect_type = SHRIEKER_SHRIEK_BUFF

	var/debuff_daze = 3

	var/shriek_cost = 150

	var/buff_range = 6
	var/debuff_range = 3
/datum/action/xeno_action/onclick/shrieker_switch_shriek_type
	name = "Toggle Shriek Type"
	action_icon_state = "roar_motivate" // default = buff
	macro_path = /datum/action/xeno_action/verb/verb_shrieker_switch_shriek_type
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/onclick/shrieker_switch_shriek_type/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/shrieker_switch_shriek_type/use_ability(atom/A)

	var/mob/living/carbon/Xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(TRUE))
		return

	var/datum/action/xeno_action/activable/shriek/shriek_ability = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/shriek)
	if (!istype(shriek_ability))
		return

	if (shriek_ability.curr_effect_type == SHRIEKER_SHRIEK_BUFF)
		action_icon_result = "roar_intimidate"
		shriek_ability.curr_effect_type = SHRIEKER_SHRIEK_DEBUFF
		to_chat(X, SPAN_XENOWARNING("You will now debuff enemies, knocking them down, slowing, and reducing their vision!"))

	else
		action_icon_result = "roar_motivate"
		shriek_ability.curr_effect_type = SHRIEKER_SHRIEK_BUFF
		to_chat(X, SPAN_XENOWARNING("You will now give your allies increased armor and damage with your shriek!"))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)


/datum/action/xeno_action/activable/rooting_slash
	name = "Rooting Slash"
	action_icon_state = "rooting_slash"
	ability_name = "rooting slash"
	macro_path = /datum/action/xeno_action/verb/verb_rooting_slash
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 10 SECONDS
	plasma_cost = 100

	// Root config
	var/root_duration = 2

	// Root check
	var/buffed = FALSE // Are we buffed

	// Range
	var/range = 2

/datum/action/xeno_action/activable/pounce/shrieker
	macro_path = /datum/action/xeno_action/verb/verb_pounce_shrieker
	name = "Dash"
	action_icon_state = "slash_dash"
	ability_name = "Dash"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 10 SECONDS
	plasma_cost = 50

	// Config options
	distance = 3
	knockdown = FALSE
	can_be_shield_blocked = FALSE
	freeze_self = FALSE				// Should we freeze ourselves after the lunge?

/datum/action/xeno_action/activable/acid_throw
	name = "Acid Throw"
	ability_name = "Acid Throw"
	action_icon_state = "blinding_acid"
	plasma_cost = 40
	macro_path = /datum/action/xeno_action/verb/verb_acid_throw
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	xeno_cooldown = 22 SECONDS

	var/throw_cost = 70

	var/delay = 14.5
	var/blinded = 2

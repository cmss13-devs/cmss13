/datum/action/xeno_action/activable/roar
	name = "Roar"
	action_icon_state = "screech"
	ability_name = "Roar"
	macro_path = /datum/action/xeno_action/verb/verb_roar
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 50 SECONDS
	plasma_cost = 300

	// Config

	// These values are used to determine the
	// Screech cost and the switching of different types of screeches

	var/screech_sound_effectt = "sound/voice/xeno_praetorian_screech.ogg"
	var/curr_effect_type = ROYAL_SCREECH_BUFF

	var/debuff_daze = 4

	var/screech_cost = 150


/datum/action/xeno_action/onclick/royal_switch_roar_type
	name = "Toggle Roar Type"
	action_icon_state = "roar_motivate" // default = buff
	macro_path = /datum/action/xeno_action/verb/verb_royal_switch_roar_type
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/onclick/royal_switch_roar_type/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/royal_switch_roar_type/use_ability(atom/A)

	var/mob/living/carbon/Xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/activable/roar/WH = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/roar)
	if (!istype(WH))
		return

	if (WH.curr_effect_type == ROYAL_SCREECH_BUFF)
		action_icon_result = "roar_intimidate"
		WH.curr_effect_type = ROYAL_SCREECH_DEBUFF
		to_chat(X, SPAN_XENOWARNING("You will now debuff enemies, knocking them down, slowing, and reducing their vision!"))

	else
		action_icon_result = "roar_motivate"
		WH.curr_effect_type = ROYAL_SCREECH_BUFF
		to_chat(X, SPAN_XENOWARNING("You will now give your allies increased armor and damage with your roar!"))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)


/datum/action/xeno_action/activable/rooting_slash
	name = "Rooting Slash"
	action_icon_state = "rooting_slash"
	ability_name = "rooting slash"
	macro_path = /datum/action/xeno_action/verb/verb_rooting_slash
	ability_primacy = XENO_PRIMARY_ACTION_2
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 13 SECONDS
	plasma_cost = 100

	// Root config
	var/root_duration = 2

	// Root check
	var/buffed = FALSE // Are we buffed

	// Range
	var/range = 2

/datum/action/xeno_action/activable/pounce/royal
	macro_path = /datum/action/xeno_action/verb/verb_pounce_royal
	name = "Dash"
	action_icon_state = "slash_dash"
	ability_name = "Dash"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 11 SECONDS
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
	xeno_cooldown = 21 SECONDS

	var/throw_cost = 70

	var/delay = 14.5
	var/blinded = 2

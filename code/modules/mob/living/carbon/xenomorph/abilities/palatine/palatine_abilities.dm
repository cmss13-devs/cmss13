/datum/action/xeno_action/onclick/palatine_roar
	name = "Roar"
	action_icon_state = "screech"
	ability_name = "roar"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_1
	xeno_cooldown = 60 SECONDS
	plasma_cost = 50

	var/roar_type = "piercing"
	var/screech_sound_effect = "sound/voice/alien_distantroar_3.ogg"
	var/bonus_damage_scale = 2.5
	var/bonus_speed_scale = 0.05

/datum/action/xeno_action/onclick/palatine_change_roar
	name = "Change Roar"
	action_icon_state = "screech_shift"
	ability_name = "change roar"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_NOT_PRIMARY_ACTION
	plasma_cost = 0

/datum/action/xeno_action/onclick/palatine_change_roar/use_ability(atom/A)
	var/mob/living/carbon/xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/onclick/palatine_roar/PR = get_xeno_action_by_type(X, /datum/action/xeno_action/onclick/palatine_roar)
	if (!istype(PR))
		return

	if (PR.roar_type == "piercing")
		action_icon_result = "screech_disrupt"
		PR.roar_type = "thundering"
		PR.screech_sound_effect = "sound/voice/4_xeno_roars.ogg"
		to_chat(X, SPAN_XENOWARNING("You will now disrupt dangers to the hive!"))

	else
		action_icon_result = "screech_empower"
		PR.roar_type = "piercing"
		PR.screech_sound_effect = "sound/voice/alien_distantroar_3.ogg"
		to_chat(X, SPAN_XENOWARNING("You will now empower your allies with rage!"))

	PR.button.overlays.Cut()
	PR.button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)

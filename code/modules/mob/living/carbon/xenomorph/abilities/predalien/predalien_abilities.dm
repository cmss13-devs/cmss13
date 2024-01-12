/datum/action/xeno_action/onclick/predalien_roar
	name = "Roar"
	action_icon_state = "screech"
	ability_name = "roar"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	xeno_cooldown = 25 SECONDS
	plasma_cost = 0

	var/predalien_roar = list("sound/voice/predalien_roar.ogg")
	var/bonus_damage_scale = 2.5
	var/bonus_speed_scale = 0.05




/datum/action/xeno_action/activable/feralfrenzy
	name = "Feral Frenzy"
	action_icon_state = "rav_eviscerate"
	ability_name = "devastate"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 15 SECONDS
	plasma_cost = 0

	var/activation_delay_aoe = 1 SECONDS
	var/base_damage_aoe = 15
	var/damage_scale_aoe = 10
	var/activation_delay = 1 SECONDS
	var/base_damage = 25
	var/damage_scale = 10 // How much it scales by every kill
	var/targetting = SINGLETARGETGUT


/datum/action/xeno_action/onclick/toggle_gut_targetting
	name = "Toggle Gutting Type"
	action_icon_state = "rav_scissor_cut" // default = heal
	macro_path = ""
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5

/datum/action/xeno_action/onclick/toggle_gut_targetting/can_use_action()
	var/mob/living/carbon/xenomorph/X = owner
	if(X && !X.buckled && !X.is_mob_incapacitated())
		return TRUE

/datum/action/xeno_action/onclick/toggle_gut_targetting/use_ability(atom/A)

	var/mob/living/carbon/xenomorph/X = owner
	var/action_icon_result

	if(!X.check_state(1))
		return

	var/datum/action/xeno_action/activable/feralfrenzy/GT = get_xeno_action_by_type(X, /datum/action/xeno_action/activable/feralfrenzy)
	if (!istype(GT))
		return

	if (GT.targetting == SINGLETARGETGUT)
		action_icon_result = "rav_scissor_cut"
		GT.targetting = AOETARGETGUT
		to_chat(X, SPAN_XENOWARNING("We will now attack everyone around us"))
	else
		action_icon_result = "gut"
		GT.targetting = SINGLETARGETGUT
		to_chat(X, SPAN_XENOWARNING("We will now unleash our rage on one person!"))

	button.overlays.Cut()
	button.overlays += image('icons/mob/hud/actions_xeno.dmi', button, action_icon_result)
	return ..()


/datum/action/xeno_action/onclick/feralrush
	name = "Toughen Up"
	action_icon_state = "charge_spit"
	ability_name = "toughen up"
	macro_path = ""
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 0
	xeno_cooldown = 12 SECONDS

	// Config
	var/duration = 3 SECONDS
	var/speed_buff_amount = 0.8 // Go from shit slow to kindafast
	var/armor_buff_amount = 10 // hopefully-minor buff so they can close the distance

	var/buffs_active = FALSE



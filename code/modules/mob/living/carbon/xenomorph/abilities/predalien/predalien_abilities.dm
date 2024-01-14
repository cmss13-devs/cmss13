/datum/action/xeno_action/onclick/predalien_roar
	name = "Roar"
	action_icon_state = "screech"
	ability_name = "roar"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	macro_path = /datum/action/xeno_action/verb/verb_predalien_roar
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
	macro_path = /datum/action/xeno_action/verb/verb_feralfrenzy
	xeno_cooldown = 15 SECONDS
	plasma_cost = 0

	var/activation_delay_aoe = 1 SECONDS
	var/base_damage_aoe = 15
	var/damage_scale_aoe = 10
	var/activation_delay = 1 SECONDS
	var/base_damage = 25
	var/damage_scale = 10 // How much it scales by every kill
	var/targetting = SINGLETARGETGUT
	var/range = 2


/datum/action/xeno_action/onclick/toggle_gut_targetting
	name = "Toggle Gutting Type"
	action_icon_state = "rav_scissor_cut" // default = heal
	macro_path = /datum/action/xeno_action/verb/verb_toggle_gut_targetting
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5




/datum/action/xeno_action/onclick/feralrush
	name = "Feral Rush Up"
	action_icon_state = "charge_spit"
	ability_name = "toughen up"
	macro_path = /datum/action/xeno_action/verb/verb_feralrush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_ACTIVATE
	plasma_cost = 0
	xeno_cooldown = 12 SECONDS

	// Config
	var/duration = 3 SECONDS
	var/speed_buff_amount = 0.8 // Go from shit slow to kindafast
	var/armor_buff_amount = 10 // hopefully-minor buff so they can close the distance

	var/buffs_active = FALSE



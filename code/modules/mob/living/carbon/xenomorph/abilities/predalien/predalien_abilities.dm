
/datum/action/xeno_action/onclick/feralrush
	name = "Feral Rush"
	action_icon_state = "charge_spit"
	ability_name = "toughen up"
	macro_path = /datum/action/xeno_action/verb/verb_feralrush
	ability_primacy = XENO_PRIMARY_ACTION_1
	action_type = XENO_ACTION_ACTIVATE
	xeno_cooldown = 12 SECONDS

	// Config
	var/speed_duration = 3 SECONDS
	var/armor_duration = 6 SECONDS
	var/speed_buff_amount = 0.8 // Go from shit slow to kindafast
	var/armor_buff_amount = 10 // hopefully-minor buff so they can close the distance

	var/speed_buff = FALSE
	var/armor_buff = FALSE


/datum/action/xeno_action/onclick/predalien_roar
	name = "Roar"
	action_icon_state = "screech"
	ability_name = "roar"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	macro_path = /datum/action/xeno_action/verb/verb_predalien_roar
	xeno_cooldown = 25 SECONDS
	var/predalien_roar = list("sound/voice/predalien_roar.ogg")
	var/bonus_damage_scale = 2.5
	var/bonus_speed_scale = 0.05

/datum/action/xeno_action/activable/feral_smash
	name = "Feral Smash"
	ability_name = "Feral Smash"
	action_icon_state = "lunge"
	action_type = XENO_ACTION_CLICK
	macro_path = /datum/action/xeno_action/verb/feral_smash
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 20 SECONDS

	// Configurables
	var/grab_range = 4
	var/twitch_message_cooldown = 0 //apparently this is necessary for a tiny code that makes the lunge message on cooldown not be spammable, doesn't need to be big so 5 will do.
	var/smash_damage = 20
	var/smash_scale = 10
	var/stun_duration = 3 SECONDS

/datum/action/xeno_action/activable/feralfrenzy
	name = "Feral Frenzy"
	action_icon_state = "rav_eviscerate"
	ability_name = "Feral Frenzy"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4
	macro_path = /datum/action/xeno_action/verb/verb_feralfrenzy
	xeno_cooldown = 15 SECONDS

	//AOE
	var/activation_delay_aoe = 1 SECONDS
	var/base_damage_aoe = 15
	var/damage_scale_aoe = 10
	//SINGLE TARGET
	var/activation_delay = 0.5 SECONDS
	var/base_damage = 25
	var/damage_scale = 10
	var/targeting = SINGLETARGETGUT
	/// The orange used for a AOETARGETGUT
	var/range = 2

/datum/action/xeno_action/onclick/toggle_gut_targeting
	name = "Toggle Gutting Type"
	action_icon_state = "gut" // starting targetting is SINGLETARGETGUT
	macro_path = /datum/action/xeno_action/verb/verb_toggle_gut_targeting
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5

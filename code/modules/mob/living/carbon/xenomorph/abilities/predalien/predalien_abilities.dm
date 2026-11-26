
/datum/action/xeno_action/onclick/feralrush
	ability_stats_type = /datum/xeno_ability_stats/onclick_feralrush
	ability_description = "Briefly increase your movement speed and armor."
	name = "Feral Rush"
	action_icon_state = "rage"
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

XENO_ABILITY_STATS(onclick_feralrush, datum/action/xeno_action/onclick/feralrush)
	return list(
		XENO_STAT_NUMBER(armor_buff_amount, "Armor gained"),
		XENO_STAT_DURATION(armor_duration, "Armor duration"),
		XENO_STAT_DURATION(speed_duration, "Speed duration"),
	)

/datum/action/xeno_action/onclick/predalien_roar
	ability_stats_type = /datum/xeno_ability_stats/onclick_predalien_roar
	ability_description = "Roar to disrupt nearby equipment, break hunter cloaks and empowers allied xenomorphs."
	name = "Roar"
	action_icon_state = "rage_screech"
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_2
	macro_path = /datum/action/xeno_action/verb/verb_predalien_roar
	xeno_cooldown = 25 SECONDS
	var/predalien_roar = list("sound/voice/predalien_roar.ogg")
	var/bonus_damage_scale = 2.5
	var/bonus_speed_scale = 0.05

XENO_ABILITY_STATS(onclick_predalien_roar, datum/action/xeno_action/onclick/predalien_roar)
	return list(
		XENO_STAT_BRUTE(bonus_damage_scale, "Ally bonus brute damage per trophy"),
	)

/datum/action/xeno_action/activable/feral_smash
	ability_stats_type = /datum/xeno_ability_stats/activable_feral_smash
	ability_description = "Leap toward your target and smash down on impact."
	name = "Feral Smash"
	action_icon_state = "powerful_pounce"
	action_type = XENO_ACTION_CLICK
	macro_path = /datum/action/xeno_action/verb/feral_smash
	ability_primacy = XENO_PRIMARY_ACTION_3
	xeno_cooldown = 20 SECONDS

	// Configurables
	var/grab_range = 4
	var/twitch_message_cooldown = 0 //apparently this is necessary for a tiny code that makes the lunge message on cooldown not be spammable, doesn't need to be big so 5 will do.
	var/base_damage = 20
	var/damage_scale = 10
	var/stun_duration = 3 SECONDS

XENO_ABILITY_STATS(activable_feral_smash, datum/action/xeno_action/activable/feral_smash)
	return list(
		XENO_STAT_BRUTE(base_damage, "Base brute damage"),
		XENO_STAT_BRUTE(damage_scale, "Extra brute damage per trophy"),
		XENO_STAT_TILES(grab_range, "Range"),
	)

/datum/action/xeno_action/activable/feralfrenzy
	ability_stats_type = /datum/xeno_ability_stats/activable_feralfrenzy
	ability_description = "Rip into one enemy or slash everyone nearby, depending on your targeting mode."
	name = "Feral Frenzy"
	action_icon_state = "butchering"
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

XENO_ABILITY_STATS(activable_feralfrenzy, datum/action/xeno_action/activable/feralfrenzy)
	return list(
		XENO_STAT_BRUTE(base_damage, "Single target base brute damage"),
		XENO_STAT_BRUTE(damage_scale, "Extra brute damage per trophy"),
		XENO_STAT_BRUTE(base_damage_aoe, "Area base brute damage"),
		XENO_STAT_BRUTE(damage_scale_aoe, "Area bonus per trophy"),
	)

/datum/action/xeno_action/onclick/toggle_gut_targeting
	ability_description = "Switch Feral Frenzy between a single target and everyone around you."
	name = "Toggle Gutting Type"
	action_icon_state = "rav_shard_shed" // starting targetting is SINGLETARGETGUT
	macro_path = /datum/action/xeno_action/verb/verb_toggle_gut_targeting
	action_type = XENO_ACTION_ACTIVATE
	ability_primacy = XENO_PRIMARY_ACTION_5

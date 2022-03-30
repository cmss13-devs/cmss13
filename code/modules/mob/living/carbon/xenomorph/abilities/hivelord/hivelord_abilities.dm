/datum/action/xeno_action/activable/transfer_plasma/hivelord
	ability_primacy = null //fourth macro for drone, its place taken by resin walker for hivelord.
	plasma_transfer_amount = 200
	transfer_delay = 5
	max_range = 7

/datum/action/xeno_action/onclick/toggle_speed
	name = "Resin Walker (50)"
	action_icon_state = "toggle_speed"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_resin_walker
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

/datum/action/xeno_action/onclick/toggle_speed/can_use_action()
	var/mob/living/carbon/Xenomorph/Hivelord/X = owner
	if(X && !X.is_mob_incapacitated() && !X.lying && !X.buckled && (X.weedwalking_activated || X.plasma_stored >= plasma_cost))
		return TRUE

//Mender Abilites

/datum/action/xeno_action/activable/spore_puff
	name = "healing spore puff"
	ability_name = "spore puff"
	action_icon_state = "warden_heal"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_bombard
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 5 SECONDS

	// Range and other config
	var/effect_range = 2
	var/effect_type = /obj/effect/xenomorph/spore_puff
	var/activation_delay = 0 SECONDS
	var/range = 16
	var/cooldown_duration = 5 SECONDS

/datum/action/xeno_action/activable/spore_puff_shield
	name = "warding spore puff"
	ability_name = "spore puff shield"
	action_icon_state = "warden_shield"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_bombard
	action_type = XENO_ACTION_CLICK
	xeno_cooldown = 5 SECONDS

	// Range and other config
	var/effect_range = 2
	var/effect_type = /obj/effect/xenomorph/spore_puff_shield
	var/activation_delay = 0 SECONDS
	var/range = 16
	var/cooldown_duration = 5 SECONDS

var/action_types_to_cd = list(/datum/action/xeno_action/activable/spore_puff, /datum/action/xeno_action/activable/spore_puff_shield)

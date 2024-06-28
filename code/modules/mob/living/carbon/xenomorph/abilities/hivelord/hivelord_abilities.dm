/datum/action/xeno_action/activable/transfer_plasma/hivelord
	ability_primacy = XENO_NOT_PRIMARY_ACTION //fourth macro for drone, its place taken by resin walker for hivelord.
	plasma_transfer_amount = 200
	transfer_delay = 5
	max_range = 7

/datum/action/xeno_action/active_toggle/toggle_speed
	name = "Resin Walker (50)"
	action_icon_state = "toggle_speed"
	plasma_cost = 50
	macro_path = /datum/action/xeno_action/verb/verb_resin_walker
	action_type = XENO_ACTION_CLICK
	ability_primacy = XENO_PRIMARY_ACTION_4

	action_start_message = "We become one with the resin. We feel the urge to run!"
	action_end_message = "We feel less in tune with the resin."
	plasma_use_per_tick = 30

/datum/action/xeno_action/active_toggle/toggle_speed/can_use_action()
	var/mob/living/carbon/xenomorph/hivelord/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated() && xeno.body_position == STANDING_UP && !xeno.buckled) // do we rly need standing up?
		return TRUE

/datum/action/xeno_action/active_toggle/toggle_speed/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/xenomorph/hivelord/xeno = owner
	var/datum/behavior_delegate/hivelord_base/hivelord_delegate = xeno.behavior_delegate

	if(!istype(hivelord_delegate))
		return

	if(hivelord_delegate.resin_walker == TRUE)
		button.icon_state = "template_active"
		action_active = TRUE

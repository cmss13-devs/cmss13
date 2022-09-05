/datum/action/xeno_action/activable/transfer_plasma/hivelord
	ability_primacy = XENO_NOT_PRIMARY_ACTION //fourth macro for drone, its place taken by resin walker for hivelord.
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
	var/mob/living/carbon/Xenomorph/Hivelord/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated() && !xeno.lying && !xeno.buckled && (xeno.weedwalking_activated || xeno.plasma_stored >= plasma_cost))
		return TRUE

/datum/action/xeno_action/onclick/toggle_speed/give_to(mob/living/living_mob)
	. = ..()
	var/mob/living/carbon/Xenomorph/Hivelord/xeno = owner
	if(xeno.weedwalking_activated)
		button.icon_state = "template_active"

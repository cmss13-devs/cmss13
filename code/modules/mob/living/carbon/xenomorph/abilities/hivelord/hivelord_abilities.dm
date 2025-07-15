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

	var/active = FALSE
	var/weed_speed_increase = XENO_SPEED_FASTMOD_TIER_10 * 3

/datum/action/xeno_action/active_toggle/toggle_speed/can_use_action()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(xeno && !xeno.is_mob_incapacitated() && xeno.body_position == STANDING_UP && !xeno.buckled)
		return TRUE

/datum/action/xeno_action/active_toggle/toggle_speed/proc/start_tick()
	addtimer(CALLBACK(src, PROC_REF(plasma_drain_tick)), 1 SECONDS)

/datum/action/xeno_action/active_toggle/toggle_speed/proc/plasma_drain_tick()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!active || !xeno)
		return

	xeno.plasma_stored -= 30

	if(xeno.plasma_stored <= 0)
		disable_resin_walker()
		to_chat(xeno, SPAN_WARNING("We feel dizzy as the world slows down."))
		xeno.recalculate_move_delay = TRUE
		return

	// Schedule next tick
	addtimer(CALLBACK(src, PROC_REF(plasma_drain_tick)), 1 SECONDS)

/datum/action/xeno_action/active_toggle/toggle_speed/enable_toggle()
	. = ..()
	enable_resin_walker()

/datum/action/xeno_action/active_toggle/toggle_speed/disable_toggle()
	. = ..()
	disable_resin_walker()

/datum/action/xeno_action/active_toggle/toggle_speed/proc/enable_resin_walker()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno)
		return

	RegisterSignal(xeno, COMSIG_XENO_MOVEMENT_DELAY, PROC_REF(apply_weed_speed))
	active = TRUE
	xeno.recalculate_move_delay = TRUE
	start_tick()

/datum/action/xeno_action/active_toggle/toggle_speed/proc/disable_resin_walker()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno)
		return

	UnregisterSignal(xeno, COMSIG_XENO_MOVEMENT_DELAY)
	active = FALSE
	xeno.recalculate_move_delay = TRUE

/datum/action/xeno_action/active_toggle/toggle_speed/proc/apply_weed_speed(mob/user, list/speed_data)
	SIGNAL_HANDLER

	var/mob/living/carbon/xenomorph/xeno = owner
	if(!xeno || xeno != user)
		return

	var/turf/Turf = get_turf(xeno)
	if(!Turf)
		return

	var/obj/effect/alien/weeds/turf_weeds = locate() in Turf
	if(!turf_weeds)
		return

	if(turf_weeds.linked_hive && turf_weeds.linked_hive.hivenumber == xeno.hivenumber)
		speed_data["speed"] += weed_speed_increase

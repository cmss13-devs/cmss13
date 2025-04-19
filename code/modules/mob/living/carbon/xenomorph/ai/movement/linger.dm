/datum/xeno_ai_movement/linger

	/// The turf the xeno is currently attempting to travel to
	var/turf/travelling_turf

	/// Distance in turfs that the xeno will try to run to when the marine is not incapacitated or out of view
	var/linger_range = 5

	/// The deviation in turfs of linger_range, gives the bounds a + and - of upper and inner range
	var/linger_deviation = 1

	/// The cooldown for how long the xeno will wait out of view before attempting to re-engage
	COOLDOWN_DECLARE(reengage_cooldown)

	var/reengage_interval = (2 SECONDS)

/datum/xeno_ai_movement/linger/ai_move_target(delta_time)
	var/mob/living/carbon/xenomorph/moving_xeno = parent
	if(moving_xeno.throwing)
		return

	// Always charge forward if sentries/APCs, no real reason to dodge and weave
	var/incapacitated_check = TRUE
	if(istype(moving_xeno.current_target, /mob))
		var/mob/current_target_mob = moving_xeno.current_target
		incapacitated_check = current_target_mob.is_mob_incapacitated()

	if(incapacitated_check)
		return ..()

	check_for_travelling_turf_change(moving_xeno)

	if(!moving_xeno.move_to_next_turf(travelling_turf))
		travelling_turf = get_turf(moving_xeno.current_target)
		return TRUE

#define FIND_NEW_TRAVEL_TURF_LIMIT 5

/datum/xeno_ai_movement/linger/proc/check_for_travelling_turf_change(mob/living/carbon/xenomorph/moving_xeno)
	if(!(moving_xeno in view(world.view, moving_xeno.current_target)) && COOLDOWN_FINISHED(src, reengage_cooldown))
		travelling_turf = get_turf(moving_xeno.current_target)
		COOLDOWN_START(src, reengage_cooldown, reengage_interval)
		moving_xeno.emote("growl")
		return

	if(!travelling_turf || get_dist(travelling_turf, moving_xeno) <= 0)
		for(var/i = 0 to FIND_NEW_TRAVEL_TURF_LIMIT)
			travelling_turf = get_random_turf_in_range_unblocked(moving_xeno.current_target, linger_range + linger_deviation, linger_range - linger_deviation)

			if(!travelling_turf)
				continue

			var/travelling_turf_dir = get_dir(moving_xeno, travelling_turf)
			var/current_target_dir = get_dir(moving_xeno, moving_xeno.current_target)

			if(current_target_dir != travelling_turf_dir && current_target_dir != turn(travelling_turf_dir, 45) && current_target_dir != turn(travelling_turf_dir, -45))
				break

	if(!travelling_turf)
		travelling_turf = get_turf(moving_xeno.current_target)
		return

#undef FIND_NEW_TRAVEL_TURF_LIMIT

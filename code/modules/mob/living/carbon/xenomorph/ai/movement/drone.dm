#define BLACKLIST_TURF_TIMEOUT (180 SECONDS)

/datum/xeno_ai_movement/drone
	var/last_home_turf
	var/list/blacklisted_turfs = list()

/datum/xeno_ai_movement/drone/Destroy(force, ...)
	. = ..()
	blacklisted_turfs = null

//drones expand the hive
/datum/xeno_ai_movement/drone/ai_move_idle(delta_time)
	if(!GLOB.ai_xeno_weeding)
		return ..()

	var/mob/living/carbon/xenomorph/idle_xeno = parent

	if(idle_xeno.throwing)
		return

	if(home_turf)
		if(get_dist(home_turf, idle_xeno) > max_distance_from_home)
			home_turf = null
			return

		if(get_dist(home_turf, idle_xeno) <= 0)
			var/datum/action/xeno_action/onclick/plant_weeds/plant_weed_action = get_action(parent, /datum/action/xeno_action/onclick/plant_weeds)
			INVOKE_ASYNC(plant_weed_action, TYPE_PROC_REF(/datum/action/xeno_action/onclick/plant_weeds, use_ability_wrapper))
			home_turf = null
			return

		if(!idle_xeno.move_to_next_turf(home_turf, home_locate_range))
			home_turf = null
			return

		return

	if(next_home_search > world.time)
		return

	var/turf/current_turf = get_turf(idle_xeno)
	next_home_search = world.time + home_search_delay

	var/shortest_distance
	for(var/turf/potential_home as anything in shuffle(RANGE_TURFS(home_locate_range, current_turf)))
		if(!check_turf(potential_home))
			continue

		if(!isnull(shortest_distance) && get_dist(idle_xeno, potential_home) > shortest_distance)
			continue

		shortest_distance = get_dist(idle_xeno, potential_home)
		home_turf = potential_home

	if(!home_turf)
		idle_xeno.set_resting(TRUE, FALSE, TRUE)
		return

	idle_xeno.set_resting(FALSE, FALSE, TRUE)

	if(home_turf == last_home_turf)
		blacklisted_turfs += home_turf
		addtimer(CALLBACK(src, PROC_REF(unblacklist_turf), home_turf), BLACKLIST_TURF_TIMEOUT)

	last_home_turf = home_turf

/datum/xeno_ai_movement/drone/proc/unblacklist_turf(turf/unblacklisting_turf)
	blacklisted_turfs -= unblacklisting_turf

/datum/xeno_ai_movement/drone/proc/check_turf(turf/checked_turf)
	var/area/found_area = get_area(checked_turf)
	if(found_area.flags_area & AREA_NOTUNNEL)
		return FALSE

	if(found_area.flags_area & AREA_UNWEEDABLE)
		return FALSE

	if(!found_area.can_build_special)
		return FALSE

	if(checked_turf in blacklisted_turfs)
		return FALSE

	var/obj/effect/alien/weeds/checked_weeds = checked_turf.weeds
	if(checked_weeds && IS_SAME_HIVENUMBER(checked_weeds, parent))
		return FALSE

	if(checked_turf.is_weedable() < FULLY_WEEDABLE)
		return FALSE

	var/obj/effect/alien/weeds/found_weeds = locate(/obj/effect/alien/weeds/node) in range(3, checked_turf)
	if(found_weeds && IS_SAME_HIVENUMBER(found_weeds, parent))
		return FALSE

	if(checked_turf.density)
		return FALSE

	var/blocked = FALSE
	for(var/atom/potential_blocker as anything in checked_turf)
		if(parent != potential_blocker && (potential_blocker.density || potential_blocker.can_block_movement))
			blocked = TRUE
			break

	if(blocked)
		return FALSE

	for(var/obj/structure/struct in checked_turf)
		if(struct.density && !(struct.flags_atom & ON_BORDER))
			return FALSE

	return TRUE

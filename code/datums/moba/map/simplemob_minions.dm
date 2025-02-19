/*mob/living/carbon/xenomorph/lesser_drone/moba // Zonenote componentize?
	need_weeds = FALSE
	var/atom/movable/target
	var/turf/next_turf_target
	var/is_moving_to_next_point = FALSE
	var/is_moving_to_target = FALSE
	var/walk_to_delay = 0.7 SECONDS

/mob/living/carbon/xenomorph/lesser_drone/moba/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	START_PROCESSING(SSprocessing, src)
	a_intent_change(INTENT_HARM)

/mob/living/carbon/xenomorph/lesser_drone/moba/Destroy()
	target = null
	next_turf_target = null
	return ..()

/mob/living/carbon/xenomorph/lesser_drone/moba/process(delta_time) // We do the bound_width/height bullshit so that AI can actually attack large objects
	if(!target)
		try_find_target()

	var/target_dist = get_dist(src, target)

	if(target && (target_dist >= 4))
		target = null

	if(target && (target_dist > ((target.bound_height + target.bound_width) / 64)))
		move_to_target()

	if(target && ((target_dist <= ((target.bound_height + target.bound_width) / 64))))
		attack_target()

	if(!target && !is_moving_to_next_point)
		move_to_next_point()

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/try_find_target()
	var/mob/living/best_target_found
	var/best_weight_found
	var/list/view_list = view(3, src)
	for(var/mob/living/possible_target in view_list)
		var/weight = 0
		if((possible_target.stat == DEAD) || hive.is_ally(possible_target))
			continue

		if(HAS_TRAIT(possible_target, TRAIT_MOBA_ATTACKED_HIVE(hive.hivenumber))) // If attacked a friendly player, they're on our shitlist
			weight = 3

		else if(HAS_TRAIT(possible_target, TRAIT_MOBA_PARTICIPANT))
			weight = 1

		else if(istype(possible_target, /mob/living/carbon/xenomorph/lesser_drone/moba)) // zonenote update if other types are added
			weight = 2
		// Maybe add a weight 4 if the target recently attacked a friendly player?

		if(weight > best_weight_found)
			best_target_found = possible_target
			best_weight_found = weight

	for(var/obj/effect/alien/resin/moba_turret/turret in view_list)
		if(turret.hivenumber == hive.hivenumber)
			continue

		if(3 > best_weight_found)
			best_target_found = turret

	target = best_target_found
	if(target) // Zonenote consider having them return to the tile they came from if they move to target someone
		is_moving_to_next_point = FALSE
		walk(src, 0) // stops them walking

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/attack_target()
	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.stat == DEAD)
			target = null
			return

	is_moving_to_target = FALSE
	target.attack_alien(src)

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/move_to_target()
	walk_to(src, target, 1, walk_to_delay)
	is_moving_to_target = TRUE

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/move_to_next_point()
	is_moving_to_next_point = TRUE
	walk_to(src, next_turf_target, 0, walk_to_delay)

/mob/living/carbon/xenomorph/lesser_drone/moba/Bump(atom/obstacle)
	. = ..()
	if(isliving(obstacle) && !hive.is_ally(obstacle))
		target = obstacle
		walk(src, 0)
		is_moving_to_next_point = FALSE
*/

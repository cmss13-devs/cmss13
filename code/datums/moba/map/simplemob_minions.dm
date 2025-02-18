/mob/living/carbon/xenomorph/lesser_drone/moba
	need_weeds = FALSE
	var/mob/living/target
	var/turf/next_turf_target
	var/is_moving_to_next_point = FALSE
	var/is_moving_to_target = FALSE
	var/walk_to_delay = 8

/mob/living/carbon/xenomorph/lesser_drone/moba/Initialize(mapload, mob/living/carbon/xenomorph/old_xeno, hivenumber)
	. = ..()
	START_PROCESSING(SSprocessing, src)
	a_intent_change(INTENT_HARM)

/mob/living/carbon/xenomorph/lesser_drone/moba/Destroy()
	target = null
	next_turf_target = null
	return ..()

/mob/living/carbon/xenomorph/lesser_drone/moba/process(delta_time)
	if(!target)
		try_find_target()

	var/target_dist = get_dist(src, target)

	if(target && (target_dist >= 4))
		target = null

	if(target && (target_dist > 1))
		move_to_target()

	if(target && (target_dist <= 1))
		attack_target()

	if(!target && !is_moving_to_next_point)
		move_to_next_point()

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/try_find_target()
	var/mob/living/best_target_found
	var/best_weight_found
	for(var/mob/living/possible_target in view(2, src))
		var/weight = 0
		if((possible_target.stat == DEAD) || hive.is_ally(possible_target))
			continue

		if(HAS_TRAIT(possible_target, TRAIT_MOBA_PARTICIPANT))
			weight = 1

		else if(istype(possible_target, /mob/living/carbon/xenomorph/lesser_drone/moba)) // zonenote update if other types are added
			weight = 2
		// Maybe add a weight 3 if the target recently attacked a friendly player?

		if(weight > best_weight_found)
			best_target_found = possible_target
			best_weight_found = weight

	target = best_target_found
	if(target) // Zonenote consider having them return to the tile they came from if they move to target someone
		is_moving_to_next_point = FALSE

/mob/living/carbon/xenomorph/lesser_drone/moba/proc/attack_target()
	if(target.stat == DEAD)
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
	if(isliving(obstacle))
		var/mob/living/living = obstacle
		target = living
		is_moving_to_next_point = FALSE

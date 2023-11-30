
/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/is_mob_restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/check_view_change(new_size, atom/source)
	LAZYREMOVE(view_change_sources, source)
	var/highest_view = 0
	for(var/view_source as anything in view_change_sources)
		var/view_rating = view_change_sources[view_source]
		if(highest_view < view_rating)
			highest_view = view_rating
	if(source && new_size != GLOB.world_view_size)
		LAZYSET(view_change_sources, source, new_size)
	if(new_size < highest_view)
		new_size = highest_view
	return new_size

/mob/living/carbon/proc/handle_queen_screech(mob/living/carbon/xenomorph/queen/queen, list/mobs_in_view)
	if(!(src in mobs_in_view))
		return
	var/dist = get_dist(queen, src)
	if(dist <= 4)
		to_chat(src, SPAN_DANGER("An ear-splitting guttural roar shakes the ground beneath your feet!"))
		adjust_effect(4, STUN)
		apply_effect(4, WEAKEN)
		if(!ear_deaf || !HAS_TRAIT(src, TRAIT_EAR_PROTECTION))
			AdjustEarDeafness(5) //Deafens them temporarily
	else if(dist >= 5 && dist < 7)
		adjust_effect(3, STUN)
		if(!ear_deaf || !HAS_TRAIT(src, TRAIT_EAR_PROTECTION))
			AdjustEarDeafness(2)
		to_chat(src, SPAN_DANGER("The roar shakes your body to the core, freezing you in place!"))

///Checks if something prevents sharp objects from interacting with the mob (such as armor blocking surgical tools / surgery)
/mob/living/carbon/proc/get_sharp_obj_blocker(obj/limb/limb)
	return null

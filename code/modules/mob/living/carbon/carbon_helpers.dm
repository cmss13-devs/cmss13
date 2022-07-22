
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

/mob/living/carbon/verb/warcry_macro()
	set name = "warcry"
	set hidden = 1

	to_chat(usr, SPAN_WARNING("Your species doesn't have a warcry associated with it!"))

/mob/living/carbon/human/warcry_macro()
	emote("warcry", player_caused = TRUE)

/mob/living/carbon/human/yautja/warcry_macro()
	emote("roar", player_caused = TRUE)

/mob/living/carbon/Xenomorph/warcry_macro()
	emote("roar", player_caused = TRUE)

/mob/living/carbon/verb/medic_macro()
	set name = "medic"
	set hidden = 1

	to_chat(usr, SPAN_WARNING("Your species doesn't have a help cry associated with it!"))

/mob/living/carbon/human/medic_macro()
	emote("medic", player_caused = TRUE)

/mob/living/carbon/human/yautja/medic_macro()
	emote("click", player_caused = TRUE)

/mob/living/carbon/Xenomorph/medic_macro()
	emote("needhelp", player_caused = TRUE)

/mob/living/carbon/check_view_change(var/new_size, var/atom/source)
	LAZYREMOVE(view_change_sources, source)
	var/highest_view = 0
	for(var/view_source as anything in view_change_sources)
		var/view_rating = view_change_sources[view_source]
		if(highest_view < view_rating)
			highest_view = view_rating
	if(source && new_size != world_view_size)
		LAZYSET(view_change_sources, source, new_size)
	if(new_size < highest_view)
		new_size = highest_view
	return new_size

/mob/living/carbon/proc/handle_queen_screech(var/mob/living/carbon/Xenomorph/Queen/queen, var/list/mobs_in_view)
	if(!(src in mobs_in_view))
		return
	scream_stun_timeout = 20 SECONDS
	var/dist = get_dist(queen, src)
	if(dist <= 4)
		to_chat(src, SPAN_DANGER("An ear-splitting guttural roar shakes the ground beneath your feet!"))
		AdjustStunned(4)
		KnockDown(4)
		if(!ear_deaf)
			AdjustEarDeafness(5) //Deafens them temporarily
	else if(dist >= 5 && dist < 7)
		AdjustStunned(3)
		if(!ear_deaf)
			AdjustEarDeafness(2)
		to_chat(src, SPAN_DANGER("The roar shakes your body to the core, freezing you in place!"))

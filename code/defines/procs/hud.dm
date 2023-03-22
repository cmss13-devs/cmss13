

/mob/proc/in_view(turf/T)
	return view(T)

/mob/aiEye/in_view(turf/T)
	var/list/viewed = new
	for(var/mob/living/carbon/human/human in GLOB.human_mob_list)
		if(get_dist(human, T) <= 7)
			viewed += human
	return viewed

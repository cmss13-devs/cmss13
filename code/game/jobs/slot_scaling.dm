/proc/get_total_marines()
	var/count = 0
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.faction == FACTION_MARINE)
			count++
	return count

// https://docs.google.com/spreadsheets/d/1PlnIwKhq-bVWWFPoBrzWYh1mWK04pyBSQUtUMEw3qSw/edit#gid=1290768907


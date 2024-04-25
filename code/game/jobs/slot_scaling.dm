/proc/get_total_marines()
	var/count = 0
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.faction == FACTION_MARINE)
			count++
	return count

// https://docs.google.com/spreadsheets/d/1PlnIwKhq-bVWWFPoBrzWYh1mWK04pyBSQUtUMEw3qSw/edit#gid=1290768907

/proc/job_slot_formula(marine_count, factor, c, min, max)
	if(marine_count <= factor)
		return min
	return round(clamp((marine_count/factor)+c, min, max))

/proc/medic_slot_formula(playercount)
	return job_slot_formula(playercount,20,1,3,5)

/proc/engi_slot_formula(playercount)
	return job_slot_formula(playercount,25,1,2,4)

/proc/mp_slot_formula(playercount)
	return job_slot_formula(playercount,25,2,4,8)

/proc/so_slot_formula(playercount)
	return job_slot_formula(playercount,20,1,2,5)

/proc/doc_slot_formula(playercount)
	return job_slot_formula(playercount,15,1,4,6)

/proc/rsc_slot_formula(playercount)
	return job_slot_formula(playercount,20,1,2,3)

/proc/ot_slot_formula(playercount)
	return job_slot_formula(playercount,30,1,2,3)

/proc/ct_slot_formula(playercount)
	return job_slot_formula(playercount,15,0,2,3)

/proc/int_slot_formula(playercount)
	return job_slot_formula(playercount,15,1,1,3)

/proc/synth_slot_formula(playercount)
	return job_slot_formula(playercount,60,1,1,2)

/proc/working_joe_slot_formula(playercount)
	return job_slot_formula(playercount,30,1,3,6)

/proc/mess_sergeant_slot_formula(playercount)
	return job_slot_formula(playercount, 70, 1, 1, 2)

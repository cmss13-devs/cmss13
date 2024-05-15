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
	return floor(clamp((marine_count/factor)+c, min, max))

/proc/medic_slot_formula(playercount)
	return job_slot_formula(playercount,40,1,3,5)

/proc/engi_slot_formula(playercount)
	return job_slot_formula(playercount,50,1,2,4)

/proc/mp_slot_formula(playercount)
	return job_slot_formula(playercount,25,2,4,8)

/proc/so_slot_formula(playercount)
	return job_slot_formula(playercount,40,1,2,5)

/proc/doc_slot_formula(playercount)
	return job_slot_formula(playercount,25,1,4,6)

/proc/rsc_slot_formula(playercount)
	return job_slot_formula(playercount,40,1,2,3)

/proc/ot_slot_formula(playercount)
	return job_slot_formula(playercount,60,1,2,3)

/proc/ct_slot_formula(playercount)
	return job_slot_formula(playercount,30,0,2,3)

/proc/int_slot_formula(playercount)
	return job_slot_formula(playercount,30,1,1,3)

/proc/spec_slot_formula(playercount)
	return job_slot_formula(playercount,20,1,2,4)

/proc/sg_slot_formula(playercount)
	return job_slot_formula(playercount,20,1,2,4)

/proc/synth_slot_formula(playercount)
	return job_slot_formula(playercount,120,1,1,2)

/proc/working_joe_slot_formula(playercount)
	return job_slot_formula(playercount,30,1,3,6)

/proc/mess_sergeant_slot_formula(playercount)
	return job_slot_formula(playercount, 70, 1, 1, 2)

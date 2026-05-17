// Leaderboard stat for festivizer_hits_total_max
// Normally includes dead always but can disable by setting prob_check_dead to 0

/datum/random_fact/christmas
	role_filter = null

/datum/random_fact/christmas/life_grab_stat(mob/fact_mob)
	return fact_mob.festivizer_hits_total

/datum/random_fact/christmas/generate_announcement_message()
	if(!check_xeno && !check_human)
		return null

	var/festivizer_hits_total_max = 0
	var/mob/mob_to_report = null

	var/list/list_to_check = list()
	if(check_human)
		if(prob_check_dead > 0)
			list_to_check += GLOB.human_mob_list
		else
			list_to_check += GLOB.alive_human_list
	if(check_xeno)
		if(prob_check_dead > 0)
			list_to_check += GLOB.xeno_mob_list
		else
			list_to_check += GLOB.living_xeno_list

	for(var/mob/checked_mob as anything in list_to_check)
		if(check_mob_ignored(checked_mob))
			continue
		if(festivizer_hits_total_max < checked_mob.festivizer_hits_total && (checked_mob.persistent_ckey in GLOB.directory))
			mob_to_report = checked_mob
			festivizer_hits_total_max = life_grab_stat(checked_mob)

	if(!mob_to_report || festivizer_hits_total_max < min_required)
		return null

	var/name = mob_to_report.real_name
	var/additional_message
	switch(festivizer_hits_total_max)
		if(0 to 30)
			additional_message = "Good work!"
		if(30 to 60)
			additional_message = "Great work!"
		if(90 to 120)
			additional_message = "INCREDIBLE work!"
		if(120 to 150)
			additional_message = "MERRY CHRISTMAS!!"
		else
			additional_message = "<b>[name] is the VERY SPIRIT of CHRISTMAS!!!</b>"

	return "<b>[name]</b> festivized a grand total of <b>[festivizer_hits_total_max] objects!</b> [additional_message]"

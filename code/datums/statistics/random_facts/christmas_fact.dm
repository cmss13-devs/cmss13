/datum/random_fact/christmas/announce()
	var/festivizer_hits_total_max = 0
	var/mob/mob_to_report = null

	var/list/list_to_check = list()
	list_to_check += GLOB.living_mob_list
	list_to_check += GLOB.dead_mob_list
	for(var/mob/checked_mob as anything in list_to_check)
		if(festivizer_hits_total_max < checked_mob.festivizer_hits_total)
			mob_to_report = checked_mob
			festivizer_hits_total_max = checked_mob.festivizer_hits_total

	if(!mob_to_report || !festivizer_hits_total_max)
		return

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

	message = "<b>[name]</b> festivized a grand total of <b>[festivizer_hits_total_max] objects!</b> [additional_message]"

	return ..()

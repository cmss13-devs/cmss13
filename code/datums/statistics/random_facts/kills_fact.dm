/datum/random_fact/kills/announce()
	var/death_kills_gotten = 0
	var/living_kills_gotten = 0
	var/datum/entity/statistic/death/death_to_report = null
	var/mob/mob_to_report = null

	if(round_statistics && length(round_statistics.death_stats_list))
		for(var/datum/entity/statistic/death/death in round_statistics.death_stats_list)
			if(!check_human && !death.is_xeno)
				continue
			if(!check_xeno && death.is_xeno)
				continue
			if(death_kills_gotten < death.total_kills)
				death_to_report = death
				death_kills_gotten = death.total_kills

	var/list/list_to_check = list()
	if(check_human) list_to_check += GLOB.alive_human_list
	if(check_xeno) list_to_check += GLOB.living_xeno_list
	for(var/mob/M as anything in list_to_check)
		if(living_kills_gotten < M.life_kills_total)
			mob_to_report = M
			living_kills_gotten = M.life_kills_total

	if(!death_to_report && !mob_to_report)
		return

	var/name = ""
	var/kills_gotten = 0
	var/additional_message = ""
	if(death_to_report && mob_to_report)
		if(living_kills_gotten > death_kills_gotten)
			name = mob_to_report.real_name
			kills_gotten = living_kills_gotten
			additional_message = "and survived! Great work!"
		else
			name = death_to_report.mob_name
			kills_gotten = death_kills_gotten
			additional_message = "before dying"
			if(death_to_report.cause_name)
				additional_message += " to <b>[death_to_report.cause_name]</b>"
			additional_message += ". Good work!"
	else if(death_to_report)
		name = death_to_report.mob_name
		kills_gotten = death_kills_gotten
		additional_message = "before dying"
		if(death_to_report.cause_name)
			additional_message += " to <b>[death_to_report.cause_name]</b>"
		additional_message += ". Good work!"
	else
		name = mob_to_report.real_name
		kills_gotten = living_kills_gotten
		additional_message = "and survived! Great work!"

	message = "<b>[name]</b> earned <b>[kills_gotten] kill\s</b> [additional_message]"
	. = ..()

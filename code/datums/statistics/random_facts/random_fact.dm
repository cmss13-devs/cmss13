/datum/random_fact
	var/message = null
	var/statistic_name = null
	var/statistic_verb = null

	var/check_human = TRUE
	var/check_xeno = TRUE

/datum/random_fact/New(set_check_human = TRUE, set_check_xeno = TRUE)
	. = ..()
	check_human = set_check_human
	check_xeno = set_check_xeno

/datum/random_fact/proc/announce()
	calculate_announcement_message()
	if(message)
		to_world(SPAN_CENTERBOLD(message))
		return TRUE
	return FALSE

/datum/random_fact/proc/calculate_announcement_message()
	var/death_stat_gotten = 0
	var/living_stat_gotten = 0
	var/datum/entity/statistic/death/death_to_report = null
	var/mob/mob_to_report = null

	if(GLOB.round_statistics && length(GLOB.round_statistics.death_stats_list))
		for(var/datum/entity/statistic/death/death in GLOB.round_statistics.death_stats_list)
			if(!check_human && !death.is_xeno)
				continue
			if(!check_xeno && death.is_xeno)
				continue
			if(death_stat_gotten < death_grab_stat(death))
				death_to_report = death
				death_stat_gotten = death_grab_stat(death)

	var/list/list_to_check = list()
	if(check_human)
		list_to_check += GLOB.alive_human_list
	if(check_xeno)
		list_to_check += GLOB.living_xeno_list

	for(var/mob/checked_mob as anything in list_to_check)
		if(!checked_mob?.persistent_ckey)
			continue // We don't care about NPCs
		if(living_stat_gotten < life_grab_stat(checked_mob))
			mob_to_report = checked_mob
			living_stat_gotten = life_grab_stat(checked_mob)

	if(!death_to_report && !mob_to_report)
		return

	var/name = ""
	var/stat_gotten = 0
	var/additional_message = ""
	if(death_to_report && mob_to_report)
		if(living_stat_gotten > death_stat_gotten)
			name = mob_to_report.real_name
			stat_gotten = living_stat_gotten
			additional_message = "and survived! Great work!"
		else
			name = death_to_report.mob_name
			stat_gotten = death_stat_gotten
			additional_message = "before dying"
			if(death_to_report.cause_name)
				additional_message += " to <b>[death_to_report.cause_name]</b>"
			additional_message += ". Good work!"
	else if(death_to_report)
		name = death_to_report.mob_name
		stat_gotten = death_stat_gotten
		additional_message = "before dying"
		if(death_to_report.cause_name)
			additional_message += " to <b>[death_to_report.cause_name]</b>"
		additional_message += ". Good work!"
	else
		name = mob_to_report.real_name
		stat_gotten = living_stat_gotten
		additional_message = "and survived! Great work!"

	message = "<b>[name]</b> [statistic_verb] <b>[stat_gotten] [statistic_name]</b> [additional_message]"

/datum/random_fact/proc/life_grab_stat(mob/fact_mob)
	return 0

/datum/random_fact/proc/death_grab_stat(datum/entity/statistic/death/fact_death)
	return 0

/datum/random_fact/damage/announce()
	var/death_damage_taken = 0
	var/living_damage_taken = 0
	var/datum/entity/statistic/death/death_to_report = null
	var/mob/mob_to_report = null

	if(round_statistics && length(round_statistics.death_stats_list))
		for(var/datum/entity/statistic/death/death in round_statistics.death_stats_list)
			if(death_damage_taken < death.total_damage_taken)
				death_to_report = death
				death_damage_taken = death.total_damage_taken

	for(var/mob/M as anything in GLOB.alive_mob_list)
		if(living_damage_taken < M.life_damage_taken_total)
			mob_to_report = M
			living_damage_taken = M.life_damage_taken_total

	if(!death_to_report && !mob_to_report)
		return

	var/name = ""
	var/damage_taken = 0
	var/additional_message = ""
	if(death_to_report && mob_to_report)
		if(living_damage_taken > death_damage_taken)
			name = mob_to_report.real_name
			damage_taken = living_damage_taken
			additional_message = "and survived! Great work!"
		else
			name = death_to_report.mob_name
			damage_taken = death_damage_taken
			additional_message = "before dying"
			if(death_to_report.cause_name)
				additional_message += " to <b>[death_to_report.cause_name]</b>"
			additional_message += ". Good work!"
	else if(death_to_report)
		name = death_to_report.mob_name
		damage_taken = death_damage_taken
		additional_message = "before dying"
		if(death_to_report.cause_name)
			additional_message += " to <b>[death_to_report.cause_name]</b>"
		additional_message += ". Good work!"
	else
		name = mob_to_report.real_name
		damage_taken = living_damage_taken
		additional_message = "and survived! Great work!"

	message = "<b>[name]</b> took a whopping <b>[damage_taken] damage</b> [additional_message]"

	return ..()

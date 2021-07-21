/datum/random_fact/calories/announce()
	if(!round_statistics || !round_statistics.death_stats_list.len)
		return
	var/datum/entity/statistic/death/death_to_report = null
	for(var/datum/entity/statistic/death/death in round_statistics.death_stats_list)
		if(!death_to_report || death.total_steps > death_to_report.total_steps)
			death_to_report = death
	if(!death_to_report)
		return
	message = "<b>[death_to_report.mob_name]</b> burned <b>[death_to_report.total_steps / 10] calories</b> before dying"
	if(death_to_report.cause_name)
		message += " to <b>[death_to_report.cause_name]</b>"
	message += ". Good job!"
	. = ..()

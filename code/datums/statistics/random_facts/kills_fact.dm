/datum/random_fact/kills/announce()
	if(!round_statistics || !round_statistics.death_stats_list.len)
		return
	var/datum/entity/statistic/death/death_to_report = null
	for(var/datum/entity/statistic/death/death in round_statistics.death_stats_list)
		if(!death_to_report || death.total_kills > death_to_report.total_kills)
			death_to_report = death
	if(!death_to_report)
		return
	message = "<b>[death_to_report.mob_name]</b> earned <b>[death_to_report.total_kills] kills</b> before dying"
	if(death_to_report.cause_name)
		message += " to <b>[death_to_report.cause_name]</b>"
	message += ". Good job!"
	. = ..()

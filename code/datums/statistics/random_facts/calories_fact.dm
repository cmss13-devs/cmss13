/datum/random_fact/calories/announce()
	if(!round_statistics || !round_statistics.death_stats_list.len)
		return
	var/datum/entity/statistic/death/death = pick(round_statistics.death_stats_list)
	message = "<b>[death.mob_name]</b> burned <b>[death.total_steps / 10] calories</b> before dying"
	if(death.cause_name)
		message += " to <b>[death.cause_name]</b>"
	message += ". Good job!"
	. = ..()

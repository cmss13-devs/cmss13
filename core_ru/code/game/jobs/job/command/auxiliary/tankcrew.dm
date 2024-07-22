/datum/job/command/tank_crew/set_spawn_positions(count)
	if (length(GLOB.clients) >= 80)
		spawn_positions = 2
	else
		spawn_positions = 0

/datum/job/command/tank_crew/get_total_positions(latejoin = FALSE)
	if(length(GLOB.clients) >= 80 || total_positions_so_far > 0)
		return 2

	return 0

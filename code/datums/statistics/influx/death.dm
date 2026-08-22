/datum/influx_player_stats/dead
	name = "Dead players"
	key = "current_dead"

/datum/influx_player_stats/dead/is_relevant(mob/target)
	return target.stat == DEAD

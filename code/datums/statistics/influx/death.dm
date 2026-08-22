/datum/player_stats/dead
	name = "Dead players"
	key = "current_dead"

/datum/player_stats/dead/is_relevant(mob/target)
	return target.stat == DEAD

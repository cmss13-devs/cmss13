/datum/influx_player_stats/living
	name = "Alive players"
	key = "current_alive"

/datum/influx_player_stats/living/is_relevant(mob/target)
	return target.stat != DEAD

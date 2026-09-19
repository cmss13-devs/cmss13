/datum/influx_player_stats/facehugged
	name = "Infected players"
	key = "current_infected"

/datum/influx_player_stats/facehugged/is_relevant(mob/target)
	return target.status_flags & XENO_HOST

/datum/player_stats/facehugged
	name = "Infected players"
	key = "current_infected"

/datum/player_stats/facehugged/is_relevant(mob/target)
	return target.status_flags & XENO_HOST

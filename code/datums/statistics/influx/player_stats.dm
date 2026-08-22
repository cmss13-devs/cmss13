/datum/player_stats
	var/name = "Player stats"
	var/key = ""

/datum/player_stats/proc/is_relevant(mob/target)
	return FALSE

/datum/player_stats/proc/group_by(mob/target)
	return target.faction

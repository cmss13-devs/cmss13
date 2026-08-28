/datum/influx_player_stats
	var/name = "Player stats"
	var/key = ""

/datum/influx_player_stats/proc/is_relevant(mob/target)
	return FALSE

/datum/influx_player_stats/proc/group_by(mob/target)
	if(target.faction_group && (FACTION_SURVIVOR in target.faction_group))
		return FACTION_SURVIVOR
	return target.faction

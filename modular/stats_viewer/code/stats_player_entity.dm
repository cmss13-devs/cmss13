// Player's holder, has data for all the player's characters who participated in the round
/datum/entity/player_entity/proc/get_player_round_stat()
	if(!length(player_stats))
		return
	var/list/data = list()
	for(var/key in player_stats)
		var/datum/entity/player_stats/stats = player_stats[key]
		data["stats"] += list(stats.get_player_stat())
	return data

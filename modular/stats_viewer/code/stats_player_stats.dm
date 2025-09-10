/datum/entity/player_stats
	/// Assoc list - ("killed name" = amount)
	var/list/human_kill_feed = list()
	/// Assoc list - ("killed name" = amount)
	var/list/xeno_kill_feed = list()

/datum/entity/player_stats/proc/count_human_kill_feed(killed_name)
	human_kill_feed["[killed_name]"] += 1

/datum/entity/player_stats/proc/count_xeno_kill_feed(killed_name)
	xeno_kill_feed["[killed_name]"] += 1

// Per faction player's stats for who participated in the round. Linked to a specific player
/datum/entity/player_stats/proc/get_player_stat()
	var/list/data = list()
	data["title"] = "CALL THE CODER"
	data["total_kills"] = total_kills
	data["total_deaths"] = total_deaths
	data["steps_walked"] = steps_walked
	if(length(human_kill_feed))
		var/human_kills_total = 0
		for(var/name in human_kill_feed)
			human_kills_total += human_kill_feed["[name]"]
			data["human_kill_feed"] += list(list(
				"name" = name,
				"value" = human_kill_feed["[name]"],
			))
		data["human_kills_total"] = human_kills_total
	if(length(xeno_kill_feed))
		var/xeno_kills_total = 0
		for(var/name in xeno_kill_feed)
			xeno_kills_total += xeno_kill_feed["[name]"]
			data["xeno_kill_feed"] += list(list(
				"name" = name,
				"value" = xeno_kill_feed["[name]"],
			))
		data["xeno_kills_total"] = xeno_kills_total
	if(length(niche_stats))
		for(var/key in niche_stats)
			var/datum/entity/statistic/stat = niche_stats[key]
			data["niche_stats"] += list(list(
				"name" = stat.name,
				"value" = stat.value,
			))
	return data

/datum/entity/player_stats/human/get_player_stat()
	var/list/data = ..()
	data["title"] = "Человек"
	data["total_friendly_fire"] = total_friendly_fire
	data["total_revives"] = total_revives
	data["total_lives_saved"] = total_lives_saved
	data["total_shots"] = total_shots
	data["total_shots_hit"] = total_shots_hit
	// TODO220: Show per job (mob)
	return data

/datum/entity/player_stats/xeno/get_player_stat()
	var/list/data = ..()
	data["title"] = "Ксеноморф"
	data["total_hits"] = total_hits
	if(length(caste_stats_list))
		for(var/caste_name in caste_stats_list)
			var/datum/entity/player_stats/caste/caste = caste_stats_list[caste_name]
			data["castes"] += list(list(
				"name" = declent_ru_initial(caste_name, NOMINATIVE, caste_name),
				"stats" = caste.get_player_stat(),
			))
	return data

/datum/entity/player_stats/caste/get_player_stat()
	var/list/data = ..()
	data["total_hits"] = total_hits
	if(length(abilities_used))
		for(var/ability_name in abilities_used)
			var/datum/entity/statistic/stat = abilities_used[ability_name]
			data["abilities_used"] += list(list(
				"name" = stat.name,
				"value" = stat.value,
			))
	return data

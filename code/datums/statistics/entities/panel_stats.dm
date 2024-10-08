/datum/player_entity/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Statistic", "Statistic")
		ui.open()
		ui.set_autoupdate(TRUE)

/datum/player_entity/ui_state(mob/user)
	return GLOB.always_state

/datum/player_entity/ui_data(mob/user, datum/entity/statistic_round/viewing_round = GLOB.round_statistics)
	var/list/data = list()
	data["data_tabs"] = list()
	if(viewing_round)
		data["round"] = viewing_round.cached_tgui_data
		data["data_tabs"] += "Round"

	if(length(medals))
		var/list/medal_list = list()
		for(var/datum/entity/statistic/medal/medal as anything in medals)
			medal_list += list(list(
				"round_id" = "[medal.round_id]",
				"medal_type" = medal.medal_type,
				"recipient" = sanitize(medal.recipient_name),
				"recipient_job" = medal.recipient_role,
				"citation" = sanitize(medal.citation),
				"giver" = sanitize(medal.giver_name),
			))

		data["medals"] = medal_list
		data["data_tabs"] += "Medals"

	data["factions"] = list()
	for(var/faction_to_get in statistics)
		var/datum/statistic_groups/group = statistics[faction_to_get]
		var/list/nemesis = list()
		var/list/death_list = list()
		var/list/top_statistics = list()
		var/list/total_statistics = list()
		var/list/statistics_list_tabs = list()
		var/list/statistics_list = list()
		if(group.nemesis)
			nemesis = list("name" = group.nemesis.nemesis_name, "value" = group.nemesis.value)

		for(var/datum/entity/statistic_death/statistic_death as anything in group.statistic_deaths)
			if(length(death_list) >= STATISTICS_DEATH_LIST_LEN)
				break

			var/list/damage_list = list()
			if(statistic_death.total_brute)
				damage_list += list(list("name" = "brute", "value" = statistic_death.total_brute))

			if(statistic_death.total_burn)
				damage_list += list(list("name" = "burn", "value" = statistic_death.total_burn))

			if(statistic_death.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = statistic_death.total_oxy))

			if(statistic_death.total_tox)
				damage_list += list(list("name" = "tox", "value" = statistic_death.total_tox))

			death_list += list(list(
				"mob_name" = sanitize(statistic_death.mob_name),
				"job_name" = statistic_death.role_name,
				"area_name" = sanitize_area(statistic_death.area_name),
				"cause_name" = sanitize(statistic_death.cause_name),
				"total_kills" = statistic_death.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(statistic_death.time_of_death),
				"total_time_alive" = duration2text(statistic_death.total_time_alive),
				"total_damage_taken" = statistic_death.total_damage_taken,
				"x" = statistic_death.x,
				"y" = statistic_death.y,
				"z" = statistic_death.z,
			))

		for(var/group_subtype in group.statistic_info)
			var/list/statistic_info = list()
			var/datum/player_statistic/player_statistic = group.statistic_info[group_subtype]
			if(player_statistic.statistic_name == STATISTIC_TYPE_CASTE || player_statistic.statistic_name == STATISTIC_TYPE_JOB)
				for(var/subtype in player_statistic.total)
					total_statistics += list(list("name" = subtype, "value" = player_statistic.total[subtype]))

			if(player_statistic.top_statistic)
				var/list/top_statistic_list = list()
				var/datum/player_statistic_detail/detail_statistic = player_statistic.top_statistic
				for(var/datum/entity/statistic/top_statistic_entity as anything in detail_statistic.statistics)
					top_statistic_list += list(list("name" = top_statistic_entity.statistic_name, "value" = top_statistic_entity.value))

				top_statistics += list(list(
					"name" = detail_statistic.detail_name,
					"statistics" = top_statistic_list,
				))

			for(var/statistic_subtype in player_statistic.statistics)
				var/datum/player_statistic_detail/detail_statistic = player_statistic.statistics[statistic_subtype]
				var/list/subtype_statistics = list()
				var/list/subtype_top_statistics = list()
				for(var/datum/entity/statistic/statistic as anything in detail_statistic.statistics)
					subtype_statistics += list(list("name" = statistic.statistic_name, "value" = statistic.value))

				for(var/datum/entity/statistic/statistic as anything in detail_statistic.top_values_statistics)
					subtype_top_statistics += list(list("name" = statistic.statistic_name, "value" = statistic.value))

				statistic_info += list(list(
					"name" = detail_statistic.detail_name,
					"statistics" = subtype_statistics,
					"top_statistics" = subtype_top_statistics,
				))

			statistics_list_tabs += player_statistic.statistic_name
			statistics_list += list(list(
				"name" = player_statistic.statistic_name,
				"value" = statistic_info,
			))

		if(length(total_statistics))
			data["data_tabs"] += group.group_name
			data["factions"][group.group_name] = list(
				"name" = group.group_name,
				"nemesis" = nemesis,
				"death_list" = death_list,
				"statistics" = total_statistics,
				"top_statistics" = top_statistics,
				"statistics_list" = statistics_list,
			)
	return data

/datum/entity/statistic_round/process()
	var/map_name
	if(current_map)
		map_name = current_map.map_name

	var/list/participants_list = null
	var/list/hijack_participants_list = null
	var/list/final_participants_list = null
	var/list/total_deaths_list = list()
	var/list/new_death_stats_list = list()

	if(length(participants))
		participants_list = list()
		for(var/stat_name in participants)
			participants_list += list(list("name" = stat_name, "value" = participants[stat_name]))

	if(length(hijack_participants))
		hijack_participants_list = list()
		for(var/stat_name in hijack_participants)
			hijack_participants_list += list(list("name" = stat_name, "value" = hijack_participants[stat_name]))

	if(length(final_participants))
		final_participants_list = list()
		for(var/stat_name in final_participants)
			final_participants_list += list(list("name" = stat_name, "value" = final_participants[stat_name]))

	total_deaths_list = length(total_deaths)

	for(var/datum/entity/statistic_death/statistic_death as anything in death_stats_list)
		if(new_death_stats_list.len >= STATISTICS_DEATH_LIST_LEN)
			break
		var/list/damage_list = list()
		if(statistic_death.total_brute)
			damage_list += list(list("name" = "brute", "value" = statistic_death.total_brute))
		if(statistic_death.total_burn)
			damage_list += list(list("name" = "burn", "value" = statistic_death.total_burn))
		if(statistic_death.total_oxy)
			damage_list += list(list("name" = "oxy", "value" = statistic_death.total_oxy))
		if(statistic_death.total_tox)
			damage_list += list(list("name" = "tox", "value" = statistic_death.total_tox))

		new_death_stats_list += list(list(
			"mob_name" = sanitize(statistic_death.mob_name),
			"job_name" = statistic_death.role_name,
			"area_name" = sanitize_area(statistic_death.area_name),
			"cause_name" = sanitize(statistic_death.cause_name),
			"total_kills" = statistic_death.total_kills,
			"total_damage" = damage_list,
			"time_of_death" = duration2text(statistic_death.time_of_death),
			"total_time_alive" = duration2text(statistic_death.total_time_alive),
			"total_damage_taken" = statistic_death.total_damage_taken,
			"x" = statistic_death.x,
			"y" = statistic_death.y,
			"z" = statistic_death.z,
		))

	cached_tgui_data = list(
		"name" = round_name,
		"game_mode" = game_mode,
		"map_name" = map_name,
		"round_result" = round_result,
		"real_time_start" = real_time_start ? duration2text(real_time_start) : 0,
		"real_time_end" = real_time_end ? duration2text(real_time_end) : 0,
		"round_length" = round_length ? duration2text(round_length) : 0,
		"round_hijack_time" = round_hijack_time ? duration2text(round_hijack_time) : 0,
		"end_round_player_population" = end_round_player_population,
		"total_projectiles_fired" = total_projectiles_fired,
		"total_projectiles_hit" = total_projectiles_hit,
		"total_projectiles_hit_human" = total_projectiles_hit_human,
		"total_projectiles_hit_xeno" = total_projectiles_hit_xeno,
		"total_slashes" = total_slashes,
		"total_friendly_fire_instances" = total_friendly_fire_instances,
		"total_friendly_kills" = total_friendly_kills,
		"total_huggers_applied" = total_huggers_applied,
		"total_larva_burst" = total_larva_burst,
		"participants" = participants_list,
		"hijack_participants" = hijack_participants_list,
		"final_participants" = final_participants_list,
		"total_deaths" = total_deaths_list,
		"death_list" = new_death_stats_list,
	)

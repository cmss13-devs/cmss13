//*******************************************************
//*******************STAT PANEL**************************
//*******************************************************


/datum/entity/player_entity/proc/show_statistics(mob/user, datum/entity/statistic/round/viewing_round = round_statistics, update_data = FALSE)
	if(update_data)
		update_panel_data(round_statistics)
	ui_interact(user)

/datum/entity/player_entity/proc/ui_interact(mob/user, ui_key = "statistics", datum/nanoui/ui = null, force_open = 1)
	data["menu"] = menu
	data["subMenu"] = subMenu
	data["dataMenu"] = dataMenu

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "cm_stat_panel.tmpl", "Statistics", 450, 700, null, -1)
		ui.set_initial_data(data)
		ui.open()

/datum/entity/player_entity/Topic(href, href_list)
	var/mob/user = usr
	user.set_interaction(src)

	if(href_list["menu"])
		menu = href_list["menu"]
	if(href_list["subMenu"])
		subMenu = href_list["subMenu"]
	if(href_list["dataMenu"])
		dataMenu = href_list["dataMenu"]

	nanomanager.update_uis(src)

/datum/entity/player_entity/proc/check_eye()
	return

//*******************************************************
//*******************KILL PANEL**************************
//*******************************************************


/datum/entity/statistic/round/proc/show_kill_feed(mob/user)
	tgui_interact(user)

/datum/entity/statistic/round/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KillPanel", "Killfeed")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/entity/statistic/round/ui_state(mob/user)
	return GLOB.always_state

/datum/entity/statistic/round/ui_data(mob/user)
	var/list/data = list()

	data["death_data"] = death_data

	return data

/datum/entity/statistic/round/proc/check_eye()
	return

//*******************************************************
//*******************PLAYER DATA*************************
//*******************************************************

/datum/entity/player_entity/proc/update_panel_data(datum/entity/statistic/round/viewing_round = round_statistics)
	data["current_time"] = worldtime2text()

	if(viewing_round)
		viewing_round.update_panel_data()
		data["round"] = viewing_round.round_data["round"]

	if(player_stats["human"])
		var/datum/entity/player_stats/human/human = player_stats["human"]
		var/list/humans_killed = list()
		var/list/xenos_killed = list()
		var/list/medal_list = list()
		var/list/death_list = list()
		var/list/weapon_stats_list = list()
		var/list/job_stats_list = list()
		var/list/niche_stats_list = list()
		var/list/top_weapon = null
		var/list/human_nemesis = null

		if(human.nemesis)
			human_nemesis = list("name" = human.nemesis.name, "value" = human.nemesis.value)

		if(human.top_weapon)
			top_weapon = list(
				"name" = sanitize(human.top_weapon.name),
				"total_kills" = human.top_weapon.total_kills,
				"total_hits" = human.top_weapon.total_hits,
				"total_shots" = human.top_weapon.total_shots,
				"total_shots_hit" = human.top_weapon.total_shots_hit,
				"total_friendly_fire" = human.top_weapon.total_friendly_fire
			)

		for(var/iteration in human.humans_killed)
			var/datum/entity/statistic/stat = human.humans_killed[iteration]
			humans_killed += list(list("name" = stat.name, "value" = stat.value))

		for(var/iteration in human.xenos_killed)
			var/datum/entity/statistic/stat = human.xenos_killed[iteration]
			xenos_killed += list(list("name" = stat.name, "value" = stat.value))

		for(var/iteration in human.niche_stats)
			var/datum/entity/statistic/stat = human.niche_stats[iteration]
			niche_stats_list += list(list("name" = stat.name, "value" = stat.value))

		for(var/datum/entity/statistic/medal/stat in human.medal_list)
			medal_list += list(list(
				"medal_type" = sanitize(stat.medal_type),
				"recipient" = sanitize(stat.recipient_name),
				"recipient_job" = sanitize(stat.recipient_role),
				"citation" = sanitize(stat.citation),
				"giver" = sanitize(stat.giver_name)
			))

		for(var/datum/entity/statistic/death/stat in human.death_list)
			var/list/damage_list = list()
			if(stat.total_brute)
				damage_list += list(list("name" = "brute", "value" = stat.total_brute))
			if(stat.total_burn)
				damage_list += list(list("name" = "burn", "value" = stat.total_burn))
			if(stat.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = stat.total_oxy))
			if(stat.total_tox)
				damage_list += list(list("name" = "tox", "value" = stat.total_tox))
			death_list += list(list(
				"mob_name" = sanitize(stat.mob_name),
				"job_name" = stat.role_name,
				"area_name" = sanitize_area(stat.area_name),
				"cause_name" = sanitize(stat.cause_name),
				"total_kills" = stat.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(stat.time_of_death),
				"total_time_alive" = duration2text(stat.total_time_alive),
				"total_damage_taken" = stat.total_damage_taken,
				"x" = stat.x,
				"y" = stat.y,
				"z" = stat.z
			))

		for(var/iteration in human.weapon_stats_list)
			var/datum/entity/weapon_stats/stat = human.weapon_stats_list[iteration]
			if(!stat.display_stat)
				continue
			var/list/weapon_humans_killed = list()
			var/list/weapon_xenos_killed = list()
			var/list/weapon_niche_stats_list = list()

			for(var/sub_iteration in stat.humans_killed)
				var/datum/entity/statistic/stat_sub_iteration = stat.humans_killed[sub_iteration]
				weapon_humans_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.xenos_killed)
				var/datum/entity/statistic/stat_sub_iteration = stat.xenos_killed[sub_iteration]
				weapon_xenos_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.niche_stats)
				var/datum/entity/statistic/stat_sub_iteration = stat.niche_stats[sub_iteration]
				weapon_niche_stats_list += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			weapon_stats_list += list(list(
				"name" = sanitize(stat.name),
				"total_kills" = stat.total_kills,
				"total_hits" = stat.total_hits,
				"total_shots" = stat.total_shots,
				"total_shots_hit" = stat.total_shots_hit,
				"total_friendly_fire" = stat.total_friendly_fire,
				"humans_killed" = weapon_humans_killed,
				"xenos_killed" = weapon_xenos_killed,
				"niche_stats" = weapon_niche_stats_list
			))

		for(var/iteration in human.job_stats_list)
			var/datum/entity/player_stats/job/stat = human.job_stats_list[iteration]
			if(!stat.display_stat)
				continue
			var/list/job_humans_killed = list()
			var/list/job_xenos_killed = list()
			var/list/job_death_list = list()
			var/list/job_niche_stats_list = list()
			var/list/job_nemesis = null

			if(stat.nemesis)
				job_nemesis = list("name" = stat.nemesis.name, "value" = stat.nemesis.value)

			for(var/sub_iteration in stat.humans_killed)
				var/datum/entity/statistic/stat_sub_iteration = stat.humans_killed[sub_iteration]
				job_humans_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.xenos_killed)
				var/datum/entity/statistic/stat_sub_iteration = stat.xenos_killed[sub_iteration]
				job_xenos_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.niche_stats)
				var/datum/entity/statistic/stat_sub_iteration = stat.niche_stats[sub_iteration]
				job_niche_stats_list += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/datum/entity/statistic/death/DS in stat.death_list)
				var/list/damage_list = list()
				if(DS.total_brute)
					damage_list += list(list("name" = "brute", "value" = DS.total_brute))
				if(DS.total_burn)
					damage_list += list(list("name" = "burn", "value" = DS.total_burn))
				if(DS.total_oxy)
					damage_list += list(list("name" = "oxy", "value" = DS.total_oxy))
				if(DS.total_tox)
					damage_list += list(list("name" = "tox", "value" = DS.total_tox))
				death_list += list(list(
					"mob_name" = sanitize(DS.mob_name),
					"job_name" = DS.role_name,
					"area_name" = sanitize_area(DS.area_name),
					"cause_name" = sanitize(DS.cause_name),
					"total_kills" = DS.total_kills,
					"total_damage" = damage_list,
					"time_of_death" = duration2text(DS.time_of_death),
					"total_time_alive" = duration2text(DS.total_time_alive),
					"total_damage_taken" = DS.total_damage_taken,
					"x" = DS.x,
					"y" = DS.y,
					"z" = DS.z
				))

			job_stats_list += list(list(
				"name" = stat.name,
				"total_kills" = stat.total_kills,
				"total_deaths" = stat.total_deaths,
				"total_playtime" = duration2text(stat.total_playtime),
				"total_rounds_played" = stat.total_rounds_played,
				"steps_walked" = stat.steps_walked,
				"total_friendly_fire" = stat.total_friendly_fire,
				"total_revives" = stat.total_revives,
				"total_lives_saved" = stat.total_lives_saved,
				"total_shots" = stat.total_shots,
				"total_shots_hit" = stat.total_shots_hit,
				"total_screams" = stat.total_screams,
				"nemesis" = job_nemesis,
				"humans_killed" = job_humans_killed,
				"xenos_killed" = job_xenos_killed,
				"job_death_list" = job_death_list,
				"niche_stats" = job_niche_stats_list
			))

		data["human"] = list(
			"total_kills" = human.total_kills,
			"total_deaths" = human.total_deaths,
			"total_playtime" = duration2text(human.total_playtime),
			"total_rounds_played" = human.total_rounds_played,
			"steps_walked" = human.steps_walked,
			"total_friendly_fire" = human.total_friendly_fire,
			"total_revives" = human.total_revives,
			"total_lives_saved" = human.total_lives_saved,
			"total_shots" = human.total_shots,
			"total_shots_hit" = human.total_shots_hit,
			"total_screams" = human.total_screams,
			"nemesis" = human_nemesis,
			"humans_killed" = humans_killed,
			"xenos_killed" = xenos_killed,
			"medal_list" = medal_list,
			"death_list" = death_list,
			"weapon_stats_list" = weapon_stats_list,
			"job_stats_list" = job_stats_list,
			"niche_stats" = niche_stats_list,
			"top_weapon" = top_weapon
		)

	if(player_stats["xeno"])
		var/datum/entity/player_stats/xeno/human = player_stats["xeno"]
		var/list/humans_killed = list()
		var/list/xenos_killed = list()
		var/list/medal_list = list()
		var/list/death_list = list()
		var/list/caste_stats_list = list()
		var/list/niche_stats_list = list()
		var/list/top_caste = null
		var/list/xeno_nemesis = null

		if(human.nemesis)
			xeno_nemesis = list("name" = human.nemesis.name, "value" = human.nemesis.value)

		if(human.top_caste)
			top_caste = list(
				"name" = human.top_caste.name,
				"total_kills" = human.top_caste.total_kills,
				"total_deaths" = human.top_caste.total_deaths,
				"total_playtime" = duration2text(human.top_caste.total_playtime),
				"total_rounds_played" = human.top_caste.total_rounds_played,
			)

		for(var/iteration in human.humans_killed)
			var/datum/entity/statistic/stat = human.humans_killed[iteration]
			humans_killed += list(list("name" = stat.name, "value" = stat.value))

		for(var/iteration in human.xenos_killed)
			var/datum/entity/statistic/stat = human.xenos_killed[iteration]
			xenos_killed += list(list("name" = stat.name, "value" = stat.value))

		for(var/iteration in human.niche_stats)
			var/datum/entity/statistic/stat = human.niche_stats[iteration]
			niche_stats_list += list(list("name" = stat.name, "value" = stat.value))

		for(var/datum/entity/statistic/medal/stat in human.medal_list)
			medal_list += list(list(
				"medal_type" = sanitize(stat.medal_type),
				"recipient" = sanitize(stat.recipient_name),
				"recipient_job" = sanitize(stat.recipient_role),
				"citation" = sanitize(stat.citation),
				"giver" = sanitize(stat.giver_name)
			))

		for(var/datum/entity/statistic/death/stat in human.death_list)
			var/list/damage_list = list()
			if(stat.total_brute)
				damage_list += list(list("name" = "brute", "value" = stat.total_brute))
			if(stat.total_burn)
				damage_list += list(list("name" = "burn", "value" = stat.total_burn))
			if(stat.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = stat.total_oxy))
			if(stat.total_tox)
				damage_list += list(list("name" = "tox", "value" = stat.total_tox))
			death_list += list(list(
				"mob_name" = sanitize(stat.mob_name),
				"job_name" = stat.role_name,
				"area_name" = sanitize_area(stat.area_name),
				"cause_name" = sanitize(stat.cause_name),
				"total_kills" = stat.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(stat.time_of_death),
				"total_time_alive" = duration2text(stat.total_time_alive),
				"total_damage_taken" = stat.total_damage_taken,
				"x" = stat.x,
				"y" = stat.y,
				"z" = stat.z
			))

		for(var/iteration in human.caste_stats_list)
			var/datum/entity/player_stats/caste/stat = human.caste_stats_list[iteration]
			if(!stat.display_stat)
				continue
			var/list/caste_abilities_used = list()
			var/list/caste_humans_killed = list()
			var/list/caste_xenos_killed = list()
			var/list/caste_death_list = list()
			var/list/caste_niche_stats_list = list()
			var/list/caste_nemesis = null

			if(stat.nemesis)
				caste_nemesis = list("name" = stat.nemesis.name, "value" = stat.nemesis.value)

			for(var/sub_iteration in stat.abilities_used)
				var/datum/entity/statistic/stat_sub_iteration = stat.abilities_used[sub_iteration]
				caste_abilities_used += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.humans_killed)
				var/datum/entity/statistic/stat_sub_iteration = stat.humans_killed[sub_iteration]
				caste_humans_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.xenos_killed)
				var/datum/entity/statistic/stat_sub_iteration = stat.xenos_killed[sub_iteration]
				caste_xenos_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/sub_iteration in stat.niche_stats)
				var/datum/entity/statistic/stat_sub_iteration = stat.niche_stats[sub_iteration]
				caste_niche_stats_list += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

			for(var/datum/entity/statistic/death/DS in stat.death_list)
				var/list/damage_list = list()
				if(DS.total_brute)
					damage_list += list(list("name" = "brute", "value" = DS.total_brute))
				if(DS.total_burn)
					damage_list += list(list("name" = "burn", "value" = DS.total_burn))
				if(DS.total_oxy)
					damage_list += list(list("name" = "oxy", "value" = DS.total_oxy))
				if(DS.total_tox)
					damage_list += list(list("name" = "tox", "value" = DS.total_tox))
				death_list += list(list(
					"mob_name" = sanitize(DS.mob_name),
					"job_name" = DS.role_name,
					"area_name" = sanitize_area(DS.area_name),
					"cause_name" = sanitize(DS.cause_name),
					"total_kills" = DS.total_kills,
					"total_damage" = damage_list,
					"time_of_death" = duration2text(DS.time_of_death),
					"total_time_alive" = duration2text(DS.total_time_alive),
					"total_damage_taken" = DS.total_damage_taken,
					"x" = DS.x,
					"y" = DS.y,
					"z" = DS.z
				))

			caste_stats_list += list(list(
				"name" = stat.name,
				"total_kills" = stat.total_kills,
				"total_hits" = stat.total_hits,
				"total_deaths" = stat.total_deaths,
				"total_playtime" = duration2text(stat.total_playtime),
				"total_rounds_played" = stat.total_rounds_played,
				"steps_walked" = stat.steps_walked,
				"nemesis" = caste_nemesis,
				"humans_killed" = caste_humans_killed,
				"xenos_killed" = caste_xenos_killed,
				"death_list" = caste_death_list,
				"abilities_used" = caste_abilities_used,
				"niche_stats" = caste_niche_stats_list
			))

		data["xeno"] = list(
			"total_kills" = human.total_kills,
			"total_deaths" = human.total_deaths,
			"total_playtime" = duration2text(human.total_playtime),
			"total_rounds_played" = human.total_rounds_played,
			"steps_walked" = human.steps_walked,
			"total_hits" = human.total_hits,
			"nemesis" = xeno_nemesis,
			"humans_killed" = humans_killed,
			"xenos_killed" = xenos_killed,
			"medal_list" = medal_list,
			"death_list" = death_list,
			"caste_stats_list" = caste_stats_list,
			"niche_stats" = niche_stats_list,
			"top_caste" = top_caste
		)

//*******************************************************
//*******************ROUND DATA**************************
//*******************************************************

/datum/entity/statistic/round/proc/update_panel_data()
	var/map_name
	if(current_map)
		map_name = current_map.name

	var/list/participants_list = list()
	var/list/hijack_participants_list = list()
	var/list/final_participants_list = list()
	var/list/total_deaths_list = list()
	var/list/new_death_stats_list = list()
	var/list/new_weapon_stats_list = list()
	var/list/new_job_stats_list = list()
	var/list/new_caste_stats_list = list()

	for(var/iteration in participants)
		var/datum/entity/statistic/stat = participants[iteration]
		participants_list += list(list("name" = stat.name, "value" = stat.value))

	for(var/iteration in hijack_participants)
		var/datum/entity/statistic/stat = hijack_participants[iteration]
		hijack_participants_list += list(list("name" = stat.name, "value" = stat.value))

	for(var/iteration in final_participants)
		var/datum/entity/statistic/stat = final_participants[iteration]
		final_participants_list += list(list("name" = stat.name, "value" = stat.value))

	for(var/iteration in total_deaths)
		var/datum/entity/statistic/stat = total_deaths[iteration]
		total_deaths_list += list(list("name" = stat.name, "value" = stat.value))

	for(var/datum/entity/statistic/death/stat in death_stats_list)
		if(new_death_stats_list.len >= STATISTICS_DEATH_LIST_LEN)
			break
		var/list/damage_list = list()
		if(stat.total_brute)
			damage_list += list(list("name" = "brute", "value" = stat.total_brute))
		if(stat.total_burn)
			damage_list += list(list("name" = "burn", "value" = stat.total_burn))
		if(stat.total_oxy)
			damage_list += list(list("name" = "oxy", "value" = stat.total_oxy))
		if(stat.total_tox)
			damage_list += list(list("name" = "tox", "value" = stat.total_tox))

		var/new_time_of_death
		if(stat.time_of_death)
			new_time_of_death = duration2text(stat.time_of_death)
		var/new_total_time_alive
		if(stat.total_time_alive)
			new_total_time_alive = duration2text(stat.total_time_alive)

		var/death = list(list(
			"mob_name" = sanitize(stat.mob_name),
			"job_name" = stat.role_name,
			"area_name" = sanitize_area(stat.area_name),
			"cause_name" = sanitize(stat.cause_name),
			"total_kills" = stat.total_kills,
			"total_damage" = damage_list,
			"time_of_death" = new_time_of_death,
			"total_time_alive" = new_total_time_alive,
			"total_damage_taken" = stat.total_damage_taken,
			"x" = stat.x,
			"y" = stat.y,
			"z" = stat.z
		))
		if(new_death_stats_list.len < STATISTICS_DEATH_LIST_LEN)
			new_death_stats_list += death

	for(var/iteration in weapon_stats_list)
		var/datum/entity/weapon_stats/stat = weapon_stats_list[iteration]
		if(!stat.display_stat)
			continue
		var/list/weapon_humans_killed = list()
		var/list/weapon_xenos_killed = list()
		var/list/weapon_niche_stats_list = list()

		for(var/sub_iteration in stat.humans_killed)
			var/datum/entity/statistic/stat_sub_iteration = stat.humans_killed[sub_iteration]
			if(!stat_sub_iteration)
				continue
			weapon_humans_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.xenos_killed)
			var/datum/entity/statistic/stat_sub_iteration = stat.xenos_killed[sub_iteration]
			if(!stat_sub_iteration)
				continue
			weapon_xenos_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.niche_stats)
			var/datum/entity/statistic/stat_sub_iteration = stat.niche_stats[sub_iteration]
			if(!stat_sub_iteration)
				continue
			weapon_niche_stats_list += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		new_weapon_stats_list += list(list(
			"name" = sanitize(stat.name),
			"total_kills" = stat.total_kills,
			"total_hits" = stat.total_hits,
			"total_shots" = stat.total_shots,
			"total_shots_hit" = stat.total_shots_hit,
			"total_friendly_fire" = stat.total_friendly_fire,
			"humans_killed" = weapon_humans_killed,
			"xenos_killed" = weapon_xenos_killed,
			"niche_stats" = weapon_niche_stats_list
		))

	for(var/iteration in job_stats_list)
		var/datum/entity/player_stats/job/stat = job_stats_list[iteration]
		if(!stat.display_stat)
			continue
		var/list/job_humans_killed = list()
		var/list/job_xenos_killed = list()
		var/list/job_death_list = list()
		var/list/job_niche_stats_list = list()
		var/list/job_nemesis = null

		if(stat.nemesis)
			job_nemesis = list("name" = stat.nemesis.name, "value" = stat.nemesis.value)

		for(var/sub_iteration in stat.humans_killed)
			var/datum/entity/statistic/stat_sub_iteration = stat.humans_killed[sub_iteration]
			if(!stat_sub_iteration)
				continue
			job_humans_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.xenos_killed)
			var/datum/entity/statistic/stat_sub_iteration = stat.xenos_killed[sub_iteration]
			if(!stat_sub_iteration)
				continue
			job_xenos_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.niche_stats)
			var/datum/entity/statistic/stat_sub_iteration = stat.niche_stats[sub_iteration]
			if(!stat_sub_iteration)
				continue
			job_niche_stats_list += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/datum/entity/statistic/death/DS in stat.death_list)
			var/list/damage_list = list()
			if(DS.total_brute)
				damage_list += list(list("name" = "brute", "value" = DS.total_brute))
			if(DS.total_burn)
				damage_list += list(list("name" = "burn", "value" = DS.total_burn))
			if(DS.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = DS.total_oxy))
			if(DS.total_tox)
				damage_list += list(list("name" = "tox", "value" = DS.total_tox))

			var/new_time_of_death
			if(DS.time_of_death)
				new_time_of_death = duration2text(DS.time_of_death)
			var/new_total_time_alive
			if(DS.total_time_alive)
				new_total_time_alive = duration2text(DS.total_time_alive)

			job_death_list += list(list(
				"mob_name" = sanitize(DS.mob_name),
				"job_name" = DS.role_name,
				"area_name" = sanitize_area(DS.area_name),
				"cause_name" = sanitize(DS.cause_name),
				"total_kills" = DS.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = new_time_of_death,
				"total_time_alive" = new_total_time_alive,
				"total_damage_taken" = DS.total_damage_taken,
				"x" = DS.x,
				"y" = DS.y,
				"z" = DS.z
			))

		new_job_stats_list += list(list(
			"name" = stat.name,
			"total_kills" = stat.total_kills,
			"total_deaths" = stat.total_deaths,
			"total_playtime" = duration2text(stat.total_playtime),
			"total_rounds_played" = stat.total_rounds_played,
			"steps_walked" = stat.steps_walked,
			"total_friendly_fire" = stat.total_friendly_fire,
			"total_revives" = stat.total_revives,
			"total_lives_saved" = stat.total_lives_saved,
			"total_shots" = stat.total_shots,
			"total_shots_hit" = stat.total_shots_hit,
			"total_screams" = stat.total_screams,
			"nemesis" = job_nemesis,
			"humans_killed" = job_humans_killed,
			"xenos_killed" = job_xenos_killed,
			"job_death_list" = job_death_list,
			"niche_stats" = job_niche_stats_list
		))

	for(var/iteration in caste_stats_list)
		var/datum/entity/player_stats/caste/stat = caste_stats_list[iteration]
		if(!stat.display_stat)
			continue
		var/list/caste_abilities_used = list()
		var/list/caste_humans_killed = list()
		var/list/caste_xenos_killed = list()
		var/list/caste_death_list = list()
		var/list/caste_niche_stats_list = list()
		var/list/caste_nemesis = null

		if(stat.nemesis)
			caste_nemesis = list("name" = stat.nemesis.name, "value" = stat.nemesis.value)

		for(var/sub_iteration in stat.abilities_used)
			var/datum/entity/statistic/stat_sub_iteration = stat.abilities_used[sub_iteration]
			if(!stat_sub_iteration)
				continue
			caste_abilities_used += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.humans_killed)
			var/datum/entity/statistic/stat_sub_iteration = stat.humans_killed[sub_iteration]
			if(!stat_sub_iteration)
				continue
			caste_humans_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.xenos_killed)
			var/datum/entity/statistic/stat_sub_iteration = stat.xenos_killed[sub_iteration]
			if(!stat_sub_iteration)
				continue
			caste_xenos_killed += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/sub_iteration in stat.niche_stats)
			var/datum/entity/statistic/stat_sub_iteration = stat.niche_stats[sub_iteration]
			if(!stat_sub_iteration)
				continue
			caste_niche_stats_list += list(list("name" = stat_sub_iteration.name, "value" = stat_sub_iteration.value))

		for(var/datum/entity/statistic/death/DS in stat.death_list)
			var/list/damage_list = list()
			if(DS.total_brute)
				damage_list += list(list("name" = "brute", "value" = DS.total_brute))
			if(DS.total_burn)
				damage_list += list(list("name" = "burn", "value" = DS.total_burn))
			if(DS.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = DS.total_oxy))
			if(DS.total_tox)
				damage_list += list(list("name" = "tox", "value" = DS.total_tox))

			var/new_time_of_death
			if(DS.time_of_death)
				new_time_of_death = duration2text(DS.time_of_death)
			var/new_total_time_alive
			if(DS.total_time_alive)
				new_total_time_alive = duration2text(DS.total_time_alive)

			caste_death_list += list(list(
				"mob_name" = sanitize(DS.mob_name),
				"job_name" = DS.role_name,
				"area_name" = sanitize_area(DS.area_name),
				"cause_name" = sanitize(DS.cause_name),
				"total_kills" = DS.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = new_time_of_death,
				"total_time_alive" = new_total_time_alive,
				"total_damage_taken" = DS.total_damage_taken,
				"x" = DS.x,
				"y" = DS.y,
				"z" = DS.z
			))

		new_caste_stats_list += list(list(
			"name" = stat.name,
			"total_kills" = stat.total_kills,
			"total_hits" = stat.total_hits,
			"total_deaths" = stat.total_deaths,
			"total_playtime" = duration2text(stat.total_playtime),
			"total_rounds_played" = stat.total_rounds_played,
			"steps_walked" = stat.steps_walked,
			"nemesis" = caste_nemesis,
			"humans_killed" = caste_humans_killed,
			"xenos_killed" = caste_xenos_killed,
			"death_list" = caste_death_list,
			"abilities_used" = caste_abilities_used,
			"niche_stats" = caste_niche_stats_list
		))

	var/new_time_start
	if(real_time_start)
		new_time_start = time2text(real_time_start)

	var/new_round_length
	if(round_length)
		new_round_length = duration2text(round_length)

	var/new_hijack_time
	if(round_hijack_time)
		new_hijack_time = time2text(round_hijack_time)

	var/new_time_end
	if(real_time_end)
		new_time_end = time2text(real_time_end)

	death_data["death_stats_list"] = new_death_stats_list
	round_data["round"] = list(
		"name" = name,
		"game_mode" = game_mode,
		"map_name" = map_name,
		"round_result" = round_result,
		"real_time_start" = new_time_start,
		"real_time_end" = new_time_end,
		"round_length" = new_round_length,
		"round_hijack_time" = new_hijack_time,
		"end_round_player_population" = end_round_player_population,
		"total_projectiles_fired" = total_projectiles_fired,
		"total_projectiles_hit" = total_projectiles_hit,
		"total_projectiles_hit_human" = total_projectiles_hit_human,
		"total_projectiles_hit_xeno" = total_projectiles_hit_xeno,
		"total_slashes" = total_slashes,
		"total_friendly_fire_instances" = total_friendly_fire_instances,
		"total_friendly_fire_kills" = total_friendly_fire_kills,
		"total_huggers_applied" = total_huggers_applied,
		"total_larva_burst" = total_larva_burst,
		"participants" = participants_list,
		"hijack_participants" = hijack_participants_list,
		"final_participants" = final_participants_list,
		"total_deaths" = total_deaths_list,
		"death_stats_list" = new_death_stats_list,
		"weapon_stats_list" = new_weapon_stats_list,
		"job_stats_list" = new_job_stats_list,
		"caste_stats_list" = new_caste_stats_list
	)

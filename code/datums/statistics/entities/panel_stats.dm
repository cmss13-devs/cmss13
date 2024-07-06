//*******************************************************
//*******************STAT PANEL**************************
//*******************************************************


/datum/entity/player_entity/proc/show_statistics(mob/user, datum/entity/statistic/round/viewing_round = GLOB.round_statistics, update_data = FALSE)
	if(update_data)
		update_panel_data(GLOB.round_statistics)
	ui_interact(user)

/datum/entity/player_entity/proc/ui_interact(mob/user, ui_key = "statistics", datum/nanoui/ui, force_open = 1)
	data["menu"] = menu
	data["subMenu"] = subMenu
	data["dataMenu"] = dataMenu

	ui = SSnano.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

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

	SSnano.nanomanager.update_uis(src)

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

/datum/entity/player_entity/proc/update_panel_data(datum/entity/statistic/round/viewing_round = GLOB.round_statistics)
	data["current_time"] = worldtime2text()

	if(viewing_round)
		viewing_round.update_panel_data()
		data["round"] = viewing_round.round_data["round"]

	if(player_stats["human"])
		var/datum/entity/player_stats/human/H = player_stats["human"]
		var/list/humans_killed = list()
		var/list/xenos_killed = list()
		var/list/medal_list = list()
		var/list/death_list = list()
		var/list/weapon_stats_list = list()
		var/list/job_stats_list = list()
		var/list/niche_stats_list = list()
		var/list/top_weapon = null
		var/list/human_nemesis = null

		if(H.nemesis)
			human_nemesis = list("name" = H.nemesis.name, "value" = H.nemesis.value)

		if(H.top_weapon)
			top_weapon = list(
				"name" = sanitize(H.top_weapon.name),
				"total_kills" = H.top_weapon.total_kills,
				"total_hits" = H.top_weapon.total_hits,
				"total_shots" = H.top_weapon.total_shots,
				"total_shots_hit" = H.top_weapon.total_shots_hit,
				"total_friendly_fire" = H.top_weapon.total_friendly_fire
			)

		for(var/iteration in H.humans_killed)
			var/datum/entity/statistic/S = H.humans_killed[iteration]
			humans_killed += list(list("name" = S.name, "value" = S.value))

		for(var/iteration in H.xenos_killed)
			var/datum/entity/statistic/S = H.xenos_killed[iteration]
			xenos_killed += list(list("name" = S.name, "value" = S.value))

		for(var/iteration in H.niche_stats)
			var/datum/entity/statistic/S = H.niche_stats[iteration]
			niche_stats_list += list(list("name" = S.name, "value" = S.value))

		for(var/datum/entity/statistic/medal/S in H.medal_list)
			medal_list += list(list(
				"medal_type" = sanitize(S.medal_type),
				"recipient" = sanitize(S.recipient_name),
				"recipient_job" = sanitize(S.recipient_role),
				"citation" = sanitize(S.citation),
				"giver" = sanitize(S.giver_name)
			))

		for(var/datum/entity/statistic/death/S in H.death_list)
			var/list/damage_list = list()
			if(S.total_brute)
				damage_list += list(list("name" = "brute", "value" = S.total_brute))
			if(S.total_burn)
				damage_list += list(list("name" = "burn", "value" = S.total_burn))
			if(S.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = S.total_oxy))
			if(S.total_tox)
				damage_list += list(list("name" = "tox", "value" = S.total_tox))
			death_list += list(list(
				"mob_name" = sanitize(S.mob_name),
				"job_name" = S.role_name,
				"area_name" = sanitize_area(S.area_name),
				"cause_name" = sanitize(S.cause_name),
				"total_kills" = S.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(S.time_of_death),
				"total_time_alive" = duration2text(S.total_time_alive),
				"total_damage_taken" = S.total_damage_taken,
				"x" = S.x,
				"y" = S.y,
				"z" = S.z
			))

		for(var/iteration in H.weapon_stats_list)
			var/datum/entity/weapon_stats/S = H.weapon_stats_list[iteration]
			if(!S.display_stat)
				continue
			var/list/weapon_humans_killed = list()
			var/list/weapon_xenos_killed = list()
			var/list/weapon_niche_stats_list = list()

			for(var/sub_iteration in S.humans_killed)
				var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
				weapon_humans_killed += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.xenos_killed)
				var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
				weapon_xenos_killed += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.niche_stats)
				var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
				weapon_niche_stats_list += list(list("name" = D.name, "value" = D.value))

			weapon_stats_list += list(list(
				"name" = sanitize(S.name),
				"total_kills" = S.total_kills,
				"total_hits" = S.total_hits,
				"total_shots" = S.total_shots,
				"total_shots_hit" = S.total_shots_hit,
				"total_friendly_fire" = S.total_friendly_fire,
				"humans_killed" = weapon_humans_killed,
				"xenos_killed" = weapon_xenos_killed,
				"niche_stats" = weapon_niche_stats_list
			))

		for(var/iteration in H.job_stats_list)
			var/datum/entity/player_stats/job/S = H.job_stats_list[iteration]
			if(!S.display_stat)
				continue
			var/list/job_humans_killed = list()
			var/list/job_xenos_killed = list()
			var/list/job_death_list = list()
			var/list/job_niche_stats_list = list()
			var/list/job_nemesis = null

			if(S.nemesis)
				job_nemesis = list("name" = S.nemesis.name, "value" = S.nemesis.value)

			for(var/sub_iteration in S.humans_killed)
				var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
				job_humans_killed += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.xenos_killed)
				var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
				job_xenos_killed += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.niche_stats)
				var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
				job_niche_stats_list += list(list("name" = D.name, "value" = D.value))

			for(var/datum/entity/statistic/death/DS in S.death_list)
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
				"name" = S.name,
				"total_kills" = S.total_kills,
				"total_deaths" = S.total_deaths,
				"total_playtime" = duration2text(S.total_playtime),
				"total_rounds_played" = S.total_rounds_played,
				"steps_walked" = S.steps_walked,
				"total_friendly_fire" = S.total_friendly_fire,
				"total_revives" = S.total_revives,
				"total_lives_saved" = S.total_lives_saved,
				"total_shots" = S.total_shots,
				"total_shots_hit" = S.total_shots_hit,
				"total_screams" = S.total_screams,
				"nemesis" = job_nemesis,
				"humans_killed" = job_humans_killed,
				"xenos_killed" = job_xenos_killed,
				"job_death_list" = job_death_list,
				"niche_stats" = job_niche_stats_list
			))

		data["human"] = list(
			"total_kills" = H.total_kills,
			"total_deaths" = H.total_deaths,
			"total_playtime" = duration2text(H.total_playtime),
			"total_rounds_played" = H.total_rounds_played,
			"steps_walked" = H.steps_walked,
			"total_friendly_fire" = H.total_friendly_fire,
			"total_revives" = H.total_revives,
			"total_lives_saved" = H.total_lives_saved,
			"total_shots" = H.total_shots,
			"total_shots_hit" = H.total_shots_hit,
			"total_screams" = H.total_screams,
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
		var/datum/entity/player_stats/xeno/H = player_stats["xeno"]
		var/list/humans_killed = list()
		var/list/xenos_killed = list()
		var/list/medal_list = list()
		var/list/death_list = list()
		var/list/caste_stats_list = list()
		var/list/niche_stats_list = list()
		var/list/top_caste = null
		var/list/xeno_nemesis = null

		if(H.nemesis)
			xeno_nemesis = list("name" = H.nemesis.name, "value" = H.nemesis.value)

		if(H.top_caste)
			top_caste = list(
				"name" = H.top_caste.name,
				"total_kills" = H.top_caste.total_kills,
				"total_deaths" = H.top_caste.total_deaths,
				"total_playtime" = duration2text(H.top_caste.total_playtime),
				"total_rounds_played" = H.top_caste.total_rounds_played,
			)

		for(var/iteration in H.humans_killed)
			var/datum/entity/statistic/S = H.humans_killed[iteration]
			humans_killed += list(list("name" = S.name, "value" = S.value))

		for(var/iteration in H.xenos_killed)
			var/datum/entity/statistic/S = H.xenos_killed[iteration]
			xenos_killed += list(list("name" = S.name, "value" = S.value))

		for(var/iteration in H.niche_stats)
			var/datum/entity/statistic/S = H.niche_stats[iteration]
			niche_stats_list += list(list("name" = S.name, "value" = S.value))

		for(var/datum/entity/statistic/medal/S in H.medal_list)
			medal_list += list(list(
				"medal_type" = sanitize(S.medal_type),
				"recipient" = sanitize(S.recipient_name),
				"recipient_job" = sanitize(S.recipient_role),
				"citation" = sanitize(S.citation),
				"giver" = sanitize(S.giver_name)
			))

		for(var/datum/entity/statistic/death/S in H.death_list)
			var/list/damage_list = list()
			if(S.total_brute)
				damage_list += list(list("name" = "brute", "value" = S.total_brute))
			if(S.total_burn)
				damage_list += list(list("name" = "burn", "value" = S.total_burn))
			if(S.total_oxy)
				damage_list += list(list("name" = "oxy", "value" = S.total_oxy))
			if(S.total_tox)
				damage_list += list(list("name" = "tox", "value" = S.total_tox))
			death_list += list(list(
				"mob_name" = sanitize(S.mob_name),
				"job_name" = S.role_name,
				"area_name" = sanitize_area(S.area_name),
				"cause_name" = sanitize(S.cause_name),
				"total_kills" = S.total_kills,
				"total_damage" = damage_list,
				"time_of_death" = duration2text(S.time_of_death),
				"total_time_alive" = duration2text(S.total_time_alive),
				"total_damage_taken" = S.total_damage_taken,
				"x" = S.x,
				"y" = S.y,
				"z" = S.z
			))

		for(var/iteration in H.caste_stats_list)
			var/datum/entity/player_stats/caste/S = H.caste_stats_list[iteration]
			if(!S.display_stat)
				continue
			var/list/caste_abilities_used = list()
			var/list/caste_humans_killed = list()
			var/list/caste_xenos_killed = list()
			var/list/caste_death_list = list()
			var/list/caste_niche_stats_list = list()
			var/list/caste_nemesis = null

			if(S.nemesis)
				caste_nemesis = list("name" = S.nemesis.name, "value" = S.nemesis.value)

			for(var/sub_iteration in S.abilities_used)
				var/datum/entity/statistic/D = S.abilities_used[sub_iteration]
				caste_abilities_used += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.humans_killed)
				var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
				caste_humans_killed += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.xenos_killed)
				var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
				caste_xenos_killed += list(list("name" = D.name, "value" = D.value))

			for(var/sub_iteration in S.niche_stats)
				var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
				caste_niche_stats_list += list(list("name" = D.name, "value" = D.value))

			for(var/datum/entity/statistic/death/DS in S.death_list)
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
				"name" = S.name,
				"total_kills" = S.total_kills,
				"total_hits" = S.total_hits,
				"total_deaths" = S.total_deaths,
				"total_playtime" = duration2text(S.total_playtime),
				"total_rounds_played" = S.total_rounds_played,
				"steps_walked" = S.steps_walked,
				"nemesis" = caste_nemesis,
				"humans_killed" = caste_humans_killed,
				"xenos_killed" = caste_xenos_killed,
				"death_list" = caste_death_list,
				"abilities_used" = caste_abilities_used,
				"niche_stats" = caste_niche_stats_list
			))

		data["xeno"] = list(
			"total_kills" = H.total_kills,
			"total_deaths" = H.total_deaths,
			"total_playtime" = duration2text(H.total_playtime),
			"total_rounds_played" = H.total_rounds_played,
			"steps_walked" = H.steps_walked,
			"total_hits" = H.total_hits,
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
		var/datum/entity/statistic/S = participants[iteration]
		participants_list += list(list("name" = S.name, "value" = S.value))

	for(var/iteration in hijack_participants)
		var/datum/entity/statistic/S = hijack_participants[iteration]
		hijack_participants_list += list(list("name" = S.name, "value" = S.value))

	for(var/iteration in final_participants)
		var/datum/entity/statistic/S = final_participants[iteration]
		final_participants_list += list(list("name" = S.name, "value" = S.value))

	for(var/iteration in total_deaths)
		var/datum/entity/statistic/S = total_deaths[iteration]
		total_deaths_list += list(list("name" = S.name, "value" = S.value))

	for(var/datum/entity/statistic/death/S in death_stats_list)
		if(length(new_death_stats_list) >= STATISTICS_DEATH_LIST_LEN)
			break
		var/list/damage_list = list()
		if(S.total_brute)
			damage_list += list(list("name" = "brute", "value" = S.total_brute))
		if(S.total_burn)
			damage_list += list(list("name" = "burn", "value" = S.total_burn))
		if(S.total_oxy)
			damage_list += list(list("name" = "oxy", "value" = S.total_oxy))
		if(S.total_tox)
			damage_list += list(list("name" = "tox", "value" = S.total_tox))

		var/new_time_of_death
		if(S.time_of_death)
			new_time_of_death = duration2text(S.time_of_death)
		var/new_total_time_alive
		if(S.total_time_alive)
			new_total_time_alive = duration2text(S.total_time_alive)

		var/death = list(list(
			"mob_name" = sanitize(S.mob_name),
			"job_name" = S.role_name,
			"area_name" = sanitize_area(S.area_name),
			"cause_name" = sanitize(S.cause_name),
			"total_kills" = S.total_kills,
			"total_damage" = damage_list,
			"time_of_death" = new_time_of_death,
			"total_time_alive" = new_total_time_alive,
			"total_damage_taken" = S.total_damage_taken,
			"x" = S.x,
			"y" = S.y,
			"z" = S.z
		))
		if(length(new_death_stats_list) < STATISTICS_DEATH_LIST_LEN)
			new_death_stats_list += death

	for(var/iteration in weapon_stats_list)
		var/datum/entity/weapon_stats/S = weapon_stats_list[iteration]
		if(!S.display_stat)
			continue
		var/list/weapon_humans_killed = list()
		var/list/weapon_xenos_killed = list()
		var/list/weapon_niche_stats_list = list()

		for(var/sub_iteration in S.humans_killed)
			var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
			if(!D)
				continue
			weapon_humans_killed += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.xenos_killed)
			var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
			if(!D)
				continue
			weapon_xenos_killed += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.niche_stats)
			var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
			if(!D)
				continue
			weapon_niche_stats_list += list(list("name" = D.name, "value" = D.value))

		new_weapon_stats_list += list(list(
			"name" = sanitize(S.name),
			"total_kills" = S.total_kills,
			"total_hits" = S.total_hits,
			"total_shots" = S.total_shots,
			"total_shots_hit" = S.total_shots_hit,
			"total_friendly_fire" = S.total_friendly_fire,
			"humans_killed" = weapon_humans_killed,
			"xenos_killed" = weapon_xenos_killed,
			"niche_stats" = weapon_niche_stats_list
		))

	for(var/iteration in job_stats_list)
		var/datum/entity/player_stats/job/S = job_stats_list[iteration]
		if(!S.display_stat)
			continue
		var/list/job_humans_killed = list()
		var/list/job_xenos_killed = list()
		var/list/job_death_list = list()
		var/list/job_niche_stats_list = list()
		var/list/job_nemesis = null

		if(S.nemesis)
			job_nemesis = list("name" = S.nemesis.name, "value" = S.nemesis.value)

		for(var/sub_iteration in S.humans_killed)
			var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
			if(!D)
				continue
			job_humans_killed += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.xenos_killed)
			var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
			if(!D)
				continue
			job_xenos_killed += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.niche_stats)
			var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
			if(!D)
				continue
			job_niche_stats_list += list(list("name" = D.name, "value" = D.value))

		for(var/datum/entity/statistic/death/DS in S.death_list)
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
			"name" = S.name,
			"total_kills" = S.total_kills,
			"total_deaths" = S.total_deaths,
			"total_playtime" = duration2text(S.total_playtime),
			"total_rounds_played" = S.total_rounds_played,
			"steps_walked" = S.steps_walked,
			"total_friendly_fire" = S.total_friendly_fire,
			"total_revives" = S.total_revives,
			"total_lives_saved" = S.total_lives_saved,
			"total_shots" = S.total_shots,
			"total_shots_hit" = S.total_shots_hit,
			"total_screams" = S.total_screams,
			"nemesis" = job_nemesis,
			"humans_killed" = job_humans_killed,
			"xenos_killed" = job_xenos_killed,
			"job_death_list" = job_death_list,
			"niche_stats" = job_niche_stats_list
		))

	for(var/iteration in caste_stats_list)
		var/datum/entity/player_stats/caste/S = caste_stats_list[iteration]
		if(!S.display_stat)
			continue
		var/list/caste_abilities_used = list()
		var/list/caste_humans_killed = list()
		var/list/caste_xenos_killed = list()
		var/list/caste_death_list = list()
		var/list/caste_niche_stats_list = list()
		var/list/caste_nemesis = null

		if(S.nemesis)
			caste_nemesis = list("name" = S.nemesis.name, "value" = S.nemesis.value)

		for(var/sub_iteration in S.abilities_used)
			var/datum/entity/statistic/D = S.abilities_used[sub_iteration]
			if(!D)
				continue
			caste_abilities_used += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.humans_killed)
			var/datum/entity/statistic/D = S.humans_killed[sub_iteration]
			if(!D)
				continue
			caste_humans_killed += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.xenos_killed)
			var/datum/entity/statistic/D = S.xenos_killed[sub_iteration]
			if(!D)
				continue
			caste_xenos_killed += list(list("name" = D.name, "value" = D.value))

		for(var/sub_iteration in S.niche_stats)
			var/datum/entity/statistic/D = S.niche_stats[sub_iteration]
			if(!D)
				continue
			caste_niche_stats_list += list(list("name" = D.name, "value" = D.value))

		for(var/datum/entity/statistic/death/DS in S.death_list)
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
			"name" = S.name,
			"total_kills" = S.total_kills,
			"total_hits" = S.total_hits,
			"total_deaths" = S.total_deaths,
			"total_playtime" = duration2text(S.total_playtime),
			"total_rounds_played" = S.total_rounds_played,
			"steps_walked" = S.steps_walked,
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


/datum/entity/player_entity/proc/setup_save(key)
	if(key && !IsGuestKey(key))
		load_path(lowertext(key))
		load_statistics()
		savefile_version = PREFFILE_VERSION_MAX

/datum/entity/player_entity/proc/load_path(ckey,filename="statistics.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"
	savefile_version = PREFFILE_VERSION_MAX

/datum/entity/player_entity/proc/save_statistics()
	if(!path || !save_loaded)
		log_debug("STATISTICS: stats failed to save for [ckey] in [path] (save_loaded: [save_loaded])")
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	update_panel_data()

	S["version"] << savefile_version
	S["xeno"] << data["xeno"]
	S["human"] << data["human"]

	return TRUE

/datum/entity/player_entity/proc/load_statistics()
	if(!path || !fexists(path))
		save_loaded = TRUE
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		log_debug("STATISTICS: fexists but load failed for [ckey] in [path]")
		return FALSE
	S.cd = "/"

	if(S["version"] < PREFFILE_VERSION_MIN)
		return FALSE

	S["version"] >> savefile_version

	var/list/human_save = list()
	var/list/xeno_save = list()

	S["human"] >> human_save
	S["xeno"] >> xeno_save

	if(human_save)
		setup_human_stats()
		var/datum/entity/player_stats/human/human_stats = player_stats["human"]
		human_stats.total_kills = human_save["total_kills"]
		human_stats.total_deaths = human_save["total_deaths"]
		human_stats.total_playtime = text2duration(human_save["total_playtime"])
		human_stats.total_rounds_played = human_save["total_rounds_played"]
		human_stats.steps_walked = human_save["steps_walked"]

		human_stats.total_friendly_fire = human_save["total_friendly_fire"]
		human_stats.total_revives = human_save["total_revives"]
		human_stats.total_lives_saved = human_save["total_lives_saved"]
		human_stats.total_shots = human_save["total_shots"]
		human_stats.total_shots_hit = human_save["total_shots_hit"]
		human_stats.total_screams = human_save["total_screams"]

		if(human_save["nemesis"])
			var/save_nemesis = human_save["nemesis"]
			var/datum/entity/statistic/new_nemesis = new()
			new_nemesis.name = save_nemesis["name"]
			new_nemesis.value = save_nemesis["value"]
			human_stats.nemesis = new_nemesis

		if(human_save["humans_killed"])
			var/save_humans_killed = human_save["humans_killed"]
			var/list/new_humans_killed_list = new()
			for(var/save_kill in save_humans_killed)
				var/datum/entity/statistic/new_human_killed = new()
				new_human_killed.name = save_kill["name"]
				new_human_killed.value = save_kill["value"]
				new_humans_killed_list["[new_human_killed.name]"] = new_human_killed
			human_stats.humans_killed = new_humans_killed_list

		if(human_save["xenos_killed"])
			var/save_xeno_killed = human_save["xenos_killed"]
			var/list/new_xenos_killed_list = new()
			for(var/save_kill in save_xeno_killed)
				var/datum/entity/statistic/new_xeno_killed = new()
				new_xeno_killed.name = save_kill["name"]
				new_xeno_killed.value = save_kill["value"]
				new_xenos_killed_list["[new_xeno_killed.name]"] = new_xeno_killed
			human_stats.xenos_killed = new_xenos_killed_list

		if(human_save["niche_stats"])
			var/save_niche_stats = human_save["niche_stats"]
			var/list/new_niche_stat_list = new()
			for(var/save_niche in save_niche_stats)
				var/datum/entity/statistic/new_niche_stat = new()
				new_niche_stat.name = save_niche["name"]
				new_niche_stat.value = save_niche["value"]
				new_niche_stat_list["[new_niche_stat.name]"] = new_niche_stat
			human_stats.niche_stats = new_niche_stat_list

		if(human_save["weapon_stats_list"])
			var/save_weapon_list = human_save["weapon_stats_list"]
			var/list/new_weapon_list = new()
			for(var/save_weapon in save_weapon_list)
				var/datum/entity/weapon_stats/new_weapon = new()
				new_weapon.player = src
				new_weapon.name = save_weapon["name"]
				new_weapon.total_kills = save_weapon["total_kills"]
				new_weapon.total_hits = save_weapon["total_hits"]
				new_weapon.total_shots = save_weapon["total_shots"]
				new_weapon.total_shots_hit = save_weapon["total_shots_hit"]
				new_weapon.total_friendly_fire = save_weapon["total_friendly_fire"]

				if(save_weapon["humans_killed"])
					var/save_humans_killed = save_weapon["humans_killed"]
					var/list/new_humans_killed_list = new()
					for(var/save_kill in save_humans_killed)
						var/datum/entity/statistic/new_human_killed = new()
						new_human_killed.name = save_kill["name"]
						new_human_killed.value = save_kill["value"]
						new_humans_killed_list["[new_human_killed.name]"] = new_human_killed
					new_weapon.humans_killed = new_humans_killed_list

				if(save_weapon["xenos_killed"])
					var/save_xeno_killed = save_weapon["xenos_killed"]
					var/list/new_xenos_killed_list = new()
					for(var/save_kill in save_xeno_killed)
						var/datum/entity/statistic/new_xeno_killed = new()
						new_xeno_killed.name = save_kill["name"]
						new_xeno_killed.value = save_kill["value"]
						new_xenos_killed_list["[new_xeno_killed.name]"] = new_xeno_killed
					new_weapon.xenos_killed = new_xenos_killed_list

				if(save_weapon["niche_stats"])
					var/save_niche_stats = save_weapon["niche_stats"]
					var/list/new_niche_stat_list = new()
					for(var/save_niche in save_niche_stats)
						var/datum/entity/statistic/new_niche_stat = new()
						new_niche_stat.name = save_niche["name"]
						new_niche_stat.value = save_niche["value"]
						new_niche_stat_list["[new_niche_stat.name]"] = new_niche_stat
					new_weapon.niche_stats = new_niche_stat_list

				new_weapon_list["[new_weapon.name]"] = new_weapon
			human_stats.weapon_stats_list = new_weapon_list

		if(human_save["job_stats_list"])
			var/save_job_list = human_save["job_stats_list"]
			var/list/new_job_list = new()
			for(var/save_job in save_job_list)
				var/datum/entity/player_stats/job/new_job = new()
				new_job.total_kills = save_job["total_kills"]
				new_job.total_deaths = save_job["total_deaths"]
				new_job.total_playtime = text2duration(save_job["total_playtime"])
				new_job.total_rounds_played = save_job["total_rounds_played"]
				new_job.steps_walked = save_job["steps_walked"]

				new_job.name = save_job["name"]
				new_job.total_friendly_fire = save_job["total_friendly_fire"]
				new_job.total_revives = save_job["total_revives"]
				new_job.total_lives_saved = save_job["total_lives_saved"]
				new_job.total_shots = save_job["total_shots"]
				new_job.total_shots_hit = save_job["total_shots_hit"]
				new_job.total_screams = save_job["total_screams"]

				if(save_job["nemesis"])
					var/save_nemesis = save_job["nemesis"]
					var/datum/entity/statistic/new_nemesis = new()
					new_nemesis.name = save_nemesis["name"]
					new_nemesis.value = save_nemesis["value"]
					new_job.nemesis = new_nemesis

				if(save_job["humans_killed"])
					var/save_humans_killed = save_job["humans_killed"]
					var/list/new_humans_killed_list = new()
					for(var/save_kill in save_humans_killed)
						var/datum/entity/statistic/new_human_killed = new()
						new_human_killed.name = save_kill["name"]
						new_human_killed.value = save_kill["value"]
						new_humans_killed_list["[new_human_killed.name]"] = new_human_killed
					new_job.humans_killed = new_humans_killed_list

				if(save_job["xenos_killed"])
					var/save_xeno_killed = save_job["xenos_killed"]
					var/list/new_xenos_killed_list = new()
					for(var/save_kill in save_xeno_killed)
						var/datum/entity/statistic/new_xeno_killed = new()
						new_xeno_killed.name = save_kill["name"]
						new_xeno_killed.value = save_kill["value"]
						new_xenos_killed_list["[new_xeno_killed.name]"] = new_xeno_killed
					new_job.xenos_killed = new_xenos_killed_list

				if(save_job["niche_stats"])
					var/save_niche_stats = save_job["niche_stats"]
					var/list/new_niche_stat_list = new()
					for(var/save_niche in save_niche_stats)
						var/datum/entity/statistic/new_niche_stat = new()
						new_niche_stat.name = save_niche["name"]
						new_niche_stat.value = save_niche["value"]
						new_niche_stat_list["[new_niche_stat.name]"] = new_niche_stat
					new_job.niche_stats = new_niche_stat_list

				new_job_list["[new_job.name]"] = new_job
			human_stats.job_stats_list = new_job_list

		human_stats.recalculate_nemesis()
		human_stats.recalculate_top_weapon()

	if(xeno_save)
		setup_xeno_stats()
		var/datum/entity/player_stats/xeno/xeno_stats = player_stats["xeno"]
		xeno_stats.total_kills = xeno_save["total_kills"]
		xeno_stats.total_deaths = xeno_save["total_deaths"]
		xeno_stats.total_playtime = text2duration(xeno_save["total_playtime"])
		xeno_stats.total_rounds_played = xeno_save["total_rounds_played"]
		xeno_stats.steps_walked = xeno_save["steps_walked"]

		xeno_stats.total_hits = xeno_save["total_hits"]

		if(xeno_save["nemesis"])
			var/save_nemesis = xeno_save["nemesis"]
			var/datum/entity/statistic/new_nemesis = new()
			new_nemesis.name = save_nemesis["name"]
			new_nemesis.value = save_nemesis["value"]
			xeno_stats.nemesis = new_nemesis

		if(xeno_save["humans_killed"])
			var/save_humans_killed = xeno_save["humans_killed"]
			var/list/new_humans_killed_list = new()
			for(var/save_kill in save_humans_killed)
				var/datum/entity/statistic/new_human_killed = new()
				new_human_killed.name = save_kill["name"]
				new_human_killed.value = save_kill["value"]
				new_humans_killed_list["[new_human_killed.name]"] = new_human_killed
			xeno_stats.humans_killed = new_humans_killed_list

		if(xeno_save["xenos_killed"])
			var/save_xeno_killed = xeno_save["xenos_killed"]
			var/list/new_xenos_killed_list = new()
			for(var/save_kill in save_xeno_killed)
				var/datum/entity/statistic/new_xeno_killed = new()
				new_xeno_killed.name = save_kill["name"]
				new_xeno_killed.value = save_kill["value"]
				new_xenos_killed_list["[new_xeno_killed.name]"] = new_xeno_killed
			xeno_stats.xenos_killed = new_xenos_killed_list

		if(xeno_save["niche_stats"])
			var/save_niche_stats = xeno_save["niche_stats"]
			var/list/new_niche_stat_list = new()
			for(var/save_niche in save_niche_stats)
				var/datum/entity/statistic/new_niche_stat = new()
				new_niche_stat.name = save_niche["name"]
				new_niche_stat.value = save_niche["value"]
				new_niche_stat_list["[new_niche_stat.name]"] = new_niche_stat
			xeno_stats.niche_stats = new_niche_stat_list

		if(xeno_save["caste_stats_list"])
			var/save_caste_list = xeno_save["caste_stats_list"]
			var/list/new_caste_list = new()
			for(var/save_caste in save_caste_list)
				var/datum/entity/player_stats/caste/new_caste = new()
				new_caste.total_kills = save_caste["total_kills"]
				new_caste.total_deaths = save_caste["total_deaths"]
				new_caste.total_playtime = text2duration(save_caste["total_playtime"])
				new_caste.total_rounds_played = save_caste["total_rounds_played"]
				new_caste.steps_walked = save_caste["steps_walked"]

				new_caste.name = save_caste["name"]
				new_caste.total_hits = save_caste["total_hits"]

				if(save_caste["nemesis"])
					var/save_nemesis = save_caste["nemesis"]
					var/datum/entity/statistic/new_nemesis = new()
					new_nemesis.name = save_nemesis["name"]
					new_nemesis.value = save_nemesis["value"]
					new_caste.nemesis = new_nemesis

				if(save_caste["abilities_used"])
					var/save_abilities_used = save_caste["abilities_used"]
					var/list/new_abilities_used_list = new()
					for(var/save_ability in save_abilities_used)
						var/datum/entity/statistic/new_ability_used = new()
						new_ability_used.name = save_ability["name"]
						new_ability_used.value = save_ability["value"]
						new_abilities_used_list["[new_ability_used.name]"] = new_ability_used
					new_caste.abilities_used = new_abilities_used_list

				if(save_caste["humans_killed"])
					var/save_humans_killed = save_caste["humans_killed"]
					var/list/new_humans_killed_list = new()
					for(var/save_kill in save_humans_killed)
						var/datum/entity/statistic/new_human_killed = new()
						new_human_killed.name = save_kill["name"]
						new_human_killed.value = save_kill["value"]
						new_humans_killed_list["[new_human_killed.name]"] = new_human_killed
					new_caste.humans_killed = new_humans_killed_list

				if(save_caste["xenos_killed"])
					var/save_xeno_killed = save_caste["xenos_killed"]
					var/list/new_xenos_killed_list = new()
					for(var/save_kill in save_xeno_killed)
						var/datum/entity/statistic/new_xeno_killed = new()
						new_xeno_killed.name = save_kill["name"]
						new_xeno_killed.value = save_kill["value"]
						new_xenos_killed_list["[new_xeno_killed.name]"] = new_xeno_killed
					new_caste.xenos_killed = new_xenos_killed_list

				if(save_caste["niche_stats"])
					var/save_niche_stats = save_caste["niche_stats"]
					var/list/new_niche_stat_list = new()
					for(var/save_niche in save_niche_stats)
						var/datum/entity/statistic/new_niche_stat = new()
						new_niche_stat.name = save_niche["name"]
						new_niche_stat.value = save_niche["value"]
						new_niche_stat_list["[new_niche_stat.name]"] = new_niche_stat
					new_caste.niche_stats = new_niche_stat_list

				new_caste_list["[new_caste.name]"] = new_caste
			xeno_stats.caste_stats_list = new_caste_list

		xeno_stats.recalculate_nemesis()
		xeno_stats.recalculate_top_caste()

	save_loaded = TRUE
	update_panel_data()
	return TRUE

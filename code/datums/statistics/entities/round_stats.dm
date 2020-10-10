/datum/entity/round_stats
	var/name = "round"
	var/datum/entity/map_stats/current_map = null // reference to current map
	var/list/datum/entity/death_stats/death_stats_list = list()
	
	var/game_mode = null

	var/real_time_start = 0 // GMT-based 11:04
	var/real_time_end = 0 // GMT-based 12:54
	var/round_length = null // current-time minus round-start time
	var/round_hijack_time = null //hijack time in-round
	var/round_result = null // "xeno_minor"
	var/end_round_player_population = 0

	var/list/abilities_used = list() // types of /datum/entity/statistic, "tail sweep" = 10, "screech" = 2

	var/list/participants = list() // types of /datum/entity/statistic, "[human.faction]" = 10, "xeno" = 2
	var/list/final_participants = list() // types of /datum/entity/statistic, "[human.faction]" = 0, "xeno" = 45
	var/list/hijack_participants = list() // types of /datum/entity/statistic, "[human.faction]" = 0, "xeno" = 45
	var/list/total_deaths = list() // types of /datum/entity/statistic, "[human.faction]" = 0, "xeno" = 45
	var/list/caste_stats_list = list() // list of types /datum/entity/player_stats/caste
	var/list/weapon_stats_list = list() // list of types /datum/entity/weapon_stats
	var/list/job_stats_list = list() // list of types /datum/entity/job_stats

	var/defcon_level = 5
	var/objective_points = 0
	var/total_objective_points = 0

	var/total_huggers_applied = 0
	var/total_larva_burst = 0

	var/total_projectiles_fired = 0
	var/total_projectiles_hit = 0
	var/total_projectiles_hit_human = 0
	var/total_projectiles_hit_xeno = 0
	var/total_friendly_fire_instances = 0
	var/total_friendly_fire_kills = 0
	var/total_slashes = 0

	// nanoui data
	var/round_data[0]
	var/death_data[0]

/datum/entity/round_stats/proc/setup_job_stats(var/job, var/noteworthy = TRUE)
	if(!job)
		return
	var/job_key = strip_improper(job)
	if(job_stats_list["[job_key]"])
		var/datum/entity/player_stats/job/S = job_stats_list["[job_key]"]
		if(!S.display_stat && noteworthy)
			S.display_stat = noteworthy
		return S
	var/datum/entity/player_stats/job/new_stat = new()
	new_stat.display_stat = noteworthy
	new_stat.player = src
	new_stat.name = job_key
	new_stat.total_rounds_played += 1
	job_stats_list["[job_key]"] = new_stat
	return new_stat

/datum/entity/round_stats/proc/setup_weapon_stats(var/weapon, var/noteworthy = TRUE)
	if(!weapon)
		return
	var/weapon_key = strip_improper(weapon)
	if(weapon_stats_list["[weapon_key]"])
		var/datum/entity/weapon_stats/S = weapon_stats_list["[weapon_key]"]
		if(!S.display_stat && noteworthy)
			S.display_stat = noteworthy
		return S
	var/datum/entity/weapon_stats/new_stat = new()
	new_stat.display_stat = noteworthy
	new_stat.player = src
	new_stat.name = weapon_key
	weapon_stats_list["[weapon_key]"] = new_stat
	return new_stat

/datum/entity/round_stats/proc/setup_caste_stats(var/caste, var/noteworthy = TRUE)
	if(!caste)
		return
	var/caste_key = strip_improper(caste)
	if(caste_stats_list["[caste_key]"])
		var/datum/entity/player_stats/caste/S = caste_stats_list["[caste_key]"]
		if(!S.display_stat && noteworthy)
			S.display_stat = noteworthy
		return S
	var/datum/entity/player_stats/caste/new_stat = new()
	new_stat.display_stat = noteworthy
	new_stat.player = src
	new_stat.name = caste_key
	new_stat.total_rounds_played += 1
	caste_stats_list["[caste_key]"] = new_stat
	return new_stat

/datum/entity/round_stats/proc/setup_ability(var/ability)
	if(!ability)
		return
	var/ability_key = strip_improper(ability)
	if(abilities_used["[ability_key]"])
		return abilities_used["[ability_key]"]
	var/datum/entity/statistic/S = new()
	S.name = ability_key
	S.value = 0
	abilities_used["[ability_key]"] = S
	return S

/datum/entity/round_stats/proc/recalculate_nemesis()
	for(var/caste_statistic in caste_stats_list)
		var/datum/entity/player_stats/caste/caste_entity = caste_stats_list[caste_statistic]
		caste_entity.recalculate_nemesis()
	for(var/job_statistic in job_stats_list)
		var/datum/entity/player_stats/job/job_entity = job_stats_list[job_statistic]
		job_entity.recalculate_nemesis()

/datum/entity/round_stats/proc/track_ability_usage(var/ability, var/amount = 1)
	var/datum/entity/statistic/S = setup_ability(ability)
	S.value += amount

/datum/entity/round_stats/proc/setup_faction(var/faction)
	if(!faction)
		return
	var/faction_key = strip_improper(faction)
	if(!participants["[faction_key]"])
		var/datum/entity/statistic/S = new()
		S.name = faction_key
		S.value = 0
		participants["[faction_key]"] = S
	if(!final_participants["[faction_key]"])
		var/datum/entity/statistic/S = new()
		S.name = faction_key
		S.value = 0
		final_participants["[faction_key]"] = S
	if(!hijack_participants["[faction_key]"])
		var/datum/entity/statistic/S = new()
		S.name = faction_key
		S.value = 0
		hijack_participants["[faction_key]"] = S
	if(!total_deaths["[faction_key]"])
		var/datum/entity/statistic/S = new()
		S.name = faction_key
		S.value = 0
		total_deaths["[faction_key]"] = S

/datum/entity/round_stats/proc/track_new_participant(var/faction, var/amount = 1)
	if(!faction)
		return
	if(!participants["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = participants["[faction]"]
	S.value += amount

/datum/entity/round_stats/proc/track_final_participant(var/faction, var/amount = 1)
	if(!faction)
		return
	if(!final_participants["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = final_participants["[faction]"]
	S.value += amount

/datum/entity/round_stats/proc/track_round_end()
	real_time_end = world.realtime
	for(var/mob/M in living_mob_list)
		if(M.mind)
			track_final_participant(M.faction)

/datum/entity/round_stats/proc/track_hijack_participant(var/faction, var/amount = 1)
	if(!faction)
		return
	if(!hijack_participants["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = hijack_participants["[faction]"]
	S.value += amount

/datum/entity/round_stats/proc/track_hijack()
	for(var/mob/M in living_mob_list)
		if(M.mind)
			track_hijack_participant(M.faction)
	round_hijack_time = world.time

/datum/entity/round_stats/proc/track_dead_participant(var/faction, var/amount = 1)
	if(!faction)
		return
	if(!total_deaths["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = total_deaths["[faction]"]
	S.value += amount

/datum/entity/round_stats/proc/track_death(var/datum/entity/death_stats/new_death, var/faction)
	if(new_death)
		death_stats_list.Insert(1, new_death)
		var/list/damage_list = list()
		for(var/damage_iteration in new_death.total_damage)
			var/datum/entity/statistic/D = new_death.total_damage[damage_iteration]
			damage_list += list(list("name" = D.name, "value" = D.value))

		var/new_time_of_death
		if(new_death.time_of_death)
			new_time_of_death = duration2text(new_death.time_of_death)
		var/new_total_time_alive
		if(new_death.total_time_alive)
			new_total_time_alive = duration2text(new_death.total_time_alive)

		var/death = list(list(
			"mob_name" = sanitize(new_death.mob_name),
			"job_name" = new_death.job_name,
			"area_name" = sanitize(new_death.area_name),
			"cause_name" = sanitize(new_death.cause_name),
			"total_kills" = new_death.total_kills,
			"total_damage" = damage_list,
			"time_of_death" = new_time_of_death,
			"total_time_alive" = new_total_time_alive,
			"x" = new_death.x,
			"y" = new_death.y,
			"z" = new_death.z
		))
		var/list/new_death_list = list()
		if(death_data["death_stats_list"])
			new_death_list = death_data["death_stats_list"]
		new_death_list.Insert(1, death)
		if(new_death_list.len > STATISTICS_DEATH_LIST_LEN)
			new_death_list.Cut(STATISTICS_DEATH_LIST_LEN+1, new_death_list.len)
		death_data["death_stats_list"] = new_death_list
	track_dead_participant(faction)

/datum/entity/round_stats/proc/log_round_statistics()
	if(!round_stats)
		return
	var/total_xenos_created = 0
	var/total_predators_spawned = 0
	var/total_predaliens = 0
	var/total_humans_created = 0
	for(var/statistic in participants)
		var/datum/entity/statistic/S = participants[statistic]
		if(S.name in FACTION_LIST_XENOMORPH)
			total_xenos_created += S.value
		else if(S.name == FACTION_YAUTJA)
			total_predators_spawned += S.value
		else if(S.name == FACTION_PREDALIEN)
			total_predators_spawned += S.value
		else
			total_humans_created += S.value

	var/xeno_count_during_hijack = 0
	var/human_count_during_hijack = 0

	for(var/statistic in hijack_participants)
		var/datum/entity/statistic/S = hijack_participants[statistic]
		if(S.name in FACTION_LIST_XENOMORPH)
			xeno_count_during_hijack += S.value
		else if(S.name == FACTION_PREDALIEN)
			xeno_count_during_hijack += S.value
		else if(S.name == FACTION_YAUTJA)
			continue
		else
			human_count_during_hijack += S.value

	var/end_of_round_marines = 0
	var/end_of_round_xenos = 0

	for(var/statistic in final_participants)
		var/datum/entity/statistic/S = final_participants[statistic]
		if(S.name in FACTION_LIST_XENOMORPH)
			end_of_round_xenos += S.value
		else if(S.name == FACTION_PREDALIEN)
			end_of_round_xenos += S.value
		else if(S.name == FACTION_YAUTJA)
			continue
		else
			end_of_round_marines += S.value

	var/stats = ""
	stats += "[ticker.mode.round_finished]\n"
	stats += "Game mode: [game_mode]\n"
	stats += "Map name: [current_map.name]\n"
	stats += "Round time: [duration2text(round_length)]\n"
	stats += "End round player population: [end_round_player_population]\n"
	
	stats += "Total xenos spawned: [total_xenos_created]\n"
	stats += "Total Preds spawned: [total_predators_spawned]\n"
	stats += "Total Predaliens spawned: [total_predaliens]\n"
	stats += "Total humans spawned: [total_humans_created]\n"

	stats += "Xeno count during hijack: [xeno_count_during_hijack]\n"
	stats += "Human count during hijack: [human_count_during_hijack]\n"

	stats += "Total huggers applied: [total_huggers_applied]\n"
	stats += "Total chestbursts: [total_larva_burst]\n"

	stats += "Total shots fired: [total_projectiles_fired]\n"
	stats += "Total friendly fire instances: [total_friendly_fire_instances]\n"
	stats += "Total friendly fire kills: [total_friendly_fire_kills]\n"

	stats += "DEFCON level: [defcon_level]\n"
	stats += "Objective points earned: [objective_points]\n"
	stats += "Objective points total: [total_objective_points]\n"

	//stats += ": []\n"

	stats += "Marines remaining: [end_of_round_marines]\n"
	stats += "Xenos remaining: [end_of_round_xenos]\n"
	stats += "Hijack time: [duration2text(round_hijack_time)]\n"

	stats += "[log_end]"

	round_stats << stats // Logging to data/logs/round_stats.log

/datum/action/show_round_statistics
	name = "View End-Round Statistics"

/datum/action/show_round_statistics/can_use_action()
	if(!..())
		return FALSE
	
	if(!owner.client || !owner.client.player_entity)
		return FALSE

	return TRUE

/datum/action/show_round_statistics/action_activate()
	if(!can_use_action())
		return

	owner.client.player_entity.show_statistics(owner, round_statistics, TRUE)
	
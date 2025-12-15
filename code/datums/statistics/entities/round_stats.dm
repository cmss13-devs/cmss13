/datum/entity/statistic/round
	var/round_id

	var/round_name
	var/map_name
	var/game_mode

	var/real_time_start = 0 // GMT-based 11:04
	var/real_time_end = 0 // GMT-based 12:54
	var/round_length = 0 // current-time minus round-start time
	var/round_hijack_time = 0 //hijack time in-round
	var/round_result // "xeno_minor"
	var/end_round_player_population = 0

	var/total_huggers_applied = 0
	var/total_larva_burst = 0

	var/total_projectiles_fired = 0
	var/total_projectiles_hit = 0
	var/total_projectiles_hit_human = 0
	var/total_projectiles_hit_xeno = 0
	var/total_friendly_fire_instances = 0
	var/total_slashes = 0

	// untracked data
	var/datum/entity/statistic/map/current_map // reference to current map
	var/list/datum/entity/statistic/death/death_stats_list = list()

	var/list/abilities_used = list() // types of /datum/entity/statistic, "tail sweep" = 10, "screech" = 2

	var/list/castes_evolved = list() // dict of any caste that has been evolved into, and how many times, "Ravager" = 5, "Warrior" = 2

	var/list/participants = list() // types of /datum/entity/statistic, "[human.faction]" = 10, "xeno" = 2
	var/list/final_participants = list() // types of /datum/entity/statistic, "[human.faction]" = 0, "xeno" = 45
	var/list/hijack_participants = list() // types of /datum/entity/statistic, "[human.faction]" = 0, "xeno" = 45
	var/list/total_deaths = list() // types of /datum/entity/statistic, "[human.faction]" = 0, "xeno" = 45
	var/list/caste_stats_list = list() // list of types /datum/entity/player_stats/caste
	var/list/weapon_stats_list = list() // list of types /datum/entity/weapon_stats
	var/list/job_stats_list = list() // list of types /datum/entity/job_stats

	/// A list of all player xenomorph deaths, type /datum/entity/xeno_death
	var/list/xeno_deaths = list()

	/// A list of all marine deaths, type /datum/entity/marine_death
	var/list/marine_deaths = list()

	// nanoui data
	var/list/round_data = list()
	var/list/death_data = list()

/datum/entity/statistic/round/Destroy(force)
	. = ..()
	QDEL_NULL(current_map)
	QDEL_LIST(death_stats_list)
	QDEL_LIST(xeno_deaths)
	QDEL_LIST(marine_deaths)
	QDEL_LIST_ASSOC_VAL(castes_evolved)
	QDEL_LIST_ASSOC_VAL(abilities_used)
	QDEL_LIST_ASSOC_VAL(final_participants)
	QDEL_LIST_ASSOC_VAL(hijack_participants)
	QDEL_LIST_ASSOC_VAL(total_deaths)
	QDEL_LIST_ASSOC_VAL(caste_stats_list)
	QDEL_LIST_ASSOC_VAL(weapon_stats_list)
	QDEL_LIST_ASSOC_VAL(job_stats_list)

/datum/entity_meta/statistic_round
	entity_type = /datum/entity/statistic/round
	table_name = "rounds"
	key_field = "round_id"
	field_types = list(
		"round_id" = DB_FIELDTYPE_BIGINT,

		"round_name" = DB_FIELDTYPE_STRING_LARGE,
		"map_name" = DB_FIELDTYPE_STRING_LARGE,
		"game_mode" = DB_FIELDTYPE_STRING_LARGE,

		"real_time_start" = DB_FIELDTYPE_BIGINT,
		"real_time_end" = DB_FIELDTYPE_BIGINT,
		"round_hijack_time" = DB_FIELDTYPE_BIGINT,
		"round_result" = DB_FIELDTYPE_STRING_MEDIUM,
		"end_round_player_population" = DB_FIELDTYPE_INT,

		"total_huggers_applied" = DB_FIELDTYPE_INT,
		"total_larva_burst" = DB_FIELDTYPE_INT,

		"total_projectiles_fired" = DB_FIELDTYPE_INT,
		"total_projectiles_hit" = DB_FIELDTYPE_INT,
		"total_projectiles_hit_human" = DB_FIELDTYPE_INT,
		"total_projectiles_hit_xeno" = DB_FIELDTYPE_INT,
		"total_friendly_fire_instances" = DB_FIELDTYPE_INT,
		"total_slashes" = DB_FIELDTYPE_INT
	)

/datum/game_mode/proc/setup_round_stats()
	if(!round_stats)
		var/operation_name
		operation_name = "[pick(GLOB.operation_titles)]"
		operation_name += " [pick(GLOB.operation_prefixes)]"
		operation_name += "-[pick(GLOB.operation_postfixes)]"

		// Round stats
		round_stats = DB_ENTITY(/datum/entity/statistic/round)
		round_stats.round_name = operation_name
		round_stats.round_id = GLOB.round_id
		round_stats.map_name = SSmapping.configs[GROUND_MAP].map_name
		round_stats.game_mode = name
		round_stats.real_time_start = world.realtime
		round_stats.save()

		// Setup the global reference
		GLOB.round_statistics = round_stats

		// Map stats
		var/datum/entity/statistic/map/new_map = DB_EKEY(/datum/entity/statistic/map, SSmapping.configs[GROUND_MAP].map_name)
		new_map.total_rounds++
		new_map.save()

		// Connect map to round
		round_stats.current_map = new_map

/datum/entity/statistic/round/proc/setup_job_stats(job, noteworthy = TRUE)
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
	new_stat.total_rounds_played++
	job_stats_list["[job_key]"] = new_stat
	return new_stat

/datum/entity/statistic/round/proc/setup_weapon_stats(weapon, noteworthy = TRUE)
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

/datum/entity/statistic/round/proc/setup_caste_stats(caste, noteworthy = TRUE)
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
	new_stat.total_rounds_played++
	caste_stats_list["[caste_key]"] = new_stat
	return new_stat

/datum/entity/statistic/round/proc/setup_ability(ability)
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

/datum/entity/statistic/round/proc/recalculate_nemesis()
	for(var/caste_statistic in caste_stats_list)
		var/datum/entity/player_stats/caste/caste_entity = caste_stats_list[caste_statistic]
		caste_entity.recalculate_nemesis()
	for(var/job_statistic in job_stats_list)
		var/datum/entity/player_stats/job/job_entity = job_stats_list[job_statistic]
		job_entity.recalculate_nemesis()

/datum/entity/statistic/round/proc/track_ability_usage(ability, amount = 1)
	var/datum/entity/statistic/S = setup_ability(ability)
	S.value += amount

/datum/entity/statistic/round/proc/setup_faction(faction)
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

/datum/entity/statistic/round/proc/track_new_participant(faction, amount = 1)
	if(!faction)
		return
	if(!participants["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = participants["[faction]"]
	S.value += amount

/datum/entity/statistic/round/proc/track_final_participant(faction, amount = 1)
	if(!faction)
		return
	if(!final_participants["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = final_participants["[faction]"]
	S.value += amount

/datum/entity/statistic/round/proc/track_round_end()
	real_time_end = world.realtime
	for(var/i in GLOB.alive_mob_list)
		var/mob/M = i
		if(M.mind)
			track_final_participant(M.faction)

	save()

/datum/entity/statistic/round/proc/track_hijack_participant(faction, amount = 1)
	if(!faction)
		return
	if(!hijack_participants["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = hijack_participants["[faction]"]
	S.value += amount

/datum/entity/statistic/round/proc/track_hijack()
	for(var/i in GLOB.alive_mob_list)
		var/mob/M = i
		if(M.mind)
			track_hijack_participant(M.faction)
	round_hijack_time = world.time
	save()

	if(current_map)
		current_map.total_hijacks++
		current_map.save()

/datum/entity/statistic/round/proc/track_dead_participant(faction, amount = 1)
	if(!faction)
		return
	if(!total_deaths["[faction]"])
		setup_faction(faction)
	var/datum/entity/statistic/S = total_deaths["[faction]"]
	S.value += amount

/datum/entity/statistic/round/proc/track_death(datum/entity/statistic/death/new_death)
	if(new_death)
		death_stats_list.Insert(1, new_death)
		var/list/damage_list = list()

		if(new_death.total_brute > 0)
			damage_list += list(list("name" = "brute", "value" = new_death.total_brute))
		if(new_death.total_burn > 0)
			damage_list += list(list("name" = "burn", "value" = new_death.total_burn))
		if(new_death.total_oxy > 0)
			damage_list += list(list("name" = "oxy", "value" = new_death.total_oxy))
		if(new_death.total_tox > 0)
			damage_list += list(list("name" = "tox", "value" = new_death.total_tox))

		var/new_time_of_death
		if(new_death.time_of_death)
			new_time_of_death = duration2text(new_death.time_of_death)
		var/new_total_time_alive
		if(new_death.total_time_alive)
			new_total_time_alive = duration2text(new_death.total_time_alive)

		var/death = list(list(
			"mob_name" = sanitize(new_death.mob_name),
			"job_name" = new_death.role_name,
			"area_name" = sanitize_area(new_death.area_name),
			"cause_name" = sanitize_area(new_death.cause_name),
			"total_kills" = new_death.total_kills,
			"total_damage" = damage_list,
			"time_of_death" = new_time_of_death,
			"total_time_alive" = new_total_time_alive,
			"total_damage_taken" = new_death.total_damage_taken,
			"x" = new_death.x,
			"y" = new_death.y,
			"z" = new_death.z
		))
		var/list/new_death_list = list()
		if(death_data["death_stats_list"])
			new_death_list = death_data["death_stats_list"]
		new_death_list.Insert(1, death)
		if(length(new_death_list) > STATISTICS_DEATH_LIST_LEN)
			new_death_list.Cut(STATISTICS_DEATH_LIST_LEN+1, length(new_death_list))
		death_data["death_stats_list"] = new_death_list
	track_dead_participant(new_death.faction_name)

/datum/entity/statistic/round/proc/store_caste_evo_data()
	if(!istype(SSticker.mode, /datum/game_mode/colonialmarines))
		return

	var/datum/entity/round_caste_picks/caste_picks = SSentity_manager.tables[/datum/entity/round_caste_picks].make_new()
	caste_picks.castes_picked = castes_evolved
	caste_picks.save()

/datum/entity/statistic/round/proc/store_spec_kit_data()
	if(!istype(SSticker.mode, /datum/game_mode/colonialmarines))
		return

	var/datum/entity/initial_spec_picks/spec_picks = DB_ENTITY(/datum/entity/initial_spec_picks)
	spec_picks.save()

/datum/entity/statistic/round/proc/log_round_statistics()
	if(!GLOB.round_stats)
		return

	store_caste_evo_data()
	store_spec_kit_data()

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
	stats += "[SSticker.mode.round_finished]\n"
	stats += "Game mode: [game_mode]\n"
	stats += "Map name: [current_map.map_name]\n"
	stats += "Round time: [duration2text(round_length)]\n"
	stats += "End round player population: [end_round_player_population]\n"

	stats += "Total xenos spawned: [total_xenos_created]\n"
	stats += "Total preds spawned: [total_predators_spawned]\n"
	stats += "Total predaliens spawned: [total_predaliens]\n"
	stats += "Total humans spawned: [total_humans_created]\n"

	stats += "Xeno count during hijack: [xeno_count_during_hijack]\n"
	stats += "Human count during hijack: [human_count_during_hijack]\n"

	stats += "Total huggers applied: [total_huggers_applied]\n"
	stats += "Total chestbursts: [total_larva_burst]\n"

	stats += "Total shots fired: [total_projectiles_fired]\n"
	stats += "Total friendly fire instances: [total_friendly_fire_instances]\n"

	stats += "Marines remaining: [end_of_round_marines]\n"
	stats += "Xenos remaining: [end_of_round_xenos]\n"
	stats += "Hijack time: [duration2text(round_hijack_time)]\n"

	stats += "[GLOB.log_end]"

	WRITE_LOG(GLOB.round_stats, stats)

/datum/action/show_round_statistics
	name = "View End-Round Statistics"

/datum/action/show_round_statistics/can_use_action()
	if(!..())
		return FALSE

	if(!owner.client || !owner.client.player_entity)
		return FALSE

	return TRUE

/datum/action/show_round_statistics/action_activate()
	. = ..()
	if(!can_use_action())
		return

	owner.client.player_entity.show_statistics(owner, GLOB.round_statistics, TRUE)

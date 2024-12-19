/datum/entity/statistic_round
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
	var/total_friendly_kills = 0
	var/total_slashes = 0

	// untracked data
	var/list/cached_tgui_data
	var/datum/entity/statistic_map/current_map = null // reference to current map
	var/list/datum/entity/statistic_death/death_stats_list = list()

	var/list/abilities_used = list() // types of /datum/entity/statistic, "tail sweep" = 10, "screech" = 2

	var/list/participants = list() // types of /datum/entity/statistic, "[mob.faction]" = 10
	var/list/final_participants = list() // types of /datum/entity/statistic, "[mob.faction]" = 0
	var/list/hijack_participants = list() // types of /datum/entity/statistic, "[mob.faction]" = 0
	var/list/total_deaths = list() // types of /datum/entity/statistic, "[mob.faction]" = 0
	var/list/caste_stats_list = list() // list of types /datum/entity/player_stats/caste
	var/list/weapon_stats_list = list() // list of types /datum/entity/weapon_stats
	var/list/job_stats_list = list() // list of types /datum/entity/job_stats

/datum/entity_meta/statistic_round
	entity_type = /datum/entity/statistic_round
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
		"total_friendly_kills" = DB_FIELDTYPE_INT,
		"total_slashes" = DB_FIELDTYPE_INT,
	)

/datum/game_mode/proc/setup_round_stats()
	set waitfor = FALSE

	WAIT_SSPERFLOGGING_READY

	if(!GLOB.round_statistics)
		var/operation_name
		operation_name = "[pick(GLOB.operation_titles)]"
		operation_name += " [pick(GLOB.operation_prefixes)]"
		operation_name += "-[pick(GLOB.operation_postfixes)]"
		// Round stats
		var/datum/entity/statistic_round/round = DB_ENTITY(/datum/entity/statistic_round)
		round.round_name = operation_name
		round.map_name = SSmapping.configs[GROUND_MAP].map_name
		var/datum/entity/statistic_map/new_map = DB_EKEY(/datum/entity/statistic_map, round.map_name)
		round.current_map = new_map
		round.current_map.save()
		round.round_id = SSperf_logging.round?.id
		round.game_mode = name
		round.real_time_start = world.realtime
		round.save()
		START_PROCESSING(SSobj, round)
		GLOB.round_statistics = round

/datum/entity/statistic_round/Destroy()
	QDEL_NULL_LIST(death_stats_list)
	QDEL_NULL(current_map)

	. = ..()

/datum/entity/statistic_round/proc/setup_faction(faction)
	if(!faction)
		return

	if(!participants[faction])
		participants[faction] = 0

	if(!final_participants[faction])
		final_participants[faction] = 0

	if(!hijack_participants[faction])
		hijack_participants[faction] = 0

	if(!total_deaths[faction])
		total_deaths[faction] = 0

/datum/entity/statistic_round/proc/track_new_participant(faction, amount = 1)
	if(!faction)
		return

	if(!participants[faction])
		setup_faction(faction)

	participants[faction]++

/datum/entity/statistic_round/proc/track_final_participant(faction, amount = 1)
	if(!faction)
		return

	if(!final_participants[faction])
		setup_faction(faction)

	final_participants[faction]++

/datum/entity/statistic_round/proc/track_round_end()
	real_time_end = world.realtime
	for(var/i in GLOB.alive_mob_list)
		var/mob/M = i
		if(M.mind && M.faction)
			track_final_participant(M.faction)

	if(current_map)
		current_map.total_rounds++
		current_map.save()

	save()

/datum/entity/statistic_round/proc/track_hijack_participant(faction, amount = 1)
	if(!faction)
		return

	if(!hijack_participants[faction])
		setup_faction(faction)

	hijack_participants[faction]++

/datum/entity/statistic_round/proc/track_hijack()
	for(var/i in GLOB.alive_mob_list)
		var/mob/M = i
		if(M.mind)
			track_hijack_participant(M.faction)

	round_hijack_time = world.time
	save()
	if(current_map)
		current_map.total_hijacks++
		current_map.save()

/datum/entity/statistic_round/proc/track_dead_participant(faction, amount = 1)
	if(!faction)
		return

	if(!total_deaths[faction])
		setup_faction(faction)

	total_deaths[faction]++

/datum/entity/statistic_round/proc/log_round_statistics()
	save()
	if(!GLOB.round_stats)
		return

	var/total_xenos_created = 0
	var/total_predators_spawned = 0
	var/total_predaliens_spawned = 0
	var/total_humans_created = 0
	for(var/statistic in participants)
		if(statistic in FACTION_LIST_XENOMORPH)
			total_xenos_created += participants[statistic]
		if(statistic == FACTION_PREDALIEN)
			total_predaliens_spawned += hijack_participants[statistic]
		else if(statistic == FACTION_YAUTJA)
			total_predators_spawned += participants[statistic]
		else
			total_humans_created += participants[statistic]

	var/xeno_count_during_hijack = 0
	var/human_count_during_hijack = 0

	for(var/statistic in hijack_participants)
		if(statistic == FACTION_PREDALIEN || (statistic in FACTION_LIST_XENOMORPH))
			xeno_count_during_hijack += hijack_participants[statistic]
		else if(statistic == FACTION_YAUTJA)
			continue
		else
			human_count_during_hijack += hijack_participants[statistic]

	var/end_of_round_marines = 0
	var/end_of_round_xenos = 0

	for(var/statistic in final_participants)
		if(statistic == FACTION_PREDALIEN || (statistic in FACTION_LIST_XENOMORPH))
			end_of_round_xenos += final_participants[statistic]
		else if(statistic == FACTION_YAUTJA)
			continue
		else
			end_of_round_marines += final_participants[statistic]

	var/stats = ""
	stats += "[SSticker.mode.round_finished]\n"
	stats += "Game mode: [game_mode]\n"
	stats += "Map name: [current_map.map_name]\n"
	stats += "Round time: [duration2text(round_length)]\n"
	stats += "End round player population: [end_round_player_population]\n"

	stats += "Total xenos spawned: [total_xenos_created]\n"
	if(total_predators_spawned)
		stats += "Total Preds spawned: [total_predators_spawned]\n"
	if(total_predaliens_spawned)
		stats += "Total Predaliens spawned: [total_predaliens_spawned]\n"
	stats += "Total humans spawned: [total_humans_created]\n"

	stats += "Xeno count during hijack: [xeno_count_during_hijack]\n"
	stats += "Human count during hijack: [human_count_during_hijack]\n"

	stats += "Total huggers applied: [total_huggers_applied]\n"
	stats += "Total chestbursts: [total_larva_burst]\n"

	stats += "Total shots fired: [total_projectiles_fired]\n"
	stats += "Total friendly fire instances: [total_friendly_fire_instances]\n"
	stats += "Total friendly kills: [total_friendly_kills]\n"

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

	if(!owner.client || !owner?.client?.player_data?.player_entity)
		return FALSE
	return TRUE

/datum/action/show_round_statistics/action_activate()
	. = ..()

	if(!can_use_action())
		return

	owner.client.player_data.player_entity.tgui_interact(owner)

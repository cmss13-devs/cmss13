
/////////////////////////////////////////////////////////////////////////////////////
//Statistic entity

/datum/entity/statistic
	var/player_id
	var/faction
	var/statistic_type
	var/general_name
	var/statistic_name
	var/value

BSQL_PROTECT_DATUM(/datum/entity/statistic)

/datum/entity_meta/statistic
	entity_type = /datum/entity/statistic
	table_name = "player_statistic"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"faction" = DB_FIELDTYPE_STRING_LARGE,
		"statistic_type" = DB_FIELDTYPE_STRING_LARGE,
		"general_name" = DB_FIELDTYPE_STRING_LARGE,
		"statistic_name" = DB_FIELDTYPE_STRING_LARGE,
		"value" = DB_FIELDTYPE_INT,
	)

/proc/track_statistic_earned(faction, statistic_type, general_name, statistic_name, value, datum/entity/player/player)
	if(!player || !faction || !statistic_type || !general_name || !statistic_name)
		return

	if(!(faction in (FACTION_LIST_ALL + list(STATISTIC_TYPE_GLOBAL))))
		faction = FACTION_NEUTRAL

	var/datum/entity/statistic/statistic = player.player_entity?.get_statistic(faction, statistic_type, general_name, statistic_name)
	if(statistic)
		statistic.value += value
		statistic.save()
		return

	DB_FILTER(/datum/entity/statistic, DB_AND(
		DB_COMP("player_id", DB_EQUALS, player.id),
		DB_COMP("faction", DB_EQUALS, faction),
		DB_COMP("statistic_type", DB_EQUALS, statistic_type),
		DB_COMP("general_name", DB_EQUALS, general_name),
		DB_COMP("statistic_name", DB_EQUALS, statistic_name)),
		CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(track_statistic_earned_callback), faction, statistic_type, general_name, statistic_name, value, player.id))

/proc/track_statistic_earned_callback(faction, statistic_type, general_name, statistic_name, value, player_id, list/datum/entity/statistic/statistics)
	if(!length(statistics))
		var/datum/entity/statistic/statistic = DB_ENTITY(/datum/entity/statistic)
		statistic.faction = faction
		statistic.statistic_type = statistic_type
		statistic.general_name = general_name
		statistic.statistic_name = statistic_name
		statistic.value = value
		statistic.player_id = player_id
		statistic.save()
	else
		var/datum/entity/statistic/real_stat = statistics[statistics.len]
		statistics.len--
		for(var/datum/entity/statistic/clone as anything in statistics)
			if(clone.value < real_stat.value)
				clone.delete()
				log_runtime("found duplicated table [faction], [statistic_type], [general_name], [statistic_name]") // Check for bug persist
			else
				real_stat.delete()
				real_stat = clone

		real_stat.value += value
		real_stat.save()

/////////////////////////////////////////////////////////////////////////////////////
//Statistic groups

/datum/statistic_groups
	var/group_name = ""
	var/group_parameter = ""
	var/datum/player_entity/player = null

	var/datum/player_statistic_nemesis/nemesis = new()
	var/list/statistic_deaths = list()
	var/list/statistic_info = list()
	var/list/statistic_all = list()

BSQL_PROTECT_DATUM(/datum/statistic_groups)

/datum/statistic_groups/proc/load_statistic_deaths(list/datum/entity/statistic_death/statistics)
	nemesis.nemesis_name = ""
	nemesis.value = 0
	statistic_deaths = list()
	var/list/causes = list()
	for(var/datum/entity/statistic_death/statistic as anything in statistics)
		statistic_deaths += statistic
		if(!statistic.cause_name)
			continue
		causes[statistic.cause_name]++
		if(causes[statistic.cause_name] > nemesis.value)
			nemesis.nemesis_name = statistic.cause_name
			nemesis.value = causes[statistic.cause_name]

/datum/statistic_groups/proc/load_statistic(list/datum/entity/statistic/statistics)
	statistic_all = list()
	for(var/datum/entity/statistic/statistic as anything in statistics)
		if(!statistic_all[statistic.statistic_type])
			statistic_all[statistic.statistic_type] = list()

		if(!statistic_all[statistic.statistic_type][statistic.general_name])
			statistic_all[statistic.statistic_type][statistic.general_name] = list()

		statistic.sync()
		statistic_all[statistic.statistic_type][statistic.general_name] += statistic
	recalculate_statistic()

/datum/statistic_groups/proc/recalculate_statistic()
	for(var/subtype in statistic_all)
		var/datum/player_statistic/statistic = statistic_info[subtype]
		if(!statistic)
			statistic = new()
			statistic.statistic_name = subtype
			statistic.player = player
			statistic.owner = src
			statistic_info[subtype] = statistic
		statistic.statistic_all = statistic_all[subtype]
		statistic.load_statistic()

/////////////////////////////////////////////////////////////////////////////////////
//Player detail statistic

/datum/player_statistic
	var/statistic_name
	var/datum/player_entity/player = null
	var/datum/statistic_groups/owner = null

	var/datum/player_statistic_detail/top_statistic = list()
	var/list/statistics = list()

	var/list/statistic_all = list()
	var/list/total = list()

BSQL_PROTECT_DATUM(/datum/player_statistic)

/datum/player_statistic/proc/load_statistic()
	for(var/subtype in statistic_all)
		var/datum/player_statistic_detail/statistic = statistics[subtype]
		if(!statistic)
			statistic = new()
			statistic.detail_name = subtype
			statistic.player = player
			statistic.owner = src
			statistics[subtype] = statistic
		statistic.statistics = statistic_all[subtype]
	recalculate_statistic()

/datum/player_statistic/proc/recalculate_statistic()
	var/list/potential_top_statistic = list("", 0)
	for(var/subtype in statistics)
		var/datum/player_statistic_detail/detail_statistic = statistics[subtype]
		detail_statistic.top_values_statistics = list()
		for(var/datum/entity/statistic/potential_statistic as anything in detail_statistic.statistics)
			var/top = TRUE
			for(var/datum/entity/statistic/statistic as anything in statistic_all[potential_statistic.general_name] - potential_statistic)
				if(potential_statistic.value <= statistic.value)
					top = FALSE
					break
			if(top)
				detail_statistic.top_values_statistics += potential_statistic
		if(potential_top_statistic[2] < length(detail_statistic.top_values_statistics))
			potential_top_statistic = list(detail_statistic, length(detail_statistic.top_values_statistics))
	top_statistic = potential_top_statistic[1]

	for(var/subtype in statistic_all)
		for(var/datum/entity/statistic/statistic as anything in statistic_all[subtype])
			if(total[statistic.statistic_name])
				total[statistic.statistic_name] += statistic.value
			else
				total[statistic.statistic_name] = statistic.value

/datum/player_statistic_detail
	var/detail_name
	var/datum/player_entity/player = null
	var/datum/player_statistic/owner = null

	var/list/top_values_statistics = list()
	var/list/statistics = list()

BSQL_PROTECT_DATUM(/datum/player_statistic_detail)

/datum/player_statistic_nemesis
	var/nemesis_name
	var/value

BSQL_PROTECT_DATUM(/datum/player_statistic_nemesis)

/////////////////////////////////////////////////////////////////////////////////////
//Player Entity

/datum/player_entity
	var/entity_name
	var/ckey
	var/datum/entity/player/player = null
	var/list/datum/entity/statistic/medal/medals = list()
	var/list/statistics = list()

BSQL_PROTECT_DATUM(/datum/player_entity)

/datum/player_entity/proc/get_statistic(faction, statistic_type, general_name, statistic_name)
	var/datum/statistic_groups/match_statistic = statistics[faction]
	if(!match_statistic)
		return FALSE

	var/datum/player_statistic/match_statistic_type = match_statistic.statistic_info[statistic_type]
	if(!match_statistic_type)
		return FALSE

	var/datum/player_statistic_detail/match_detail_statistic = match_statistic_type.statistics[general_name]
	if(!match_detail_statistic)
		return FALSE

	for(var/datum/entity/statistic/statistic as anything in match_detail_statistic.statistics)
		if(statistic.statistic_name != statistic_name)
			continue
		return statistic
	return FALSE

/datum/player_entity/proc/setup_entity()
	set waitfor = FALSE
	WAIT_DB_READY
	if(player)
		for(var/faction_to_get in FACTION_LIST_ALL + list(STATISTIC_TYPE_GLOBAL))
			var/datum/statistic_groups/new_group = statistics[faction_to_get]
			if(!new_group)
				new_group = new()
//				new_group.group_name = GLOB.faction_datums[faction_to_get].name // FUCK YOU
				// FUCK YOU x2
				new_group.group_name = faction_to_get
				new_group.group_parameter = faction_to_get
				new_group.player = src
				statistics[faction_to_get] = new_group

			DB_FILTER(/datum/entity/statistic_death, DB_AND(
			DB_COMP("player_id", DB_EQUALS, player.id),
			DB_COMP("faction_name", DB_EQUALS, faction_to_get)),
			CALLBACK(new_group, TYPE_PROC_REF(/datum/statistic_groups, load_statistic_deaths)))

			DB_FILTER(/datum/entity/statistic, DB_AND(
			DB_COMP("player_id", DB_EQUALS, player.id),
			DB_COMP("faction", DB_EQUALS, faction_to_get)),
			CALLBACK(new_group, TYPE_PROC_REF(/datum/statistic_groups, load_statistic)))

		DB_FILTER(/datum/entity/statistic/medal, DB_COMP("player_id", DB_EQUALS, player.id), CALLBACK(src, TYPE_PROC_REF(/datum/player_entity, statistic_load_medals)))

/datum/player_entity/proc/statistic_load_medals(list/datum/entity/statistic/medal/statistics)
	for(var/datum/entity/statistic/medal/statistic as anything in statistics)
		if(statistic in medals)
			continue

		medals += statistic


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
	set waitfor = FALSE

	if(!player || !player.player_entity || !faction || !statistic_type || !general_name || !statistic_name)
		return

	if(!(faction in (FACTION_LIST_ALL + list(STATISTIC_TYPE_GLOBAL))))
		faction = FACTION_NEUTRAL

	var/datum/player_entity/player_entity = player.player_entity
	if(player_entity.statistic_logged)
		return

	var/datum/grouped_statistic/statistics_group = player_entity.statistics_groups[faction]
	var/datum/entity/statistic/statistic = player_entity.get_statistic(faction, statistic_type, general_name, statistic_name)
	if(statistic)
		statistic.value += value
		if(statistics_group)
			statistics_group.waiting_for_recalculate = TRUE
		return

	if(!statistics_group)
		return

	statistic = DB_ENTITY(/datum/entity/statistic)
	statistic.faction = faction
	statistic.statistic_type = statistic_type
	statistic.general_name = general_name
	statistic.statistic_name = statistic_name
	statistic.value = value
	statistic.player_id = player.id
	statistics_group.load_statistic_group(list(statistic), FALSE)
	statistics_group.waiting_for_recalculate = TRUE

/////////////////////////////////////////////////////////////////////////////////////
//Statistic groups

/datum/grouped_statistic
	var/group_name = ""
	var/group_parameter = ""

	var/datum/player_statistic_nemesis/nemesis = new()
	var/list/datum/entity/statistic_death/statistic_deaths = list()
	// Sub group, used by us so we can easy group them UP
	var/list/datum/player_statistic/statistics_infos = list()
	// List of all statistic grouped by type and general name
	var/list/statistic_all = list()

	// Don't recalculate if we didn't gather any data
	var/waiting_for_recalculate = FALSE

BSQL_PROTECT_DATUM(/datum/grouped_statistic)

/datum/grouped_statistic/proc/load_statistic_deaths(list/datum/entity/statistic_death/statistics)
	nemesis.nemesis_name = ""
	nemesis.value = 0
	statistic_deaths.Cut()
	var/list/causes = list()
	for(var/datum/entity/statistic_death/statistic as anything in statistics)
		statistic_deaths += statistic
		if(!statistic.cause_name)
			continue

		causes[statistic.cause_name]++
		if(causes[statistic.cause_name] > nemesis.value)
			nemesis.nemesis_name = statistic.cause_name
			nemesis.value = causes[statistic.cause_name]

/datum/grouped_statistic/proc/load_statistic_group(list/datum/entity/statistic/statistics, recalculate = TRUE)
	for(var/datum/entity/statistic/statistic as anything in statistics)
		if(!statistic_all[statistic.statistic_type])
			statistic_all[statistic.statistic_type] = list()

		if(!statistic_all[statistic.statistic_type][statistic.general_name])
			statistic_all[statistic.statistic_type][statistic.general_name] = list()

		statistic.sync()
		statistic_all[statistic.statistic_type][statistic.general_name] |= statistic

	recalculate_statistic_group(recalculate)

/datum/grouped_statistic/proc/recalculate_statistic_group(recalculate)
	for(var/subtype in statistic_all)
		if(statistics_infos[subtype])
			if(recalculate)
				statistics_infos[subtype].recalculate_statistic()
			continue

		var/datum/player_statistic/statistics_info = new()
		statistics_info.statistic_name = subtype
		statistics_info.statistic_all = statistic_all[subtype]
		statistics_info.load_statistic()
		statistics_infos[subtype] = statistics_info

/////////////////////////////////////////////////////////////////////////////////////
//Player detail statistic

/datum/player_statistic
	var/statistic_name

	var/datum/player_statistic_detail/top_statistic = list()
	var/list/datum/player_statistic_detail/statistics_details = list()
	var/list/statistic_all = list()

	var/list/total_statistic = list()

BSQL_PROTECT_DATUM(/datum/player_statistic)

/datum/player_statistic/proc/load_statistic()
	for(var/subtype in statistic_all)
		if(statistics_details[subtype])
			continue

		var/datum/player_statistic_detail/detail_statistic = new()
		detail_statistic.detail_name = subtype
		statistics_details[subtype] = detail_statistic
		detail_statistic.statistics = statistic_all[subtype]

	recalculate_statistic()

/datum/player_statistic/proc/recalculate_statistic()
	total_statistic.Cut()
	for(var/subtype in statistic_all)
		for(var/datum/entity/statistic/statistic as anything in statistic_all[subtype])
			if(total_statistic[statistic.statistic_name])
				total_statistic[statistic.statistic_name] += statistic.value
			else
				total_statistic[statistic.statistic_name] = statistic.value

	var/list/potential_top_statistic = list("", 0)
	for(var/subtype in statistics_details)
		var/datum/player_statistic_detail/detail_statistic = statistics_details[subtype]
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

/datum/player_statistic_detail
	var/detail_name

	var/list/datum/entity/statistic/top_values_statistics = list()
	var/list/datum/entity/statistic/statistics = list()

BSQL_PROTECT_DATUM(/datum/player_statistic_detail)

/datum/player_statistic_nemesis
	var/nemesis_name
	var/value

BSQL_PROTECT_DATUM(/datum/player_statistic_nemesis)

/////////////////////////////////////////////////////////////////////////////////////
//Player Entity

/datum/player_entity
	var/ckey
	var/datum/entity/player/player = null
	var/list/datum/entity/statistic_medal/statistics_medals = list()
	var/list/datum/grouped_statistic/statistics_groups = list()

	// Oh god. Just don't mess with it further please...
	var/statistic_logged = FALSE

BSQL_PROTECT_DATUM(/datum/player_entity)

/datum/player_entity/proc/get_statistic(faction, statistic_type, general_name, statistic_name)
	var/datum/grouped_statistic/statistics_group = statistics_groups[faction]
	if(!statistics_group)
		return FALSE

	var/list/refs_holder = statistics_group.statistic_all[statistic_type]
	if(!refs_holder || !refs_holder[general_name])
		return FALSE

	for(var/datum/entity/statistic/statistic as anything in refs_holder[general_name])
		if(statistic.statistic_name != statistic_name)
			continue
		return statistic
	return FALSE

/datum/player_entity/proc/try_recalculate()
	for(var/faction_to_get in statistics_groups)
		var/datum/grouped_statistic/statistics_group = statistics_groups[faction_to_get]
		if(statistics_group.waiting_for_recalculate)
			statistics_group.recalculate_statistic_group(TRUE)

/datum/player_entity/proc/save_statistics()
	statistic_logged = TRUE
	for(var/faction_to_get in statistics_groups)
		var/datum/grouped_statistic/statistics_group = statistics_groups[faction_to_get]
		for(var/statistic_type in statistics_group.statistic_all)
			var/list/refs_holder = statistics_group.statistic_all[statistic_type]
			for(var/general_name in refs_holder)
				CHECK_TICK
				for(var/datum/entity/statistic/statistic as anything in refs_holder[general_name])
					statistic.save()// You still looking here? Your soul doomed

/datum/player_entity/proc/setup_entity()
	set waitfor = FALSE
	WAIT_DB_READY
	if(!player)
		return

	for(var/faction_to_get in FACTION_LIST_ALL + list(STATISTIC_TYPE_GLOBAL))
		var/datum/grouped_statistic/statistics_group = statistics_groups[faction_to_get]
		if(!statistics_group)
			statistics_group = new()
//			statistics_group.group_name = GLOB.faction_datums[faction_to_get].name // One day... dream come true...
			statistics_group.group_name = faction_to_get
			statistics_group.group_parameter = faction_to_get
			statistics_groups[faction_to_get] = statistics_group

		DB_FILTER(/datum/entity/statistic_death, DB_AND(
		DB_COMP("player_id", DB_EQUALS, player.id),
		DB_COMP("faction_name", DB_EQUALS, faction_to_get)),
		CALLBACK(statistics_group, TYPE_PROC_REF(/datum/grouped_statistic, load_statistic_deaths)))

		DB_FILTER(/datum/entity/statistic, DB_AND(
		DB_COMP("player_id", DB_EQUALS, player.id),
		DB_COMP("faction", DB_EQUALS, faction_to_get)),
		CALLBACK(statistics_group, TYPE_PROC_REF(/datum/grouped_statistic, load_statistic_group)))

	DB_FILTER(/datum/entity/statistic_medal, DB_COMP("player_id", DB_EQUALS, player.id), CALLBACK(src, TYPE_PROC_REF(/datum/player_entity, statistic_load_medals)))

/datum/player_entity/proc/statistic_load_medals(list/datum/entity/statistic_medal/statistics)
	for(var/datum/entity/statistic_medal/statistic as anything in statistics)
		statistics_medals |= statistic

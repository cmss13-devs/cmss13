/datum/entity/player_stat
	var/player_id
	var/stat_id
	var/stat_number
	var/stat_category

BSQL_PROTECT_DATUM(/datum/entity/player_stat)

/datum/entity_meta/player_stat
	entity_type = /datum/entity/player_stat
	table_name = "player_stat"
	field_types = list(
		"player_id" = DB_FIELDTYPE_BIGINT,
		"stat_id" = DB_FIELDTYPE_STRING_LARGE,
		"stat_number" = DB_FIELDTYPE_BIGINT,
		"stat_category" = DB_FIELDTYPE_STRING_LARGE
	)

/datum/entity_meta/player_stat/on_insert(var/datum/entity/player_stat/stat)
	stat.stat_number = 0

/datum/entity_link/player_to_stat
	parent_entity = /datum/entity/player
	child_entity = /datum/entity/player_stat
	child_field = "player_id"

	parent_name = "player"
	child_name = "player_stats"

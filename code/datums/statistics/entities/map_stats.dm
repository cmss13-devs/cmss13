/datum/entity/statistic/map
	var/map_name
	var/total_rounds = 0
	var/total_hijacks = 0
	var/total_marine_victories = 0
	var/total_marine_majors = 0
	var/total_xeno_victories = 0
	var/total_xeno_majors = 0
	var/total_draws = 0

/datum/entity_meta/statistic_map
	entity_type = /datum/entity/statistic/map
	table_name = "maps"
	key_field = "map_name"
	field_typepaths = list(
		"map_name" = DB_FIELDTYPE_STRING_LARGE,
		"total_rounds" = DB_FIELDTYPE_BIGINT,

		"total_hijacks" = DB_FIELDTYPE_BIGINT,
		"total_marine_victories" = DB_FIELDTYPE_BIGINT,
		"total_marine_majors" = DB_FIELDTYPE_BIGINT,
		"total_xeno_victories" = DB_FIELDTYPE_BIGINT,
		"total_xeno_majors" = DB_FIELDTYPE_BIGINT,
		"total_draws" = DB_FIELDTYPE_BIGINT
	)


/datum/entity/moba_player_report
	var/round_id
	var/game_id
	var/won_game
	var/kills
	var/deaths
	var/caste_name
	var/items_json
	var/level
	var/gold
	var/creep_score
	var/lane
	var/game_length

/datum/entity/moba_player_report/New()
	. = ..()
	round_id = GLOB.round_id || -1

/datum/entity_meta/moba_player_report
	entity_type = /datum/entity/moba_player_report
	table_name = "moba_player_report"
	field_types = list(
		"round_id" = DB_FIELDTYPE_INT,
		"game_id" = DB_FIELDTYPE_INT,
		"won_game" = DB_FIELDTYPE_INT,
		"kills" = DB_FIELDTYPE_INT,
		"deaths" = DB_FIELDTYPE_INT,
		"caste_name" = DB_FIELDTYPE_STRING_MEDIUM,
		"items_json" = DB_FIELDTYPE_JSON,
		"level" = DB_FIELDTYPE_INT,
		"gold" = DB_FIELDTYPE_INT,
		"creep_score" = DB_FIELDTYPE_INT,
		"lane" = DB_FIELDTYPE_STRING_SMALL,
		"game_length" = DB_FIELDTYPE_INT,
	)

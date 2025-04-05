/datum/entity/moba_round_report
	/// Server Round ID that we're storing data on
	var/round_id
	/// If left side won, this is TRUE, else right side won
	var/left_won
	var/round_time
	var/game_level
	var/killed_hivebots
	var/killed_megacarps
	var/killed_reapers
	var/total_kills
	var/total_deaths
	var/leftside_wards_used
	var/rightside_wards_used

/datum/entity/moba_round_report/New()
	. = ..()
	round_id = GLOB.round_id || -1

/datum/entity_meta/moba_round_report
	entity_type = /datum/entity/moba_round_report
	table_name = "moba_round_report"
	field_types = list(
		"round_id" = DB_FIELDTYPE_INT,
		"left_won" = DB_FIELDTYPE_INT,
		"round_time" = DB_FIELDTYPE_INT,
		"game_level" = DB_FIELDTYPE_INT,
		"killed_hivebots" = DB_FIELDTYPE_INT,
		"killed_megacarps" = DB_FIELDTYPE_INT,
		"killed_reapers" = DB_FIELDTYPE_INT,
		"total_kills" = DB_FIELDTYPE_INT,
		"total_deaths" = DB_FIELDTYPE_INT,
		"leftside_wards_used" = DB_FIELDTYPE_INT,
		"rightside_wards_used" = DB_FIELDTYPE_INT,
	)

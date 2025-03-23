/datum/entity/moba_round_report
	/// Server Round ID that we're storing data on
	var/round_id
	/// Game Round ID that we're storing data on
	var/local_round_id
	/// If left side won, this is TRUE, else right side won
	var/left_won

/datum/entity/moba_round_report/New()
	. = ..()
	round_id = GLOB.round_id || -1


/datum/entity/moba_round_report/post_creation()
	save()

/datum/entity_meta/moba_round_report
	entity_type = /datum/entity/moba_round_report
	table_name = "moba_round_report"
	field_types = list(
		"round_id" = DB_FIELDTYPE_INT,
		"local_round_id" = DB_FIELDTYPE_INT,
		"left_won" = DB_FIELDTYPE_INT,
	)

/datum/entity/mc_round
	var/map_name

/datum/entity_meta/mc_round
	entity_type = /datum/entity/mc_round
	table_name = "mc_round"
	field_types = list(
			"map_name"=DB_FIELDTYPE_STRING_LARGE
		)

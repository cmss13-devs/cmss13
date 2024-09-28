/datum/entity/predround_chance
	var/chance


/datum/entity_meta/predround_chance
	entity_type = /datum/entity/predround_chance
	table_name = "predround_chance"
	field_types = list(
		"chance" = DB_FIELDTYPE_BIGINT,
	)

/datum/view_record/predround_chance
	var/id
	var/chance

/datum/entity_view_meta/stickyban
	root_record_type = /datum/entity/predround_chance
	destination_entity = /datum/view_record/predround_chance
	fields = list(
		"id",
		"chance",
	)

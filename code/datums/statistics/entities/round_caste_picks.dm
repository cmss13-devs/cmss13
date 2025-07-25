/datum/entity/round_caste_picks
	/// Round ID that we're storing data on
	var/round_id
	/// Dict of "castename" : amount picked
	var/list/castes_picked
	/// If xenos won (major or minor)
	var/xenos_won = FALSE

/datum/entity/round_caste_picks/New()
	. = ..()
	round_id = GLOB.round_id || -1
	if(SSticker.mode.round_finished == MODE_INFESTATION_X_MAJOR || SSticker.mode.round_finished == MODE_INFESTATION_X_MINOR)
		xenos_won = TRUE

/datum/entity/round_caste_picks/assign_values(list/values, list/ignore = list())
	for(var/field in metadata.field_types)
		if(ignore.Find(field))
			continue
		if((field == "round_id") || (field == "xenos_won"))
			vars[field] = values[field]
		else
			castes_picked[field] = values[field]

/datum/entity_meta/round_caste_picks
	entity_type = /datum/entity/round_caste_picks
	table_name = "round_caste_picks"
	field_types = list(
		"round_id" = DB_FIELDTYPE_INT,
		"xenos_won" = DB_FIELDTYPE_INT,
	)

/datum/entity_meta/round_caste_picks/New()
	. = ..()
	for(var/caste_name in (ALL_XENO_CASTES - XENO_T0_CASTES - XENO_CASTE_HELLHOUND - XENO_CASTE_KING))
		field_types[lowertext(replacetext(caste_name, " ", "_"))] = DB_FIELDTYPE_INT

/datum/entity_meta/round_caste_picks/map(datum/entity/round_caste_picks/entity, list/values)
	entity.id = "[values[DB_DEFAULT_ID_FIELD]]"
	for(var/field in field_types)
		if((field == "round_id") || (field == "xenos_won"))
			entity.vars[field] = values[field]
		else
			entity.castes_picked[field] = values[field]

/datum/entity_meta/round_caste_picks/unmap(datum/entity/round_caste_picks/entity, include_id = TRUE)
	var/list/values = list()
	if(include_id)
		values[DB_DEFAULT_ID_FIELD] = entity.id
	for(var/field in field_types)
		if((field == "round_id") || (field == "xenos_won"))
			values[field] = entity.vars[field]
		else
			values[field] = entity.castes_picked[field]

	return values

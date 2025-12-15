/datum/entity/initial_spec_picks
	/// Round ID that we're storing data on
	var/round_id
	/// Dict of "spec kit name" to 1, for the picked spec kits
	var/list/specs_picked
	/// If the marines won or not
	var/marines_won = FALSE

/datum/entity/initial_spec_picks/New()
	. = ..()
	round_id = GLOB.round_id || -1
	specs_picked = GLOB.primary_specialists_picked
	if(SSticker.mode.round_finished == MODE_INFESTATION_M_MAJOR || SSticker.mode.round_finished == MODE_INFESTATION_M_MINOR)
		marines_won = TRUE

/datum/entity/initial_spec_picks/assign_values(list/values, list/ignore = list())
	for(var/field in metadata.field_types)
		if(ignore.Find(field))
			continue
		if((field == "round_id") || (field == "marines_won"))
			vars[field] = values[field]
		else
			specs_picked[field] = values[field]

/datum/entity_meta/initial_spec_picks
	entity_type = /datum/entity/initial_spec_picks
	table_name = "initial_spec_picks"
	field_types = list(
		"round_id" = DB_FIELDTYPE_INT,
		"marines_won" = DB_FIELDTYPE_INT,
	)

/datum/entity_meta/initial_spec_picks/New()
	. = ..()
	for(var/obj/item/storage/box/spec/spec_kit as anything in subtypesof(/obj/item/storage/box/spec))
		if(!spec_kit::kit_name)
			continue

		field_types[lowertext(replacetext(spec_kit::kit_name, " ", "_"))] = DB_FIELDTYPE_INT

/datum/entity_meta/initial_spec_picks/map(datum/entity/initial_spec_picks/entity, list/values)
	var/strid = "[values[DB_DEFAULT_ID_FIELD]]"
	entity.id = strid
	for(var/field in field_types)
		if((field == "round_id") || (field == "marines_won"))
			entity.vars[field] = values[field]
		else
			entity.specs_picked[field] = values[field]

/datum/entity_meta/initial_spec_picks/unmap(datum/entity/initial_spec_picks/entity, include_id = TRUE)
	var/list/values = list()
	if(include_id)
		values[DB_DEFAULT_ID_FIELD] = entity.id
	for(var/field in field_types)
		if((field == "round_id") || (field == "marines_won"))
			values[field] = entity.vars[field]
		else
			values[field] = entity.specs_picked[field]

	return values

/datum/entity/chemical_information
	var/nutriment_factor
	var/custom_metabolism
	var/overdose
	var/overdose_critical
	var/color
	var/explosive
	var/power
	var/falloff_modifier
	var/chemfiresupp
	var/intensitymod
	var/durationmod
	var/radiusmod
	var/burncolor
	var/burncolormod
	var/properties_text

	var/list/properties

/datum/entity_meta/chemical_information
	entity_type = /datum/entity/chemical_information
	table_name = "chemical_information"
	field_types = list(
		"nutriment_factor" = DB_FIELDTYPE_DECIMAL,
		"custom_metabolism" = DB_FIELDTYPE_DECIMAL,
		"overdose" = DB_FIELDTYPE_INT,
		"overdose_critical" = DB_FIELDTYPE_INT,
		"color" = DB_FIELDTYPE_STRING_SMALL,
		"explosive" = DB_FIELDTYPE_INT,
		"power" = DB_FIELDTYPE_DECIMAL,
		"falloff_modifier" = DB_FIELDTYPE_DECIMAL,
		"chemfiresupp" = DB_FIELDTYPE_INT,
		"intensitymod" = DB_FIELDTYPE_DECIMAL,
		"durationmod" = DB_FIELDTYPE_DECIMAL,
		"radiusmod" = DB_FIELDTYPE_DECIMAL,
		"burncolor" = DB_FIELDTYPE_STRING_SMALL,
		"burncolormod" = DB_FIELDTYPE_INT,
		"properties_text" = DB_FIELDTYPE_STRING_MAX)

/datum/entity_meta/chemical_information/map(var/datum/entity/chemical_information/ET, var/list/values)
	..()
	if(values["properties_text"])
		ET.properties = json_decode(values["properties_text"])

/datum/entity_meta/chemical_information/unmap(var/datum/entity/chemical_information/ET)
	. = ..()
	if(length(ET.properties))
		.["properties_text"] = json_encode(ET.properties)
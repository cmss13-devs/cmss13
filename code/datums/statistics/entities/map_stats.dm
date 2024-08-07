/datum/entity/statistic_map
	var/map_name
	var/total_rounds = 0
	var/total_hijacks = 0
	var/total_victories
	var/list/victories

/datum/entity_meta/statistic_map
	entity_type = /datum/entity/statistic_map
	table_name = "maps"
	key_field = "map_name"
	field_types = list(
		"map_name" = DB_FIELDTYPE_STRING_LARGE,
		"total_rounds" = DB_FIELDTYPE_BIGINT,

		"total_hijacks" = DB_FIELDTYPE_BIGINT,
		"total_victories" = DB_FIELDTYPE_STRING_MAX,
	)

/datum/entity_meta/statistic_map/map(datum/entity/statistic_map/map_entity, list/values)
    ..()
    if(values["total_victories"])
        map_entity.victories = json_decode(values["total_victories"])

/datum/entity_meta/statistic_map/unmap(datum/entity/statistic_map/map_entity)
	. = ..()
	if(length(map_entity.victories))
		.["total_victories"] = json_encode(map_entity.victories)

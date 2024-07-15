/datum/entity/test_entity
	var/name
	var/description
	var/value

/datum/entity_meta/test_entity
	entity_type = /datum/entity/test_entity
	table_name = "test_table"
	field_types = list("name"=DB_FIELDTYPE_STRING_MEDIUM, "description"=DB_FIELDTYPE_STRING_MAX, "value"=DB_FIELDTYPE_BIGINT)

// redefine this for faster operations
/datum/entity_meta/test_entity/map(datum/entity/test_entity/ET, list/values)
	ET.id = text2num(values[DB_DEFAULT_ID_FIELD])
	ET.name = values["name"]
	ET.description = values["description"]
	ET.value = text2num(values["value"])

// redefine this for faster operations
/datum/entity_meta/test_entity/unmap(datum/entity/test_entity/ET, include_id = TRUE)
	var/list/values = list()
	if(include_id)
		values[DB_DEFAULT_ID_FIELD] = ET.id
	values["name"] = ET.name
	values["description"] = ET.description
	values["value"] = ET.value
	return values

/proc/test_read(id)
	var/datum/entity/test_entity/ET = SSentity_manager.select(/datum/entity/test_entity, id)
	ET.sync_then(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(log_sync)))

/proc/test_insert(name, desc, value)
	var/datum/entity/test_entity/ET = SSentity_manager.select(/datum/entity/test_entity)
	ET.name = name
	ET.description = desc
	ET.value = value
	ET.save()

/proc/test_update(id, nvalue)
	var/datum/entity/test_entity/ET = SSentity_manager.select(/datum/entity/test_entity, id)
	ET.sync()
	ET.value = nvalue
	ET.save()

/proc/test_delete(id)
	var/datum/entity/test_entity/ET = SSentity_manager.select(/datum/entity/test_entity, id)
	ET.delete()

/proc/test_filter(value)
	SSentity_manager.filter_then(/datum/entity/test_entity, DB_COMP("value", DB_EQUALS, value), CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(log_filter)))

/proc/log_filter(list/datum/entity/elist)
	to_world("got [length(elist)] items")

/proc/log_sync(datum/entity/test_entity/ET)
	to_world("id:[ET.id] = name: [ET.name], description: [ET.description], value: [ET.value]")

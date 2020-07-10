/datum/entity_view_meta
	var/active_view = TRUE
	var/root_record_type
	var/destination_entity
	var/list/fields
	var/list/order_by
	var/list/group_by

	var/datum/entity_meta/root_entity_meta
	var/datum/db/filter/root_filter

/datum/view_record
	var/datum/entity_view_meta/meta

/datum/entity_view_meta/proc/map(var/datum/view_record/ET, var/list/values)
	for(var/F in fields)
		ET.vars[F] = values[F]
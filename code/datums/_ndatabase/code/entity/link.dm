/datum/entity_link
	var/parent_entity
	var/child_entity
	var/child_field

	var/parent_name
	var/child_name

	var/datum/entity_meta/parent_meta
	var/datum/entity_meta/child_meta

	var/enforced = FALSE

	var/list/child_requests

/datum/entity_link/proc/get_filter(parent_alias, child_alias)
	return new /datum/db/filter/link(parent_alias, DB_DEFAULT_ID_FIELD, child_alias, child_field)	
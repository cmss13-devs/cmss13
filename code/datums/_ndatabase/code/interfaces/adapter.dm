/datum/db/adapter

/datum/db/adapter/proc/sync_table_meta()
	return

/datum/db/adapter/proc/sync_table(type_name, table_name, var/list/field_types)
	return

/datum/db/adapter/proc/read_table(table_name, var/list/ids, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/update_table(table_name, var/list/values, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/insert_table(table_name, var/list/values, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/delete_table(table_name, var/list/ids, var/datum/callback/CB, sync=FALSE)
	return

/datum/db/adapter/proc/read_filter(table_name, var/datum/db/filter, var/datum/callback/CB, sync=FALSE)
	return
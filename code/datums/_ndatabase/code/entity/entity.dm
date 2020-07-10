/datum/entity
	var/id
	var/status
	var/datum/entity_meta/metadata
	var/__key_synced = FALSE

/datum/entity/proc/save()
	if(__key_synced && !id)
		status = DB_ENTITY_STATE_ADD_OR_SELECT
		return
	if(!id)
		status = DB_ENTITY_STATE_ADDED
		metadata.to_insert |= src
		return
	status = DB_ENTITY_STATE_UPDATED
	metadata.to_update |= src

/datum/entity/proc/delete()
	if(!id)
		qdel(src)
		return
	status = DB_ENTITY_STATE_DELETED
	metadata.managed -= src
	metadata.to_delete |= src

/datum/entity/proc/invalidate()
	if(!id)
		return
	status = DB_ENTITY_STATE_DETACHED
	metadata.to_read |= src

/datum/entity/proc/detach()
	metadata.to_read -= src
	metadata.to_delete -= src	
	metadata.to_update -= src
	metadata.managed -= src
	if(!id)
		status = DB_ENTITY_STATE_ADD_DETACH

/datum/entity/Dispose()
	detach()
	..()

/datum/entity/proc/sync()
	while(status > DB_ENTITY_STATE_SYNCED)
		stoplag()

/datum/entity/proc/sync_new()
	if(id)
		return
	while(status > DB_ENTITY_STATE_SYNCED)
		stoplag()

/datum/entity/proc/sync_then(var/datum/callback/CB)
	set waitfor = 0
	while(status > DB_ENTITY_STATE_SYNCED)
		stoplag()
	if(CB)
		CB.Invoke(src)

/datum/entity/proc/assign_values(var/list/values, var/list/ignore = list())
	for(var/F in metadata.field_types)
		if(!(ignore.Find(F)))
			vars[F] = values[F]
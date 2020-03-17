/datum/entity
	var/id
	var/status
	var/datum/entity_meta/metadata

/datum/entity/proc/save()
	if(!id)
		status = DB_ENTITY_STATE_ADDED
		metadata.to_insert |= src
		return
	status = DB_ENTITY_STATE_UPDATED
	metadata.to_update |= src

/datum/entity/proc/delete()
	if(!id)
		return
	status = DB_ENTITY_STATE_DELETED
	metadata.to_delete |= src

/datum/entity/proc/invalidate()
	if(!id)
		return
	status = DB_ENTITY_STATE_DETACHED
	metadata.to_read |= src

/datum/entity/proc/detach()
	metadata.to_read -= src
	metadata.to_delete -= src
	metadata.to_insert -= src
	metadata.to_update -= src
	metadata.managed -= src

/datum/entity/Dispose()
	detach()

/datum/entity/proc/sync()
	while(status > DB_ENTITY_STATE_SYNCED)
		sleep(5)

/datum/entity/proc/sync_then(var/datum/callback/CB)
	set waitfor = 0
	while(status > DB_ENTITY_STATE_SYNCED)
		sleep(5)
	CB.Invoke(src)
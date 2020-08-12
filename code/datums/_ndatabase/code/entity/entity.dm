// MIT License

// Copyright (c) 2020 Neth Iafin

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
	metadata.managed -= src.id
	metadata.to_delete |= src

/datum/entity/proc/invalidate()
	if(!id)
		return
	status = DB_ENTITY_STATE_FRESH
	metadata.to_read |= src

/datum/entity/proc/detach()
	metadata.to_read -= src
	metadata.to_delete -= src	
	metadata.to_update -= src
	metadata.managed -= src.id
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
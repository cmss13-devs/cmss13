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
GLOBAL_REAL(SSentity_manager, /datum/controller/subsystem/entity_manager)

/datum/controller/subsystem/entity_manager
	name   = "Entity Manager"
	init_order = SS_INIT_ENTITYMANAGER
	init_stage = INITSTAGE_EARLY
	priority   = SS_PRIORITY_ENTITY
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	flags = SS_NO_INIT

	var/datum/db/adapter/adapter
	var/list/datum/entity_meta/tables
	var/list/datum/entity_meta/tables_unsorted
	var/list/datum/entity_view_meta/views
	var/list/datum/entity_view_meta/views_unsorted

	var/list/datum/entity_meta/currentrun

	var/datum/entity/mc_round/round

	var/ready = FALSE

/datum/controller/subsystem/entity_manager/New()
	tables = list()
	tables_unsorted = list()
	var/list/all_entities = typesof(/datum/entity_meta) - list(/datum/entity_meta)
	for(var/entity_meta in all_entities)
		var/datum/entity_meta/table = new entity_meta()
		if(table.active_entity)
			tables[table.entity_type] = table
			tables_unsorted.Add(table)

	var/list/all_links = typesof(/datum/entity_link) - list(/datum/entity_link)
	for(var/entity_link in all_links)
		var/datum/entity_link/link = new entity_link()
		var/datum/entity_meta/parent = tables[link.parent_entity]
		var/datum/entity_meta/child = tables[link.child_entity]
		if(link.child_name)
			parent.inbound_links[link.child_name] = link
		if(link.parent_name)
			child.outbound_links[link.parent_name] = link
		link.parent_meta = parent
		link.child_meta = child

	views = list()
	views_unsorted = list()

	NEW_SS_GLOBAL(SSentity_manager)

/datum/controller/subsystem/entity_manager/proc/start_up()
	set waitfor=0
	UNTIL(SSdatabase.connection.connection_ready())
	adapter = SSdatabase.connection.get_adapter()
	prepare_tables()

	var/list/all_views = typesof(/datum/entity_view_meta) - list(/datum/entity_view_meta)
	for(var/view_meta in all_views)
		var/datum/entity_view_meta/view = new view_meta()
		if(view.active_view)
			views[view.destination_entity] = view
			views_unsorted.Add(view)
			view.root_entity_meta = tables[view.root_record_type]
			adapter.prepare_view(view)

	ready = TRUE

/datum/controller/subsystem/entity_manager/proc/prepare_tables()
	adapter.sync_table_meta()
	for(var/ET in tables)
		var/datum/entity_meta/EM = tables[ET]
		adapter.sync_table(EM.entity_type, EM.table_name, EM.field_types)
		if(EM.indexes)
			for(var/datum/db/index/I in EM.indexes)
				adapter.sync_index(I.name, EM.table_name, I.fields, I.hints & DB_INDEXHINT_UNIQUE, I.hints & DB_INDEXHINT_CLUSTER)
		if(EM.key_field)
			adapter.sync_index("keyfield_index_[EM.key_field]", EM.table_name, list(EM.key_field), TRUE, TRUE)


/datum/controller/subsystem/entity_manager/fire(resumed = FALSE)
	if (!resumed)
		currentrun = tables_unsorted.Copy()
	if(!SSdatabase.connection.connection_ready())
		return
	while (length(currentrun))
		var/datum/entity_meta/Q = currentrun[length(currentrun)]
		do_select(Q)
		do_insert(Q)
		do_update(Q)
		do_delete(Q)
		currentrun.len--
		if (MC_TICK_CHECK)
			return


/datum/controller/subsystem/entity_manager/proc/do_insert(datum/entity_meta/meta)
	var/list/datum/entity/to_insert = meta.to_insert
	if(!length(to_insert))
		return
	meta.to_insert = list() // release the list early
	meta.inserting = to_insert
	var/list/unmap = list()
	for(var/datum/entity/item in to_insert)
		var/list/value = meta.unmap(item, FALSE)
		unmap.Add(list(value))

	adapter.insert_table(meta.table_name, unmap, CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_insert), meta, to_insert))

/datum/controller/subsystem/entity_manager/proc/after_insert(datum/entity_meta/meta, list/datum/entity/inserted_entities, first_id)
	var/currid = text2num("[first_id]")
	meta.inserting = list()
	// order between those two has to be same
	for(var/datum/entity/IE in inserted_entities)
		IE.id = "[currid]"
		meta.on_insert(IE)
		meta.on_action(IE)
		currid++
		if(IE.status == DB_ENTITY_STATE_ADD_DETACH)
			qdel(IE)
			continue
		IE.status = DB_ENTITY_STATE_SYNCED
		meta.managed["[IE.id]"] = IE

/datum/controller/subsystem/entity_manager/proc/do_update(datum/entity_meta/meta)
	var/list/datum/entity/to_update = meta.to_update
	if(!length(to_update))
		return
	meta.to_update = list() // release the list early
	var/list/unmap = list()
	for(var/datum/entity/item in to_update)
		var/list/value = meta.unmap(item)
		unmap.Add(list(value))

	adapter.update_table(meta.table_name, unmap, CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_update), meta, to_update))

/datum/controller/subsystem/entity_manager/proc/after_update(datum/entity_meta/meta, list/datum/entity/updated_entities)
	for(var/datum/entity/IE in updated_entities)
		IE.status = DB_ENTITY_STATE_SYNCED
		meta.on_update(IE)
		meta.on_action(IE)

/datum/controller/subsystem/entity_manager/proc/do_delete(datum/entity_meta/meta)
	var/list/datum/entity/to_delete = meta.to_delete
	if(!length(to_delete))
		return
	meta.to_delete = list() // release the list early
	var/list/ids = list()
	for(var/datum/entity/item in to_delete)
		ids += item.id

	adapter.delete_table(meta.table_name, ids, CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_delete), meta, to_delete))

/datum/controller/subsystem/entity_manager/proc/after_delete(datum/entity_meta/meta, list/datum/entity/deleted_entities)
	for(var/datum/entity/IE in deleted_entities)
		IE.status = DB_ENTITY_STATE_BROKEN
		meta.on_delete(IE)

/datum/controller/subsystem/entity_manager/proc/do_select(datum/entity_meta/meta)
	var/list/datum/entity/to_select = meta.to_read
	if(!length(to_select))
		return
	meta.to_read = list() // release the list early
	var/list/ids = list()
	for(var/datum/entity/item in to_select)
		ids += item.id

	adapter.read_table(meta.table_name, ids, CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_select), meta, to_select))

/datum/controller/subsystem/entity_manager/proc/after_select(datum/entity_meta/meta, list/datum/entity/selected_entities, uqid, list/results)
	for(var/list/IE in results)
		var/datum/entity/ET = meta.managed["[IE[DB_DEFAULT_ID_FIELD]]"]
		var/old_status = ET.status
		ET.status = DB_ENTITY_STATE_SYNCED
		meta.map(ET, IE)
		if(old_status != DB_ENTITY_STATE_SYNCED)
			meta.on_read(ET)
			meta.on_action(ET)

/datum/controller/subsystem/entity_manager/proc/select(entity_type, id = null)
	var/datum/entity_meta/meta = tables[entity_type]
	if(!meta)
		return null
	var/datum/entity/ET = meta.make_new(id)
	return ET

/datum/controller/subsystem/entity_manager/proc/filter_then(entity_type, datum/db/filter, datum/callback/CB, sync = FALSE)
	var/datum/entity_meta/meta = tables[entity_type]
	if(!meta)
		return null
	if(meta.hints & DB_TABLEHINT_LOCAL)
		after_filter(filter, meta, CB, null, meta.filter_assoc_list(meta.managed, filter))
		return
	adapter.read_filter(meta.table_name, filter, CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_filter), filter, meta, CB), sync)

/datum/controller/subsystem/entity_manager/proc/after_filter(datum/db/filter, datum/entity_meta/meta, datum/callback/CB, quid, list/results)
	var/list/datum/entity/resultset

	if(meta.hints & DB_TABLEHINT_LOCAL)
		resultset = results
	else
		resultset = list()
		for(var/list/IE in results)
			var/id = "[IE[DB_DEFAULT_ID_FIELD]]"
			var/datum/entity/ET = meta.managed[id]
			if(!ET)
				ET = meta.make_new(id, FALSE)
				ET.status = DB_ENTITY_STATE_SYNCED
				meta.map(ET, IE)
				meta.managed[id] = ET
				meta.on_read(ET)
				meta.on_action(ET)
				resultset.Add(ET)
				continue

			if(ET.status != DB_ENTITY_STATE_DETACHED)
				resultset.Add(ET)
				continue //already synced

			ET.status = DB_ENTITY_STATE_SYNCED
			meta.to_read -= ET // just for safety sake
			meta.map(ET, IE)
			meta.on_read(ET)
			meta.on_action(ET)
			resultset.Add(ET)


	if(length(meta.to_insert))
		resultset.Add(meta.filter_list(meta.to_insert, filter))
	if(length(meta.inserting))
		resultset.Add(meta.filter_list(meta.inserting, filter))
	if(CB)
		CB.Invoke(resultset)

/datum/controller/subsystem/entity_manager/proc/select_by_key(entity_type, key)
	var/datum/entity_meta/meta = tables[entity_type]
	if(!meta || !meta.key_field || !key)
		return null
	var/datum/entity/ET = meta.make_new_by_key(key)
	if(!ET.__key_synced)
		ET.__key_synced = TRUE
		adapter.read_filter(meta.table_name, DB_COMP(meta.key_field, DB_EQUALS, key), CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_select_by_key), ET, meta))
	return ET

/datum/controller/subsystem/entity_manager/proc/after_select_by_key(datum/entity/ET, datum/entity_meta/meta, quid, list/results)
	var/r_len = length(results)
	if(!r_len) // safe to insert
		meta.to_insert |= ET
		return

	if(r_len > 1)
		CRASH("Secondary Key constraint violation on [ET.type], key: [ET.vars[meta.key_field]]")

	// safe to select
	var/list/IE = results[1]
	ET.id = "[IE[DB_DEFAULT_ID_FIELD]]"
	meta.managed[ET.id] = ET
	ET.status = DB_ENTITY_STATE_SYNCED
	meta.map(ET, IE)
	meta.on_read(ET)
	meta.on_action(ET)

/datum/controller/subsystem/entity_manager/proc/view_meta(view_type, datum/db/filter = null)
	var/datum/entity_view_meta/meta = views[view_type]
	if(!meta)
		return null
	var/list/result = list()
	adapter.read_view(meta, filter, CALLBACK(src, TYPE_PROC_REF(/datum/controller/subsystem/entity_manager, after_view), meta, result), TRUE)
	return result

/datum/controller/subsystem/entity_manager/proc/after_view(datum/entity_view_meta/meta, list/to_write, quid, list/results)
	for(var/list/r in results)
		var/V = new meta.destination_entity()
		meta.map(V, r)
		to_write.Add(V)

/datum/controller/subsystem/entity_manager/proc/setup_round_id()
	round = SSentity_manager.select(/datum/entity/mc_round)
	round.save()
	round.sync_then(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(start_logging)))


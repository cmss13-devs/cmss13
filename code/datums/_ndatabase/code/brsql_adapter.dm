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
#define BRSQL_SYSTABLENAME "__entity_master"
#define BRSQL_BACKUP_PREFIX "__backup_"
#define BRSQL_COUNT_COLUMN_NAME "total"
#define BRSQL_ROOT_NAME "__root"
#define BRSQL_ROOT_ALIAS "T_root"
#define COPY_FROM_START(T, loc) copytext(T, 1, loc)
#define COPY_AFTER_FOUND(T, loc) copytext(T, loc+1)

/datum/db/adapter/brsql_adapter
	var/list/issue_log
	var/datum/db/connection/brsql_connection/connection

	var/list/datum/db/brsql_cached_query/cached_queries

/datum/db/adapter/brsql_adapter/New()
	issue_log = list()
	cached_queries = list()

// this implementation is pretty janky, our goal here to create query we can work with, not cover every possible case.
// don't make same mistake I did. 20% jank code that is usable now is better than 0% jank code that covers every case that won't even happen and is written in a year
/datum/db/brsql_cached_query
	var/datum/db/adapter/brsql_adapter/adapter
	// text of the query before we put filter
	var/pre_filter
	// text of the query after we put filter
	var/post_filter
	// casts, because our query is already mapped to internal `T_n` structure, while whatever the hell we get is not
	var/list/casts = list()
	// list of pre pflds
	var/list/pre_pflds
	// list of post pflds
	var/list/post_pflds


/datum/db/brsql_cached_query/New(_adapter, _pre_filter, _post_filter, _casts, _pre_pflds, _post_pflds)
	adapter = _adapter
	pre_filter = _pre_filter
	post_filter = _post_filter
	casts = _casts
	pre_pflds = _pre_pflds
	post_pflds = _post_pflds

// maybe pflds can be changed to named parameters? but that might take time. The contract is set, so changes here shouldn't affect your code besides performance
/datum/db/brsql_cached_query/proc/spawn_query(var/datum/db/filter/F, var/list/pflds)
	for(var/i in pre_pflds)
		pflds.Add(i)
	var/query = "[pre_filter] [adapter.get_filter(F, casts, pflds)] [post_filter]"
	for(var/i in post_pflds)
		pflds.Add(i)
	return query

/datum/db/adapter/brsql_adapter/sync_table_meta()
	var/query = getquery_systable_check()
	var/datum/db/query_response/sys_table = SSdatabase.create_query_sync(query)
	if(sys_table.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create or access system table, error: '[sys_table.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE


/datum/db/adapter/brsql_adapter/read_table(table_name, var/list/ids, var/datum/callback/CB, sync = FALSE)
	var/query_gettable = getquery_select_table(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_gettable, CB)
	else
		SSdatabase.create_query(query_gettable, CB)

/datum/db/adapter/brsql_adapter/update_table(table_name, var/list/values, var/datum/callback/CB, sync = FALSE)
	var/list/qpars = list()
	var/query_updatetable = getquery_update_table(table_name, values, qpars)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_updatetable, qpars, CB)
	else
		SSdatabase.create_parametric_query(query_updatetable, qpars, CB)

/datum/db/adapter/brsql_adapter/insert_table(table_name, var/list/values, var/datum/callback/CB, sync = FALSE)
	if(!sync)
		set waitfor = 0
	var/length = values.len
	var/list/qpars = list()
	var/query_inserttable = getquery_insert_table(table_name, values, qpars)
	var/datum/callback/callback = CALLBACK(src, /datum/db/adapter/brsql_adapter.proc/after_insert_table, CB, length, table_name)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_inserttable, qpars, callback)
	else
		SSdatabase.create_parametric_query(query_inserttable, qpars, callback)

/datum/db/adapter/brsql_adapter/proc/after_insert_table(var/datum/callback/CB, length, table_name, uid, var/list/results, var/datum/db/query/brsql/query)
	CB.Invoke(query.last_insert_id)


/datum/db/adapter/brsql_adapter/delete_table(table_name, var/list/ids, var/datum/callback/CB, sync = FALSE)
	var/query_deletetable = getquery_delete_table(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_deletetable, CB)
	else
		SSdatabase.create_query(query_deletetable, CB)

/datum/db/adapter/brsql_adapter/read_filter(table_name, var/datum/db/filter, var/datum/callback/CB, sync = FALSE)
	var/list/qpars = list()
	var/query_gettable = getquery_filter_table(table_name, filter, qpars)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_gettable, qpars, CB)
	else
		SSdatabase.create_parametric_query(query_gettable, qpars, CB)

/datum/db/adapter/brsql_adapter/read_view(var/datum/entity_view_meta/view, var/datum/db/filter/filter, var/datum/callback/CB, sync=FALSE)
	var/v_key = "v_[view.type]"
	var/list/qpars = list()
	var/datum/db/brsql_cached_query/cached_view = cached_queries[v_key]
	if(!istype(cached_view))
		return null
	var/query_getview = cached_view.spawn_query(filter, qpars)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_getview, qpars, CB)
	else
		SSdatabase.create_parametric_query(query_getview, qpars, CB)

/datum/db/adapter/brsql_adapter/sync_table(type_name, table_name, var/list/field_types)
	var/list/qpars = list()
	var/query_gettable = getquery_systable_gettable(table_name, qpars)
	var/datum/db/query_response/table_meta = SSdatabase.create_parametric_query_sync(query_gettable, qpars)
	if(table_meta.status != DB_QUERY_FINISHED)
		issue_log += "Unable to access system table, error: '[table_meta.error]'"
		return FALSE // OH SHIT OH FUCK
	if(!table_meta.results.len) // Table doesn't exist
		return internal_create_table(table_name, field_types) && internal_record_table_in_sys(type_name, table_name, field_types)

	var/id =  table_meta.results[1][DB_DEFAULT_ID_FIELD]
	var/old_fields = savetext2fields(table_meta.results[1]["fields_current"])
	var/old_hash = table_meta.results[1]["fields_hash"]
	var/field_text = fields2savetext(field_types)
	var/new_hash = sha1(field_text)

	if(old_hash == new_hash)
		return TRUE // no action required

	var/tablecount = internal_table_count(table_name)
	// check if we have any records	
	if(tablecount == 0)
		// just MURDER IT
		return internal_drop_table(table_name) && internal_create_table(table_name, field_types) && internal_record_table_in_sys(type_name, table_name, field_types, id)
	
	return internal_drop_backup_table(table_name) && internal_create_backup_table(table_name, old_fields) && internal_migrate_to_backup(table_name, old_fields) && \
		internal_update_table(table_name, field_types, old_fields) && internal_record_table_in_sys(type_name, table_name, field_types, id)
	


/datum/db/adapter/brsql_adapter/proc/internal_create_table(table_name, field_types)
	var/query = getquery_systable_maketable(table_name, field_types)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create new table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/brsql_adapter/proc/internal_record_table_in_sys(type_name, table_name, field_types, id)
	var/list/qpars = list()
	var/query = getquery_systable_recordtable(type_name, table_name, field_types, qpars, id)
	var/datum/db/query_response/sit_check = SSdatabase.create_parametric_query_sync(query, qpars)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to record meta for table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/brsql_adapter/proc/internal_drop_table(table_name)
	var/query = getcommand_droptable(table_name)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/brsql_adapter/proc/internal_drop_backup_table(table_name)
	var/query = getcommand_droptable("[BRSQL_BACKUP_PREFIX][table_name]")
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

// returns -1 if shit is fucked, otherwise returns count
/datum/db/adapter/brsql_adapter/proc/internal_table_count(table_name)
	var/query = getquery_get_rowcount(table_name)
	var/datum/db/query_response/rowcount = SSdatabase.create_query_sync(query)
	if(rowcount.status != DB_QUERY_FINISHED)
		issue_log += "Unable to get row count from table [table_name], error: '[rowcount.error]'"
		return -1 // OH SHIT OH FUCK
	return rowcount.results[1][BRSQL_COUNT_COLUMN_NAME]

/datum/db/adapter/brsql_adapter/proc/internal_request_insert_allocation(table_name, size)
	var/query = getquery_allocate_insert(table_name, size)
	var/datum/db/query_response/first_id = SSdatabase.create_query_sync(query)
	if(first_id.status != DB_QUERY_FINISHED)
		issue_log += "Unable to allocate insert for [table_name], error: '[first_id.error]'"
		return -1 // OH SHIT OH FUCK
	var/value = first_id.results[1][BRSQL_COUNT_COLUMN_NAME]
	if(!value)
		return 1
	return value

/datum/db/adapter/brsql_adapter/proc/internal_create_backup_table(table_name, field_types)
	var/query = getquery_systable_maketable("[BRSQL_BACKUP_PREFIX][table_name]", field_types)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create backup for table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/brsql_adapter/proc/internal_migrate_table(table_name, var/list/field_types_old)
	var/list/fields = list(DB_DEFAULT_ID_FIELD)
	for(var/field in field_types_old)
		fields += field

	var/query = getquery_insert_from_backup(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table [table_name] to backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/brsql_adapter/proc/internal_migrate_to_backup(table_name, var/list/field_types_old)
	var/list/fields = list(DB_DEFAULT_ID_FIELD)
	for(var/field in field_types_old)
		fields += field

	var/query = getquery_insert_into_backup(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table [table_name] to backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/brsql_adapter/proc/internal_update_table(table_name, var/list/field_types_new, var/list/field_types_old)
	for(var/field in field_types_old)
		if(!field_types_new[field])
			var/query = getquery_update_table_delete_column(table_name, field)
			var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
			if(sit_check.status != DB_QUERY_FINISHED)
				issue_log += "Unable to update table `[table_name]`, error: '[sit_check.error]'"
				return FALSE // OH SHIT OH FUCK
	
	for(var/field in field_types_new)
		if(!field_types_old[field])
			var/query = getquery_update_table_add_column(table_name, field, field_types_new[field])
			var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
			if(sit_check.status != DB_QUERY_FINISHED)
				issue_log += "Unable to update table `[table_name]`, error: '[sit_check.error]'"
				return FALSE // OH SHIT OH FUCK
		else
			if(field_types_old[field] != field_types_new[field])
				var/query = getquery_update_table_change_column(table_name, field, field_types_new[field])
				var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
				if(sit_check.status != DB_QUERY_FINISHED)
					issue_log += "Unable to update table `[table_name]`, error: '[sit_check.error]'"
					return FALSE // OH SHIT OH FUCK
	return TRUE

// local stuff starts with "getquery_"
/datum/db/adapter/brsql_adapter/proc/getquery_systable_check()
	return {"
		CREATE TABLE IF NOT EXISTS `[connection.database]`.`[BRSQL_SYSTABLENAME]` (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,type_name TEXT NOT NULL,table_name TEXT NOT NULL,fields_hash TEXT NOT NULL,fields_current TEXT NOT NULL)
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_systable_gettable(table_name, var/list/qpar)
	qpar.Add("[table_name]")
	return {"
		SELECT id, type_name, table_name, fields_hash, fields_current FROM `[connection.database]`.`[BRSQL_SYSTABLENAME]` WHERE table_name = ?
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_get_rowcount(table_name)
	return {"
		SELECT count(1) as [BRSQL_COUNT_COLUMN_NAME] FROM `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/brsql_adapter/proc/getcommand_droptable(table_name)
	return {"
		DROP TABLE IF EXISTS `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_systable_maketable(table_name, field_types)
	return {"
		CREATE TABLE `[connection.database]`.`[table_name]` (
			id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY, [fields2text(field_types)]
		);
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_systable_recordtable(type_name, table_name, field_types, var/list/qpar, id = null)
	var/field_text = fields2savetext(field_types)
	var/new_hash = sha1(field_text)
	qpar.Add("[type_name]")
	qpar.Add("[table_name]")
	qpar.Add("[new_hash]")
	qpar.Add("[field_text]")
	if(!id)
		return {"
			INSERT INTO `[connection.database]`.`[BRSQL_SYSTABLENAME]` (type_name, table_name, fields_hash, fields_current) VALUES (?, ?, ?, ?);
		"}

	return {"
			UPDATE `[connection.database]`.`[BRSQL_SYSTABLENAME]` SET type_name = ?, table_name = ?, fields_hash = ?, fields_current= ? WHERE id=[text2num(id)];
		"}

/datum/db/adapter/brsql_adapter/proc/getquery_insert_into_backup(table_name, var/list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO `[connection.database]`.`[BRSQL_BACKUP_PREFIX][table_name]` ([field_text])
		SELECT [field_text] FROM `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_insert_from_backup(table_name, var/list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO `[connection.database]`.`[table_name]` ([field_text])
		SELECT [field_text] FROM `[connection.database]`.`[BRSQL_BACKUP_PREFIX][table_name]`
	"}


/datum/db/adapter/brsql_adapter/proc/getquery_select_table(table_name, var/list/ids, var/list/fields)
	var/id_text = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			id_text+=","
		first = FALSE
		id_text += "[text2num(id)]" // against some pesky injections
	return {"
		SELECT [fields?(""+jointext(fields,",")+""):"*"]  FROM `[connection.database]`.`[table_name]` WHERE id in ([id_text])
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_filter_table(table_name, var/datum/db/filter, var/list/pflds, var/list/fields)
	return {"
		SELECT [fields?(""+jointext(fields,",")+""):"*"]  FROM `[connection.database]`.`[table_name]` WHERE [get_filter(filter, null, pflds)]
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_insert_table(table_name, var/list/values, var/list/pflds)
	var/calltext = ""
	var/insert_items = ""
	var/first = TRUE
	for(var/fields in values)
		if(!first)
			calltext += " , "
		var/local_text = ""
		var/local_first = TRUE
		for(var/field in fields)
			if(field == DB_DEFAULT_ID_FIELD)
				continue
			if(!local_first)
				local_text+=","
			if(fields[field] == null)
				local_text += "NULL"
			else
				pflds.Add("[fields[field]]")
				local_text += " ? "
			if(first)
				if(!local_first)
					insert_items+=","
				insert_items+="[field]"
			local_first = FALSE
		calltext += "([local_text])"
		first = FALSE
	
	return {"
		INSERT INTO `[connection.database]`.`[table_name]` ([insert_items]) VALUES [calltext];
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_update_row(table_name, var/list/values, var/list/pflds)
	var/calltext = ""
	var/first = TRUE
	var/id = 0
	for(var/field in values)
		var/esfield = "[field]"
		if(!first)
			calltext += ","
		var/is_id = field == DB_DEFAULT_ID_FIELD
		if(is_id)
			id = values[field]
			continue
		if(values[field])
			calltext+="[esfield]=?"
			pflds.Add("[values[field]]")
		else
			calltext+="[esfield]=NULL"
		first = FALSE
	if(!id)
		issue_log += "No ID passed to update query."
		return "" // AAAAAAAAAAAAAH FUCK DON'T JUST KILL THE ENTIRE FUCKING TABLE BRUH
	return {"
		UPDATE `[connection.database]`.`[table_name]` SET [calltext] WHERE id = [id];
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_update_table(table_name, var/list/values, var/list/parameters)
	var/calltext = ""
	var/update_items = ""
	var/first = TRUE
	var/items_first = TRUE
	var/found_id = FALSE
	for(var/fields in values)
		if(!first)
			calltext += " UNION ALL "
		var/local_text = ""
		var/local_first = TRUE
		for(var/field in fields)
			var/is_id = field == DB_DEFAULT_ID_FIELD
			if(!found_id && is_id)
				found_id = TRUE
			var/esfield = "`[field]`"
			if(!local_first)
				local_text+=","
			if(fields[field] != null)
				local_text += "? as [esfield]"
				parameters.Add(fields[field])
			else
				local_text += "null as [esfield]"
			if(first && !is_id)
				if(!items_first)
					update_items+=","
				update_items+="`[table_name]`.[esfield]=`__prep_update`.[esfield]"
				items_first = FALSE
			local_first = FALSE
		calltext += "SELECT [local_text]"
		first = FALSE
	if(!found_id)
		issue_log += "No ID passed to update query."
		return "" // AAAAAAAAAAAAAH FUCK DON'T JUST KILL THE ENTIRE FUCKING TABLE BRUH
	return {"
		WITH __prep_update as (
			[calltext]
		) UPDATE `[connection.database]`.`[table_name]` INNER JOIN `__prep_update` ON `[table_name]`.id = `__prep_update`.id SET [update_items]
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_delete_table(table_name, var/list/ids)
	var/idtext = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			idtext+=","
		idtext += "[text2num(id)]"	
	return {"
		DELETE FROM `[connection.database]`.`[table_name]` WHERE id IN ([idtext]);
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_allocate_insert(table_name, size)
	return {"
		SELECT max(id) + 1 as total FROM `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/brsql_adapter/proc/getquery_update_table_add_column(table_name, column_name, column_type)
	return "ALTER TABLE `[connection.database]`.`[table_name]` ADD COLUMN `[column_name]` [fieldtype2text(column_type)];"

/datum/db/adapter/brsql_adapter/proc/getquery_update_table_change_column(table_name, column_name, column_type)
	return "ALTER TABLE `[connection.database]`.`[table_name]` MODIFY COLUMN `[column_name]` [fieldtype2text(column_type)];"

/datum/db/adapter/brsql_adapter/proc/getquery_update_table_delete_column(table_name, column_name)
	return "ALTER TABLE `[connection.database]`.`[table_name]` DROP COLUMN `[column_name]`;"

/datum/db/adapter/brsql_adapter/proc/fieldtype2text(typeid)
	switch(typeid)
		if(DB_FIELDTYPE_INT)
			return "INT"
		if(DB_FIELDTYPE_BIGINT)
			return "BIGINT"
		if(DB_FIELDTYPE_CHAR)
			return "VARCHAR(1)"
		if(DB_FIELDTYPE_STRING_SMALL)	
			return "VARCHAR(16)"
		if(DB_FIELDTYPE_STRING_MEDIUM)	
			return "VARCHAR(64)"
		if(DB_FIELDTYPE_STRING_LARGE)	
			return "VARCHAR(256)"
		if(DB_FIELDTYPE_STRING_MAX)	
			return "VARCHAR(4000)"
		if(DB_FIELDTYPE_DATE)	
			return "DATETIME"
		if(DB_FIELDTYPE_TEXT)	
			return "TEXT"
		if(DB_FIELDTYPE_BLOB)	
			return "BLOB"
		if(DB_FIELDTYPE_DECIMAL)
			return "DECIMAL(18,5)"
	return FALSE

/datum/db/adapter/brsql_adapter/proc/fields2text(var/list/L)
	var/list/result = list()
	for(var/item in L)
		result += "[item] [fieldtype2text(L[item])]"
	return jointext(result, ",")

/datum/db/adapter/brsql_adapter/proc/fields2savetext(var/list/L)
	var/list/result = list()
	for(var/item in L)
		result += "[item]:[L[item]]"
	return jointext(result, ",")

/datum/db/adapter/brsql_adapter/proc/savetext2fields(text)
	var/list/result = list()
	var/list/split1 = splittext(text, ",")
	for(var/field in split1)
		var/list/split2 = splittext(field, ":")
		result[split2[1]] = text2num(split2[2])
	return result

/datum/db/adapter/brsql_adapter/prepare_view(var/datum/entity_view_meta/view)
	var/list/datum/entity_meta/meta_to_load = list(BRSQL_ROOT_NAME = view.root_entity_meta)
	var/list/meta_to_table = list(BRSQL_ROOT_NAME = BRSQL_ROOT_ALIAS)
	var/list/datum/db/filter/join_conditions = list()
	var/list/field_alias = list()
	var/list/shared_options = list()
	shared_options["table_alias_id"] = 1
	for(var/field in view.fields)
		var/field_path = view.fields[field]
		if(!field_path)
			field_path = field
		internal_parse_column(field, field_path, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

	for(var/field in view.group_by)
		var/field_path = view.fields[field]
		if(!field_path)
			field_path = field
		internal_parse_column(field, field_path, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)
	
	if(view.root_filter)
		var/list/filter_columns = view.root_filter.get_columns()
		for(var/field in filter_columns)
			internal_parse_column(field, field, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

	internal_generate_view_query(view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

/datum/db/adapter/brsql_adapter/proc/internal_proc_to_text(var/datum/db/native_function/NF, var/list/field_alias, var/list/pflds)
	switch(NF.type)
		if(/datum/db/native_function/case)
			var/datum/db/native_function/case/case_f = NF
			var/result_true = case_f.result_true
			var/result_false = case_f.result_false
			var/condition_text = get_filter(case_f.condition, field_alias, pflds)
			var/true_text			
			if(result_true)
				var/datum/db/native_function/native_true = result_true
				if(istype(native_true))
					true_text = internal_proc_to_text(native_true, field_alias, pflds)
				else
					var/field_cast = "[result_true]"
					if(field_alias && field_alias[field_cast])
						field_cast = field_alias[field_cast]
					true_text = field_cast
			var/false_text
			if(result_false)
				var/datum/db/native_function/native_false = result_false
				if(istype(native_false))
					false_text = internal_proc_to_text(native_false, field_alias, pflds)
				else
					var/field_cast = "[result_false]"
					if(field_alias && field_alias[field_cast])
						field_cast = field_alias[field_cast]
					false_text = field_cast
			if(false_text)
				false_text = "ELSE ([false_text]) "
			return "CASE WHEN [condition_text] THEN ([true_text]) [false_text] END"
		else
			return NF.default_to_string(field_alias, pflds)	

/datum/db/adapter/brsql_adapter/proc/internal_generate_view_query(var/datum/entity_view_meta/view, var/list/shared_options, var/list/datum/entity_meta/meta_to_load, var/list/meta_to_table, var/list/datum/db/filter/join_conditions, var/list/field_alias)
	var/list/pre_pflds = list()
	var/query_text = "SELECT "
	for(var/fld in view.fields)
		var/field = field_alias[fld]
		var/datum/db/native_function/NF = field
		// this is a function?
		if(istype(NF))
			field = internal_proc_to_text(NF, field_alias, pre_pflds)
		query_text += "[field] as `[fld]`, "
	query_text += "1 as is_view "
	query_text += "FROM `[connection.database]`.`[meta_to_load[BRSQL_ROOT_NAME].table_name]` as `[meta_to_table[BRSQL_ROOT_NAME]]` "
	var/join_text = ""
	for(var/mtt in meta_to_table)
		if(mtt == BRSQL_ROOT_NAME)
			continue
		var/alias_t = meta_to_table[mtt]
		var/name_t = meta_to_load[mtt].table_name
		var/join_c = get_filter(join_conditions[alias_t], null, pre_pflds)
		join_text += "LEFT JOIN "
		join_text += "`[connection.database]`.`[name_t]` as `[alias_t]` on [join_c] "
	
	query_text += join_text

	query_text += "WHERE "

	var/query_part_1 = query_text

	var/list/post_pflds = list()

	query_text = ""

	if(view.root_filter)
		var/filter_text = get_filter(view.root_filter, field_alias, post_pflds)
		query_text += "AND ([filter_text]) "

	var/order_length = length(view.order_by)

	if(order_length)
		var/order_text = "ORDER BY "
		var/index_order = 1
		for(var/order_field in view.order_by)
			var/order_d = view.order_by[order_field]
			order_text += "[field_alias[order_field]] "
			if(order_d == DB_ORDER_BY_ASC)
				order_text += "ASC"
			if(order_d == DB_ORDER_BY_DESC)
				order_text += "DESC"
			if(index_order != order_length)
				order_text += ","
			index_order++
		query_text += order_text

	var/group_length = length(view.group_by)

	if(group_length)
		var/group_text = "GROUP BY "
		var/index_order = 1
		for(var/fld in view.group_by)
			var/field = field_alias[fld]			
			group_text += "[field]"
			if(index_order != group_length)
				group_text += ","
		query_text += group_text + " "

	var/query_part_2 = query_text
	var/key = "v_[view.type]"
	cached_queries[key] = new /datum/db/brsql_cached_query(src, query_part_1, query_part_2, field_alias, pre_pflds, post_pflds)


/datum/db/adapter/brsql_adapter/proc/internal_parse_column(field, field_value, var/datum/entity_view_meta/view, var/list/shared_options, var/list/datum/entity_meta/meta_to_load, var/list/meta_to_table, var/list/datum/db/filter/join_conditions, var/list/field_alias)
	var/datum/db/native_function/NF = field_value
	// this is a function?
	if(istype(NF))
		var/list/field_list = NF.get_columns()
		
		for(var/sub_field in field_list)
			internal_parse_column(sub_field, sub_field, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)
		if(field)
			field_alias[field] = NF

		return
	// no, this is a normal field
	// already parsed?
	if(field && field_alias[field])
		return

	var/datum/entity_meta/current_root = view.root_entity_meta
	var/current_field = field_value
	var/current_path = ""
	var/current_alias = meta_to_table[BRSQL_ROOT_NAME]
	var/link_loc = findtextEx(current_field, ".")
	while(link_loc)
		var/table_link = COPY_FROM_START(current_field, link_loc)
		if(!table_link)
			break
		if(current_path)
			current_path += "." + table_link
		else
			current_path = table_link
		current_field = COPY_AFTER_FOUND(current_field, link_loc)
		link_loc = findtextEx(current_field, ".")
		if(!meta_to_table[current_path])
			var/step_child = "T_[shared_options["table_alias_id"]]"
			meta_to_table[current_path] = step_child
			shared_options["table_alias_id"]++
			var/datum/entity_link/next_link = current_root.outbound_links[table_link]
			if(next_link)
				meta_to_load[current_path] = next_link.parent_meta
				join_conditions[step_child] = next_link.get_filter(step_child, current_alias)
			else
				next_link = current_root.inbound_links[table_link]
				if(!next_link)
					return FALSE // failed to initialize view
				meta_to_load[current_path] = next_link.child_meta
				join_conditions[step_child] = next_link.get_filter(current_alias, step_child)

		current_root = meta_to_load[current_path]
		current_alias = meta_to_table[current_path]

	if(field)
		field_alias[field] = "`[current_alias]`.`[current_field]`"
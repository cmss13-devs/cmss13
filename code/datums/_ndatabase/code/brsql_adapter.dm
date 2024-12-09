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

/datum/db/adapter/sql/brsql
	var/datum/db/connection/brsql_connection/connection

/datum/db/adapter/sql/brsql/sync_table_meta()
	var/query = generate_systable_check_sql()
	var/datum/db/query_response/sys_table = SSdatabase.create_query_sync(query)
	if(sys_table.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create or access system table, error: '[sys_table.error]'"
		return FALSE // OH SHIT OH FUCK
	query = generate_sysindex_check_sql()
	var/datum/db/query_response/sys_index = SSdatabase.create_query_sync(query)
	if(sys_index.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create or access system index table, error: '[sys_table.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/brsql/update_table(table_name, list/values, datum/callback/on_update_table_callback, sync = FALSE)
	var/list/query_parameters = list()
	var/query_updatetable = getquery_update_table(table_name, values, query_parameters)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_updatetable, query_parameters, on_update_table_callback)
	else
		SSdatabase.create_parametric_query(query_updatetable, query_parameters, on_update_table_callback)

/datum/db/adapter/sql/brsql/insert_table(table_name, list/values, datum/callback/on_insert_table_callback, sync = FALSE)
	set waitfor = FALSE

	var/length = length(values)
	var/list/query_parameters = list()
	var/query_inserttable = generate_insert_table_sql(table_name, values, query_parameters)
	var/datum/callback/on_insert_table_callback_wrapper = CALLBACK(src, TYPE_PROC_REF(/datum/db/adapter/sql/brsql, after_insert_table), on_insert_table_callback, length, table_name)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_inserttable, query_parameters, on_insert_table_callback_wrapper)
	else
		SSdatabase.create_parametric_query(query_inserttable, query_parameters, on_insert_table_callback_wrapper)

/// Wrapper to on_insert_table_callback that passes the only value it cares about: the id of the newly inserted table
/datum/db/adapter/sql/brsql/proc/after_insert_table(datum/callback/on_insert_table_callback, length, table_name, uid, list/results, datum/db/query/brsql/query)
	on_insert_table_callback.Invoke(query.last_insert_id)

/datum/db/adapter/sql/brsql/complete_sync(type_name, table_name, field_typepaths, old_field_typepaths, id)
	return internal_drop_backup_table(table_name) && internal_create_backup_table(table_name, old_field_typepaths) && internal_migrate_to_backup(table_name, old_field_typepaths) && \
		internal_update_table(table_name, field_typepaths, old_field_typepaths) && internal_record_table_in_sys(type_name, table_name, field_typepaths, id)

/datum/db/adapter/sql/brsql/sync_index(index_name, table_name, list/fields, unique, cluster)
	var/list/query_parameters = list()
	var/query_getindex = generate_get_index_sql(index_name, table_name, query_parameters)
	var/datum/db/query_response/index_meta = SSdatabase.create_parametric_query_sync(query_getindex, query_parameters)
	if(index_meta.status != DB_QUERY_FINISHED)
		issue_log += "Unable to access system index table, error: '[index_meta.error]'"
		return FALSE // OH SHIT OH FUCK
	if(!length(index_meta.results)) // Index doesn't exist
		return internal_create_index(index_name, table_name, fields, unique, cluster) && internal_record_index_in_sys(index_name, table_name, fields)

	var/id =  index_meta.results[1][DB_DEFAULT_ID_FIELD]
	var/old_hash = index_meta.results[1]["fields_hash"]
	var/field_text = jointext(fields, ",")
	var/new_hash = sha1(field_text)

	if(old_hash == new_hash)
		return TRUE // no action required

	// Index can be updated only by recreating it
	return internal_drop_index(index_name, table_name) && internal_create_index(index_name, table_name, fields, unique, cluster) && internal_record_index_in_sys(index_name, table_name, fields, id)

/datum/db/adapter/sql/brsql/proc/internal_create_index(index_name, table_name, fields, unique, cluster)
	var/query = generate_make_index_sql(index_name, table_name, fields, unique, cluster)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create new index [index_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/brsql/proc/internal_record_index_in_sys(index_name, table_name, fields, id)
	var/list/query_parameters = list()
	var/query = generate_sysindex_record_sql(index_name, table_name, fields, query_parameters, id)
	var/datum/db/query_response/sit_check = SSdatabase.create_parametric_query_sync(query, query_parameters)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to record meta for index [index_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE


/datum/db/adapter/sql/brsql/proc/internal_drop_index(index_name, table_name)
	var/query = generate_drop_index_sql(index_name, table_name)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop index [index_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/brsql/proc/internal_update_table(table_name, list/datum/db_field/field_typepaths_new, list/datum/db_field/field_typepaths_old)
	for(var/field in field_typepaths_old)
		if(!field_typepaths_new[field])
			var/query = getquery_update_table_delete_column(table_name, field)
			var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
			if(sit_check.status != DB_QUERY_FINISHED)
				issue_log += "Unable to update table `[table_name]`, error: '[sit_check.error]'"
				return FALSE // OH SHIT OH FUCK

	for(var/field in field_typepaths_new)
		if(!field_typepaths_old[field])
			var/query = getquery_update_table_add_column(table_name, field_typepaths_new[field])
			var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
			if(sit_check.status != DB_QUERY_FINISHED)
				issue_log += "Unable to update table `[table_name]`, error: '[sit_check.error]'"
				return FALSE // OH SHIT OH FUCK
		else
			if(field_typepaths_old[field] != field_typepaths_new[field])
				var/query = getquery_update_table_change_column(table_name, field_typepaths_new[field])
				var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
				if(sit_check.status != DB_QUERY_FINISHED)
					issue_log += "Unable to update table `[table_name]`, error: '[sit_check.error]'"
					return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/brsql/get_table_metadata_fields_sql()
	return "id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY"

/datum/db/adapter/sql/brsql/get_systable_fields_sql()
	return "id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,type_name TEXT NOT NULL,table_name TEXT NOT NULL,fields_hash TEXT NOT NULL,fields_current TEXT NOT NULL"

/// Generate SQL code to create the system index table if it does not exist
/datum/db/adapter/sql/brsql/proc/generate_sysindex_check_sql()
	return {"
		CREATE TABLE IF NOT EXISTS `[connection.database]`.`[sql_constants::SYSINDEXNAME]` (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,index_name TEXT NOT NULL,table_name TEXT NOT NULL,fields_hash TEXT NOT NULL,fields_current TEXT NOT NULL)
	"}

/datum/db/adapter/sql/brsql/proc/generate_get_index_sql(index_name, table_name, list/query_parameters)
	query_parameters.Add("[index_name]")
	query_parameters.Add("[table_name]")
	return {"
		SELECT id, index_name, table_name, fields_hash, fields_current FROM `[connection.database]`.`[sql_constants::SYSINDEXNAME]` WHERE index_name = ? AND table_name = ?
	"}

/datum/db/adapter/sql/brsql/proc/generate_drop_index_sql(index_name, table_name)
	return {"
		DROP INDEX IF EXISTS `[index_name]` on `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/sql/brsql/proc/generate_make_index_sql(index_name, table_name, fields, unique, cluster)
	var/unique_text = unique?"UNIQUE":""
	var/field_text = jointext(fields,",")
	return {"
		CREATE [unique_text] INDEX [index_name]  on `[connection.database]`.`[table_name]` (
			[field_text]
		);
	"}

/datum/db/adapter/sql/brsql/proc/generate_sysindex_record_sql(index_name, table_name, fields, list/query_parameters, id = null)
	var/field_text = jointext(fields, ",")
	var/new_hash = sha1(field_text)
	query_parameters.Add("[index_name]")
	query_parameters.Add("[table_name]")
	query_parameters.Add("[new_hash]")
	query_parameters.Add("[field_text]")
	if(!id)
		return {"
			INSERT INTO `[connection.database]`.`[sql_constants::SYSINDEXNAME]` (index_name, table_name, fields_hash, fields_current) VALUES (?, ?, ?, ?);
		"}

	return {"
			UPDATE `[connection.database]`.`[sql_constants::SYSINDEXNAME]` SET index_name = ?, table_name = ?, fields_hash = ?, fields_current= ? WHERE id=[text2num(id)];
		"}

/datum/db/adapter/sql/brsql/proc/generate_insert_table_sql(table_name, list/values, list/query_parameters)
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
				query_parameters.Add("[fields[field]]")
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

/datum/db/adapter/sql/brsql/proc/getquery_update_row(table_name, list/values, list/query_parameters)
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
			query_parameters.Add("[values[field]]")
		else
			calltext+="[esfield]=NULL"
		first = FALSE
	if(!id)
		issue_log += "No ID passed to update query."
		return "" // AAAAAAAAAAAAAH FUCK DON'T JUST KILL THE ENTIRE FUCKING TABLE BRUH
	return {"
		UPDATE `[connection.database]`.`[table_name]` SET [calltext] WHERE id = [id];
	"}

/datum/db/adapter/sql/brsql/proc/getquery_update_table(table_name, list/values, list/query_parameters)
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
				query_parameters.Add(fields[field])
			else
				local_text += "null as [esfield]"
			if(first && !is_id)
				if(!items_first)
					update_items+=","
				update_items+="`[table_name]`.[esfield]=`subquery`.[esfield]"
				items_first = FALSE
			local_first = FALSE
		calltext += "SELECT [local_text]"
		first = FALSE
	if(!found_id)
		issue_log += "No ID passed to update query."
		return "" // AAAAAAAAAAAAAH FUCK DON'T JUST KILL THE ENTIRE FUCKING TABLE BRUH
	return {"
		UPDATE `[connection.database]`.`[table_name]` JOIN (WITH `__prep_update` AS ( [calltext] ) SELECT * FROM `__prep_update`) subquery ON `[table_name]`.id = subquery.id SET [update_items]
	"}


/datum/db/adapter/sql/brsql/proc/getquery_update_table_add_column(table_name, datum/db_field/column)
	return "ALTER TABLE `[connection.database]`.`[table_name]` ADD COLUMN `[column::name]` [fieldtype2text(column::field_type)];"

/datum/db/adapter/sql/brsql/proc/getquery_update_table_change_column(table_name, datum/db_field/column)
	return "ALTER TABLE `[connection.database]`.`[table_name]` MODIFY COLUMN `[column::name]` [fieldtype2text(column::field_type)];"

/datum/db/adapter/sql/brsql/proc/getquery_update_table_delete_column(table_name, column_name)
	return "ALTER TABLE `[connection.database]`.`[table_name]` DROP COLUMN `[column_name]`;"

/datum/db/adapter/sql/brsql/fieldtype2text(typeid)
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

/datum/db/adapter/sql/brsql/table_name_to_sql(table_name)
	return "`[connection.database]`.`[table_name]`"

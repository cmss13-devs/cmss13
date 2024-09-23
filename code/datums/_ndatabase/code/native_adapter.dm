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

/datum/db/adapter/sql/native
	var/datum/db/connection/native/connection

/datum/db/adapter/sql/native/sync_table_meta()
	var/query = generate_systable_check_sql()
	var/datum/db/query_response/sys_table = SSdatabase.create_query_sync(query)
	if(sys_table.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create or access system table, error: '[sys_table.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/native/update_table(table_name, list/values, datum/callback/on_update_table_callback, sync = FALSE)
	set waitfor = FALSE

	for(var/list/vals in values)
		var/list/query_parameters = list()
		var/query_updaterow = getquery_update_row(table_name, vals, query_parameters)
		SSdatabase.create_parametric_query_sync(query_updaterow, query_parameters, on_update_table_callback)

/datum/db/adapter/sql/native/insert_table(table_name, list/values, datum/callback/on_insert_table_callback, sync = FALSE)
	set waitfor = FALSE

	var/length = length(values)
	var/startid = internal_request_insert_allocation(table_name, length)
	var/list/query_parameters = list()
	var/query_inserttable = generate_insert_table_sql(table_name, values, startid, query_parameters)
	if(!on_insert_table_callback.arguments)
		on_insert_table_callback.arguments = list()
	on_insert_table_callback.arguments.Add(startid)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_inserttable, query_parameters, on_insert_table_callback)
	else
		SSdatabase.create_parametric_query(query_inserttable, query_parameters, on_insert_table_callback)

/datum/db/adapter/sql/native/complete_sync(type_name, table_name, list/datum/db_field/field_typepaths, list/datum/db_field/old_field_typepaths, id)
	return internal_drop_backup_table(table_name) && internal_create_backup_table(table_name, old_field_typepaths) && internal_migrate_to_backup(table_name, old_field_typepaths) && \
		internal_drop_table(table_name) && internal_create_table(table_name, field_typepaths) && internal_migrate_table(table_name, old_field_typepaths) && internal_record_table_in_sys(type_name, table_name, field_typepaths, id)

/datum/db/adapter/sql/native/get_table_metadata_fields_sql()
	return "id BIGINT NOT NULL PRIMARY KEY"

/datum/db/adapter/sql/native/get_systable_fields_sql()
	return "id INTEGER PRIMARY KEY,type_name TEXT NOT NULL,table_name TEXT NOT NULL,fields_hash TEXT NOT NULL,fields_current TEXT NOT NULL"

/datum/db/adapter/sql/native/proc/generate_insert_table_sql(table_name, list/values, start_id, list/query_parameters)
	var/calltext = ""
	var/insert_items = ""
	var/id = text2num(start_id)
	var/first = TRUE
	for(var/fields in values)
		if(!first)
			calltext += " UNION ALL "
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
		calltext += "SELECT [id],[local_text]"
		id++
		first = FALSE

	return {"
		INSERT INTO [table_name] (id, [insert_items]) [calltext];
	"}

/datum/db/adapter/sql/native/proc/getquery_update_row(table_name, list/values, list/query_parameters)
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
		UPDATE [table_name] SET [calltext] WHERE id = [id];
	"}

/datum/db/adapter/sql/native/fieldtype2text(typeid)
	switch(typeid)
		if(DB_FIELDTYPE_INT)
			return "INT"
		if(DB_FIELDTYPE_BIGINT)
			return "INT"
		if(DB_FIELDTYPE_CHAR)
			return "TEXT"
		if(DB_FIELDTYPE_STRING_SMALL)
			return "TEXT"
		if(DB_FIELDTYPE_STRING_MEDIUM)
			return "TEXT"
		if(DB_FIELDTYPE_STRING_LARGE)
			return "TEXT"
		if(DB_FIELDTYPE_STRING_MAX)
			return "TEXT"
		if(DB_FIELDTYPE_DATE)
			return "TEXT"
		if(DB_FIELDTYPE_TEXT)
			return "TEXT"
		if(DB_FIELDTYPE_BLOB)
			return "BLOB"
		if(DB_FIELDTYPE_DECIMAL)
			return "NUMERIC"
	return FALSE

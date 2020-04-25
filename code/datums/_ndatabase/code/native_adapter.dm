#define NATIVE_SYSTABLENAME "__entity_master"
#define NATIVE_BACKUP_PREFIX "__backup_"
#define NATIVE_COUNT_COLUMN_NAME "total"

/datum/db/adapter/native_adapter
	var/list/issue_log
	var/datum/db/connection/native/connection


/datum/db/adapter/native_adapter/New()
	issue_log = list()

/datum/db/adapter/native_adapter/sync_table_meta()
	var/query = getquery_systable_check()
	var/datum/db/query_response/sys_table = SSdatabase.create_query_sync(query)
	if(sys_table.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create or access system table, error: '[sys_table.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE


/datum/db/adapter/native_adapter/read_table(table_name, var/list/ids, var/datum/callback/CB, sync = FALSE)
	var/query_gettable = getquery_select_table(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_gettable, CB)
	else
		SSdatabase.create_query(query_gettable, CB)

/datum/db/adapter/native_adapter/update_table(table_name, var/list/values, var/datum/callback/CB, sync = FALSE)
	if(!sync)
		set waitfor = 0
	
	for(var/list/vals in values)
		var/list/qpars = list()
		var/query_updaterow = getquery_update_row(table_name, vals, qpars)
		SSdatabase.create_parametric_query_sync(query_updaterow, qpars, CB)

/datum/db/adapter/native_adapter/insert_table(table_name, var/list/values, var/datum/callback/CB, sync = FALSE)
	set waitfor = 0
	var/length = values.len
	var/startid = internal_request_insert_allocation(table_name, length)
	var/list/qpars = list()
	var/query_inserttable = getquery_insert_table(table_name, values, startid, qpars)
	if(!CB.arguments)
		CB.arguments = list()
	CB.arguments.Add(startid)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_inserttable, qpars, CB)
	else
		SSdatabase.create_parametric_query(query_inserttable, qpars, CB)

/datum/db/adapter/native_adapter/delete_table(table_name, var/list/ids, var/datum/callback/CB, sync = FALSE)
	var/query_deletetable = getquery_delete_table(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_deletetable, CB)
	else
		SSdatabase.create_query(query_deletetable, CB)

/datum/db/adapter/native_adapter/read_filter(table_name, var/datum/db/filter, var/datum/callback/CB, sync = FALSE)
	var/list/qpars = list()
	var/query_gettable = getquery_filter_table(table_name, filter, qpars)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_gettable, qpars, CB)
	else
		SSdatabase.create_parametric_query(query_gettable, qpars, CB)

/datum/db/adapter/native_adapter/sync_table(type_name, table_name, var/list/field_types)
	var/list/qpars = list()
	var/query_gettable = getquery_systable_gettable(table_name, qpars)
	var/datum/db/query_response/table_meta = SSdatabase.create_parametric_query_sync(query_gettable, qpars)
	if(table_meta.status != DB_QUERY_FINISHED)
		issue_log += "Unable to access system table, error: '[table_meta.error]'"
		return FALSE // OH SHIT OH FUCK
	if(!table_meta.results.len) // Table doesn't exist
		return internal_create_table(table_name, field_types) && internal_record_table_in_sys(type_name, table_name, field_types)

	var/id =  table_meta.results[1]["id"]
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
		internal_drop_table(table_name) && internal_create_table(table_name, field_types) && internal_migrate_table(table_name, old_fields) && internal_record_table_in_sys(type_name, table_name, field_types, id)
	


/datum/db/adapter/native_adapter/proc/internal_create_table(table_name, field_types)
	var/query = getquery_systable_maketable(table_name, field_types)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create new table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/native_adapter/proc/internal_record_table_in_sys(type_name, table_name, field_types, id)
	var/list/qpars = list()
	var/query = getquery_systable_recordtable(type_name, table_name, field_types, qpars, id)
	var/datum/db/query_response/sit_check = SSdatabase.create_parametric_query_sync(query, qpars)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to record meta for table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/native_adapter/proc/internal_drop_table(table_name)
	var/query = getcommand_droptable(table_name)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/native_adapter/proc/internal_drop_backup_table(table_name)
	var/query = getcommand_droptable("[BSQL_BACKUP_PREFIX][table_name]")
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

// returns -1 if shit is fucked, otherwise returns count
/datum/db/adapter/native_adapter/proc/internal_table_count(table_name)
	var/query = getquery_get_rowcount(table_name)
	var/datum/db/query_response/rowcount = SSdatabase.create_query_sync(query)
	if(rowcount.status != DB_QUERY_FINISHED)
		issue_log += "Unable to get row count from table [table_name], error: '[rowcount.error]'"
		return -1 // OH SHIT OH FUCK
	return rowcount.results[1][BSQL_COUNT_COLUMN_NAME]

/datum/db/adapter/native_adapter/proc/internal_request_insert_allocation(table_name, size)
	var/query = getquery_allocate_insert(table_name, size)
	var/datum/db/query_response/first_id = SSdatabase.create_query_sync(query)
	if(first_id.status != DB_QUERY_FINISHED)
		issue_log += "Unable to allocate insert for [table_name], error: '[first_id.error]'"
		return -1 // OH SHIT OH FUCK
	var/value = first_id.results[1][BSQL_COUNT_COLUMN_NAME]
	if(!value)
		return 1
	return value

/datum/db/adapter/native_adapter/proc/internal_create_backup_table(table_name, field_types)
	var/query = getquery_systable_maketable("[BSQL_BACKUP_PREFIX][table_name]", field_types)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create backup for table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/native_adapter/proc/internal_migrate_table(table_name, var/list/field_types_old)
	var/list/fields = list("id")
	for(var/field in field_types_old)
		fields += field

	var/query = getquery_insert_from_backup(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table [table_name] to backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/native_adapter/proc/internal_migrate_to_backup(table_name, var/list/field_types_old)
	var/list/fields = list("id")
	for(var/field in field_types_old)
		fields += field

	var/query = getquery_insert_into_backup(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table [table_name] to backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

// local stuff starts with "getquery_"
/datum/db/adapter/native_adapter/proc/getquery_systable_check()
	return {"
		CREATE TABLE IF NOT EXISTS [BSQL_SYSTABLENAME] (id INTEGER PRIMARY KEY,type_name TEXT NOT NULL,table_name TEXT NOT NULL,fields_hash TEXT NOT NULL,fields_current TEXT NOT NULL)
	"}

/datum/db/adapter/native_adapter/proc/getquery_systable_gettable(table_name, var/list/qpar)
	qpar.Add("[table_name]")
	return {"
		SELECT id, type_name, table_name, fields_hash, fields_current FROM [BSQL_SYSTABLENAME] WHERE table_name = ?
	"}

/datum/db/adapter/native_adapter/proc/getquery_get_rowcount(table_name)
	return {"
		SELECT count(1) as [BSQL_COUNT_COLUMN_NAME] FROM [table_name]
	"}

/datum/db/adapter/native_adapter/proc/getcommand_droptable(table_name)
	return {"
		DROP TABLE IF EXISTS [table_name]
	"}

/datum/db/adapter/native_adapter/proc/getquery_systable_maketable(table_name, field_types)
	return {"
		CREATE TABLE [table_name] (
			id BIGINT NOT NULL PRIMARY KEY, [fields2text(field_types)]
		);
	"}

/datum/db/adapter/native_adapter/proc/getquery_systable_recordtable(type_name, table_name, field_types, var/list/qpar, id = null)
	var/field_text = fields2savetext(field_types)
	var/new_hash = sha1(field_text)
	qpar.Add("[type_name]")
	qpar.Add("[table_name]")
	qpar.Add("[new_hash]")
	qpar.Add("[field_text]")
	if(!id)
		return {"
			INSERT INTO [BSQL_SYSTABLENAME] (type_name, table_name, fields_hash, fields_current) VALUES (?, ?, ?, ?);
		"}

	return {"
			UPDATE [BSQL_SYSTABLENAME] SET type_name = ?, table_name = ?, fields_hash = ?, fields_current= ? WHERE id=[text2num(id)];
		"}

/datum/db/adapter/native_adapter/proc/getquery_insert_into_backup(table_name, var/list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO [BSQL_BACKUP_PREFIX][table_name] ([field_text])
		SELECT [field_text] FROM [table_name]
	"}

/datum/db/adapter/native_adapter/proc/getquery_insert_from_backup(table_name, var/list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO [table_name] ([field_text])
		SELECT [field_text] FROM [BSQL_BACKUP_PREFIX][table_name]
	"}


/datum/db/adapter/native_adapter/proc/getquery_select_table(table_name, var/list/ids, var/list/fields)
	var/id_text = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			id_text+=","
		first = FALSE
		id_text += "[text2num(id)]" // against some pesky injections
	return {"
		SELECT [fields?(""+jointext(fields,",")+""):"*"]  FROM [table_name] WHERE id in ([id_text])
	"}

/datum/db/adapter/native_adapter/proc/getquery_filter_table(table_name, var/datum/db/filter, var/list/pflds, var/list/fields)
	return {"
		SELECT [fields?(""+jointext(fields,",")+""):"*"]  FROM [table_name] WHERE [get_filter(filter, pflds)]
	"}

/datum/db/adapter/native_adapter/proc/getquery_insert_table(table_name, var/list/values, start_id, var/list/pflds)
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
			if(field == "id")
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
		calltext += "SELECT [id],[local_text]"
		id += 1
		first = FALSE
	
	return {"
		INSERT INTO [table_name] (id, [insert_items]) [calltext];
	"}

/datum/db/adapter/native_adapter/proc/getquery_update_row(table_name, var/list/values, var/list/pflds)
	var/calltext = ""
	var/first = TRUE
	var/id = 0
	for(var/field in values)
		var/esfield = "[field]"
		if(!first)
			calltext += ","
		var/is_id = field == "id"
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
		UPDATE [table_name] SET [calltext] WHERE id = [id];
	"}

/datum/db/adapter/native_adapter/proc/getquery_delete_table(table_name, var/list/ids)
	var/idtext = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			idtext+=","
		idtext += "[text2num(id)]"	
	return {"
		DELETE FROM [table_name] WHERE id IN ([idtext]);
	"}

/datum/db/adapter/native_adapter/proc/getquery_allocate_insert(table_name, size)
	return {"
		SELECT max(id) + 1 as total FROM [table_name]
	"}

/datum/db/adapter/native_adapter/proc/fieldtype2text(typeid)
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

/datum/db/adapter/native_adapter/proc/fields2text(var/list/L)
	var/list/result = list()
	for(var/item in L)
		result += "[item] [fieldtype2text(L[item])]"
	return jointext(result, ",")

/datum/db/adapter/native_adapter/proc/fields2savetext(var/list/L)
	var/list/result = list()
	for(var/item in L)
		result += "[item]:[L[item]]"
	return jointext(result, ",")

/datum/db/adapter/native_adapter/proc/savetext2fields(text)
	var/list/result = list()
	var/list/split1 = splittext(text, ",")
	for(var/field in split1)
		var/list/split2 = splittext(field, ":")
		result[split2[1]] = text2num(split2[2])
	return result
	
/datum/db/adapter/native_adapter/proc/get_filter_comparison(var/datum/db/filter/comparison/filter, var/list/pflds)
	switch(filter.operator)
		if(DB_EQUALS)
			pflds.Add("[filter.value]")
			return "[filter.field] = ?"
		if(DB_NOTEQUAL)
			pflds.Add("[filter.value]")
			return "[filter.field] <> ?"
		if(DB_GREATER)
			pflds.Add("[filter.value]")
			return "[filter.field] > ?"
		if(DB_LESS)
			pflds.Add("[filter.value]")
			return "[filter.field] < ?"
		if(DB_GREATER_EQUAL)
			pflds.Add("[filter.value]")
			return "[filter.field] >= ?"
		if(DB_LESS_EQUAL)
			pflds.Add("[filter.value]")
			return "[filter.field] <= ?"
		if(DB_IS)
			return "[filter.field] IS NULL"
		if(DB_ISNOT)
			return "[filter.field] IS NOT NULL"
		if(DB_IN)
			var/text = ""
			var/first = TRUE
			for(var/item in filter.value)
				if(!first)
					text += ","
				pflds.Add("[item]")
				text += "?"
				first = FALSE
			return "[filter.field] IN ([text])"
		if(DB_NOTIN)
			var/text = ""
			var/first = TRUE
			for(var/item in filter.value)
				if(!first)
					text += ","
				pflds.Add("[item]")
				text += "?"
				first = FALSE
			return "[filter.field] NOTIN ([text])"
	return "1=1" // shunt

/datum/db/adapter/native_adapter/proc/get_filter_and(var/datum/db/filter/and/filter, var/list/pflds)
	var/text = "(1=1)" // so empty filters never cause errors
	for(var/item in filter.subfilters)
		text+=" AND ([get_filter(item, pflds)])"
	return text
	
/datum/db/adapter/native_adapter/proc/get_filter_or(var/datum/db/filter/or/filter, var/list/pflds)
	var/text = "(1=1)" // so empty filters never cause errors
	for(var/item in filter.subfilters)
		text+=" OR ([get_filter(item, pflds)])"
	return text

/datum/db/adapter/native_adapter/proc/get_filter(var/datum/db/filter/filter, var/list/pflds)
	if(istype(filter,/datum/db/filter/and))
		return get_filter_and(filter, pflds)
	if(istype(filter,/datum/db/filter/or))
		return get_filter_or(filter, pflds)
	if(istype(filter,/datum/db/filter/comparison))
		return get_filter_comparison(filter, pflds)
	return "1=1" // shunt
#define BSQL_SYSTABLENAME "__entity_master"
#define BSQL_BACKUP_PREFIX "__backup_"
#define BSQL_REQUEST_INSERT "__request_insert"
#define BSQL_COUNT_COLUMN_NAME "total"

/datum/db/adapter/bsql_adapter
	var/list/issue_log
	var/datum/db/connection/persistent_connection/connection


/datum/db/adapter/bsql_adapter/New()
	issue_log = list()

/datum/db/adapter/bsql_adapter/sync_table_meta()
	var/query = getquery_systable_check()
	var/datum/db/query_response/sys_table = SSdatabase.create_query_sync(query)
	if(sys_table.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create or access system table, error: '[sys_table.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE


/datum/db/adapter/bsql_adapter/read_table(table_name, var/list/ids, var/datum/callback/CB, sync=FALSE)
	var/query_gettable = getquery_select_table(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_gettable, CB)
	else
		SSdatabase.create_query(query_gettable, CB)

/datum/db/adapter/bsql_adapter/update_table(table_name, var/list/values, var/datum/callback/CB, sync=FALSE)
	var/query_updatetable = getquery_update_table(table_name, values)
	SSdatabase.create_query(query_updatetable, CB)

/datum/db/adapter/bsql_adapter/insert_table(table_name, var/list/values, var/datum/callback/CB, sync=FALSE)
	set waitfor = 0
	var/length = values.len
	var/startid = internal_request_insert_allocation(table_name, length)
	var/query_inserttable = getquery_insert_table(table_name, values, startid)
	if(!CB.arguments)
		CB.arguments = list()
	CB.arguments.Add(startid)
	if(sync)
		SSdatabase.create_query_sync(query_inserttable, CB)
	else
		SSdatabase.create_query(query_inserttable, CB)

/datum/db/adapter/bsql_adapter/delete_table(table_name, var/list/ids, var/datum/callback/CB, sync=FALSE)
	var/query_deletetable = getquery_delete_table(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_deletetable, CB)
	else
		SSdatabase.create_query(query_deletetable, CB)

/datum/db/adapter/bsql_adapter/read_filter(table_name, var/datum/db/filter, var/datum/callback/CB, sync=FALSE)
	var/query_gettable = getquery_filter_table(table_name, filter)
	if(sync)
		SSdatabase.create_query_sync(query_gettable, CB)
	else
		SSdatabase.create_query(query_gettable, CB)

/datum/db/adapter/bsql_adapter/sync_table(type_name, table_name, var/list/field_types)
	var/query_gettable = getquery_systable_gettable(table_name)
	var/datum/db/query_response/table_meta = SSdatabase.create_query_sync(query_gettable)
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
		internal_update_table(table_name, field_types, old_fields) && internal_record_table_in_sys(type_name, table_name, field_types, id)
	


/datum/db/adapter/bsql_adapter/proc/internal_create_table(table_name, field_types)
	var/query = getquery_systable_maketable(table_name, field_types)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create new table `[table_name]`, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/bsql_adapter/proc/internal_record_table_in_sys(type_name, table_name, field_types, id)
	var/query = getquery_systable_recordtable(type_name, table_name, field_types, id)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to record meta for table `[table_name]`, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/bsql_adapter/proc/internal_drop_table(table_name)
	var/query = getcommand_droptable(table_name)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table `[table_name]`, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/bsql_adapter/proc/internal_drop_backup_table(table_name)
	var/query = getcommand_droptable("[BSQL_BACKUP_PREFIX][table_name]")
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table `[table_name]`, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

// returns -1 if shit is fucked, otherwise returns count
/datum/db/adapter/bsql_adapter/proc/internal_table_count(table_name)
	var/query = getquery_get_rowcount(table_name)
	var/datum/db/query_response/rowcount = SSdatabase.create_query_sync(query)
	if(rowcount.status != DB_QUERY_FINISHED)
		issue_log += "Unable to get row count from table `[table_name]`, error: '[rowcount.error]'"
		return -1 // OH SHIT OH FUCK
	return rowcount.results[1][BSQL_COUNT_COLUMN_NAME]

/datum/db/adapter/bsql_adapter/proc/internal_request_insert_allocation(table_name, size)
	var/query = getquery_allocate_insert(table_name, size)
	var/datum/db/query_response/first_id = SSdatabase.create_query_sync(query)
	if(first_id.status != DB_QUERY_FINISHED)
		issue_log += "Unable to allocate insert for `[table_name]`, error: '[first_id.error]'"
		return -1 // OH SHIT OH FUCK
	return first_id.results[1][BSQL_COUNT_COLUMN_NAME]

/datum/db/adapter/bsql_adapter/proc/internal_create_backup_table(table_name, field_types)
	var/query = getquery_systable_maketable("[BSQL_BACKUP_PREFIX][table_name]", field_types)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create backup for table `[table_name]`, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/bsql_adapter/proc/internal_migrate_to_backup(table_name, var/list/field_types_old)
	var/list/fields = list("id")
	for(var/field in field_types_old)
		fields += field

	var/query = getquery_insert_into_backup(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table `[table_name]` to backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/bsql_adapter/proc/internal_update_table(table_name, var/list/field_types_new, var/list/field_types_old)
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
/datum/db/adapter/bsql_adapter/proc/getquery_systable_check()
	return {"
		CREATE TABLE IF NOT EXISTS `[connection.database]`.`[BSQL_SYSTABLENAME]` (`id` INT NOT NULL auto_increment PRIMARY KEY,`type_name` VARCHAR(250) NOT NULL,`table_name` VARCHAR(50) NOT NULL,`fields_hash` VARCHAR(64) NOT NULL,`fields_current` VARCHAR(4000) NOT NULL)
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_systable_gettable(table_name)
	return {"
		SELECT `id`, `type_name`, `table_name`, `fields_hash`, `fields_current` FROM `[connection.database]`.`[BSQL_SYSTABLENAME]` WHERE `table_name` = '[table_name]'
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_get_rowcount(table_name)
	return {"
		SELECT count(1) as [BSQL_COUNT_COLUMN_NAME] FROM `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/bsql_adapter/proc/getcommand_droptable(table_name)
	return {"
		DROP TABLE IF EXISTS `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_systable_maketable(table_name, field_types)
	return {"
		CREATE TABLE `[connection.database]`.`[table_name]` (
			`id` BIGINT NOT NULL PRIMARY KEY, [fields2text(field_types)]
		);
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_systable_recordtable(type_name, table_name, field_types, id = null)
	var/field_text = fields2savetext(field_types)
	var/new_hash = sha1(field_text)
	if(!id)
		return {"
			INSERT INTO `[connection.database]`.`[BSQL_SYSTABLENAME]` (`type_name`, `table_name`, `fields_hash`, `fields_current`) VALUES ('[type_name]', '[table_name]', '[new_hash]', '[field_text]');
		"}

	return {"
			UPDATE `[connection.database]`.`[BSQL_SYSTABLENAME]` SET `type_name`='[type_name]', `table_name`='[table_name]', `fields_hash`='[new_hash]', `fields_current`= '[field_text]' WHERE `id`=[id];
		"}

/datum/db/adapter/bsql_adapter/proc/getquery_insert_into_backup(table_name, var/list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO `[connection.database]`.`[BSQL_BACKUP_PREFIX][table_name]` ([field_text])
		SELECT [field_text] FROM `[connection.database]`.`[table_name]`
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_update_table_structure(table_name, var/list/fields_to_add,  var/list/fields_to_change,  var/list/fields_to_remove)
	var/result = ""
	for(var/field in fields_to_remove)
		result += getquery_update_table_delete_column(table_name, field)
	for(var/field in fields_to_change)
		result += getquery_update_table_change_column(table_name, field, fields_to_change[field])
	for(var/field in fields_to_add)
		result += getquery_update_table_add_column(table_name, field, fields_to_add[field])

	return result

/datum/db/adapter/bsql_adapter/proc/getquery_update_table_add_column(table_name, column_name, column_type)
	return "ALTER TABLE `[connection.database]`.`[table_name]` ADD COLUMN `[column_name]` [fieldtype2text(column_type)];"

/datum/db/adapter/bsql_adapter/proc/getquery_update_table_change_column(table_name, column_name, column_type)
	return "ALTER TABLE `[connection.database]`.`[table_name]` MODIFY COLUMN `[column_name]` [fieldtype2text(column_type)];"

/datum/db/adapter/bsql_adapter/proc/getquery_update_table_delete_column(table_name, column_name)
	return "ALTER TABLE `[connection.database]`.`[table_name]` DROP COLUMN `[column_name]`;"

/datum/db/adapter/bsql_adapter/proc/getquery_select_table(table_name, var/list/ids, var/list/fields)
	var/id_text = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			id_text+=","
		first = FALSE
		id_text += "[text2num(id)]" // against some pesky injections
	return {"
		SELECT [fields?("`"+jointext(fields,"`,`")+"`"):"*"]  FROM `[connection.database]`.`[table_name]` WHERE id in ([id_text])
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_filter_table(table_name, var/datum/db/filter, var/list/fields)
	return {"
		SELECT [fields?("`"+jointext(fields,"`,`")+"`"):"*"]  FROM `[connection.database]`.`[table_name]` WHERE [get_filter(filter)]
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_insert_table(table_name, var/list/values, start_id)
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
				local_text += "'[escape_string(fields[field])]'"
			if(first)
				if(!local_first)
					insert_items+=","
				insert_items+="`[escape_string(field)]`"
			local_first = FALSE
		calltext += "SELECT [id],[local_text]"
		id += 1
		first = FALSE
	
	return {"
		INSERT INTO `[connection.database]`.`[table_name]` (`id`, [insert_items]) [calltext];
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_update_table(table_name, var/list/values)
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
			var/is_id = field == "id"
			if(!found_id && is_id)
				found_id = TRUE
			var/esfield = "[escape_string(field)]"
			if(!local_first)
				local_text+=","
			if(fields[field] != null)
				local_text += "'[escape_string(fields[field])]' as `[esfield]`"
			else
				local_text += "null as `[esfield]`"
			if(first && !is_id)
				if(!items_first)
					update_items+=","
				update_items+="`[table_name]`.`[esfield]`=`__prep_update`.`[esfield]`"
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

/datum/db/adapter/bsql_adapter/proc/getquery_delete_table(table_name, var/list/ids)
	var/idtext = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			idtext+=","
		idtext += "'[escape_string(id)]'"	
	return {"
		DELETE FROM `[connection.database]`.`[table_name]` WHERE `id` IN ([idtext]);
	"}

/datum/db/adapter/bsql_adapter/proc/getquery_allocate_insert(table_name, size)
	return {"
		CALL `[connection.database]`.`[BSQL_REQUEST_INSERT]`('[table_name]', [text2num(size)]);
	"}



/datum/db/adapter/bsql_adapter/proc/fieldtype2text(typeid)
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

/datum/db/adapter/bsql_adapter/proc/fields2text(var/list/L)
	var/list/result = list()
	for(var/item in L)
		result += "`[item]` [fieldtype2text(L[item])]"
	return jointext(result, ",")

/datum/db/adapter/bsql_adapter/proc/fields2savetext(var/list/L)
	var/list/result = list()
	for(var/item in L)
		result += "[item]:[L[item]]"
	return jointext(result, ",")

/datum/db/adapter/bsql_adapter/proc/savetext2fields(text)
	var/list/result = list()
	var/list/split1 = splittext(text, ",")
	for(var/field in split1)
		var/list/split2 = splittext(field, ":")
		result[split2[1]] = text2num(split2[2])
	return result

/datum/db/adapter/bsql_adapter/proc/escape_string(str)
	return connection.connection.Quote("[str]")
	
/datum/db/adapter/bsql_adapter/proc/get_filter_comparison(var/datum/db/filter/comparison/filter)
	switch(filter.operator)
		if(DB_EQUALS)
			return "`[escape_string(filter.field)]` = '[escape_string(filter.value)]'"
		if(DB_NOTEQUAL)
			return "`[escape_string(filter.field)]` <> '[escape_string(filter.value)]'"
		if(DB_GREATER)
			return "`[escape_string(filter.field)]` > '[escape_string(filter.value)]'"
		if(DB_LESS)
			return "`[escape_string(filter.field)]` < '[escape_string(filter.value)]'"
		if(DB_GREATER_EQUAL)
			return "`[escape_string(filter.field)]` >= '[escape_string(filter.value)]'"
		if(DB_LESS_EQUAL)
			return "`[escape_string(filter.field)]` <= '[escape_string(filter.value)]'"
		if(DB_IS)
			return "`[escape_string(filter.field)]` IS NULL"
		if(DB_ISNOT)
			return "`[escape_string(filter.field)]` IS NOT NULL"
		if(DB_IN)
			var/text = ""
			var/first = TRUE
			for(var/item in filter.value)
				if(!first)
					text += ","
				text += "'[escape_string(item)]''"
				first = FALSE
			return "`[escape_string(filter.field)]` IN ([text])"
		if(DB_NOTIN)
			var/text = ""
			var/first = TRUE
			for(var/item in filter.value)
				if(!first)
					text += ","
				text += "'[escape_string(item)]''"
				first = FALSE
			return "`[escape_string(filter.field)]` NOTIN ([text])"
	return "1=1" // shunt

/datum/db/adapter/bsql_adapter/proc/get_filter_and(var/datum/db/filter/and/filter)
	var/text = "(1=1)" // so empty filters never cause errors
	for(var/item in filter.subfilters)
		text+=" AND ([get_filter(item)])"
	return text
	
/datum/db/adapter/bsql_adapter/proc/get_filter_or(var/datum/db/filter/or/filter)
	var/text = "(1=1)" // so empty filters never cause errors
	for(var/item in filter.subfilters)
		text+=" OR ([get_filter(item)])"
	return text

/datum/db/adapter/bsql_adapter/proc/get_filter(var/datum/db/filter/filter)
	if(istype(filter,/datum/db/filter/and))
		return get_filter_and(filter)
	if(istype(filter,/datum/db/filter/or))
		return get_filter_or(filter)
	if(istype(filter,/datum/db/filter/comparison))
		return get_filter_comparison(filter)
	return "1=1" // shunt
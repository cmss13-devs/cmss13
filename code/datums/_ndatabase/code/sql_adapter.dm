/**
 * Queries with generated components around the filter (WHERE clause)
 *
 * Reserved for database structures with pre- and post- filter components that require
 * more expensive (i.e. non-constant time) generation logic and only need to be generated
 * once
 */
/datum/db/cached_query
	var/datum/db/adapter/sql/native/adapter
	/// Part of the query preceding the filter (optional)
	var/pre_filter
	/// Part of the query proceeding the filter (optional)
	var/post_filter
	/// Casts, because our query is already mapped to internal `T_n` structure, while whatever the hell we get is not
	var/list/casts = list()
	/// Parameters for the pre-filter component (if it exists)
	var/list/pre_filter_query_parameters
	/// Parameters for the post-filter component (if it exists)
	var/list/post_filter_query_parameters

/datum/db/cached_query/New(adapter, pre_filter, post_filter, casts, pre_filter_query_parameters, post_filter_query_parameters)
	src.adapter = adapter
	src.pre_filter = pre_filter
	src.post_filter = post_filter
	src.casts = casts
	src.pre_filter_query_parameters = pre_filter_query_parameters
	src.post_filter_query_parameters = post_filter_query_parameters

/datum/db/cached_query/proc/spawn_query(datum/db/filter/F, list/query_parameters)
	for(var/i in pre_filter_query_parameters)
		query_parameters.Add(i)
	var/query = "[pre_filter] [adapter.get_filter(F, casts, query_parameters)] [post_filter]"
	for(var/i in post_filter_query_parameters)
		query_parameters.Add(i)
	return query

GLOBAL_REAL(sql_constants, /datum/sql_constants)
/datum/sql_constants
	var/const/SYSTABLENAME = "__entity_master"
	var/const/SYSINDEXNAME = "__index_master"
	var/const/BACKUP_PREFIX = "__backup_"
	var/const/COUNT_COLUMN_NAME = "total"
	var/const/ROOT_NAME = "__root"
	var/const/ROOT_ALIAS = "T_root"

/datum/db/adapter/sql
	var/list/issue_log
	var/list/datum/db/cached_query/cached_queries

/datum/db/adapter/sql/New()
	issue_log = list()
	cached_queries = list()

/datum/db/adapter/sql/read_table(table_name, list/ids, datum/callback/on_read_table_callback, sync = FALSE)
	var/query_gettable = generate_select_table_query_text(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_gettable, on_read_table_callback)
	else
		SSdatabase.create_query(query_gettable, on_read_table_callback)

/datum/db/adapter/sql/delete_table(table_name, list/ids, datum/callback/on_delete_table_callback, sync = FALSE)
	var/query_deletetable = generate_delete_table_sql(table_name, ids)
	if(sync)
		SSdatabase.create_query_sync(query_deletetable, on_delete_table_callback)
	else
		SSdatabase.create_query(query_deletetable, on_delete_table_callback)

/datum/db/adapter/sql/sync_table(type_name, table_name, list/datum/db_field/field_typepaths)
	var/list/query_parameters = list()
	var/query_gettable = generate_get_systable_query_text(table_name, query_parameters)
	var/datum/db/query_response/table_meta = SSdatabase.create_parametric_query_sync(query_gettable, query_parameters)
	if(table_meta.status != DB_QUERY_FINISHED)
		issue_log += "Unable to access system table, error: '[table_meta.error]'"
		return FALSE // OH SHIT OH FUCK
	if(!length(table_meta.results)) // Table doesn't exist
		return internal_create_table(table_name, field_typepaths) && internal_record_table_in_sys(type_name, table_name, field_typepaths)

	var/id =  table_meta.results[1][DB_DEFAULT_ID_FIELD]
	var/old_field_typepaths = savetext2fields(table_meta.results[1]["fields_current"])
	var/old_hash = table_meta.results[1]["fields_hash"]
	var/field_text = fields2savetext(field_typepaths)
	var/new_hash = sha1(field_text)

	if(old_hash == new_hash)
		return TRUE // no action required

	var/tablecount = internal_table_count(table_name)
	// check if we have any records
	if(tablecount == 0)
		// just MURDER IT
		return internal_drop_table(table_name) && internal_create_table(table_name, field_typepaths) && internal_record_table_in_sys(type_name, table_name, field_typepaths, id)
	return complete_sync(type_name, table_name, field_typepaths, old_field_typepaths, id)

/datum/db/adapter/sql/proc/complete_sync(type_name, table_name, list/datum/db_field/field_typepaths, list/datum/db_field/old_field_typepaths, id)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Database adapter [type] did not override `complete_sync` proc")

/datum/db/adapter/sql/read_view(datum/entity_view_meta/view, datum/db/filter/filter, datum/callback/on_read_view_callback, sync=FALSE)
	var/v_key = "v_[view.type]"
	var/list/query_parameters = list()
	var/datum/db/cached_query/cached_view = cached_queries[v_key]
	if(!istype(cached_view))
		return null
	var/query_getview = cached_view.spawn_query(filter, query_parameters)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_getview, query_parameters, on_read_view_callback)
	else
		SSdatabase.create_parametric_query(query_getview, query_parameters, on_read_view_callback)

/datum/db/adapter/sql/read_filter(table_name, datum/db/filter, datum/callback/on_read_filter_callback, sync = FALSE)
	var/list/query_parameters = list()
	var/query_gettable = generate_filter_table_query_text(table_name, filter, query_parameters)
	if(sync)
		SSdatabase.create_parametric_query_sync(query_gettable, query_parameters, on_read_filter_callback)
	else
		SSdatabase.create_parametric_query(query_gettable, query_parameters, on_read_filter_callback)

/datum/db/adapter/sql/proc/internal_create_table(table_name, field_typepaths)
	var/query = generate_create_table_sql(table_name, field_typepaths)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create new table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/proc/internal_create_backup_table(table_name, field_typepaths)
	var/query = generate_create_table_sql("[sql_constants::BACKUP_PREFIX][table_name]", field_typepaths)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to create backup for table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/proc/internal_drop_table(table_name)
	var/query = generate_drop_table_sql(table_name)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to drop table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/proc/internal_drop_backup_table(table_name)
	return internal_drop_table("[sql_constants::BACKUP_PREFIX][table_name]")

/datum/db/adapter/sql/proc/internal_record_table_in_sys(type_name, table_name, field_typepaths, id)
	var/list/query_parameters = list()
	var/query = generate_systable_record_sql(type_name, table_name, field_typepaths, query_parameters, id)
	var/datum/db/query_response/sit_check = SSdatabase.create_parametric_query_sync(query, query_parameters)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to record meta for table [table_name], error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

// returns -1 if shit is fucked, otherwise returns count
/datum/db/adapter/sql/proc/internal_table_count(table_name)
	var/query = generate_get_rowcount_sql(table_name)
	var/datum/db/query_response/rowcount = SSdatabase.create_query_sync(query)
	if(rowcount.status != DB_QUERY_FINISHED)
		issue_log += "Unable to get row count from table [table_name], error: '[rowcount.error]'"
		return -1 // OH SHIT OH FUCK
	return rowcount.results[1][sql_constants::COUNT_COLUMN_NAME]

/datum/db/adapter/sql/proc/internal_migrate_table(table_name, list/datum/db_field/field_typepaths_old)
	var/list/fields = list(DB_DEFAULT_ID_FIELD)
	for(var/field in field_typepaths_old)
		fields += field

	var/query = generate_insert_from_backup_sql(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table [table_name] from backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/proc/internal_migrate_to_backup(table_name, list/datum/db_field/field_typepaths_old)
	var/list/fields = list(DB_DEFAULT_ID_FIELD)
	for(var/field in field_typepaths_old)
		fields += field

	var/query = generate_insert_into_backup_sql(table_name, fields)
	var/datum/db/query_response/sit_check = SSdatabase.create_query_sync(query)
	if(sit_check.status != DB_QUERY_FINISHED)
		issue_log += "Unable to migrate table [table_name] to backup, error: '[sit_check.error]'"
		return FALSE // OH SHIT OH FUCK
	return TRUE

/datum/db/adapter/sql/proc/internal_request_insert_allocation(table_name, size)
	var/query = generate_allocate_insert_sql(table_name, size)
	var/datum/db/query_response/first_id = SSdatabase.create_query_sync(query)
	if(first_id.status != DB_QUERY_FINISHED)
		issue_log += "Unable to allocate insert for [table_name], error: '[first_id.error]'"
		return -1 // OH SHIT OH FUCK
	var/value = first_id.results[1][sql_constants::COUNT_COLUMN_NAME]
	if(!value)
		return 1
	return value

/datum/db/adapter/sql/proc/native_function_to_query_text(datum/db/native_function/native_function, list/field_alias, list/query_parameters)
	switch(native_function.type)
		if(/datum/db/native_function/case)
			var/datum/db/native_function/case/case_f = native_function
			var/result_true = case_f.result_true
			var/result_false = case_f.result_false
			var/condition_text = get_filter(case_f.condition, field_alias, query_parameters)
			var/true_query_text
			if(result_true)
				if(istype(result_true, /datum/db/native_function))
					true_query_text = native_function_to_query_text(result_true, field_alias, query_parameters)
				else
					var/field_cast = "[result_true]"
					if(field_alias && field_alias[field_cast])
						field_cast = field_alias[field_cast]
					true_query_text = field_cast
			var/false_query_text
			if(result_false)
				if(istype(result_false, /datum/db/native_function))
					false_query_text = native_function_to_query_text(result_false, field_alias, query_parameters)
				else
					var/field_cast = "[result_false]"
					if(field_alias && field_alias[field_cast])
						field_cast = field_alias[field_cast]
					false_query_text = field_cast
			if(false_query_text)
				false_query_text = "ELSE ([false_query_text]) "
			return "CASE WHEN [condition_text] THEN ([true_query_text]) [false_query_text] END"
		else
			return native_function.default_to_string(field_alias, query_parameters)

/// Generate SQL code to create the system table if it does not exist.
/datum/db/adapter/sql/proc/generate_systable_check_sql()
	return {"
		CREATE TABLE IF NOT EXISTS [table_name_to_sql(sql_constants::SYSTABLENAME)] ([get_systable_fields_sql()])
	"}

/// Generate SQL code for the column definition of the `CREATE TABLE` SQL command for the system table.
/datum/db/adapter/sql/proc/get_systable_fields_sql()
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Database adapter [type] did not override `get_systable_fields_sql` proc")

/// Generate SQL code to query for a specific entity table from the system table.
/datum/db/adapter/sql/proc/generate_get_systable_query_text(table_name, list/query_parameters)
	query_parameters.Add("[table_name]")
	return {"
		SELECT id, type_name, table_name, fields_hash, fields_current FROM [table_name_to_sql(sql_constants::SYSTABLENAME)] WHERE table_name = ?
	"}

/// Generate SQL code to create an entity table.
/datum/db/adapter/sql/proc/generate_create_table_sql(table_name, field_typepaths)
	return {"
		CREATE TABLE [table_name_to_sql(table_name)] (
			[get_table_metadata_fields_sql()], [fields2text(field_typepaths)]
		);
	"}

/// Generate SQL code for the metadata fields of an entity table.
/// Placed in the beginning of the column definition of the `CREATE TABLE` SQL command for the entity table.
/datum/db/adapter/sql/proc/get_table_metadata_fields_sql()
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Database adapter [type] did not override `get_table_metadata_fields_sql` proc")

/// Generate SQL code to delete a table
/datum/db/adapter/sql/proc/generate_delete_table_sql(table_name, list/ids)
	var/idtext = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			idtext+=","
		idtext += "[text2num(id)]"
		first = FALSE
	return {"
		DELETE FROM [table_name_to_sql(table_name)] WHERE id IN ([idtext]);
	"}

/// Generate SQL code to insert a row from an entity table into its backup table
/datum/db/adapter/sql/proc/generate_insert_into_backup_sql(table_name, list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO [table_name_to_sql("[sql_constants::BACKUP_PREFIX][table_name]")] ([field_text])
		SELECT [field_text] FROM [table_name_to_sql(table_name)]
	"}

/// Generate SQL code to insert a row into an entity table from its backup table
/datum/db/adapter/sql/proc/generate_insert_from_backup_sql(table_name, list/fields)
	var/field_text = jointext(fields, ", ")
	return {"
		INSERT INTO [table_name_to_sql(table_name)] ([field_text])
		SELECT [field_text] FROM [table_name_to_sql("[sql_constants::BACKUP_PREFIX][table_name]")]
	"}

/// Generate SQL code to record a table in the system table.
/datum/db/adapter/sql/proc/generate_systable_record_sql(type_name, table_name, field_typepaths, list/query_parameters, id = null)
	var/field_text = fields2savetext(field_typepaths)
	var/new_hash = sha1(field_text)
	query_parameters.Add("[type_name]")
	query_parameters.Add("[table_name]")
	query_parameters.Add("[new_hash]")
	query_parameters.Add("[field_text]")
	if(!id)
		return {"
			INSERT INTO [table_name_to_sql(sql_constants::SYSTABLENAME)] (type_name, table_name, fields_hash, fields_current) VALUES (?, ?, ?, ?);
		"}

	return {"
			UPDATE [table_name_to_sql(sql_constants::SYSTABLENAME)]` SET type_name = ?, table_name = ?, fields_hash = ?, fields_current= ? WHERE id=[text2num(id)];
		"}

/// Generate SQL code to allocate a row for insertion on a table.
/datum/db/adapter/sql/proc/generate_allocate_insert_sql(table_name, size)
	return {"
		SELECT max(id) + 1 as total FROM [table_name_to_sql(table_name)]
	"}

/// Generate SQL code to get the row count of a table.
/datum/db/adapter/sql/proc/generate_get_rowcount_sql(table_name)
	return {"
		SELECT count(1) as [sql_constants::COUNT_COLUMN_NAME] FROM [table_name_to_sql(table_name)]
	"}

/datum/db/adapter/sql/proc/generate_drop_table_sql(table_name)
	return {"
		DROP TABLE IF EXISTS [table_name_to_sql(table_name)]
	"}

/datum/db/adapter/sql/proc/generate_select_table_query_text(table_name, list/ids, list/fields)
	var/id_text = ""
	var/first = TRUE
	for(var/id in ids)
		if(!first)
			id_text+=","
		first = FALSE
		id_text += "[text2num(id)]" // against some pesky injections
	return {"
		SELECT [fields?(""+jointext(fields,",")+""):"*"]  FROM [table_name_to_sql(table_name)] WHERE id in ([id_text])
	"}

/datum/db/adapter/sql/proc/generate_filter_table_query_text(table_name, datum/db/filter, list/query_parameters, list/fields)
	return {"
		SELECT [fields?(""+jointext(fields,",")+""):"*"]  FROM [table_name_to_sql(table_name)] WHERE [get_filter(filter, null, query_parameters)]
	"}

/datum/db/adapter/sql/proc/parse_column(field, field_value, datum/entity_view_meta/view, list/shared_options, list/datum/entity_meta/meta_to_load, list/meta_to_table, list/datum/db/filter/join_conditions, list/field_alias)
	PRIVATE_PROC(TRUE)
	if (istype(field_value, /datum/db/native_function))
		var/datum/db/native_function/native_function = field_value
		var/list/field_list = native_function.get_columns()

		for(var/sub_field in field_list)
			parse_column(sub_field, sub_field, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)
		if(field)
			field_alias[field] = native_function

		return
	// no, this is a normal field
	// already parsed?
	if (field && field_alias[field])
		return

	var/datum/entity_meta/current_root = view.root_entity_meta
	var/current_field = field_value
	var/current_path = ""
	var/current_alias = meta_to_table[sql_constants::ROOT_NAME]
	var/link_loc = findtextEx(current_field, ".")
	while (link_loc)
		var/table_link = COPY_FROM_START(current_field, link_loc)
		if (!table_link)
			break
		if (current_path)
			current_path += "." + table_link
		else
			current_path = table_link
		current_field = COPY_AFTER_FOUND(current_field, link_loc)
		link_loc = findtextEx(current_field, ".")
		if (!meta_to_table[current_path])
			var/step_child = "T_[shared_options["table_alias_id"]]"
			meta_to_table[current_path] = step_child
			shared_options["table_alias_id"]++
			var/datum/entity_link/next_link = current_root.outbound_links[table_link]
			if (next_link)
				meta_to_load[current_path] = next_link.parent_meta
				join_conditions[step_child] = next_link.get_filter(step_child, current_alias)
			else
				next_link = current_root.inbound_links[table_link]
				if (!next_link)
					return FALSE // failed to initialize view
				meta_to_load[current_path] = next_link.child_meta
				join_conditions[step_child] = next_link.get_filter(current_alias, step_child)

		current_root = meta_to_load[current_path]
		current_alias = meta_to_table[current_path]

	if (field)
		field_alias[field] = "`[current_alias]`.`[current_field]`"

/datum/db/adapter/sql/prepare_view(datum/entity_view_meta/view)
	/// Maps an entity node to the table name
	var/list/datum/entity_meta/meta_to_load = list(sql_constants::ROOT_NAME = view.root_entity_meta)
	var/list/meta_to_table = list(sql_constants::ROOT_NAME = sql_constants::ROOT_ALIAS)
	var/list/datum/db/filter/join_conditions = list()
	var/list/field_alias = list()
	var/list/shared_options = list()
	shared_options["table_alias_id"] = 1
	for (var/field in view.fields)
		var/field_path = view.fields[field]
		if (!field_path)
			field_path = field
		parse_column(field, field_path, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

	for (var/field in view.group_by)
		var/field_path = view.fields[field]
		if (!field_path)
			field_path = field
		parse_column(field, field_path, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

	if (view.root_filter)
		var/list/filter_columns = view.root_filter.get_columns()
		for (var/field in filter_columns)
			parse_column(field, field, view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

	generate_view_query(view, shared_options, meta_to_load, meta_to_table, join_conditions, field_alias)

/datum/db/adapter/sql/proc/table_name_to_sql(table_name)
	PROTECTED_PROC(TRUE)
	return "`[table_name]`"

/datum/db/adapter/sql/proc/generate_view_query(datum/entity_view_meta/view, list/shared_options, list/datum/entity_meta/meta_to_load, list/meta_to_table, list/datum/db/filter/join_conditions, list/field_alias)
	PRIVATE_PROC(TRUE)
	var/list/pre_filter_query_parameters = list()
	var/query_text = "SELECT "
	for (var/fld in view.fields)
		var/field = field_alias[fld]
		var/datum/db/native_function/native_function = field
		// this is a function?
		if(istype(native_function))
			field = native_function_to_query_text(native_function, field_alias, pre_filter_query_parameters)
		query_text += "[field] as `[fld]`, "
	query_text += "1 as `is_view` "
	query_text += "FROM `[meta_to_load[sql_constants::ROOT_NAME].table_name]` as `[meta_to_table[sql_constants::ROOT_NAME]]` "
	var/join_text = ""
	for (var/mtt in meta_to_table)
		if(mtt == sql_constants::ROOT_NAME)
			continue
		var/table_alias = meta_to_table[mtt]
		var/table_name = meta_to_load[mtt].table_name
		var/join_condition_text = get_filter(join_conditions[table_alias], null, pre_filter_query_parameters)
		join_text += "LEFT JOIN [table_name_to_sql(table_name)] as `[table_alias]` on [join_condition_text] "

	query_text += join_text

	query_text += "WHERE "

	var/pre_filter = query_text

	var/list/post_filter_query_parameters = list()

	query_text = ""

	if (view.root_filter)
		var/filter_text = get_filter(view.root_filter, field_alias, post_filter_query_parameters)
		query_text += "AND ([filter_text]) "

	var/order_length = length(view.order_by)

	if (order_length)
		var/order_text = "ORDER BY "
		var/index_order = 1
		for (var/order_field in view.order_by)
			var/order_d = view.order_by[order_field]
			order_text += "[field_alias[order_field]] "
			if (order_d == DB_ORDER_BY_ASC)
				order_text += "ASC"
			if (order_d == DB_ORDER_BY_DESC)
				order_text += "DESC"
			if (index_order != order_length)
				order_text += ","
			index_order++
		query_text += order_text

	var/group_length = length(view.group_by)

	if (group_length)
		var/group_text = "GROUP BY "
		var/index_order = 1
		for (var/fld in view.group_by)
			var/field = field_alias[fld]
			group_text += "[field]"
			if (index_order != group_length)
				group_text += ","
		query_text += group_text + " "

	var/post_filter = query_text
	var/key = "v_[view.type]"
	cached_queries[key] = new /datum/db/cached_query(src, pre_filter, post_filter, field_alias, pre_filter_query_parameters, post_filter_query_parameters)

/datum/db/adapter/sql/proc/fieldtype2text(type_id)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(FALSE)
	CRASH("Database adapter [type] did not override `fieldtype2text` proc")

/datum/db/adapter/sql/proc/fields2text(list/datum/db_field/field_typepaths)
	var/list/result = list()
	for(var/field in field_typepaths)
		var/datum/db_field/field_typepath = field_typepaths[field]
		result += "[field_typepath::name] [fieldtype2text(field_typepath::field_type)]"
	return jointext(result, ",")

/datum/db/adapter/sql/proc/fields2savetext(list/datum/db_field/field_typepaths)
	var/list/result = list()
	for(var/field in field_typepaths)
		var/datum/db_field/field_typepath = field_typepaths[field]
		result += "[field_typepath::name]:[field_typepath::field_type::type_id]"
	return jointext(result, ",")

#define FIELD_NAME_IDX 1
#define FIELD_TYPE_ID_IDX 2
/datum/db/adapter/sql/proc/savetext2fields(text)
	PRIVATE_PROC(TRUE)
	var/list/result = list()
	var/list/fields_as_savetext = splittext(text, ",")
	for(var/field_as_savetext in fields_as_savetext)
		var/list/field_information = splittext(field_as_savetext, ":")
		var/field_type_id = text2num(field_information[FIELD_TYPE_ID_IDX])
		result[field_information[FIELD_NAME_IDX]] = GLOB.db_field_types[field_type_id]
	return result
#undef FIELD_NAME_IDX
#undef FIELD_TYPE_ID_IDX

/datum/db/query/native
	var/database/query/query
	var/database/db

	var/completed = FALSE
	var/affected_rows = 0

/datum/db/query/native/read_single()
	if(status >= DB_QUERY_FINISHED || completed) //broken or finished
		return
	
	if(!completed)
		completed = TRUE
		var/status = query.Execute(db)
		if(!status)
			status = DB_QUERY_BROKEN
			error = query.ErrorMsg()
			return
	status = DB_QUERY_READING
	if(!results)
		results = list()
	var/list/cols = query.Columns()
	if(cols && cols.len>0)
		while(query.NextRow())
			var/list/current_row = query.GetRowData()
			results += list(current_row)
	affected_rows = query.RowsAffected()
	qdel(query)
	status = DB_QUERY_FINISHED
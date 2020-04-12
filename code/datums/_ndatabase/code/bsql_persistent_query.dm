/datum/db/query/persistent_query
	var/datum/BSQL_Operation/Query/query
	var/list/result

/datum/db/query/persistent_query/read_single()
	if(status >= DB_QUERY_FINISHED) //broken or finished
		return
	
	var/is_complete = FALSE
	if(!results)
		results = list()
	if(status <= DB_QUERY_READING)
		is_complete = query.IsComplete()
		error = null
		if(is_complete)
			error = query.GetError()
		var/errored = !!error
		if(is_complete && !errored)
			if(!query.last_result)
				status = DB_QUERY_FINISHED
				qdel(query)
				query = null
				return
			status = DB_QUERY_READING
			var/list/current_row = query.CurrentRow()
			results += list(current_row)
			return
		if(is_complete && errored)
			status = DB_QUERY_BROKEN
			return
	status = DB_QUERY_STARTED
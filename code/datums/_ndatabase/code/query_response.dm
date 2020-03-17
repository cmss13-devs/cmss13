/datum/db/query_response
	var/datum/db/query/query
	var/datum/callback/success_callback
	var/datum/callback/fail_callback
	var/unique_query_id
	var/status
	var/error
	var/list/results

	var/query_text

	var/called_callback = FALSE

/datum/db/query_response/proc/process()
	if(!query)
		if(fail_callback && !called_callback)
			called_callback = TRUE
			fail_callback.Invoke(unique_query_id)
		return TRUE
	query.read_single()
	status = query.status
	if(status==DB_QUERY_FINISHED)		
		results = query.results
		error = query.error
		if(success_callback && !called_callback)
			called_callback = TRUE
			success_callback.Invoke(unique_query_id, results)
		return TRUE
	if(status==DB_QUERY_BROKEN)
		error = query.error
		if(fail_callback && !called_callback)
			called_callback = TRUE
			fail_callback.Invoke(unique_query_id)
		return TRUE
	return FALSE
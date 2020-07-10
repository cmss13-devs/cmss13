/datum/db/query/brsql
	var/job_id
	var/list/parameters
	var/list/columns
	var/affected_rows = 0
	var/last_insert_id

/datum/db/query/brsql/read_single()
	if(status >= DB_QUERY_FINISHED) //broken or finished
		return
	
	status = DB_QUERY_STARTED
	var/job_result = rustg_sql_check_query(job_id)
	if(job_result == RUSTG_JOB_NO_RESULTS_YET)
		return
	
	var/result = json_decode(job_result)
	switch(result["status"])
		if("ok")
			columns = result["columns"]
			// MOVE THIS STUFF TO THE ASSIGNOR, THIS IS HERE TO TEST AND UNOPTIMAL AS FUCK
			if(columns)
				results = list()
				var/list/col_list = list()
				for(var/col in columns)
					col_list.Add(col["name"])
				var/col_len = length(col_list)
				for(var/row in result["rows"])
					var/adapted_row = list()
					for(var/i = 1; i<=col_len; i++)
						adapted_row[col_list[i]] = row[i]
					results.Add(list(adapted_row))
			affected_rows = result["affected"]
			last_insert_id = result["last_insert_id"]
			status = DB_QUERY_FINISHED
			return
		if("err")
			error = result["data"]
			status = DB_QUERY_BROKEN
			return
		if("offline")
			error = "CONNECTION OFFLINE"
			status = DB_QUERY_BROKEN
			return
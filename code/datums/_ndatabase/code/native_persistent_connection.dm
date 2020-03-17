//connection that keeps itself on while it can
/datum/db/connection/native
	//what connection we are using
	var/database/db

	var/filename

	var/query_number = 0

/datum/db/connection/native/connection_ready()
	if(!db)
		status = DB_CONNECTION_BROKEN
		return FALSE
	
	status = DB_CONNECTION_READY
	error_msg = null
	
	return TRUE

/datum/db/connection/native/setup(_filename)
	filename = _filename
	if(!filename)
		filename = "local.db"
	
	db = new(filename)

	return TRUE

/datum/db/connection/native/keep()
	return

/datum/db/connection/native/query(query_text, query_parameters)
	if(connection_ready())
		var/datum/db/query/native/pq = new()
		pq.db = db
		var/list/stufflist = list()
		stufflist += args
		pq.query = new /database/query(arglist(args))
		query_number++
		return pq
	return null
	
/datum/db/connection/native/get_adapter()
	var/datum/db/adapter/native_adapter/adapter = new()
	adapter.connection = src
	return adapter
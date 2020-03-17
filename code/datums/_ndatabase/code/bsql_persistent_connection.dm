//connection that keeps itself on while it can
/datum/db/connection/persistent_connection
	//what connection we are using
	var/datum/BSQL_Connection/connection
	var/datum/BSQL_Operation/connect_operation

	var/_lock
	var/_next_timeout
	var/_next_connectcheck

	var/ipaddress
	var/port
	var/username
	var/password
	var/database

	var/query_number = 0

/datum/db/connection/persistent_connection/connection_ready()
	if(!connection)
		status = DB_CONNECTION_BROKEN
		return FALSE
	
	var/wtime = world.time

	if(QDELETED(connection))
		status = DB_CONNECTION_DELETED

	if(wtime>_next_connectcheck)
		if(connect_operation.IsComplete())
			var/error_text = connect_operation.GetError()
			if(!error_text)
				status = DB_CONNECTION_READY
				error_msg = null
			else
				status = DB_CONNECTION_BROKEN
				error_msg = error_text
		else
			status = DB_CONNECTION_NOT_CONNECTED
			error_msg = null
		_next_connectcheck = wtime + DB_RECHECK_TIMEOUT
	
	return status == DB_CONNECTION_READY

/datum/db/connection/persistent_connection/setup(_ipaddress, _port, _username, _password, _database)
	if(status == DB_CONNECTION_READY)
		return FALSE
	ipaddress = _ipaddress
	port = _port
	username = _username
	password = _password
	database = _database

	if(connection)
		del(connection)

	return TRUE

/datum/db/connection/persistent_connection/keep()
	if(connection_ready())
		return
	if(status == DB_CONNECTION_BROKEN || !connection)
		del(connection)
		connection = new("MySql")
		connect_operation = connection.BeginConnect(ipaddress, port, username, password, database)


/datum/db/connection/persistent_connection/query(query_text)
	if(connection_ready())
		var/datum/db/query/persistent_query/pq = new()
		pq.connection = src
		pq.query = connection.BeginQuery(query_text)
		query_number++
		return pq
	return null
	
/datum/db/connection/persistent_connection/get_adapter()
	var/datum/db/adapter/bsql_adapter/adapter = new()
	adapter.connection = src
	return adapter
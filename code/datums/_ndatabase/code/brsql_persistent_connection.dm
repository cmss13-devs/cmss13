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
//connection that keeps itself on while it can
/datum/db/connection/brsql_connection
	//what connection we are using
	var/connection_handle

	var/ipaddress
	var/port
	var/username
	var/password
	var/database

	var/min_threads
	var/max_threads

	var/query_number = 0

	var/connection_result

/datum/db/connection/brsql_connection/connection_ready()
	if(status == DB_CONNECTION_BROKEN)
		return
	if(!connection_handle)
		status = DB_CONNECTION_BROKEN
		return FALSE
	return TRUE

/datum/db/connection/brsql_connection/setup(_ipaddress, _port, _username, _password, _database, _min_threads, _max_threads)
	if(status == DB_CONNECTION_READY)
		return FALSE
	ipaddress = _ipaddress
	port = _port
	username = _username
	password = _password
	database = _database

	min_threads = _min_threads
	max_threads = _max_threads
	var/options = list(
		"host" = ipaddress,
		"port" = port,
		"user" = username,
		"pass" = password,
		"db_name" = database,
		"min_threads" = min_threads,
		"max_threads" = max_threads,
	)
	log_sql("Connecting to database pool at [ipaddress]:[port], database: [database]")
	connection_result = rustg_sql_connect_pool(json_encode(options))
	connection_handle = json_decode(connection_result)["handle"]
	if(!connection_handle)
		log_sql("Failed to connect to database pool - no handle returned. Result: [connection_result]")
		status = DB_CONNECTION_BROKEN
		return FALSE
	log_sql("Successfully connected to database pool. Handle: [connection_handle]")
	status = DB_CONNECTION_READY
	return TRUE

/datum/db/connection/brsql_connection/keep()
	if(connection_ready())
		return
	if(status == DB_CONNECTION_BROKEN)
		log_sql("Attempting to reconnect to database pool at [ipaddress]:[port]")
		var/options = list(
			"host" = ipaddress,
			"port" = port,
			"user" = username,
			"pass" = password,
			"db_name" = database,
			"min_threads" = min_threads,
			"max_threads" = max_threads,
		)
		connection_result = rustg_sql_connect_pool(json_encode(options))
		connection_handle = json_decode(connection_result)["handle"]
		if(connection_handle)
			log_sql("Successfully reconnected to database pool. Handle: [connection_handle]")
		else
			log_sql("Failed to reconnect to database pool. Result: [connection_result]")

/datum/db/connection/brsql_connection/query()
	if(connection_ready())
		var/datum/db/query/brsql/pq = new()
		var/query_text = args[1]
		var/query_parameters = (length(args) > 1) ? args.Copy(2) : list()
		pq.parameters = query_parameters
		var/text = json_encode(query_parameters)
		log_sql("Query #[query_number + 1]: Executing async query: [query_text]")
		pq.job_id = rustg_sql_query_async(connection_handle, query_text, text)
		log_sql("Query #[query_number + 1]: Assigned job_id: [pq.job_id]")
		query_number++
		return pq
	log_sql("Query failed: Connection not ready (status: [status])")
	return null
	
/datum/db/connection/brsql_connection/get_adapter()
	var/datum/db/adapter/brsql_adapter/adapter = new()
	adapter.connection = src
	return adapter

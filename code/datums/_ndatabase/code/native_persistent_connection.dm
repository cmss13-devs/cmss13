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
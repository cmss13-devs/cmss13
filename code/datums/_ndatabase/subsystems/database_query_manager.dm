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
var/datum/subsystem/database_query_manager/SSdatabase

/datum/subsystem/database_query_manager
	name          = "Database QM"
	wait		  = 1 // CALL US AS OFTEN AS YOU CAN, GAME!
	init_order    = SS_INIT_DATABASE
	flags         = SS_FIRE_IN_LOBBY
	priority      = SS_PRIORITY_DATABASE
	display_order = SS_DISPLAY_DATABASE

	var/datum/db/connection/connection
	var/datum/db/connection_settings/settings
	var/list/datum/db/query_response/queries

	var/list/datum/db/query_response/all_queries
	var/list/datum/db/query_response/rejected_queries

	var/list/datum/db/query_response/currentrun

	var/list/query_texts

	var/in_progress = 0
	var/in_callback = 0

	var/in_progress_tally = 0
	var/in_callback_tally = 0

	var/last_query_id = 0

	var/debug_mode = FALSE

/datum/subsystem/database_query_manager/New()
	queries = list()
	currentrun = list()
	all_queries = list()
	rejected_queries = list()
	var/list/result = loadsql("config/dbconfig.txt")
	settings = connection_settings_from_config(result)
	debug_mode = settings.debug_mode
	NEW_SS_GLOBAL(SSdatabase)

/datum/subsystem/database_query_manager/Initialize()
	set waitfor=0
	connection = settings.create_connection()
	connection.keep()

/datum/subsystem/database_query_manager/stat_entry()
	var/text = (connection && connection.status == DB_CONNECTION_READY) ? ("READY") : ("PREPPING")
	..("[text], Q:[queries.len]; P:[currentrun.len]; C:[in_callback]")

/datum/subsystem/database_query_manager/fire(resumed = FALSE)
	if (!resumed)
		connection.keep()
		currentrun = queries.Copy()
		in_progress_tally = 0
		in_callback_tally = 0
	if(connection.status != DB_CONNECTION_READY)
		return
	while (currentrun.len)
		var/datum/db/query_response/Q = currentrun[currentrun.len]		
		if (!Q || Q.disposed)
			queries -= Q
			continue
		in_progress_tally++
		if(Q.process())
			queries -= Q
			if(Q.status == DB_QUERY_BROKEN)
				rejected_queries += Q
			in_callback_tally++
		currentrun.len--
		if (MC_TICK_CHECK)			
			return
	in_progress = in_progress_tally
	in_callback = in_callback_tally

/datum/subsystem/database_query_manager/proc/create_query(query_text, success_callback, fail_callback, unique_query_id)
	var/datum/db/query_response/qr = new()
	qr.query = connection.query(query_text)
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	if(unique_query_id)
		qr.unique_query_id = unique_query_id
	else
		qr.unique_query_id = last_query_id
		last_query_id++
	queries += qr
	if(debug_mode)
		all_queries += qr
	
// if DB supports this
/datum/subsystem/database_query_manager/proc/create_parametric_query(query_text, parameters, success_callback, fail_callback, unique_query_id)
	var/datum/db/query_response/qr = new()
	var/list/prs = list()
	prs.Add(query_text)
	if(parameters)
		prs.Add(parameters)
	qr.query = connection.query(arglist(prs))
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	if(unique_query_id)
		qr.unique_query_id = unique_query_id
	else
		qr.unique_query_id = last_query_id
		last_query_id++
	queries += qr
	if(debug_mode)
		all_queries += qr

// Do not use this if you don't know why this exists
/datum/subsystem/database_query_manager/proc/create_query_sync(query_text, success_callback, fail_callback)
	var/datum/db/query_response/qr = new()
	qr.query = connection.query(query_text)
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	if(debug_mode)
		all_queries += qr
	while(!qr.process())
		stoplag()
	return qr

/datum/subsystem/database_query_manager/proc/create_parametric_query_sync(query_text, parameters, success_callback, fail_callback)
	var/datum/db/query_response/qr = new()
	var/list/prs = list()
	prs += query_text
	if(parameters)
		prs += parameters
	qr.query = connection.query(arglist(prs))
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	if(debug_mode)
		all_queries += qr
	while(!qr.process())
		stoplag()
	return qr

/datum/subsystem/database_query_manager/proc/get_query_text(qid)
	to_chat(usr, queries[qid].query)

/proc/loadsql(filename)
	var/list/Lines = file2list(filename)
	var/list/result = list()
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)
		
		if(findtext(name, "db_")==0)
			continue

		if(!name)
			continue

		result[name] = value
	return result
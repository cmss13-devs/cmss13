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
GLOBAL_REAL(SSdatabase, /datum/controller/subsystem/database_query_manager)
/datum/controller/subsystem/database_query_manager
	name   = "Database QM"
	wait   = 1
	init_order = SS_INIT_DATABASE
	init_stage = INITSTAGE_EARLY
	priority   = SS_PRIORITY_DATABASE // Low prio SS_TICKER
	flags  = SS_TICKER|SS_NO_INIT

	var/datum/db/connection/connection
	var/datum/db/connection_settings/settings

	/// Maximum amount of queries that can be ran concurrently
	var/max_concurrent_queries = 25
	/// Queries currently being handled by database driver
	var/list/datum/db/query_response/queries_active
	/// Queries left to handle during controller firing
	var/list/datum/db/query_response/queries_current
	/// Queries pending execution, mapped to complete arguments
	var/list/datum/db/query_response/queries_standby
	/// Queries pending execution that will be handled this controller firing
	var/list/datum/db/query_response/queries_new

	var/list/query_texts
	var/in_progress = 0
	var/in_callback = 0
	var/last_query_id = 0

/datum/controller/subsystem/database_query_manager/New()
	queries_active = list()
	queries_current = list()
	queries_standby = list()
	NEW_SS_GLOBAL(SSdatabase)

/datum/controller/subsystem/database_query_manager/proc/start_up()
	set waitfor = FALSE

	settings = connection_settings_from_config(CONFIG_GET(string/db_provider))
	connection = settings.create_connection()
	connection.keep()

/datum/controller/subsystem/database_query_manager/stat_entry(msg)
	var/text = (connection && connection.status == DB_CONNECTION_READY) ? ("READY") : ("PREPPING")
	msg = "[text], AQ:[length(queries_active)]; SQ:[length(queries_standby)]; P:[length(queries_current)]; C:[in_callback]"
	return ..()

/datum/controller/subsystem/database_query_manager/fire(resumed = FALSE)
	if(connection.status != DB_CONNECTION_READY)
		return

	if(!resumed)
		if(!length(queries_active) && !length(queries_standby))
			return
		connection.keep()
		queries_current = queries_active.Copy()
		queries_new = null

	// First handle the already running queries
	while(length(queries_current))
		var/datum/db/query_response/Q = popleft(queries_current)
		if(!process_query(Q))
			queries_active -= Q
		if(MC_TICK_CHECK)
			return

	// Then strap on extra new queries as possible
	if(isnull(queries_new))
		if(!length(queries_standby))
			return
		queries_new = queries_standby.Copy(1, min(length(queries_standby), max_concurrent_queries) + 1)

	while(length(queries_new) && length(queries_active) < max_concurrent_queries)
		var/datum/db/query_response/Q = queries_new[1]
		var/list/ar = queries_new[Q]
		queries_standby.Remove(Q)
		queries_new.Remove(Q)
		create_queued_query(Q, ar)
		if(MC_TICK_CHECK)
			return

/// Helper proc for query processing used in fire() - returns TRUE if not done yet
/datum/controller/subsystem/database_query_manager/proc/process_query(datum/db/query_response/Q)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(QDELETED(Q))
		return FALSE
	if(Q.process(world.tick_lag))
		queries_active -= Q
		return FALSE
	return TRUE

/// Helper proc for handling queued new queries
/datum/controller/subsystem/database_query_manager/proc/create_queued_query(datum/db/query_response/Q, qtargs)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/datum/db/query)
	if(!Q.unique_query_id)
		Q.unique_query_id = last_query_id++
	var/datum/db/query/RQ
	if(islist(qtargs))
		RQ = connection.query(arglist(qtargs))
	else
		RQ = connection.query(qtargs)
	Q.query = RQ
	queries_active += Q
	return RQ

/datum/controller/subsystem/database_query_manager/proc/create_query(query_text, success_callback, fail_callback, unique_query_id)
	var/datum/db/query_response/qr = new()
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	if(unique_query_id)
		qr.unique_query_id = unique_query_id
	queries_standby[qr] = query_text

// if DB supports this
/datum/controller/subsystem/database_query_manager/proc/create_parametric_query(query_text, parameters, success_callback, fail_callback, unique_query_id)
	var/datum/db/query_response/qr = new()
	var/list/prs = list()
	prs.Add(query_text)
	if(parameters)
		prs.Add(parameters)
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	if(unique_query_id)
		qr.unique_query_id = unique_query_id
	queries_standby[qr] = prs

// Do not use this if you don't know why this exists
/datum/controller/subsystem/database_query_manager/proc/create_query_sync(query_text, success_callback, fail_callback)
	var/datum/db/query_response/qr = new()
	qr.query = connection.query(query_text)
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	UNTIL(qr.process())
	return qr

/datum/controller/subsystem/database_query_manager/proc/create_parametric_query_sync(query_text, parameters, success_callback, fail_callback)
	var/datum/db/query_response/qr = new()
	var/list/prs = list()
	prs += query_text
	if(parameters)
		prs += parameters
	qr.query = connection.query(arglist(prs))
	qr.query_text = query_text
	qr.success_callback = success_callback
	qr.fail_callback = fail_callback
	UNTIL(qr.process())
	return qr

/proc/loadsql(filename)
	var/list/Lines = file2list(filename)
	var/list/result = list()
	for(var/t in Lines)
		if(!t) continue

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

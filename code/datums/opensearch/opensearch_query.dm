/// Models a single instance of an OpenSearch query to be used
/// The query can be changed over time, and this datum also serves as the
/// handler of the tgui associated with viewing the search

/datum/opensearch_query
	/// Numerical ID used to reference the search internally and in links
	var/id = NONE
	/// User given name to the query
	var/name = ""

	/// BYOND-side representation of the query DSL that will be sent to
	/// OpenSearch - This is either direct user input, or the cached query
	/// buiilt from the user arguments
	/// Note that PPL/SQL modes do not use this
	var/list/dsl = list()

	/// Mode the query builder is in, providing user the appropriate UI
	/// before finally turning it into the final query DSL
	var/query_mode = OPENSEARCH_QUERY_MODE_LUCENE
	/// If true, we sort by query ranks instead of by time
	var/ranking_mode = FALSE


	/// Current status of the query
	var/query_status = NONE
	/// Status text, human readable, including errors
	var/status_text = "Ready"
	/// Raw results of the last query, to be passed as stringified JSON to TGUI
	var/query_results


	// Basic query parameters go below

	/// Index pattern to query against, basically a config option for now,
	/// but you might want to let it be selectable later for performance
	var/target_index = "gamelogs-*"
	/// Max amount of results to be fetched. Be conservative, BYOND's json decode is a killer
	var/max_results = 500

	/// What mode the time selector is in
	var/time_mode = OPENSEARCH_QUERY_TIME_MODE_RELATIVE
	/// Start time (or time offset in the past from now) in seconds
	var/time_start = (240 * 3600)
	/// End time for the selected time range, defaults to 0 so now in relative mode
	var/time_end = 0

	/// Selected round_id if any. If null, the filter is inactive. If zero, autofilled to current round.
	var/target_roundid = NONE

	/// User input query text if any - such as DSL/PPL/Lucene
	var/user_query = ""
	/// Filter for the type of logs to view. If empty, show everything.
	var/list/log_types = list()


/datum/opensearch_query/New(id, bootstrap)
	. = ..()
	src.id = id // To be attributed by SSopensearch, don't instantiate this directly
	if(target_roundid == NONE)
		target_roundid = GLOB.round_id
	name = "Query ~[id]"
	query_status = OPENSEARCH_QUERY_STATUS_READY
	if(bootstrap)
		var/list/splitwords = splittext(bootstrap, " ")
		user_query = ""
		for(var/word in splitwords)
			user_query += "[word]~2"
		user_query = "([user_query])^3 "

/datum/opensearch_query/Destroy(force)
	SStgui.close_uis(src)
	SSopensearch.forget(src)
	return ..()

/// Launches the query, returning an error text if something went wrong
/datum/opensearch_query/proc/execute()
	PRIVATE_PROC(TRUE)
	. = "Unknown Error"
	if(query_status == OPENSEARCH_QUERY_STATUS_EXECUTING)
		return "Already in progress"
	. = build_dsl()
	if(!SSopensearch.queue(src, "_search", query_mode == OPENSEARCH_QUERY_MODE_DSL_RAW ? user_query : dsl))
		return "Failed to start query"
	. = null

/// Builds the query DSL based on the query builder parameters
/// This returns either null on success or an error message
/datum/opensearch_query/proc/build_dsl()
	PRIVATE_PROC(TRUE)
	if(query_status == OPENSEARCH_QUERY_STATUS_EXECUTING)
		return "Already in progress"

	. = "Unknown error"

	switch(query_mode)
		if(OPENSEARCH_QUERY_MODE_DSL_RAW)
			. = null // Nothing to do, this will send the user input directly

		if(OPENSEARCH_QUERY_MODE_DSL)
			try
				dsl = json_decode(user_query)
			catch
				. = "Failed to parse DSL into JSON"
			if(!.)
				. = inject_parameters_in_dsl()

		if(OPENSEARCH_QUERY_MODE_LUCENE)
			. = bootstrap_lucene_dsl()
			if(!.)
				. = inject_parameters_in_dsl()

	query_status = . ? OPENSEARCH_QUERY_STATUS_BUILD_ERROR : OPENSEARCH_QUERY_STATUS_READY

/// Creates the base DSL for executing a Lucene based search
/datum/opensearch_query/proc/bootstrap_lucene_dsl()
	PRIVATE_PROC(TRUE)
	. = "Internal error creating the Lucene-based DSL"
	dsl = list("query" = list("bool" = list("must" = list())))
	var/list/must = dsl["query"]["bool"]["must"]
	if(length(user_query))
		must[++must.len] = list("query_string" = list("query" = user_query))
	else
		must[++must.len] = list("match_all" = alist())
	. = null


/// Adds additional query builder parameters into the DSL
/datum/opensearch_query/proc/inject_parameters_in_dsl()
	PRIVATE_PROC(TRUE)
	. = "Failed to inject query builder params into DSL"
	dsl["size"] = max_results
	. = "Malformed DSL query - it needs to use query.bool"

	var/list/bool = dsl["query"]["bool"]
	if(!bool["filter"])
		bool["filter"] = list()
	if(!bool["must"])
		bool["must"] = list()

	var/list/filter = bool["filter"]
	var/list/must = bool["must"]
	. = "Unknown error"

	// If requested, inject log_type filtering in the must close
	if(length(log_types))
		var/list/lower_logtypes = list()
		for(var/logtype in log_types)
			lower_logtypes += lowertext(logtype) // OpenSearch wants them in lower case, presumably because it's stored as a keyword
		must[++must.len] = list("terms" = list("logtype" = lower_logtypes))

	// Inject Time range in the filter clause
	var/timefilter = list("range" = list("@timestamp" = list("gte" = render_time_param(time_start), "lte" = render_time_param(time_end))))
	filter[++filter.len] = timefilter

	// Inject Round ID filtering in the filter clause
	if(target_roundid)
		var/roundidfilter = list("term" = list("roundid" = target_roundid))
		filter[++filter.len] = roundidfilter

	// Set sorting mode by most recent by default, unless we want to have ranking sorting
	if(!ranking_mode)
		dsl["sort"] = list(list("@timestamp" = list("order" = "desc")))

	// Output the ranking information regardless of time sorting
	dsl["track_scores"] = "true" // BYOND json won't let us get a real true, but OpenSearch is nice enough to accept it as string
	. = null


/// Gets the correct time string for a given time
/datum/opensearch_query/proc/render_time_param(time_param)
	SHOULD_BE_PURE(TRUE)
	var/as_string = "[time_param]"
	switch(time_mode)
		if(OPENSEARCH_QUERY_TIME_MODE_RELATIVE)
			return "now-[time_param]s"
		else
			CRASH("Unimplemented")


/// Callback for an errored HTTP request (probably at network level)
/datum/opensearch_query/proc/on_error(datum/http_response/response_object)
	query_status = OPENSEARCH_QUERY_STATUS_FAILED
	status_text = response_object.error
	SStgui.update_uis(src)

/// Callback for an request that was unsucessful at OpenSearch level
/datum/opensearch_query/proc/on_failure(datum/http_response/response_object)
	query_status = OPENSEARCH_QUERY_STATUS_FAILED
	var/list/parsed_response
	try
		parsed_response = json_decode(response_object.body)
	catch
		status_text = "Request failed, and failed to parse OpenSearch response"
		return
	var/list/error = parsed_response["error"]
	if(error["root_cause"])
		status_text = "OpenSearch error: [json_encode(error["root_cause"])]"
		return
	status_text = "Unknown Opensearch Error"
	SStgui.update_uis(src)

/// Callback for a successful request
/datum/opensearch_query/proc/on_success(datum/http_response/response_object)
	query_status = OPENSEARCH_QUERY_STATUS_SUCCESS
	// We don't actually do anything here. For server performance reasons, we just pass the
	// entire response object as string to TGUI, without any JSON encoding.
	query_results = response_object.body
	status_text = "Request successful"
	SStgui.update_uis(src)


// ====
// UI Work goes below
// ====

/datum/opensearch_query/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "OpenSearchQuery", "Query ~[id]")
		ui.open()

/datum/opensearch_query/ui_data(mob/user)
	. = list()
	.["queryId"] = id
	.["queryName"] = name
	.["queryStatus"] = query_status
	.["queryResults"] = query_results
	.["queryMode"] = query_mode
	.["rankingMode"] = ranking_mode
	.["queryTimeStart"] = time_start
	.["queryTimeEnd"] = time_end
	.["queryRoundId"] = target_roundid
	.["userQuery"] = user_query
	.["logTypes"] = log_types
	.["statusText"] = status_text

/datum/opensearch_query/ui_state(mob/user)
	return GLOB.admin_state

/datum/opensearch_query/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return FALSE
	switch(action)
		if("delete")
			qdel(src)
		if("update_query")
			if(params["query_name"])
				name = params["query_name"]
			if(params["query_mode"])
				query_mode = params["query_mode"]
			if(params["ranking_mode"])
				ranking_mode = params["ranking_mode"]
			if(params["query_time_start"])
				time_start = params["query_time_start"]
			if(params["query_time_end"])
				time_end = params["query_time_end"]
			if(!isnull(params["query_roundid"]))
				target_roundid = params["query_roundid"]
				if(!(text2num(target_roundid) < 1))
					target_roundid = null
			if(params["user_query"])
				user_query = params["user_query"]
			if(params["log_types"])
				log_types = params["log_types"]
			if(params["execute"])
				execute()
			SStgui.update_uis(src)
		if("jmp")
			var/x = text2num(params["x"])
			var/y = text2num(params["y"])
			var/z = text2num(params["z"])
			var/client/client = usr?.client
			if(x && y && z && client)
				client.jumptocoord(x, y, z)
		if("playerpanel")
			var/client/target_client = GLOB.directory[params["ckey"]]
			var/mob/target_mob = target_client?.mob
			var/datum/admins/admin_user = GLOB.admin_datums[usr?.client?.ckey]
			if(target_mob && admin_user)
				admin_user.show_player_panel(target_mob)


/client/proc/opensearch_query_builder()
	set name = "Open OpenSearch Query Builder"
	set category = "Admin"

	var/list/options = list("New")

	for(var/id in SSopensearch.queries)
		var/datum/opensearch_query/query = SSopensearch.queries[id]
		options[query] = "[query.id] : [query.name]"

	var/reply = tgui_input_list(usr, "Select the query to edit", "OpenSearch Query Builder", options)

	if(!usr)
		return

	var/datum/opensearch_query/query = reply
	if(reply == "New")
		query = SSopensearch.new_query()
	if(!istype(query) || QDELETED(query))
		return
	query.tgui_interact(usr)

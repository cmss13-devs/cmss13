/// Models a single instance of an OpenSearch query to be used
/// The query can be changed over time, and this datum also serves as the
/// handler of the tgui associated with viewing the search

/datum/opensearch_query
	/// Numerical ID used to reference the search internally and in links
	var/id = NONE
	/// User given name to the query
	var/name = ""

	// Query state
	/// Current status of the query
	var/query_status = NONE
	/// Last error message if applicable
	var/error_text
	/// Raw results of the last query, as stringified JSON, to be passed to TGUI for parsing clientside
	var/query_results

	// Query parameters
	/// How long ago to stop search, this lets us look further back in time unbothered or do simple pagination
	/// If this is 3600 for example, we'll search from forever ago to 1 hour ago.
	/// The beginning range is configured separately in config entries.
	var/time_ago = 0
	/// Round ID to look at
	var/roundid
	/// The actual Lucene query text that the user is requesting. It'll be mashed with everything else.
	var/user_query = ""
	/// Ranging part of the filter, allowing an user to set to only display events near a position
	var/range_query
	/// Filter for the type of logs to view. If empty, show everything.
	var/list/log_types = list()
	/// If true, we sort by query score instead of by time
	var/ranking_mode = TRUE

/datum/opensearch_query/New(id, bootstrap, boostfield, boostfactor = 3)
	. = ..()
	src.id = id // To be attributed by SSopensearch, don't instantiate this directly
	name = "Query ~[id]"

	if(bootstrap)
		// First we allow searching all fields by the user's query
		user_query = "\"[bootstrap]\""
		// Then we add a second boosted search term for the query if applicable
		// This is because we routinely want to do ckey searches, and a direct match
		// to the ckey field is more important than in the other fields.
		// Note that we could also do this via injecting boosted parameters in the DSL,
		// but then that needs a whole new UI for user interaction
		if(boostfield && boostfactor)
			user_query = "([boostfield]:\"[bootstrap]\"^[boostfactor]) [user_query]"

	roundid = GLOB.round_id
	query_status = OPENSEARCH_QUERY_STATUS_READY

/datum/opensearch_query/Destroy(force)
	SStgui.close_uis(src)
	SSopensearch.forget(src)
	return ..()

/// Launches the query, returning an error text if something went wrong
/datum/opensearch_query/proc/execute(mob/logging_user)
	PRIVATE_PROC(TRUE)
	error_text = ""
	if(query_status == OPENSEARCH_QUERY_STATUS_EXECUTING)
		error_text = "Already executing"
		return
	var/list/dsl = build_dsl() // Build the final query to be made to OpenSearch
	if(dsl)
		if(logging_user)
			log_debug("OPENSEARCH: [key_name(logging_user)] executing a query: [json_encode(dsl)]")
		if(!SSopensearch.queue(src, "_search", dsl))
			error_text = "Could not start query"

/// Builds the query DSL based on the query builder parameters
/// This returns either null on success or an error message
/datum/opensearch_query/proc/build_dsl()
	PRIVATE_PROC(TRUE)
	RETURN_TYPE(/list)
	var/list/dsl = bootstrap_lucene_dsl()
	if(!dsl || !inject_parameters_in_dsl(dsl))
		query_status = OPENSEARCH_QUERY_STATUS_BUILD_ERROR
		return
	query_status = OPENSEARCH_QUERY_STATUS_READY
	return dsl

/// Creates the base DSL for executing a Lucene based search
/datum/opensearch_query/proc/bootstrap_lucene_dsl()
	PRIVATE_PROC(TRUE)
	var/list/dsl = list("query" = list("bool" = list("must" = list())))
	var/list/must = dsl["query"]["bool"]["must"]
	if(length(user_query))
		must[++must.len] = list("query_string" = list("query" = create_lucene_query()))
	else
		must[++must.len] = list("match_all" = alist()) // This must be an alist so we get a JSON {} and not a []
	return dsl

///

/// Adds additional query builder parameters into the DSL
/datum/opensearch_query/proc/inject_parameters_in_dsl(list/dsl)
	PRIVATE_PROC(TRUE)
	dsl["size"] = CONFIG_GET(number/opensearch_max_results)

	var/list/bool = dsl["query"]["bool"]
	if(!bool["filter"])
		bool["filter"] = list()
	if(!bool["must"])
		bool["must"] = list()

	var/list/filter = bool["filter"]
	var/list/must = bool["must"]

	// If requested, inject log_type filtering in the must clause
	if(length(log_types))
		var/list/lower_logtypes = list()
		for(var/logtype in log_types)
			lower_logtypes += lowertext(logtype) // OpenSearch wants them in lower case, presumably because it's stored as a keyword
		must[++must.len] = list("terms" = list("logtype" = lower_logtypes))

	// Inject Time range in the filter clause. Arbitrarily limit to 30 days, this isn't meant for long term use anyway. Use dashboards.
	var/timefilter = list("range" = list("@timestamp" = list("gte" = "now-30d", "lte" = render_time_param(time_ago))))
	filter[++filter.len] = timefilter

	// Inject Round ID filtering in the filter clause
	var/roundidfilter = list("term" = list("roundid" = "[roundid]"))
	filter[++filter.len] = roundidfilter

	// Set sorting mode by most recent by default, unless we want to have ranking sorting
	if(!ranking_mode)
		dsl["sort"] = list(list("@timestamp" = list("order" = "desc")))

	// Output the ranking information regardless of time sorting
	dsl["track_scores"] = "true" // BYOND json won't let us get a real true, but OpenSearch is nice enough to accept it as string

	return dsl

/// Creates the full Lucene query for use by us
/// All the extras handled here could be injected into the DSL instead,
/// but this requires more intricate handling of internal state and UI work.
/datum/opensearch_query/proc/create_lucene_query()
	if(range_query)
		return "([range_query]) AND ([user_query])"
	return user_query

/// Creates an expanded Lucene query with additional filters that are normally injected into the DSL
/// This is because passing filters and such in a Dashboards URL is very unwieldy.
/// So instead, we just do best-effort by shoving equivalent filters into the Lucene query.
/// Note that this doesn't include the time filter, which we can set easily in URL.
/datum/opensearch_query/proc/create_dashboards_lucene_query()
	var/query = "roundid:[roundid]"
	if(length(log_types))
		query = " AND logtype:([log_types.Join(" OR ")])"
	if(range_query)
		query += " AND ([range_query])"
	query += " AND ([user_query])"
	return query

/// Creates the Link to Dashboards for our query
/datum/opensearch_query/proc/create_dashboards_link()
	if(!CONFIG_GET(string/opensearch_dashboards_url) || !CONFIG_GET(string/opensearch_dashboards_saved_discover))
		return
	var/lucene_query = rustg_url_encode(create_dashboards_lucene_query())
	lucene_query = replacetext(lucene_query, "'", "!'") // Escaping
	var/_q = "(filters:!(),query:(language:lucene,query:'[lucene_query]'))"
	// By default we create the discover view with 30d max and refresh every 30 seconds
	var/_g = "(filters:!(),refreshInterval:(pause:!f,value:30000),time:(from:now-30d,to:[render_time_param(time_ago)]))"
	var/url = "[CONFIG_GET(string/opensearch_dashboards_url)]"
	url += "/app/data-explorer/discover/#/view/"
	url += "[CONFIG_GET(string/opensearch_dashboards_saved_discover)]"
	return "[url]?_q=[_q]&_g=[_g]"


/// Gets the correct time string for a given time
/datum/opensearch_query/proc/render_time_param(time_param)
	SHOULD_BE_PURE(TRUE)
	return "now-[time_param]s" // Expand this if you want absolute time ranges

/// Callback for an errored HTTP request (probably at network level)
/datum/opensearch_query/proc/on_error(datum/http_response/response_object)
	query_status = OPENSEARCH_QUERY_STATUS_FAILED
	error_text = response_object.error
	SStgui.update_uis(src)

/// Callback for a successful request
/datum/opensearch_query/proc/on_success(datum/http_response/response_object)
	query_status = OPENSEARCH_QUERY_STATUS_SUCCESS
	// We don't actually do anything here. For server performance reasons, we just pass the
	// entire response object as string to TGUI, without any JSON encoding.
	query_results = response_object.body
	error_text = ""
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
	.["queryTimeAgo"] = time_ago
	.["rankingMode"] = ranking_mode
	.["userQuery"] = user_query
	.["logTypes"] = log_types
	.["errorText"] = error_text
	.["roundid"] = roundid
	.["rangedQuery"] = !!range_query

/datum/opensearch_query/ui_state(mob/user)
	return GLOB.admin_state

/datum/opensearch_query/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return FALSE
	switch(action)
		if("delete")
			log_admin("[key_name(usr)] deleted OpenSearch Query ~[id]")
			qdel(src)

		if("update_query")
			if(params["query_name"])
				name = params["query_name"]
			if(params["ranking_mode"])
				ranking_mode = params["ranking_mode"]
			if(params["roundid"])
				roundid = params["roundid"]
			if(params["user_query"])
				user_query = params["user_query"]
			if(params["log_types"])
				log_types = params["log_types"]
			if(params["time_ago"])
				time_ago = params["time_ago"]
			if(params["execute"])
				execute(ui.user)
			SStgui.update_uis(src)

		if("jmp")
			var/x = text2num(params["x"])
			var/y = text2num(params["y"])
			var/z = text2num(params["z"])
			var/client/client = ui.user?.client
			if(x && y && z && client)
				client.jumptocoord(x, y, z)

		if("playerpanel")
			var/client/target_client = GLOB.directory[params["ckey"]]
			var/mob/target_mob = target_client?.mob
			var/datum/admins/admin_user = GLOB.admin_datums[ui.user?.client?.ckey]
			if(target_mob && admin_user)
				admin_user.show_player_panel(target_mob)

		if("toggle_range") // Add a ranging component to the query
			if(range_query)
				// Remove it.
				range_query = null
				SStgui.update_uis(src)
				return

			var/turf/turf = get_turf(ui.user)
			if(!turf.z)
				return
			var/range = tgui_input_number(ui.user, "How far from here? Zero to cancel.", "Range Picker", 8, 1000, 0)
			if(!range)
				return

			// Scan min/max Z coordinates
			var/turf/scan_turf

			// Up
			var/max_z = turf.z
			scan_turf = turf
			while(scan_turf)
				scan_turf = SSmapping.get_turf_above(scan_turf)
				if(scan_turf)
					max_z = scan_turf.z
			max_z = min(turf.z + range, max_z)

			// Down
			var/min_z = turf.z
			scan_turf = turf
			while(scan_turf)
				scan_turf = SSmapping.get_turf_below(scan_turf)
				if(scan_turf)
					min_z = scan_turf.z
			min_z = max(turf.z - range, min_z)

			// X / Y is easier, fill out the query now
			range_query = "loc_x: \[[turf.x - range] TO [turf.x + range]\]"
			range_query += " AND loc_y: \[[turf.y - range] TO [turf.y + range]\]"
			range_query += " AND loc_z: \[[min_z] TO [max_z]\]"

			SStgui.update_uis(src)


		if("open_dashboards")
			var/link = create_dashboards_link()
			if(link)
				ui.user << link(link)


/// Opens the full on builder letting us select a query to edit
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

/// Creates a new query quickly with the passed text
/client/proc/opensearch_quick_query(bootstrap as text)
	set name = ".opensearch"
	set desc = "Create an OpenSearch query quickly"
	set category = null

	var/datum/opensearch_query/query = SSopensearch.new_query(bootstrap)
	query.tgui_interact(usr)

/// Handles querying OpenSearch for logs information
SUBSYSTEM_DEF(opensearch)
	name = "OpenSearch"
	priority = SS_PRIORITY_OPENSEARCH
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	wait = 0.2 SECONDS

	/// Incrementing id counter to assign to queries
	var/query_counter = 1
	/// Incrementing counter of completed requests
	var/total_requests = 0
	/// AList of ID -> /datum/opensearch_query
	var/alist/queries = alist()
	/// List of /datum/opensearch_query currently performing a request, mapped to their http_request object
	var/list/datum/opensearch_query/active = list()
	/// Snapshot of the above for scheduling
	var/list/datum/opensearch_query/currentrun

/datum/controller/subsystem/opensearch/Initialize()
	if(!CONFIG_GET(string/opensearch_host))
		can_fire = FALSE
		return SS_INIT_NO_NEED
	return SS_INIT_SUCCESS

/datum/controller/subsystem/opensearch/stat_entry(msg)
	if(!can_fire)
		msg = "Disabled"
	else
		msg = "Completed: [total_requests], Queries: [length(queries)], Active: [length(active)]"
	return ..()

/datum/controller/subsystem/opensearch/fire(resumed)
	if(!resumed)
		currentrun = active.Copy()
	while(length(currentrun))
		var/datum/opensearch_query/query = currentrun[currentrun.len]
		var/datum/http_request/http_request = currentrun[query]
		currentrun.len--
		handle_request(query, http_request)
		if(MC_TICK_CHECK)
			return

/// Create a new query and register it
/datum/controller/subsystem/opensearch/proc/new_query()
	RETURN_TYPE(/datum/opensearch_query)
	var/id = query_counter++
	var/datum/opensearch_query/query = new(id)
	queries[id] = query
	return query

/// Remove a query from controller tracking
/datum/controller/subsystem/opensearch/proc/forget(datum/opensearch_query/query)
	if(length(currentrun))
		currentrun -= query
	active -= query
	queries -= query.id

/// Handle a request completion during fire
/datum/controller/subsystem/opensearch/proc/handle_request(datum/opensearch_query/query, datum/http_request/http_request)
	PRIVATE_PROC(TRUE)
	var/completed = http_request.is_complete()
	if(completed)
		total_requests++
		active -= query
		var/datum/http_response/response = http_request.into_response()
		if(!response || response.errored)
			query.on_error(response)
		else if(response.status_code == 200)
			query.on_success(response)
		else
			query.on_failure(response)

/// Queues a new HTTP request to the OpenSearch backend:
///  * [query] : The query this request is attributed to. Has no real effect, is just to know who to fire callbacks to.
///  * [endpoint] : The HTTP endpoint to make the request to. For example, /_search
///  * [payload] : The full HTTP payload with a properly built query for the backend
/datum/controller/subsystem/opensearch/proc/queue(datum/opensearch_query/query, endpoint, list/payload)
	if(!can_fire || query.query_status != OPENSEARCH_QUERY_STATUS_READY || (query in active))
		return FALSE
	var/bare_payload = payload
	if(islist(payload))
		bare_payload = json_encode(payload)
	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, "[CONFIG_GET(string/opensearch_host)]/[CONFIG_GET(string/opensearch_pattern)]/[endpoint]", bare_payload, list("Content-Type" = "application/json", "Authorization" = "Basic [CONFIG_GET(string/opensearch_authtoken)]"))
	request.begin_async()
	active[query] = request
	query.query_status = OPENSEARCH_QUERY_STATUS_EXECUTING
	. = TRUE


/// The host to make OpenSearch queries to, for example "https://opensearch.cm-ss13.com"
/datum/config_entry/string/opensearch_host
	protection = CONFIG_ENTRY_LOCKED

/// The Basic HTTP auth token to use for authentication to OpenSearch, in the form of user:password base64ed
/datum/config_entry/string/opensearch_authtoken
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_SENSITIVE

/// Index patterns to be accessed by OpenSearch query tool
/datum/config_entry/string/opensearch_pattern
	protection = CONFIG_ENTRY_LOCKED

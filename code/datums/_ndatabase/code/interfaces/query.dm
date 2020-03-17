/datum/db/query
	var/datum/db/connection/connection
	var/list/results
	var/status
	var/error

/datum/db/query/proc/read_single()
	status = DB_QUERY_BROKEN
/datum/db/connection
	var/status
	var/error_msg

/datum/db/connection/proc/connection_ready()
	return FALSE

/datum/db/connection/proc/setup()
	return FALSE

/datum/db/connection/proc/keep()
	return

/datum/db/connection/proc/query(query_text)
	return null

/datum/db/connection/proc/get_adapter()
	return null
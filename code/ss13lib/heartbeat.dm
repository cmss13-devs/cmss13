/// Sends the regular heartbeat to the hub, which will ping back with a Topic query
/datum/ss13lib/proc/perform_heartbeat()
	perform_fire_and_forget_http(SS13LIB_HTTP_GET, "[SS13LIB_HUB_SERVER]/heartbeat?port=[SS13LIB_SERVER_PORT]")

/datum/ss13lib
	/// The ID for this server. This must be sent in all authentication requests
	var/server_id
	/// Whether the library has completed initialisation
	var/ready = FALSE

#define SS13LIB_MAX_HANDSHAKE_ATTEMPTS 3

/// Before starting to fire off heartbeats, perform a handshake to get our server ID.
/datum/ss13lib/proc/perform_handshake()
	SS13LIB_INFO_LOG("Beginning handshake with hub server.")

	for(var/i in 1 to SS13LIB_MAX_HANDSHAKE_ATTEMPTS)
		var/datum/ss13lib_http_response/response = perform_http_request(
			SS13LIB_HTTP_GET,
			"[SS13LIB_HUB_SERVER]/handshake?port=[SS13LIB_SERVER_PORT]&version=[SS13LIB_VERSION]",
		)

		if(response.errored)
			SS13LIB_WARNING_LOG("Error occured in handshake, attempt [i]/[SS13LIB_MAX_HANDSHAKE_ATTEMPTS].")
			sleep(i * 10)
			continue

		var/body

		try
			body = json_decode(response.body)
		catch
			SS13LIB_WARNING_LOG("Could not decode handshake response, attempt [i]/[SS13LIB_MAX_HANDSHAKE_ATTEMPTS].")
			sleep(i * 10)
			continue

		if(!body || !length(body))
			SS13LIB_WARNING_LOG("No valid JSON response during handshake, attempt [i]/[SS13LIB_MAX_HANDSHAKE_ATTEMPTS].")
			sleep(i * 10)
			continue

		var/retrieved_id = body["server_id"]
		if(!retrieved_id)
			SS13LIB_WARNING_LOG("Response from hub server was invalid, attempt [i]/[SS13LIB_MAX_HANDSHAKE_ATTEMPTS].")
			sleep(i * 10)
			continue

		src.server_id = retrieved_id
		break

	if(src.server_id)
		SS13LIB_INFO_LOG("Handshake with hub server completed successfully.")
		return TRUE

	SS13LIB_ERROR_LOG("Fatal error, handshake with hub server could not be completed.")
	return FALSE


#undef SS13LIB_MAX_HANDSHAKE_ATTEMPTS

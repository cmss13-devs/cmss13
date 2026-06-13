/datum/ss13lib
	/// The ID for this server. This must be sent in all authentication requests
	var/server_id
	/// Nonce from the last handshake, used for domain attestation
	var/nonce
	/// Poll key from the last handshake, included in topic responses
	var/poll_key
	/// Whether the library has completed initialisation
	var/ready = FALSE
	/// Whether we have already warned about being blacklist-hidden
	var/blacklist_warned = FALSE

#define SS13LIB_MAX_HANDSHAKE_ATTEMPTS 3

/// Before starting to fire off heartbeats, perform a handshake to get our server ID.
/datum/ss13lib/proc/perform_handshake()
	SS13LIB_INFO_LOG("Beginning handshake with hub server.")

	var/handshake_url = "[SS13LIB_HUB_SERVER]/handshake?port=[SS13LIB_SERVER_PORT]&version=[SS13LIB_VERSION]"
#ifdef SS13LIB_AUTH_METHODS
	var/list/auth_methods = SS13LIB_AUTH_METHODS
	if(length(auth_methods))
		handshake_url += "&auth_methods=[jointext(auth_methods, ",")]"
#endif
#ifdef SS13LIB_ENGINE
	var/engine = SS13LIB_ENGINE
	if(length(engine))
		handshake_url += "&engine=[engine]"
#endif

	for(var/i in 1 to SS13LIB_MAX_HANDSHAKE_ATTEMPTS)
		var/datum/ss13lib_http_response/response = perform_http_request(
			SS13LIB_HTTP_GET,
			handshake_url,
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
		src.nonce = body["nonce"]
		src.poll_key = body["poll_key"]
		break

	if(src.server_id)
		SS13LIB_INFO_LOG("Handshake with hub server completed successfully.")
		return TRUE

	SS13LIB_ERROR_LOG("Fatal error, handshake with hub server could not be completed.")
	return FALSE


#undef SS13LIB_MAX_HANDSHAKE_ATTEMPTS

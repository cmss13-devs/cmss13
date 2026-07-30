/// Intercepts /world/Topic(), if the query contains our query code, return the structured
/// topic response. If not, allows /world/Topic() to continue and handle the response normally.
/// This does not require any authentication, and does not expose any non-public information
/datum/ss13lib/proc/handle_topic(topic_parameters)
	var/parameters = params2list(topic_parameters)

	if(parameters[SS13LIB_PREFLIGHT_CODE])
		if(!src.server_id)
			return FALSE
		var/response = list("server_id" = src.server_id)
#ifdef SS13LIB_ATTEST_DOMAIN
		var/challenge = parameters["challenge"]
		if(challenge)
			var/domain = SS13LIB_ATTEST_DOMAIN
			if(domain)
				var/message = "[challenge]:[domain]"
				var/signature = SS13LIB_ED25519_SIGN(SS13LIB_ATTEST_PRIVKEY, message)
				response["domain"] = domain
				response["signature"] = signature
#endif
		return json_encode(response)

	if(parameters[SS13LIB_INFO_CODE])
		return json_encode(build_static_info())

	if(!parameters[SS13LIB_QUERY_CODE])
		return FALSE

	if(!src.ready)
		return json_encode(list("status" = "starting"))

#ifdef SS13LIB_HUB_VISIBILITY
	if(!SS13LIB_HUB_VISIBILITY)
		return json_encode(list("status" = "unlisted"))
#else
	if(!world.visibility)
		return json_encode(list("status" = "unlisted"))
#endif

	SS13LIB_INFO_LOG("Received topic query, preparing response.")

	var/response = list(
		"poll_key" = src.poll_key,

#ifndef SS13LIB_PLAYER_COUNT
#error SS13LIB_PLAYER_COUNT must be defined if using external SS13Lib configuration!
#endif
		"pop" = SS13LIB_PLAYER_COUNT,

		"round" = list(
#ifdef SS13LIB_ROUND_MAP_NAME
			"map_name" = SS13LIB_ROUND_MAP_NAME,
#endif

#ifdef SS13LIB_ROUND_STARTED_AT_UNIX
			"started_at_unix" = SS13LIB_ROUND_STARTED_AT_UNIX,
#endif

#ifdef SS13LIB_ROUND_STARTED_AT_BYOND
			"started_at_byond" = SS13LIB_ROUND_STARTED_AT_BYOND,
#endif

#ifdef SS13LIB_ROUND_ID
			"id"= SS13LIB_ROUND_ID,
#endif

#ifdef SS13LIB_ROUND_SECURITY_LEVEL
			"security_level" = SS13LIB_ROUND_SECURITY_LEVEL,
#endif

#ifdef SS13LIB_ROUND_GAMEMODE
			"gamemode" = SS13LIB_ROUND_GAMEMODE,
#endif

#ifdef SS13LIB_ROUND_STATE
			"state" = SS13LIB_ROUND_STATE,
#endif
		)
	)

	return json_encode(response)

/datum/ss13lib/proc/build_static_info()
	var/response = list()

#ifndef SS13LIB_SERVER_DISPLAY_NAME
#error SS13LIB_SERVER_DISPLAY_NAME must be defined if using external SS13Lib configuration!
#endif
	response["display_name"] = SS13LIB_SERVER_DISPLAY_NAME

#ifndef SS13LIB_SERVER_LANGUAGE
#error SS13LIB_SERVER_LANGUAGE must be defined if using external SS13Lib configuration!
#endif
	response["language"] = SS13LIB_SERVER_LANGUAGE

#ifdef SS13LIB_SERVER_DESCRIPTION
	response["description"] = SS13LIB_SERVER_DESCRIPTION
#endif

#ifdef SS13LIB_PLAYER_LIMIT
	response["pop_cap"] = SS13LIB_PLAYER_LIMIT
#endif

#ifdef SS13LIB_REGION
	response["region"] = SS13LIB_REGION
#endif

#ifdef SS13LIB_SERVER_TAGS
	response["server_tags"] = SS13LIB_SERVER_TAGS
#endif

	var/list/engine_info = list()
#ifdef SS13LIB_ENGINE_MIN_VERSION
	engine_info["min_version"] = SS13LIB_ENGINE_MIN_VERSION
#endif
#ifdef SS13LIB_ENGINE_MAX_VERSION
	engine_info["max_version"] = SS13LIB_ENGINE_MAX_VERSION
#endif
#ifdef SS13LIB_ENGINE_BLACKLISTED_VERSIONS
	engine_info["blacklisted_versions"] = SS13LIB_ENGINE_BLACKLISTED_VERSIONS
#endif
	if(length(engine_info))
		response["engine"] = engine_info

#ifdef SS13LIB_SERVER_LINKS
	response["links"] = SS13LIB_SERVER_LINKS
#endif

#ifdef SS13LIB_WHITELISTED
	response["whitelisted"] = SS13LIB_WHITELISTED
#endif

#ifdef SS13LIB_TERMS_OF_SERVICE
	response["terms_of_service"] = list("url" = SS13LIB_TERMS_OF_SERVICE)
#endif

#ifdef SS13LIB_CONNECTION_ADDRESS
	response["connection_address"] = SS13LIB_CONNECTION_ADDRESS
#endif

	return response

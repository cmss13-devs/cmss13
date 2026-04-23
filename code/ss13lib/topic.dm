/// Intercepts /world/Topic(), if the query contains our query code, return the structured
/// topic response. If not, allows /world/Topic() to continue and handle the response normally.
/// This does not require any authentication, and does not expose any non-public information
/datum/ss13lib/proc/handle_topic(topic_parameters)
	var/parameters = params2list(topic_parameters)

	if(parameters[SS13LIB_PREFLIGHT_CODE])
		if(!src.server_id)
			return FALSE
		return json_encode(list("server_id" = src.server_id))

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

#ifndef SS13LIB_SERVER_DISPLAY_NAME
#error SS13LIB_SERVER_DISPLAY_NAME must be defined if using external SS13Lib configuration!
#endif
		"display_name" = SS13LIB_SERVER_DISPLAY_NAME,

#ifndef SS13LIB_SERVER_LANGUAGE
#error SS13LIB_SERVER_LANGUAGE must be defined if using external SS13Lib configuration!
#endif
		"language" = SS13LIB_SERVER_LANGUAGE,

#ifdef SS13LIB_SERVER_DESCRIPTION
		"description" = SS13LIB_SERVER_DESCRIPTION,
#endif

#ifdef SS13LIB_PLAYER_LIMIT
		"pop_cap" = SS13LIB_PLAYER_LIMIT,
#endif

#ifdef SS13LIB_REGION
		"region" = SS13LIB_REGION,
#endif

#ifdef SS13LIB_SERVER_TAGS
		"server_tags" = SS13LIB_SERVER_TAGS,
#endif


		"engine" = list(
#ifdef SS13LIB_ENGINE_MIN_VERSION
			"min_version" = SS13LIB_ENGINE_MIN_VERSION,
#endif

#ifdef SS13LIB_ENGINE_MAX_VERSION
			"max_version" = SS13LIB_ENGINE_MAX_VERSION,
#endif

#ifdef SS13LIB_ENGINE_BLACKLISTED_VERSIONS
			"blacklisted_versions" = SS13LIB_ENGINE_BLACKLISTED_VERSIONS,
#endif
		),

#ifdef SS13LIB_SERVER_LINKS
		"links" = SS13LIB_SERVER_LINKS,
#endif

#ifdef SS13LIB_CONNECTION_ADDRESS
		"connection_address" = SS13LIB_CONNECTION_ADDRESS,
#endif

		"round" = list(
#ifdef SS13LIB_ROUND_MAP_NAME
			"map_name" = SS13LIB_ROUND_MAP_NAME,
#endif

#ifdef SS13LIB_ROUND_DURATION
			"duration" = SS13LIB_ROUND_DURATION,
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



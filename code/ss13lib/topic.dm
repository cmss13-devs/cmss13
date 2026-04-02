/// Intercepts /world/Topic(), if the query contains our query code, return the structured
/// topic response. If not, allows /world/Topic() to continue and handle the response normally.
/// This does not require any authentication, and does not expose any non-public information
/datum/ss13lib/proc/handle_topic(topic_parameters)
	var/parameters = params2list(topic_parameters)

	var/query = parameters[SS13LIB_QUERY_CODE]
	if(!query)
		return FALSE

	SS13LIB_INFO_LOG("Received topic query, preparing response.")

	var/response = list(
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

#ifdef SS13LIB_PLAYER_LIMIT
		"pop_cap" = SS13LIB_PLAYER_LIMIT,
#endif

#ifdef SS13LIB_NETWORK_IDENTIFIER
		"network_identifier" = SS13LIB_NETWORK_IDENTIFIER,
#endif

#ifdef SS13LIB_SERVER_TAGS
		"server_tags" = SS13LIB_SERVER_TAGS,
#endif

#ifdef SS13LIB_CLIENT_VERSION
		"client_version" = "[SS13LIB_CLIENT_VERSION].[SS13LIB_CLIENT_BUILD]",
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
		)
	)

	return json_encode(response)



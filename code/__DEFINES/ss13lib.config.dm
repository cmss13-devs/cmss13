#define SS13LIB_EXTERNAL_CONFIGURATION

#define SS13LIB_PLAYER_COUNT length(GLOB.clients) // length(GLOB.clients)
#define SS13LIB_SERVER_DISPLAY_NAME CONFIG_GET(string/servername) // CONFIG_GET(string/servername)
#define SS13LIB_SERVER_DESCRIPTION "The year is 2182. High Command has dispatched the USS Almayer to the frontier. You are a member of the Falling Falcons - 2nd Company, 2nd Battalion, 4th Brigade.\n\nYour orders are simple: Respond to an unknown distress signal, secure the colony, and neutralise any threats. But on the rim of known space, nothing is ever simple."
#define SS13LIB_SERVER_LINKS list(list("type" = "discord", "link" = CONFIG_GET(string/discordurl)), list("type" = "wiki", "link" = CONFIG_GET(string/wikiurl)), list("type" = "forum", "link" = CONFIG_GET(string/forumurl)), list("type" = "github", "link" = CONFIG_GET(string/githuburl)))
#define SS13LIB_NETWORK_IDENTIFIER "cm-ss13" // CONFIG_GET(string/network_identifier)
#define SS13LIB_SERVER_TAGS list("total conversion", "teams", "combat") // CONFIG_GET(str_list/server_tags)
#define SS13LIB_SERVER_LANGUAGE "en" // en

#define SS13LIB_ROUND_MAP_NAME SSmapping.configs[GROUND_MAP].map_name // SSmapping.current_map.map_name
#define SS13LIB_ROUND_DURATION ROUND_TIME // STATION_TIME_PASSED
#define SS13LIB_ROUND_SECURITY_LEVEL get_security_level() // SSsecurity_level.current_security_level.name
#define SS13LIB_ROUND_GAMEMODE GLOB.master_mode // GLOB.master_mode
#define SS13LIB_ROUND_ID GLOB.round_id // GLOB.round_id

#define SS13LIB_INFO_LOG(X) log_debug("\[SS13LIB INFO\] [X]")
#define SS13LIB_WARNING_LOG(X) log_debug("\[SS13LIB WARNING\] [X]")
#define SS13LIB_ERROR_LOG(X) log_debug("\[SS13LIB ERROR\] [X]")

/client/var/datum/ss13lib_auth_response/hub_info
#define SS13LIB_CLIENT_INFO(X) X.hub_info

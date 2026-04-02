#define SS13LIB_EXTERNAL_CONFIGURATION

#define SS13LIB_EXTERNAL_INIT
#define SS13LIB_EXTERNAL_HEARTBEAT

#define SS13LIB_PLAYER_COUNT length(GLOB.clients) // length(GLOB.clients)
#define SS13LIB_SERVER_DISPLAY_NAME CONFIG_GET(string/servername) // CONFIG_GET(string/servername)
#define SS13LIB_NETWORK_IDENTIFIER "cm-ss13" // CONFIG_GET(string/network_identifier)
#define SS13LIB_SERVER_TAGS list("Total Conversion") // CONFIG_GET(str_list/server_tags)
#define SS13LIB_SERVER_LANGUAGE "en" // en

#define SS13LIB_ROUND_MAP_NAME SSmapping.configs[GROUND_MAP].map_name // SSmapping.current_map.map_name
#define SS13LIB_ROUND_DURATION ROUND_TIME // STATION_TIME_PASSED
#define SS13LIB_ROUND_SECURITY_LEVEL GLOB.security_level // SSsecurity_level.current_security_level.name
#define SS13LIB_ROUND_GAMEMODE GLOB.master_mode // GLOB.master_mode
#define SS13LIB_ROUND_ID GLOB.round_id // GLOB.round_id

#define SS13LIB_INFO_LOG(X) log_debug("\[SS13LIB INFO\] [X]")
#define SS13LIB_WARNING_LOG(X) log_debug("\[SS13LIB WARNING\] [X]")
#define SS13LIB_ERROR_LOG(X) log_debug("\[SS13LIB ERROR\] [X]")

#define SS13LIB_GUESTS_BANNED CONFIG_GET(flag/guest_ban)

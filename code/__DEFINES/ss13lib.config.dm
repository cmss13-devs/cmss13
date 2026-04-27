#define SS13LIB_EXTERNAL_CONFIGURATION

#define SS13LIB_EXTERNAL_INIT
#define SS13LIB_EXTERNAL_HEARTBEAT

#define SS13LIB_PLAYER_COUNT length(GLOB.clients)
#define SS13LIB_SERVER_DISPLAY_NAME CONFIG_GET(string/servername)
#define SS13LIB_SERVER_DESCRIPTION "The year is 2182. High Command has dispatched the USS Almayer to the frontier. You are a member of the Falling Falcons - 2nd Company, 2nd Battalion, 4th Brigade.\n\nYour orders are simple: Respond to an unknown distress signal, secure the colony, and neutralise any threats. But on the rim of known space, nothing is ever simple."
#define SS13LIB_SERVER_LINKS list(list("type" = "discord", "link" = CONFIG_GET(string/discordurl)), list("type" = "wiki", "link" = CONFIG_GET(string/wikiurl)), list("type" = "forum", "link" = CONFIG_GET(string/forumurl)), list("type" = "github", "link" = CONFIG_GET(string/githuburl)))
#define SS13LIB_SERVER_TAGS list("total conversion", "teams", "combat")
#define SS13LIB_SERVER_LANGUAGE "en"
#define SS13LIB_PLAYER_LIMIT CONFIG_GET(number/hard_popcap)
#define SS13LIB_REGION CONFIG_GET(string/ss13lib_region)
#define SS13LIB_CONNECTION_ADDRESS CONFIG_GET(string/ss13lib_connection_address)
#define SS13LIB_ENGINE_MIN_VERSION CONFIG_GET(string/ss13lib_engine_min_version)
#define SS13LIB_ENGINE_MAX_VERSION CONFIG_GET(string/ss13lib_engine_max_version)
#define SS13LIB_ENGINE_BLACKLISTED_VERSIONS CONFIG_GET(str_list/ss13lib_engine_blacklisted_versions)

#define SS13LIB_ROUND_MAP_NAME SSmapping.configs[GROUND_MAP].map_name

GLOBAL_VAR(round_started_at)
#define SS13LIB_ROUND_STARTED_AT_UNIX GLOB.round_started_at

#define SS13LIB_ROUND_SECURITY_LEVEL get_security_level()
#define SS13LIB_ROUND_GAMEMODE GLOB.master_mode
#define SS13LIB_ROUND_ID GLOB.round_id
#define SS13LIB_ROUND_STATE ss13lib_round_state()

#define SS13LIB_ATTEST_DOMAIN CONFIG_GET(string/verified_domain)
#define SS13LIB_ATTEST_PRIVKEY CONFIG_GET(string/verified_domain_privkey)

#define SS13LIB_ED25519_SIGN(privkey, message) rustg_ed25519_sign(privkey, message)
#define SS13LIB_UNIX_EPOCH rustg_unix_timestamp()

#define SS13LIB_INFO_LOG(X) log_debug("\[SS13LIB INFO\] [X]")
#define SS13LIB_WARNING_LOG(X) log_debug("\[SS13LIB WARNING\] [X]")
#define SS13LIB_ERROR_LOG(X) log_debug("\[SS13LIB ERROR\] [X]")

/client/var/datum/ss13lib_auth_response/hub_info
#define SS13LIB_CLIENT_INFO(X) X.hub_info

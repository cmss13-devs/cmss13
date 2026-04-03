//! SS13Lib

#define SS13LIB_VERSION "0.0.1"

#define SS13LIB world.get_or_init_ss13lib()

/// Consumers must add this to **the top** of /client/New, before any setup is performed on a client.
#define SS13LIB_CLIENT var/ss13lib_client_return = (SS13LIB).handle_client(src, args[1]); if (ss13lib_client_return) return ss13lib_client_return

/// Consumers must call this as early as possible in /world/Topic
#define SS13LIB_TOPIC var/ss13lib_topic_return = (SS13LIB).handle_topic(args[1]); if(ss13lib_topic_return) return ss13lib_topic_return

/// Consumers must call this at the start of /client/IsBanned()
#define SS13LIB_ISBANNED var/ss13lib_ban_return = (SS13LIB).handle_banned(args[1], args[2], args[3]); if(!isnull(ss13lib_ban_return)) return ss13lib_ban_return

//! CONFIGURATION

// It is recommended to copy these defines and configure them externally
// to allow for easy updates to the SS13Lib, without manually editing this file

/// Consumers SHOULD create this define if you want to do SS13Lib configuration outside of this file.
#ifndef SS13LIB_EXTERNAL_CONFIGURATION

// #error SS13Lib unconfigured, either uncomment this error if you are including configuration directly in ss13lib.dm
// #error or #define SS13LIB_EXTERNAL_CONFIGURATION where you have configured SS13Lib

//! HUB CONFIGURATION

/// The total number of players currently connected to this server
/// Mandatory field
#define SS13LIB_PLAYER_COUNT // length(GLOB.clients)

/// The display name of this server on the SS13Hub. Not exceeding 128
/// characters, otherwise it may be truncated
/// Mandatory field
#define SS13LIB_SERVER_DISPLAY_NAME // CONFIG_GET(string/servername)

/// What language this server should be advertised as being for. This is an ISO 639-1 code, eg:
/// "en", "ru", "es"
/// Mandatory field
#define SS13LIB_SERVER_LANGUAGE // en

/// A secondary field that will be visible to users
/// Up to 1024 characters, no HTML encoding.
/// Optional field
#define SS13LIB_SERVER_DESCRIPTION // "A very fun server."

/// Links that will be visible/clickable to users on the launcher
/// Up to 10, with discord/wiki/web/github/forum as "type" options
/// Optional field
#define SS13LIB_SERVER_LINKS // list(list("type" = "web", "link" = "https://myserver.com"))

/// If this server has a maximum number of connected players
/// Optional field
#define SS13LIB_PLAYER_LIMIT // CONFIG_GET(number/popcap)

/// If this server belongs to a known network of servers, this can be provided here.
/// This only provides a small logo next to the listing on the launcher page
/// Optional field
#define SS13LIB_NETWORK_IDENTIFIER // CONFIG_GET(string/network_identifier)

/// What tags this server should have on the SS13Hub. This is from a predefined list of available tags,
/// available at: <source code link to backend parsing for tags>
/// Optional field
#define SS13LIB_SERVER_TAGS // CONFIG_GET(str_list/server_tags)

/// If users are to connect to a different IP than the one the hub is communicating to
/// Optional field
#define SS13LIB_CONNECTION_ADDRESS // direct.myserver.com:1337

/// What BYOND client version players should use to connect.
/// Optional field - if not defined, the launcher will use its default
#define SS13LIB_CLIENT_VERSION // world.byond_version

/// What BYOND client build players should use to connect.
/// Optional field - paired with SS13LIB_CLIENT_VERSION
#define SS13LIB_CLIENT_BUILD // world.byond_build

//! All fields prefixed with _ROUND_ are optional, many of these are not applicable to some kinds of SS13 servers

/// What map is currently being played on
#define SS13LIB_ROUND_MAP_NAME // SSmapping.current_map.map_name

/// How long the current round has been going on for, in deciseconds
#define SS13LIB_ROUND_DURATION // STATION_TIME_PASSED

/// What the current security level of the round is
#define SS13LIB_ROUND_SECURITY_LEVEL // SSsecurity_level.current_security_level.name

/// What the current gamemode is that the round is playing on
#define SS13LIB_ROUND_GAMEMODE // GLOB.master_mode

/// What the ID of the current round is
#define SS13LIB_ROUND_ID // GLOB.round_id

//! LIBRARY CONFIGURATION

#define SS13LIB_INFO_LOG(X) // log_debug(X)
#define SS13LIB_WARNING_LOG(X) // log_debug(X)
#define SS13LIB_ERROR_LOG(X) // log_debug(X)

/// If the codebase would like to handle initializing SS13Lib themselves
/// instead of it being started automatically
#define SS13LIB_EXTERNAL_INIT

/// If the codebase would like to handle the regular heartbeat to the hub
/// isntead of it being looped internally. This must fire at least every minute
/// as servers are only considered active if they have had a successful heartbeat
/// within the last two minutes. It is recommended to fire every 30 seconds.
#define SS13LIB_EXTERNAL_HEARTBEAT

/// If this is defined, after authenticating, SS13Lib will save this field to the client
/// which can be used for identification of the upstream username, hwid or account age.
/// This shoulds be typed as /datum/ss13lib_auth_response
#define SS13LIB_CLIENT_INFO(X) // X.hub_info

#endif

/datum/ss13lib_auth_response
	/// The BYOND ckey if the user has a linked BYOND account, null otherwise.
	var/ckey
	/// The BYOND display key if the user has a linked BYOND account, null otherwise.
	var/key
	/// The SS13Hub username, always present.
	var/username
	/// Account creation timestamp (ISO 8601).
	var/created_at
	/// Anonymized hardware ID for this client, null if not provided.
	var/hwid

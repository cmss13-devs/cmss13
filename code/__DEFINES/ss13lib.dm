//! SS13Lib

#define SS13LIB_VERSION "0.0.1"

#define SS13LIB world.get_or_init_ss13lib()

/// Consumers must add this to **the top** of /client/New, before any setup is performed on a client.
#define SS13LIB_CLIENT var/ss13lib_client_return = (SS13LIB).handle_client(src, args[1]); if (ss13lib_client_return) return ss13lib_client_return

/// Consumers must call this as early as possible in /world/Topic
#define SS13LIB_TOPIC var/ss13lib_topic_return = (SS13LIB).handle_topic(args[1]); if(ss13lib_topic_return) return ss13lib_topic_return

/// Consumers must call this at the start of /client/IsBanned()
#define SS13LIB_ISBANNED var/ss13lib_ban_return = (SS13LIB).handle_banned(args[1], args[2], args[3]); if(!isnull(ss13lib_ban_return)) return ss13lib_ban_return

/// Consumers must call this as early as possible in /world/Reboot
#define SS13LIB_REBOOT (SS13LIB).handle_reboot()

//! CONFIGURATION

// It is recommended to copy these defines and configure them externally
// to allow for easy updates to the SS13Lib, without manually editing this file

/// Consumers SHOULD create this define if you want to do SS13Lib configuration outside of this file.
#ifndef SS13LIB_EXTERNAL_CONFIGURATION

// #error SS13Lib unconfigured, either uncomment this error if you are including configuration directly in ss13lib.dm
// #error or #define SS13LIB_EXTERNAL_CONFIGURATION where you have configured SS13Lib

/// Define this to opt out of all SS13Hub features. The server will always be
/// invisible on the hub and will only use BYOND pager authentication.
/// This overrides SS13LIB_HUB_VISIBILITY and SS13LIB_AUTH_METHODS.
// #define SS13LIB_BYOND_ONLY

#ifdef SS13LIB_BYOND_ONLY
#define SS13LIB_HUB_VISIBILITY FALSE
#define SS13LIB_AUTH_METHODS list("byond")
#define SS13LIB_PLAYER_COUNT 0
#define SS13LIB_SERVER_DISPLAY_NAME ""
#define SS13LIB_SERVER_LANGUAGE "en"
#endif

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

/// The geographic region where this server is hosted.
/// Values: "africa_central", "africa_north", "africa_south", "antarctica",
///   "asia_east", "asia_north", "asia_southeast", "central_america",
///   "europe_east", "europe_west", "greenland", "india", "middle_east",
///   "north_america_central", "north_america_east", "north_america_west",
///   "oceania", "south_america_east", "south_america_south", "south_america_west"
/// Optional field
#define SS13LIB_REGION // "north_america_east"

/// What tags this server should have on the SS13Hub. This is from a predefined list of available tags,
/// available at: <source code link to backend parsing for tags>
/// Optional field
#define SS13LIB_SERVER_TAGS // CONFIG_GET(str_list/server_tags)

/// Controls whether SS13Lib responds to hub topic queries with server information.
/// If defined and truthy, the server will be visible on the hub. If falsy, topic
/// queries are silently ignored. If not defined, falls back to world.visibility.
/// Optional field
#define SS13LIB_HUB_VISIBILITY // world.visibility

/// The authentication methods this server supports. Sent during handshake.
/// Valid values: "hub" (SS13Hub authentication), "byond" (BYOND pager authentication)
/// Defaults to list("hub", "byond") if not defined.
/// Optional field
#define SS13LIB_AUTH_METHODS // list("hub", "byond")

/// If users are to connect to a different IP than the one the hub is communicating to
/// Optional field
#define SS13LIB_CONNECTION_ADDRESS // direct.myserver.com:1337

//! Engine fields, relevant to the version of the engine that users must use to join
//! All engine fields are optional.

/// The minimum BYOND version.build that clients must have to connect.
/// Format: "version.build", eg: "516.1664"
#define SS13LIB_ENGINE_MIN_VERSION // "516.1664"

/// The maximum BYOND version.build that clients are allowed to connect with.
/// Format: "version.build", eg: "516.1700"
#define SS13LIB_ENGINE_MAX_VERSION // "516.1700"

/// A list of specific BYOND version.build strings that are blocked from connecting.
/// Format: list of "version.build" strings
#define SS13LIB_ENGINE_BLACKLISTED_VERSIONS // list("516.1670", "516.1671")

//! All fields prefixed with _ROUND_ are optional, many of these are not applicable to some kinds of SS13 servers

/// What map is currently being played on
#define SS13LIB_ROUND_MAP_NAME // SSmapping.current_map.map_name

/// Unix timestamp (seconds) of when the current round started.
/// Use this if your codebase has access to a unix timestamp (e.g. via rustg).
/// Preferred over SS13LIB_ROUND_STARTED_AT_BYOND when available.
#define SS13LIB_ROUND_STARTED_AT_UNIX // rustg_unix_timestamp() at round start

/// BYOND world.realtime value captured at round start (deciseconds since 2000-01-01 00:00:00 UTC).
/// Use this if your codebase does not have access to a unix timestamp.
#define SS13LIB_ROUND_STARTED_AT_BYOND // world.realtime at round start

/// What the current security level of the round is
#define SS13LIB_ROUND_SECURITY_LEVEL // SSsecurity_level.current_security_level.name

/// What the current gamemode is that the round is playing on
#define SS13LIB_ROUND_GAMEMODE // GLOB.master_mode

/// What the ID of the current round is
#define SS13LIB_ROUND_ID // GLOB.round_id

/// The current state of the round
/// Values: "initializing", "lobby", "playing", "finished"
#define SS13LIB_ROUND_STATE // "playing"

//! LIBRARY CONFIGURATION

#define SS13LIB_INFO_LOG(X) // log_debug(X)
#define SS13LIB_WARNING_LOG(X) // log_debug(X)
#define SS13LIB_ERROR_LOG(X) // log_debug(X)

/// If the codebase would like to handle initializing SS13Lib themselves
/// instead of it being started automatically
#define SS13LIB_EXTERNAL_INIT

/// If the codebase would like to handle the regular heartbeat to the hub
/// instead of it being looped internally. This must fire at least every minute
/// as servers are only considered active if they have had a successful heartbeat
/// within the last two minutes. It is recommended to fire every 30 seconds.
#define SS13LIB_EXTERNAL_HEARTBEAT

/// If this is defined, SS13Lib will call this to notify in-game administrators
/// of important messages, such as content policy violations.
/// The argument is a string message.
#define SS13LIB_MESSAGE_ADMINS(X) // message_admins(X)

/// If this is defined, after authenticating, SS13Lib will save this field to the client
/// which can be used for identification of the upstream username, hwid or account age.
/// This should be typed as /datum/ss13lib_auth_response
#define SS13LIB_CLIENT_INFO(X) // X.hub_info

//! DOMAIN ATTESTATION
//! Optional. Proves domain ownership to the hub via DNS TXT record + ed25519 signature.

/// The domain to attest ownership of. Must have a _ss13hub TXT record with the matching ed25519 pubkey.
/// Maximum 32 characters.
/// Optional field — if not defined, attestation is skipped.
#define SS13LIB_ATTEST_DOMAIN // CONFIG_GET(string/verified_domain)

/// Ed25519 signing implementation. Takes a base64 private key and a message string,
/// returns a base64-encoded signature. The consumer must provide this — typically via rustg.
/// Required if SS13LIB_ATTEST_DOMAIN is defined.
#define SS13LIB_ED25519_SIGN(privkey, message) // rustg_ed25519_sign(privkey, message)

/// Base64-encoded ed25519 private key (32-byte seed). The corresponding public key
/// must appear in the _ss13hub DNS TXT record as: ss13hub-ed25519=<base64-pubkey>
/// Required if SS13LIB_ATTEST_DOMAIN is defined.
#define SS13LIB_ATTEST_PRIVKEY // CONFIG_GET(string/verified_private_key) = "base64-encoded-32-byte-seed"

/// Returns the current Unix timestamp (seconds since 1970-01-01). The consumer must
/// provide this — typically via rustg
/// Required if SS13LIB_ATTEST_DOMAIN is defined.
#define SS13LIB_UNIX_EPOCH // rustg_unix_timestamp()

#endif

/datum/ss13lib_auth_response
	/// The BYOND key if the user has a linked BYOND account, null otherwise.
	var/key
	/// The SS13Hub username, always present.
	var/username
	/// Account creation timestamp (ISO 8601).
	var/created_at
	/// Anonymized hardware ID for this client, null if not provided.
	var/hwid
	/// The user's Discord ID if they have a linked Discord account, null otherwise.
	var/discord_id
	/// The user's Steam ID if they have a linked Steam account, null otherwise.
	var/steam_id

#ifndef SS13LIB_HUB_SERVER
#define SS13LIB_HUB_SERVER "https://api.spacestation13.com/server"
#endif

#ifndef SS13LIB_CKEY_SUFFIX
#define SS13LIB_CKEY_SUFFIX "@hub"
#endif

/// Runs a statement that calls into a codebase-supplied macro, wrapped in try/catch
#define SS13LIB_SAFELY(NAME, STATEMENT) try { STATEMENT } catch(codebase_error) { log_codebase_error(NAME, codebase_error) }

#ifndef SS13LIB_SERVER_PORT
#define SS13LIB_SERVER_PORT world.port
#endif

#ifdef RUST_G
#define SS13LIB_HTTP_GET RUSTG_HTTP_METHOD_GET
#define SS13LIB_HTTP_POST RUSTG_HTTP_METHOD_POST
#else
#define SS13LIB_HTTP_GET "GET"
#define SS13LIB_HTTP_POST "POST"
#endif

#ifndef SS13LIB_INFO_LOG
#define SS13LIB_INFO_LOG(x)
#endif

#ifndef SS13LIB_WARNING_LOG
#define SS13LIB_WARNING_LOG(x)
#endif

#ifndef SS13LIB_ERROR_LOG
#define SS13LIB_ERROR_LOG(x)
#endif

#ifndef SS13LIB_QUERY_CODE
#define SS13LIB_QUERY_CODE "ss13hub"
#endif

#ifndef SS13LIB_AUTH_TICKET_CODE
#define SS13LIB_AUTH_TICKET_CODE "auth_ticket"
#endif

#define SS13LIB_PREFLIGHT_CODE "ss13hub_preflight"

#define SS13LIB_INFO_CODE "ss13hub_info"

#define SS13LIB_RELAY_ANNOUNCE_CODE "ss13lib_relay"

/// Process environment variable holding the relay's address across world reboots.
#define SS13LIB_RELAY_ADDRESS_ENV "SS13LIB_RELAY_ADDRESS"

/// How long relay details stay in our status response after the relay's last announce
/// (deciseconds). The relay announces every 60 seconds.
#define SS13LIB_RELAY_INFO_TTL 1800

/// How long a relayed client without a valid ticket may wait in the holder mob for the launcher
/// to supply one before being disconnected (deciseconds).
#define SS13LIB_RELAY_HOLDER_TIMEOUT 600

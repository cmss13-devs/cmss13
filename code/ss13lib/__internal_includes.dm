#ifndef SS13LIB_HUB_SERVER
#define SS13LIB_HUB_SERVER "https://hub.spacestation13.com/api/server"
#endif

#ifndef SS13LIB_CKEY_SUFFIX
#define SS13LIB_CKEY_SUFFIX "_hub"
#endif

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

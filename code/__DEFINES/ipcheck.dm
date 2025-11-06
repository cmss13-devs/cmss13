#define IPCHECK_RATE_LIMIT_DAY "day"

/// An internal error occurred and the query cannot be processed
#define IPCHECK_UNKNOWN_INTERNAL_ERROR "unknown_internal_error"

/// Cannot query as we are rate limited for the rest of the day
#define IPCHECK_RATE_LIMITED_DAY "rate_limited_day"

/// The IP address is a VPN or bad IP
#define IPCHECK_BAD_IP "bad_ip"
/// The IP address is not a VPN or bad IP
#define IPCHECK_GOOD_IP "good_ip"

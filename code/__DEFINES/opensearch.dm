
// Modes for the query builder

/// Send the query as raw DSL without changes - for debugging only
#define OPENSEARCH_QUERY_MODE_DSL_RAW 0
/// Use a DSL query as input, but add-in parameters from the query builder (such as time range)
/// This needs a compatible query that is structured around an outer 'bool' clause to work
#define OPENSEARCH_QUERY_MODE_DSL 1
/// Send the query as a Lucene query_string together with query builder params
#define OPENSEARCH_QUERY_MODE_LUCENE 2

// This could also support PPL and SQL querying. DQL is only available in Opensearch-Dashboards.
// Ultimately, the query builder should have custom modes that create more complex queries for the user.


// Modes for the time selector in query builder

/// Relative mode, for input compared to present time
#define OPENSEARCH_QUERY_TIME_MODE_RELATIVE 0
/// Absolute mode, to specify exact points in time
#define OPENSEARCH_QUERY_TIME_MODE_ABSOLUTE 1


// States of query

/// Query is ready to be built
#define OPENSEARCH_QUERY_STATUS_READY 1
/// Query was unable to be built
#define OPENSEARCH_QUERY_STATUS_BUILD_ERROR 2
/// Query is executing
#define OPENSEARCH_QUERY_STATUS_EXECUTING 3
/// Query failed to execute
#define OPENSEARCH_QUERY_STATUS_FAILED 4
/// Query executed successfully
#define OPENSEARCH_QUERY_STATUS_SUCCESS 5

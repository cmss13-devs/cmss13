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

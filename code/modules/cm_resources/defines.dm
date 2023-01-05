// 5 minutes for each growth level on main resources
#define RESOURCE_GROWTH_NORMAL 3000
// 10 seconds for each growth level on rapidly growing resources such as xeno hive & marine LZ crystals
#define RESOURCE_GROWTH_RAPID 100

// Growth time can vary up to +/- RESOURCE_GROWTH_VARY
#define RESOURCE_GROWTH_VARY 50

// The total amount of resources in each node group is constant, but each node's resource count may vary up to +/- RESOURCE_MAX_VARIANCE
#define RESOURCE_MAX_VARIANCE 10
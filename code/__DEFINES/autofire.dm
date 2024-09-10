// Controls how many buckets should be kept, each representing a tick. Max is ten seconds, to have better perf.
#define AUTOFIRE_BUCKET_LEN (world.fps * 10)
/// Helper for getting the correct bucket
#define AUTOFIRE_BUCKET_POS(next_fire) (((floor((next_fire - SSautomatedfire.head_offset) / world.tick_lag) + 1) % AUTOFIRE_BUCKET_LEN) || AUTOFIRE_BUCKET_LEN)

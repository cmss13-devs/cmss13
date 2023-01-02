#define get_client_stat(client, stat) (client.player_data ? LAZYACCESS(client.player_data.stats, stat) ? client.player_data.stats[stat].stat_number : 0 : 0)

// Stat IDs
#define PLAYER_STAT_FACEHUGS "facehugs"

#define FACEHUG_TIER_1 5
#define FACEHUG_TIER_2 25
#define FACEHUG_TIER_3 100
#define FACEHUG_TIER_4 1000

// Stat Categories
#define STAT_CATEGORY_MARINE "marine"
#define STAT_CATEGORY_XENO "xeno"
#define STAT_CATEGORY_YAUTJA "yautja"

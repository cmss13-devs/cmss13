//We use the cost to determine the spawn chance this equals out the crates that spawn later in the round.
#define ASRS_HIGHEST_WEIGHT 0 //warning this weight wont change.
#define ASRS_VERY_HIGH_WEIGHT 5
#define ASRS_HIGH_WEIGHT 15
#define ASRS_MEDIUM_WEIGHT 25
#define ASRS_LOW_WEIGHT 35
#define ASRS_VERY_LOW_WEIGHT 50
#define ASRS_LOWEST_WEIGHT 100

// List of pools of supply packs, rolled individually by the ASRS system
/// Main pool of ASRS supplies, dispensing military supplies such as ammo
#define ASRS_POOL_MAIN "Main"
/// Secondary ASRS pool dispening food related items for MessTech
#define ASRS_POOL_FOOD "Food"

/// Divider to the amount of xeno forces on the planet to ASRS provided crates. It is used as such sqrt(xenos/ASRS_XENO_CRATES_DIVIDER))
#define ASRS_XENO_CRATES_DIVIDER 4

// Defines for wall states
#define WALL_STATE_WELD			0
#define WALL_STATE_SCREW		1
#define WALL_STATE_WIRECUTTER	2
#define WALL_STATE_WRENCH		3
#define WALL_STATE_CROWBAR		4

// Defines for barricade upgrades
#define BARRICADE_UPGRADE_BURN 		"biohazard upgrade(++burn, -brute)"
#define BARRICADE_UPGRADE_BRUTE 	"reinforced upgrade(++brute, -burn)"
#define BARRICADE_UPGRADE_EXPLOSIVE "explosive upgrade(++explosive)"

// Defines for defense stats
#define DEFENSE_FUNCTIONAL 		0
#define DEFENSE_DAMAGED			1
#define DEFENSE_DESTROYED	 	2

// Defines for modules inserted into a defensible base
#define DEFENSE_SENTRY_BASE			1
#define DEFENSE_SENTRY_FLAMER		2
#define DEFENSE_PLANTED_FLAG		3
#define DEFENSE_BELL_TOWER			4
#define DEFENSE_TESLA_COIL			5

// What range the generator has to be in or defenses has to be in.
#define GEN_SEARCH_RANGE 5
#define GEN_PLASTEEL_COST 10

// Dismantle/Build cost
#define MODULE_METAL_COST 			15
#define DEFENSE_METAL_COST 			10

// The maximum amount of phoron marines can store up in their pool
#define MAX_PHORON_STORAGE 1000
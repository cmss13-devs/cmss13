#define MELEE_FORCE_TIER_1 5
#define MELEE_FORCE_TIER_2 10
#define MELEE_FORCE_TIER_3 15
#define MELEE_FORCE_TIER_4 20
#define MELEE_FORCE_TIER_5 25
#define MELEE_FORCE_TIER_6 30
#define MELEE_FORCE_TIER_7 35
#define MELEE_FORCE_TIER_8 40
#define MELEE_FORCE_TIER_9 45
#define MELEE_FORCE_TIER_10 50
#define MELEE_FORCE_TIER_11 55

#define MELEE_FORCE_WEAK MELEE_FORCE_TIER_2
#define MELEE_FORCE_NORMAL MELEE_FORCE_TIER_5
#define MELEE_FORCE_STRONG MELEE_FORCE_TIER_7
#define MELEE_FORCE_VERY_STRONG MELEE_FORCE_TIER_9

//the define for visible message range in combat
#define COMBAT_MESSAGE_RANGE 3
#define DEFAULT_MESSAGE_RANGE 7

#define BAYONET_DRAW_DELAY (1 SECONDS)
#define POINTBLANK_COOLDOWN_TIME (2 SECONDS)

//Predator decloak multpliers based on the standard.
#define DECLOAK_STANDARD (10 SECONDS)
/// Forced for any unspecified reason.
#define DECLOAK_FORCED 1
/// Caused by being worn by non humans.
#define DECLOAK_SPECIES 0.75
/// Caused by fire extinguisher.
#define DECLOAK_EXTINGUISHER 1.5
/// Caused by predalien screech.
#define DECLOAK_PREDALIEN 2
/// Caused by being in a body of water.
#define DECLOAK_SUBMERGED 2
/// Caused by an EMP.
#define DECLOAK_EMP 3

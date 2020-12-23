#define BLOCKED_MOVEMENT (NORTH|SOUTH|EAST|WEST)
#define NO_BLOCKED_MOVEMENT 0

#define LOW_LAUNCH      0
#define NORMAL_LAUNCH   1
#define HIGH_LAUNCH     2

// Speed = [1/(MOVE_DELAY + 0.5)]*10
#define SPEED_INSTANT       20
#define SPEED_REALLY_FAST   15
#define SPEED_VERY_FAST     10
#define SPEED_FAST          6.67
#define SPEED_AVERAGE       5
#define SPEED_SLOW          4
#define SPEED_VERY_SLOW     3.33
#define MAX_SPEED           20
#define MIN_SPEED           1

#define MINIMAL_MOVEMENT_INTERVAL 0.1 SECONDS

// PASS FLAGS
// Flags have been slightly revamped to reflect ways things pass rather than having arbitrarily named vars

// Specific pass flags
// Note:	these are pretty abstract, when trying to apply one of these flags to an atom's flags_pass/flags_can_pass vars,
//			consider what you intend to allow a given atom to pass/let through and how the "pass-bys" might happen logically

#define PASS_THROUGH				(1<<0)		// For atoms that are porous or have holes that an atom cannot normally pass through
#define PASS_AROUND					(1<<1)		// For atoms that do not necessarily "fill" the turf that they're on and give some space to go around
#define PASS_OVER_THROW_ITEM		(1<<2)		// For atoms that allow thrown items to go over them
#define PASS_OVER_THROW_MOB			(1<<3)		// For atoms that allow thrown mobs to go over them
#define PASS_OVER_FIRE				(1<<4)		// For atoms that allow fire to go over them
#define PASS_OVER_ACID_SPRAY		(1<<5)		// For atoms that allow xeno acid spray to go over them
#define PASS_UNDER					(1<<6)		// For atoms that have some space underneath for things to pass through
#define PASS_GLASS					(1<<7)		// For atoms that are made of glass or have hollow sections filled with glass
#define PASS_MOB_IS_XENO			(1<<8)		// For if a xeno can pass through something
#define PASS_MOB_IS_HUMAN			(1<<9)		// For if a human can pass through something
#define PASS_MOB_IS_OTHER			(1<<10)		// For if every other mob can pass through something
#define PASS_MOB_THRU_XENO			(1<<11)		// For if something can pass through a xeno
#define PASS_MOB_THRU_HUMAN			(1<<12)		// For if something can pass through a human
#define PASS_MOB_THRU_OTHER			(1<<13)		// For if something can pass through every other mob
#define PASS_TYPE_CRAWLER			(1<<14)		// For mobs that crawl/climb over stuff (runners/larva), more for "whitelisting" crawlers to pass
#define PASS_HIGH_OVER_ONLY			(1<<15)		// For atoms that require a high toss to go over it, should only really be using this for flags_can_pass_x vars
#define PASS_BUILDING_ONLY			(1<<16)		// For throwing stuff over walls (that lead to open ceilings)
#define PASS_CRUSHER_CHARGE			(1<<17)		// For crusher charge specifically

// Pass flag groups
#define PASS_OVER		(PASS_OVER_THROW_ITEM|PASS_OVER_THROW_MOB|PASS_OVER_FIRE|PASS_OVER_ACID_SPRAY)
#define PASS_HIGH_OVER	(PASS_HIGH_OVER_ONLY|PASS_OVER)
#define PASS_BUILDING	(PASS_HIGH_OVER|PASS_BUILDING_ONLY)
#define PASS_MOB_IS		(PASS_MOB_IS_XENO|PASS_MOB_IS_HUMAN|PASS_MOB_IS_OTHER)
#define PASS_MOB_THRU	(PASS_MOB_THRU_XENO|PASS_MOB_THRU_HUMAN|PASS_MOB_THRU_OTHER)
#define PASS_ALL		(PASS_THROUGH|PASS_AROUND|PASS_OVER|PASS_UNDER|PASS_GLASS|PASS_MOB_IS|PASS_MOB_THRU|PASS_HIGH_OVER_ONLY|PASS_BUILDING_ONLY|PASS_TYPE_CRAWLER|PASS_CRUSHER_CHARGE)

// Short-hand pass flags for very specific things
#define PASS_FLAGS_WEEDS        (PASS_UNDER|PASS_MOB_THRU|PASS_OVER_ACID_SPRAY)
#define PASS_FLAGS_ACID_SPRAY	(PASS_UNDER|PASS_MOB_THRU|PASS_OVER_ACID_SPRAY)
#define PASS_FLAGS_FLAME		(PASS_AROUND|PASS_UNDER|PASS_MOB_THRU|PASS_THROUGH|PASS_OVER_FIRE)
#define PASS_FLAGS_SMOKE		(PASS_HIGH_OVER|PASS_AROUND|PASS_UNDER|PASS_MOB_THRU|PASS_THROUGH)
#define PASS_FLAGS_CRAWLER		(PASS_TYPE_CRAWLER|PASS_UNDER)

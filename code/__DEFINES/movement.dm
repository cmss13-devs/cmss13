#define BLOCKED_MOVEMENT (NORTH|SOUTH|EAST|WEST)
#define NO_BLOCKED_MOVEMENT 0

#define LOW_LAUNCH   0
#define NORMAL_LAUNCH   1
#define HIGH_LAUNCH  2

// Speed = [1/(MOVE_DELAY + 0.5)]*10
#define SPEED_INSTANT    20
#define SPEED_REALLY_FAST   15
#define SPEED_VERY_FAST  10
#define SPEED_FAST   6.67
#define SPEED_AVERAGE    5
#define SPEED_SLOW   4
#define SPEED_VERY_SLOW  3.33
#define MAX_SPEED    20
#define MIN_SPEED    1

#define MINIMAL_MOVEMENT_INTERVAL 0.1 SECONDS

// PASS FLAGS
// Flags have been slightly revamped to reflect ways things pass rather than having arbitrarily named vars

// Specific pass flags
// Note: these are pretty abstract, when trying to apply one of these flags to an atom's flags_pass/flags_can_pass vars,
// consider what you intend to allow a given atom to pass/let through and how the "pass-bys" might happen logically

#define PASS_THROUGH (1<<0) // For atoms that are porous or have holes that an atom cannot normally pass through
#define PASS_AROUND (1<<1) // For atoms that do not necessarily "fill" the turf that they're on and give some space to go around
#define PASS_OVER_THROW_ITEM (1<<2) // For atoms that allow thrown items to go over them
#define PASS_OVER_THROW_MOB (1<<3) // For atoms that allow thrown mobs to go over them
#define PASS_OVER_FIRE (1<<4) // For atoms that allow fire to go over them
#define PASS_OVER_ACID_SPRAY (1<<5) // For atoms that allow xeno acid spray to go over them
#define PASS_UNDER (1<<6) // For atoms that have some space underneath for things to pass through
#define PASS_GLASS (1<<7) // For atoms that are made of glass or have hollow sections filled with glass
#define PASS_MOB_IS_XENO (1<<8) // For if a xeno can pass through something
#define PASS_MOB_IS_HUMAN (1<<9) // For if a human can pass through something
#define PASS_MOB_IS_OTHER (1<<10) // For if every other mob can pass through something
#define PASS_MOB_THRU_XENO (1<<11) // For if something can pass through a xeno
#define PASS_MOB_THRU_HUMAN (1<<12) // For if something can pass through a human
#define PASS_MOB_THRU_OTHER (1<<13) // For if something can pass through every other mob
#define PASS_TYPE_CRAWLER (1<<14) // For mobs that crawl/climb over stuff (runners/larva), more for "whitelisting" crawlers to pass
#define PASS_HIGH_OVER_ONLY (1<<15) // For atoms that require a high toss to go over it, should only really be using this for flags_can_pass_x vars
#define PASS_BUILDING_ONLY (1<<16) // For throwing stuff over walls (that lead to open ceilings)
#define PASS_CRUSHER_CHARGE (1<<17) // For crusher charge specifically

// Pass flag groups
#define PASS_OVER (PASS_OVER_THROW_ITEM|PASS_OVER_THROW_MOB|PASS_OVER_FIRE|PASS_OVER_ACID_SPRAY)
#define PASS_HIGH_OVER (PASS_HIGH_OVER_ONLY|PASS_OVER)
#define PASS_BUILDING (PASS_HIGH_OVER|PASS_BUILDING_ONLY)
#define PASS_MOB_IS (PASS_MOB_IS_XENO|PASS_MOB_IS_HUMAN|PASS_MOB_IS_OTHER)
#define PASS_MOB_THRU (PASS_MOB_THRU_XENO|PASS_MOB_THRU_HUMAN|PASS_MOB_THRU_OTHER)
#define PASS_ALL (PASS_THROUGH|PASS_AROUND|PASS_OVER|PASS_UNDER|PASS_GLASS|PASS_MOB_IS|PASS_MOB_THRU|PASS_HIGH_OVER_ONLY|PASS_BUILDING_ONLY|PASS_TYPE_CRAWLER|PASS_CRUSHER_CHARGE)

// Short-hand pass flags for very specific things
#define PASS_FLAGS_WEEDS (PASS_UNDER|PASS_MOB_THRU|PASS_OVER_ACID_SPRAY)
#define PASS_FLAGS_ACID_SPRAY (PASS_UNDER|PASS_MOB_THRU|PASS_OVER_ACID_SPRAY)
#define PASS_FLAGS_FLAME (PASS_AROUND|PASS_UNDER|PASS_MOB_THRU|PASS_THROUGH|PASS_OVER_FIRE)
#define PASS_FLAGS_SMOKE (PASS_HIGH_OVER|PASS_AROUND|PASS_UNDER|PASS_MOB_THRU|PASS_THROUGH)
#define PASS_FLAGS_CRAWLER (PASS_TYPE_CRAWLER|PASS_UNDER)

/**
 * currently_z_moving defines. Higher numbers mean higher priority.
 * This one is for falling down open space from stuff such as deleted tile, pit grate...
 */
#define CURRENTLY_Z_FALLING 1
/// currently_z_moving is set to this in zMove() if 0.
#define CURRENTLY_Z_MOVING_GENERIC 2
/// This one is for falling down open space from movement.
#define CURRENTLY_Z_FALLING_FROM_MOVE 3
/// This one is for going upstairs.
#define CURRENTLY_Z_ASCENDING 4

/// possible bitflag return values of [atom/proc/intercept_zImpact] calls
/// Stops the movable from falling further and crashing on the ground. Example: stairs.
#define FALL_INTERCEPTED (1<<0)
/// Suppresses the "[movable] falls through [old_turf]" message because it'd make little sense in certain contexts like climbing stairs.
#define FALL_NO_MESSAGE (1<<1)
/// Used when the whole intercept_zImpact forvar loop should be stopped. For example: when someone falls into the supermatter and becomes dust.
#define FALL_STOP_INTERCEPTING (1<<2)
/// Used when the grip on a pulled object shouldn't be broken.
#define FALL_RETAIN_PULL (1<<3)

/// Runs check_pulling() by the end of [/atom/movable/proc/zMove] for every movable that's pulling something. Should be kept enabled unless you know what you are doing.
#define ZMOVE_CHECK_PULLING (1<<0)
/// Checks if pulledby is nearby. if not, stop being pulled.
#define ZMOVE_CHECK_PULLEDBY (1<<1)
/// flags for different checks done in [/atom/movable/proc/can_z_move]. Should be self-explainatory.
#define ZMOVE_FALL_CHECKS (1<<2)
#define ZMOVE_CAN_FLY_CHECKS (1<<3)
#define ZMOVE_INCAPACITATED_CHECKS (1<<4)
/// Doesn't call zPassIn() and zPassOut()
#define ZMOVE_IGNORE_OBSTACLES (1<<5)
/// Gives players chat feedbacks if they're unable to move through z levels.
#define ZMOVE_FEEDBACK (1<<6)
/// Whether we check the movable (if it exists) the living mob is buckled on or not.
#define ZMOVE_ALLOW_BUCKLED (1<<7)
/// If the movable is actually ventcrawling vertically.
#define ZMOVE_VENTCRAWLING (1<<8)
/// Includes movables that're either pulled by the source or mobs buckled to it in the list of moving movables.
#define ZMOVE_INCLUDE_PULLED (1<<9)
/// Skips check for whether the moving atom is anchored or not.
#define ZMOVE_ALLOW_ANCHORED (1<<10)

#define ZMOVE_CHECK_PULLS (ZMOVE_CHECK_PULLING|ZMOVE_CHECK_PULLEDBY)

/// Flags used in "Move Upwards" and "Move Downwards" verbs.
#define ZMOVE_FLIGHT_FLAGS (ZMOVE_CAN_FLY_CHECKS|ZMOVE_INCAPACITATED_CHECKS|ZMOVE_CHECK_PULLS|ZMOVE_ALLOW_BUCKLED)
/// Used when walking upstairs
#define ZMOVE_STAIRS_FLAGS (ZMOVE_CHECK_PULLEDBY|ZMOVE_ALLOW_BUCKLED)
/// Used for falling down open space.
#define ZMOVE_FALL_FLAGS (ZMOVE_FALL_CHECKS|ZMOVE_ALLOW_BUCKLED)

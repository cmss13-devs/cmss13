#define HDPT_PRIMARY "primary"
#define HDPT_SECONDARY   "secondary"
#define HDPT_SUPPORT "support"
#define HDPT_ARMOR   "armor"
#define HDPT_TREADS  "treads"
#define HDPT_WHEELS  "wheels"
#define HDPT_TURRET  "turret"
#define HDPT_SPECIAL "special" //special pre-installed hardpoints with unique behaviour

#define HDPT_LAYER_WHEELS   0.01 // so it appears below xenomorphs and other mobs
#define HDPT_LAYER_SUPPORT  2
#define HDPT_LAYER_ARMOR 3
#define HDPT_LAYER_TURRET   4
#define HDPT_LAYER_MAX   4

#define VEHICLE_DRIVER   "driver"
#define VEHICLE_GUNNER "primary gunner"
#define VEHICLE_SUPPORT_GUNNER_ONE  "1st support gunner"
#define VEHICLE_SUPPORT_GUNNER_TWO  "2nd support gunner"

#define VEHICLE_SPEED_STATIC 5000 //500 seconds per tile, while not actually static, it's much better than adding check for each movement attempt.
#define VEHICLE_SPEED_SLOW   30 //3 seconds per tile
#define VEHICLE_SPEED_NORMAL 10 //default 1 second per tile
#define VEHICLE_SPEED_FASTNORMAL 7
#define VEHICLE_SPEED_FAST 5 //half a second per tile
#define VEHICLE_SPEED_FASTER 4
#define VEHICLE_SPEED_VERYFAST   3
#define VEHICLE_SPEED_SUPERFAST  2
#define VEHICLE_SPEED_DEBUGFAST  1

#define VEHICLE_TRAMPLE_DAMAGE_TIER_1  22.5
#define VEHICLE_TRAMPLE_DAMAGE_TIER_2  18
#define VEHICLE_TRAMPLE_DAMAGE_TIER_3  13.5
#define VEHICLE_TRAMPLE_DAMAGE_SPECIAL 10 // Larva, Queen, Abomination, or Xenoborg
#define VEHICLE_TRAMPLE_DAMAGE_MIN 5  // Minimum is 5% damage from a ram

#define VEHICLE_TRAMPLE_DAMAGE_APC_REDUCTION 0.2  // APC deals 1/5 of normal damage

#define VEHICLE_TRAMPLE_DAMAGE_OVERDRIVE_BUFF 3 // Overdrive enhancer damage buff
#define VEHICLE_TRAMPLE_DAMAGE_REDUCTION_ARMOR_MULT 12 // How much we divide our armor by to get the percentage reduction

#define TIER_3_RAM_DAMAGE_TAKEN 60

#define INTERIOR_BOUND_SIZE 25 //How big we want each vehicle interior instance to be, including padding

#define HDPT_OFFSET_EMPTY list(NORTH = list(0, 0), SOUTH = list(0, 0), EAST = list(0, 0), WEST = list(0, 0))

/// Vehicle Classes (for future)
#define VEHICLE_CLASS_WEAK (1<<1) //light unarmored vehicles like colony vehicles/trucks/vans
#define VEHICLE_CLASS_LIGHT (1<<2) //light class armor (APC, tank)
#define VEHICLE_CLASS_MEDIUM (1<<3) //medium class armor (tank)
#define VEHICLE_CLASS_HEAVY (1<<4) //heavy class armor (tank)
// Other vehicle flags
/// Vehicle can bypass vehicle blockers, typically going further into maps than intended
#define VEHICLE_BYPASS_BLOCKERS (1<<5)

//Ridden vehicle flags

/// Does our vehicle require arms to operate? Also used for piggybacking on humans to reserve arms on the rider
#define RIDER_NEEDS_ARMS (1<<0)
// As above but only reserves 1 arm instead of 2
#define RIDER_NEEDS_ARM (1<<1)
/// Do we need legs to ride this (checks against TRAIT_FLOORED)
#define RIDER_NEEDS_LEGS (1<<2)
/// If the rider is disabled or loses their needed limbs, do they fall off?
#define UNBUCKLE_DISABLED_RIDER (1<<3)
// For fireman carries, the carrying human needs an arm
#define CARRIER_NEEDS_ARM (1<<4)

#define CAN_BUCKLE (1<<0)
#define CAN_BE_BUCKLED (1<<1)
#define BUCKLE_REQUIRES_RESTRAINTS (1<<2)
#define BUCKLE_PREVENTS_PULL (1<<3)
#define BUCKLE_NEEDS_HAND (1<<4)
#define BUCKLE_NEEDS_TWO_HANDS (1<<5)

//Tank turret mouse-aim rotation

/// How close current_angle needs to be to desired_angle before the turret rotation loop considers itself settled and stops ticking.
#define ROTATION_SETTLE_TOLERANCE 0.5
/// How close current_angle needs to be to the angle-to-target before a turret-mounted weapon is allowed to fire.
#define FIRING_GATE_TOLERANCE 5
/// Baseline turn speed (degrees per decisecond) for a turret whose median mounted traverse_arc equals TURRET_ARC_NORMALIZATION.
#define TURRET_BASE_ANGULAR_VELOCITY 6
/// The traverse_arc value that maps 1:1 onto TURRET_BASE_ANGULAR_VELOCITY.
#define TURRET_ARC_NORMALIZATION 90
/// Turn speed floor, so a turret can never be fully immobilized by a degenerate (e.g. 0) traverse_arc value.
#define TURRET_MIN_ANGULAR_VELOCITY 2
/// Turn speed used when the turret has no weapons mounted at all.
#define TURRET_DEFAULT_ANGULAR_VELOCITY 4
/// Flat angular acceleration (degrees per decisecond^2) used to ramp angular_velocity up/down.
#define TURRET_ANGULAR_ACCEL 1
/// Half-width, in degrees, of the arc a self_gimballed weapon's driver-controlled aim is clamped to around the turret's own current facing (see /obj/item/hardpoint/proc/update_desired_angle()) - keeps the visual swivel (see /obj/item/hardpoint/holder/tank_turret/get_hardpoint_image()) to a modest look-around instead of a full swing to any absolute angle.
#define SLAVED_GIMBAL_ARC_HALF_WIDTH 30

// Flamer hardpoint fire modes - see /obj/item/hardpoint/proc/toggle_fire_mode()
/// Directional line stream (walks toward the target, self-propagating tile by tile).
#define FLAME_MODE_STREAM "stream"
/// Single traveling projectile that plants one AOE ignition point on impact.
#define FLAME_MODE_GLOB "glob"
/// should these go into a _DEFINES for hardpoints instead???

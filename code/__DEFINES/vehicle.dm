#define HDPT_PRIMARY "primary"
#define HDPT_SECONDARY   "secondary"
#define HDPT_SUPPORT "support"
#define HDPT_ARMOR   "armor"
#define HDPT_TREADS  "treads"
#define HDPT_WHEELS  "wheels"
#define HDPT_TURRET  "turret"
#define HDPT_SPECIAL "special" //special pre-installed hardpoints with unique behaviour

// Tank Desant logistics parts
// traction, movement, acceleration, power generation
#define HDPT_ENGINE "engine"
// fuel levels & fuel pump
#define HDPT_FUEL_TANK "fuel tank"
// engine heat management, cooling of the fighting compartment
#define HDPT_RADIATOR "radiator"
// engine ignition; internal climatization; IFF, hatch locks, visual sensors, turret ring drive, air filtering
#define HDPT_BATTERY "battery"
// blocks movement into the tank. When destroyed, xenos can go in and out almost instantly.
#define HDPT_HATCH "hatch"
// can be interacted with to change IFF mode like turrets. When broken, weapons lose projectile IFF
#define HDPT_IFF_MODULE "iff module"
// external cameras. Can be hawk tuah'd by spitters and praes to obscure. Requires constant cleaning
#define HDPT_VISUAL_SENSORS "visual sensors"
// turret rotation speed
#define HDPT_TURRET_RING "turret ring"
// protects against boiler clouds & smoke from entering the tank
#define HDPT_AIR_FILTER "air filter"
// front-mounted plow
#define HDPT_SNOWPLOW "snowplow"
// Not a real install slot. Lets the UA flag use its own wound text instead of gun-part wording.
#define HDPT_UA_FLAG "ua flag"

#define HDPT_LAYER_WHEELS   0.01 // so it appears below xenomorphs and other mobs
#define HDPT_LAYER_SUPPORT  2
#define HDPT_LAYER_ARMOR 3
#define HDPT_LAYER_TURRET   4
#define HDPT_LAYER_MAX   4

/// Fixed view radius for a seated driver/gunner/passenger
#define VEHICLE_SEAT_VIEW_RADIUS 8

// Gear transmission
/// Torque floor so a wrecked engine/treads combo can still crawl.
#define GEAR_MIN_TORQUE_FRACTION 0.15
/// Gear 1's own min-power floor
#define GEAR_1_MIN_POWER_FRACTION 0.6
/// Gear 2's own min-power floor
#define GEAR_2_MIN_POWER_FRACTION 0.45
// Reverse's own power floor. Made a little stronger than gear 2 so Crewmen can retreat more easily.
#define GEAR_REVERSE_MIN_POWER_FRACTION 0.6
/// Below this fraction of nominal torque, is_underpowered() reports TRUE.
#define GEAR_UNDERPOWERED_FRACTION 0.5
/// Engine and ttreads performance only degrades below this health level.
#define DEGRADE_GRACE_THRESHOLD_PCT 95
/// Speed floor (tiles/sec) to avoid a divide-by-zero when scheduling the next move.
#define VEHICLE_MIN_CRAWL_SPEED 0.05
/// Deciseconds between each movement loop (gear_movement_loop()) progress check.
#define GEAR_MOVEMENT_POLL_INTERVAL 1
/// Flat deceleration (tiles/sec^2) applied by the brake key, independent of gear.
#define VEHICLE_BRAKE_DECELERATION 1.5
/// Traction malus applied to a turf weeded at WEED_LEVEL_WEAK.
#define WEED_TRACTION_CAP_WEAK 0.8
/// Traction malus for WEED_LEVEL_STANDARD.
#define WEED_TRACTION_CAP_STANDARD 0.6
/// Traction malus for WEED_LEVEL_HARDY.
#define WEED_TRACTION_CAP_HARDY 0.55
/// Traction malus for WEED_LEVEL_HIVE.
#define WEED_TRACTION_CAP_HIVE 0.4
/// How much of a turf's traction deviation from neutral (1.0) a vehicle actually feels.
#define TRACTION_DAMPENING_TREADS 0.4
#define TRACTION_DAMPENING_WHEELS 1.0
/// Fuel burn multiplier for reagents other than the vehicle's intended fuel (welding fuel, cooking oil, etc etc).
#define OFF_LABEL_FUEL_PENALTY 1.5
/// Units/sec a fuel tank or radiator drains its own contents at once fully destroyed.
#define HARDPOINT_BUSTED_LEAK_RATE 100
/// Extra blunt damage a knockback-shoved tank takes when slammed into a wall.
#define KNOCKBACK_WALL_SLAM_DAMAGE 15
/// Fixed physics tick (deciseconds) gear_cruise_loop() runs on.
#define GEAR_TICK_INTERVAL 2
/// How long (deciseconds) a gas/brake key event still counts as "held".
#define GEAR_INPUT_GRACE_PERIOD 3
/// Default cruise control granularity as a fraction of the top gear's max_speed.
#define CRUISE_CONTROL_DEFAULT_GRANULARITY_FRACTION (1/3)
/// Extra fuel (units) burned per (tile/sec) of speed changed in one tick, on top of baseline cruising cost.
#define ACCEL_FUEL_PER_SPEED_DELTA 0.3
/// Fuel (units/sec) burned just from the engine idling.
#define ENGINE_IDLE_FUEL_USE 0.1
/// How much of top_speed gear 1 (low range) targets.
#define GEAR_1_SPEED_FRACTION 0.5
/// How much of top_speed gear 2 (low range) targets.
#define GEAR_2_SPEED_FRACTION 0.75
/// Fraction of D gear's own stopping distance that gear 2 is tuned to reach its target speed within.
#define GEAR_2_DISTANCE_FRACTION (1/3)
/// Coefficient (1/sec) of speed-scaled drag decay applied while a gear-transmission vehicle has momentum.
#define SPEED_DECAY_COEFFICIENT 0.2
/// Coefficient (1/sec) of the decay applied to drift_speed (Complex acceleration only).
#define DRIFT_DECAY_COEFFICIENT 1.2
/// Fraction of top_speed below which a 90-degree turn creates no drift at all.
#define DRIFT_MIN_SPEED_FRACTION 0.8

// Hardpoint status HUD (west-side vertical icon stack, see multitile_hardpoint_hud.dm)
/// Deciseconds between each hardpoint HUD refresh.
#define HARDPOINT_HUD_UPDATE_INTERVAL 5
/// Deciseconds each color holds during a 3-wound slot's blinking outline.
#define HARDPOINT_HUD_BLINK_HALF_PERIOD 5
/// Pixel offset the hardpoint HUD's icon stack sits at.
#define HARDPOINT_HUD_PIXEL_X -24
/// Vertical pixel offset applied on top of the icon stack's own centered layout.
#define HARDPOINT_HUD_PIXEL_Y_OFFSET 64
/// tankhud.dmi's own sprite size.
#define HARDPOINT_HUD_ICON_SIZE 16
/// Color a slot's icon renders as once destroyed or missing.
#define HARDPOINT_HUD_DESTROYED_COLOR "#404040"

// Crew HUD (see tank_hud.dm)
/// Deciseconds between each crew HUD text refresh while a driver/gunner is seated.
#define CREW_HUD_UPDATE_INTERVAL 3
/// Assumed real-world tile size (meters) for the driver HUD's display-only speed readout.
#define VEHICLE_HUD_METERS_PER_TILE 2
/// Artistic-license multiplier so the driver HUD's displayed top speed reads like a real light tank. Wouln't make sense if a 22 century light tank cralwed at 20kmh, would it?
#define VEHICLE_HUD_SPEED_DISPLAY_MULT (10/3)
/// (tiles/sec) * this = km/h.
#define VEHICLE_HUD_KMH_PER_TILE (VEHICLE_HUD_METERS_PER_TILE * 3.6 * VEHICLE_HUD_SPEED_DISPLAY_MULT)
/// (tiles/sec) * this = mph.
#define VEHICLE_HUD_MPH_PER_TILE (VEHICLE_HUD_METERS_PER_TILE * 2.23694 * VEHICLE_HUD_SPEED_DISPLAY_MULT)

// Engine temperature/overheat model
/// Kelvin above which the engine hardpoint starts taking overheat condition damage.
#define ENGINE_OVERHEAT_THRESHOLD (T20C + 60)
/// Heat generated (Kelvin/sec) per unit of nominal gear torque under full load.
#define ENGINE_HEAT_PER_LOAD 20
/// Baseline heat generated (Kelvin/sec) just from the engine running.
#define ENGINE_HEAT_IDLE 1
/// Torque-equivalent used for heat generation while revving in Park/Neutral.
#define ENGINE_REV_TORQUE_EQUIVALENT 0.1
/// Fuel (units/sec) burned while actively revving in Park/Neutral.
#define ENGINE_REV_FUEL_USE 0.08
/// Newton's-law-of-cooling coefficient (1/sec) at 100% radiator integrity and coolant.
#define ENGINE_RADIATOR_COOLING_COEFFICIENT 0.5
/// Cooling coefficient (1/sec) with no radiator installed, or one fully wrecked/dry.
#define ENGINE_PASSIVE_COOLING_COEFFICIENT 0.05
/// Condition damage/sec applied to the engine hardpoint while above ENGINE_OVERHEAT_THRESHOLD.
#define ENGINE_OVERHEAT_DAMAGE_PER_SEC 15
/// Hard temperature ceiling. Reaching it forces an emergency engine shutdown. (200%)
#define ENGINE_OVERHEAT_SHUTDOWN_THRESHOLD (T20C + 120)
/// How long (deciseconds) after the engine turns on before it can build any new torque.
#define ENGINE_SPINUP_TIME (3 SECONDS)
/// Kelvin within which engine_temperature counts as "setttled" near ambient.
#define ENGINE_TEMPERATURE_SETTLE_THRESHOLD 0.5
/// Extra heat (Kelvin/sec) added per flame mounted atop the hull.
#define ENGINE_HEAT_PER_MOUNTED_FLAME_TILE 5
/// Extra heat (Kelvin/sec) added per flame burning on a turf the tank occupies without being mounted.
#define ENGINE_HEAT_PER_UNDERNEATH_FLAME_TILE (ENGINE_HEAT_PER_MOUNTED_FLAME_TILE * 0.25)

// Overheat wound rolls
/// How often check_overheat_wound_trigger() actually rolls.
#define ENGINE_OVERHEAT_WOUND_ROLL_INTERVAL (1 SECONDS)
/// Temperature threshold above which the engine can gain a fresh Tier 1 (Blown Gasket) wound.
#define ENGINE_OVERHEAT_WOUND_TIER1_THRESHOLD_PCT 125
/// Percent chance per roll of gaining a Tier 1 wound in the Tier 1 heat band.
#define ENGINE_OVERHEAT_WOUND_TIER1_CHANCE_PCT 5
/// Temperature threshold above which the engine can advance to Tier 2 (Cracked Block).
#define ENGINE_OVERHEAT_WOUND_TIER2_THRESHOLD_PCT 150
/// Percent chance per roll of gaining a Tier 1 wound in the Tier 2 heat band.
#define ENGINE_OVERHEAT_WOUND_TIER1_CHANCE_PCT_HIGH 10
/// Percent chance per roll of an existing Tier 1 wound advancing to Tier 2.
#define ENGINE_OVERHEAT_WOUND_TIER2_ADVANCE_CHANCE_PCT 5

// Battery draw/recharge
/// How often (deciseconds) the battery charge/drain loop ticks.
#define BATTERY_TICK_INTERVAL 10
/// Charge (units/sec) restored to the battery while the engine is on.
#define BATTERY_RECHARGE_RATE 10
/// Baseline power draw (units/sec) for the IFF module.
#define IFF_MODULE_POWER_DRAW 0.5
/// Baseline power draw (units/sec) for visual sensors (external cameras).
#define VISUAL_SENSORS_POWER_DRAW 0.5
/// Baseline power draw (units/sec) for the air filter.
#define AIR_FILTER_POWER_DRAW 0.5
/// Baseline power draw (units/sec) for the turret ring while idle.
#define TURRET_RING_IDLE_POWER_DRAW 0.2
/// Power draw (units/sec) for the turret ring while actively rotating.
#define TURRET_RING_ROTATING_POWER_DRAW 2

// Simple acceleration mode
/// Number of discrete notches between 0 and a gear's max_speed under Simple acceleration mode.
#define SIMPLE_ACCEL_STEP_COUNT 4
/// Deciseconds of no accelerate/brake input before speed_notch starts passively decaying.
#define SIMPLE_ACCEL_IDLE_GRACE 10
/// Deciseconds between each passive decay step once idle.
#define SIMPLE_ACCEL_DECAY_INTERVAL 5

// Turn signals
/// Deciseconds between blink toggles for the turn signal overlay.
#define TURN_SIGNAL_BLINK_INTERVAL 5
/// Deciseconds the turn signal's relay sound plays after being (re)activated.
#define TURN_SIGNAL_SOUND_DURATION 50

// Tank engine sound
/// Playback frequency at a standstill/idle.
#define ENGINE_SOUND_MIN_FREQUENCY 24000
/// Playback frequency at the current gear's max_speed.
#define ENGINE_SOUND_MAX_FREQUENCY 44000
/// Volume at a standstill/idle.
#define ENGINE_SOUND_MIN_VOLUME 30
/// Volume at the current gear's max_speed.
#define ENGINE_SOUND_MAX_VOLUME 55
/// Minimum tile range the outside-hearer copy is audible at, even at idle.
#define ENGINE_SOUND_MIN_RANGE 9
/// How fast engine_rev_level (0-1) climbs per second while revving in Park/Neutral.
#define ENGINE_REV_RISE_RATE (1 / 1.5)
/// How fast engine_rev_level decays back down per second once gas is released.
#define ENGINE_REV_DECAY_RATE (1 / 2.5)

// Engine exhaust smoke
/// Tint for exhaust smoke triggered by engine_cracked_block (Brute).
#define ENGINE_SMOKE_COLOR_BRUTE_WOUND "#d9d9d9"
/// Tint for exhaust smoke triggered by Fouled Carburator (tier-1 engine_fouled_injector).
#define ENGINE_SMOKE_COLOR_FOULED_CARBURATOR "#262626"
/// Tint for exhaust smoke triggered by Acid Intake (tier-2 engine_fouled_injector).
#define ENGINE_SMOKE_COLOR_ACID_WOUND "#1f2a12"
/// Tint for exhaust smoke from running on off-label fuel (welding fuel/cornoil).
#define ENGINE_SMOKE_COLOR_OFF_LABEL_FUEL "#8c8c8c"
/// Percent of a fuel ttank's total volume an off-label reagent needs before it smokes at all.
#define VEHICLE_FUEL_SMOKE_THRESHOLD_PCT 51
/// Minimum seconds between exhaust smoke puffs from cornoil alone over the threshold.
#define ENGINE_SMOKE_INTERVAL_COOKING_OIL 8 SECONDS
/// Minimum seconds between exhaust smoke puffs from welding fuel alone over the threshold.
#define ENGINE_SMOKE_INTERVAL_WELDING_FUEL 3 SECONDS
/// Minimum seconds between exhaust smoke puffs from an active engine wound.
#define ENGINE_SMOKE_INTERVAL_WOUND 1.5 SECONDS
/// Exhaust smoke spread/linger amount for the default (off-label fuel/no wound) case.
#define ENGINE_SMOKE_AMOUNT_DEFAULT 2
/// Exhaust smoke spread/linger amount for an actve engine wound.
#define ENGINE_SMOKE_AMOUNT_WOUND 4

/// Minimum seconds between a Boiler glob re-checking a non-tank vehicle it's sitting on.
#define VEHICLE_GAS_EXPOSURE_INTERVAL 8 SECONDS

/// Minimum seconds between a Boiler glob re-checking a tank it's sitting on.
#define TANK_GLOB_EXPOSURE_INTERVAL 1 SECONDS

/// Percent of a tank part's own remaining health dealt per full-strength acid glob tick.
#define TANK_GLOB_ACID_HEALTH_PCT 12

/// Flat minimum damage per full-strength acid glob tick.
#define TANK_GLOB_ACID_FLOOR 12

/// Multiplies a neuro-foulable slot's own wound chance for an AOE neurotoxin glob tick.
#define TANK_GLOB_NEURO_CHANCE_MULT 4

/// Ceiling on the per-tick neuro wound chance after TANK_GLOB_NEURO_CHANCE_MULT is applied.
#define TANK_GLOB_NEURO_CHANCE_CAP_PCT 95

/// Fraction of a bridged interior gas cloud that gets through a lightly damaged air filter.
#define AIR_FILTER_LEAK_FRACTION_TIER_1 0.08
/// Fraction of a bridged interior gas cloud that gets through a badly damaged air filter.
#define AIR_FILTER_LEAK_FRACTION_TIER_2 0.35
/// Filter integrity% below which gas leak-through starts climbing within its current wound tier.
#define AIR_FILTER_LEAK_HEALTH_THRESHOLD_PCT 75
/// Alpha a bridged interior gas cloud needs before it's thick enough to block sight.
#define AIR_FILTER_LEAK_OPACITY_ALPHA_THRESHOLD 128

/// Minimum seconds between separate Acid Mine detonations hitting the same vehicle.
#define ACID_MINE_VEHICLE_DAMAGE_COOLDOWN 2 SECONDS

/// Minimum seconds between a lingering acid puddle re-applying its hit to the same vehicle.
#define LINGERING_ACID_VEHICLE_DAMAGE_COOLDOWN 3 SECONDS

/// Fraction of a vehicle's speed/momentum retained after driving over a Trapper Boiler trap.
#define BOILER_TRAP_VEHICLE_MOMENTUM_RETAINED 0.85

/// Minimum collision-damage multiplier a gear-transmission vehicle can hit for, even near a standstill.
#define COLLISION_SPEED_SCALE_FLOOR 0.2

#define VEHICLE_DRIVER   "driver"
#define VEHICLE_GUNNER "primary gunner"
#define VEHICLE_SUPPORT_GUNNER_ONE  "1st support gunner"
#define VEHICLE_SUPPORT_GUNNER_TWO  "2nd support gunner"

#define VEHICLE_SPEED_STATIC 5000 //500 seconds per tile, while not actually static, it's much better than adding check for each movement attempt.
#define VEHICLE_SPEED_SLOW   30 //3 seconds per tile
#define VEHICLE_SPEED_NORMAL 10 //default 1 second per ttile
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

// Vehicle-vs-vehicle ramming
/// Fraction of the ramming vehicle's own top speed needed for a collision to deal any damage/knockback.
#define VEHICLE_COLLISION_MOMENTUM_THRESHOLD 0.5
/// Knockback distance (tiles) a collision deals at the ramming vehicle's own full top speed.
#define VEHICLE_COLLISION_MAX_KNOCKBACK_TILES 3
/// Damage a collision deals at the ramming vehicle's own full top speed.
#define VEHICLE_COLLISION_MAX_DAMAGE 60
/// Fraction of its own momentum a heavier vehicle bleeds off crashing into a lighter one.
#define VEHICLE_SOFT_CRASH_MOMENTUM_LOSS 0.25

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

/// How close current_angle needs to be to desired_angle before the rotation loop stops ticking.
#define ROTATION_SETTLE_TOLERANCE 0.5
/// How close current_angle needs to be to target before a turret-mounted weapon can fire.
#define FIRING_GATE_TOLERANCE 5
/// Degrees the turret can drift off a rangefinder target before Ctrl+Click rangefinding aborts.
#define RANGEFINDER_TURRET_ARC_TOLERANCE 10
/// Baseline turn speed (degrees/decisecond) for a turret at TURRET_ARC_NORMALIZATION traverse_arc.
#define TURRET_BASE_ANGULAR_VELOCITY 6
/// The traverse_arc value that maps 1:1 onto TURRET_BASE_ANGULAR_VELOCITY.
#define TURRET_ARC_NORMALIZATION 90
/// Turn speed floor, so a turret can never be fully immobilized.
#define TURRET_MIN_ANGULAR_VELOCITY 2
/// Initial max_angular_velocity before recalculate_turn_rate() first runs.
#define TURRET_DEFAULT_ANGULAR_VELOCITY 4
/// Flat angular acceleration (degrees/decisecond^2) used to ramp angular_velocity up/down.
#define TURRET_ANGULAR_ACCEL 1
/// Turn rate multiplier applied with no vehicle power.
#define TURRET_NO_POWER_TURN_RATE_FRACTION 0.2
/// Half-widtth, in degrees, of a self-gimballed weapon's aim clamp around the turret's own facing.
#define SLAVED_GIMBAL_ARC_HALF_WIDTH 30
/// Fire delay multiplier while a seconday is self-gimballed (slaved to the driver's own aim). (higher is worse)
#define SECONDARY_SLAVED_COOLDOWN_MULT 1.33

// Weapon/turret-ring degradation
/// Turret ring/weapon integrity% above which raw damage has no effect on performance at all.
#define WEAPON_DEGRADE_GRACE_THRESHOLD_PCT 90
/// Accuracy multiplier floor.
#define WEAPON_MIN_ACCURACY_MULT 0.25
/// Scatter multiplier ceiling.
#define WEAPON_MAX_SCATTER_MULT 8
/// Projectile speed multiplier floor.
#define WEAPON_MIN_PROJECTILE_SPEED_MULT 0.4
/// Damage multiplier floor.
#define WEAPON_MIN_DAMAGE_MULT 0.4
/// Absolute final turn-rate floor, applied after every other multiplier.
#define TURRET_ABSOLUTE_MIN_ANGULAR_VELOCITY 0.3
/// traverse_arc used when no primary weapon is mounted at all.
#define TURRET_EMPTY_TRAVERSE_ARC 150

// Flamer hardpoint fire modes
/// Directional line stream (walks toward the target, self-propagating tile by tile).
#define FLAME_MODE_STREAM "stream"
/// Single traveling projectile that plants one AOE ignition point on impact.
#define FLAME_MODE_GLOB "glob"
/// should these go into a _DEFINES for hardpoints instead???

/// Flat extra tiles of range the DRG-N gets in stream mode.
#define DRG_N_STREAM_RANGE_BONUS 1
/// Flat extra tiles of range the DRG-N gets in glob mode.
#define DRG_N_GLOB_RANGE_BONUS 2

/// Tiles the DRG-N's own smoke ttank disperses smoke across.
#define DRG_N_SMOKE_RANGE 6
/// Reagent units per dispersed smoke puff for the DRG-N's own smoke tank.
#define DRG_N_SMOKE_UNITS 45

// Hardpoint wounds
/// A wound family gated by/rolled off the hardpoint's acid_damage_taken sub-pool.
#define WOUND_DAMTYPE_ACID "acid"
/// A wound family gated by/rolled off the hardpoint's brute_damage_taken sub-pool.
#define WOUND_DAMTYPE_BRUTE "brute"
/// A wound family gated by/rolled off overall integrity rather than either sub-pool alone.
#define WOUND_DAMTYPE_UNIFIED "unified"
/// Synthetic part_slot for the hull_melted/hull_hole families, tracking the vehicle's own frame health.
#define WOUND_SLOT_HULL "hull"

// Single-target damage resolution
/// Fraction of a struck parent's hit that splashes into its directly-mounted external children.
#define HARDPOINT_BLEED_THROUGH_FRACTION 0.1
/// Armor's own splash fraction from every external hit.
#define ARMOR_SPLASH_FRACTION 0.5
/// Percent chance per point of incoming damage that a struck parent's internal-module pool also takes a hit.
#define HARDPOINT_ORGAN_DAMAGE_CHANCE_PER_DAMAGE 1.2
/// Cap on the per-damage term alone, before wound/integrity bonuses are added.
#define HARDPOINT_ORGAN_DAMAGE_CHANCE_CAP 30
/// Percent chance added per currently-active wound family on the struck parent.
#define HARDPOINT_ORGAN_DAMAGE_WOUND_BONUS 20
/// Integrity percent below which low health starts adding extra internal-hit chance.
#define HARDPOINT_ORGAN_DAMAGE_INTEGRITY_THRESHOLD 60
/// Percent chance added per integrity point below HARDPOINT_ORGAN_DAMAGE_INTEGRITY_THRESHOLD.
#define HARDPOINT_ORGAN_DAMAGE_INTEGRITY_SCALE 1.5
/// Percent chance a neurotoxin spit at the Turret bleeds through to the Air Filter's neuro family.
#define TURRET_NEURO_SPIT_AIR_FILTER_BLEED_CHANCE_PCT 50

// Directional armor
/// A hit landing within 45 degres of the tank hull's own facing.
#define HIT_ZONE_FRONT "front"
/// A hit landing on either flank.
#define HIT_ZONE_SIDE "side"
/// A hit landing within 45 degrees of directly behind the tank.
#define HIT_ZONE_REAR "rear"
/// Fraction of Armor's own contribution a side hit ignores outright.
#define ARMOR_BYPASS_FRACTION_SIDE 0.25
/// Fraction of Armor's own contribution a rear hit ignores outright.
#define ARMOR_BYPASS_FRACTION_REAR 0.75
/// Percent chance bonus added to internal-module-damage rolls for a side hit.
#define ARMOR_BYPASS_INTERNAL_CHANCE_BONUS_SIDE 10
/// Percent chance bonus added to internal-module-damage rolls for a rear hit.
#define ARMOR_BYPASS_INTERNAL_CHANCE_BONUS_REAR 35

// Hatch-wound-driven lock access
/// Entry/exit delay multiplier for an authorized marine at maximum hatch instability.
#define HATCH_WOUNDED_MARINE_MAX_DELAY_MULT 5
/// Entry/exit delay multiplier for a xeno the moment the hatch first becomes wounded while locked.
#define HATCH_WOUNDED_XENO_START_MULT 1.5
/// Entry/exit delay multiplier for a xeno at maximum hatch instability.
#define HATCH_WOUNDED_XENO_MIN_MULT 0.25
/// Entry/exit delay multiplier for a non-USCM human once the hatch is wounded while locked.
#define HATCH_WOUNDED_NON_USCM_DELAY_MULT 6

// Caste-specific tank interactions
// Would those be better in the defines of those abilities themselves??? I don't know, so I placed them here. - BWSB
/// Damage a Crusher's Headbutt deals to the tank on contact.
#define CRUSHER_HEADBUTT_TANK_DAMAGE 20
/// Tiles the tank is shoved back when a Crusher's Charge slams into it.
#define CRUSHER_CHARGE_TANK_KNOCKBACK_TILES 3
/// Damage a plain Crusher Charge deals to the tank on contact.
#define CRUSHER_CHARGE_TANK_DAMAGE 60
/// Deciseconds paused between each individual tile of a knockback shove.
#define KNOCKBACK_STEP_DELAY 3
/// Knockback tiles for the Charger strain's toggled ram.
#define CRUSHER_CHARGER_RAM_TANK_KNOCKBACK_TILES 2
/// Degrees a tank's turret is forcibly turned by a Warrior's Punch.
#define WARRIOR_PUNCH_TURRET_TURN_DEGREES 110
/// Multiplier applied to a Warrior Punch's damage when it lands on the Turret Ring hardpoint.
#define WARRIOR_PUNCH_TURRET_RING_DAMAGE_MULT 2
/// Overall multiplier on Warrior Punch's tank damage.
#define WARRIOR_PUNCH_TANK_DAMAGE_MULT 0.5
/// Same as WARRIOR_PUNCH_TANK_DAMAGE_MULT, for Praetorian Oppressor's Dislocate.
#define OPPRESSOR_DISLOCATE_TANK_DAMAGE_MULT 0.75
/// Angular velocity a Warrior Punch's forced turret turn uses.
#define WARRIOR_PUNCH_TURRET_ANGULAR_VELOCITY 20
/// Angular acceleration to match WARRIOR_PUNCH_TURRET_ANGULAR_VELOCITY.
#define WARRIOR_PUNCH_TURRET_ANGULAR_ACCEL 6
/// Fraction of Queen Screech's own stun duration applied to a tank's seated crew.
#define QUEEN_SCREECH_CREW_STUN_FRACTION 0.5
/// Fraction of Visual Sensors' max health dealt as unblocked damage by a Queen Screech.
#define QUEEN_SCREECH_CAMERA_DAMAGE_PCT 0.05
/// Same idea as QUEEN_SCREECH_CAMERA_DAMAGE_PCT, for the King's Doom ability.
#define KING_DOOM_CAMERA_DAMAGE_PCT 0.05
/// Unblocked damage dealt to every part on a tank per AOE tile of a King's Destroy landing.
#define KING_JUMP_DAMAGE_PER_TILE 50

/// Traction malus cap for a turf covered in full-strength sticky resin.
#define STICKY_RESIN_TRACTION_CAP 0.3
/// Traction malus cap for the weaker/temporary "thin" sticky resin variant.
#define STICKY_RESIN_WEAK_TRACTION_CAP 0.5
/// Traction malus cap for a turf with a resin spike on it.
#define RESIN_SPIKE_TRACTION_CAP 0.8

/// Deciseconds a repeated acid spray hit still counts as "the same spray" for streak decay.
#define ACID_SPRAY_STREAK_WINDOW 20

/// Damage multiplier for Dancer's Impale/Vanguard's Pierce when aimed at an external module.
#define GUARANTEED_EXTERNAL_HIT_DAMAGE_MULT 1.5

/// Fraction of a tank's own momentum retained after a Praetorian Valkyrie's High Gallop clips it.
#define HIGH_GALLOP_MOMENTUM_LOSS_MULT 0.85

// Hull-destruction grand finale ammo cookoff
/// Seconds between the hull-death warning starting and the cookoff detonating.
#define HULL_COOKOFF_WARNING_TIME 10 SECONDS
/// Seconds between repeats of the on-screen "get out now" banner.
#define HULL_COOKOFF_PASSENGER_WARNING_INTERVAL 5 SECONDS
/// Radius of the small warning-phase napalm flame lit the instant the countdown starts.
#define HULL_COOKOFF_WARNING_FLAME_RADIUS 0
/// cell_explosion() power at the tank's own exterior epicenter.
#define HULL_COOKOFF_EXTERIOR_EXPLOSION_POWER 150
/// cell_explosion() falloff to pair with HULL_COOKOFF_EXTERIOR_EXPLOSION_POWER.
#define HULL_COOKOFF_EXTERIOR_EXPLOSION_FALLOFF 16
/// cell_explosion() power for the separate interior blast if anyone's still trapped inside.
#define HULL_COOKOFF_INTERIOR_EXPLOSION_POWER 300
/// cell_explosion() falloff for the interior blast.
#define HULL_COOKOFF_INTERIOR_EXPLOSION_FALLOFF 100
/// Nearest a piece of launched turret wreckage is allowed to land from the tank's own turf.
#define HULL_COOKOFF_TURRET_LAUNCH_MIN_RANGE 2
/// Farthest a piece of launched turret wreckage is allowed to land from the tank's own turf.
#define HULL_COOKOFF_TURRET_LAUNCH_MAX_RANGE 4
/// Layer for the blinking cookoff warning icon.
#define HULL_COOKOFF_WARNING_ICON_LAYER (TANK_ABOVE_RIDER_LAYER + 0.01)

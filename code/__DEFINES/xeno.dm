#define XENOCON_THRESHOLD 6000

#define TUNNEL_MOVEMENT_XENO_DELAY 20
#define TUNNEL_MOVEMENT_BIG_XENO_DELAY 60
#define TUNNEL_MOVEMENT_LARVA_DELAY 5

#define TUNNEL_ENTER_XENO_DELAY 40
#define TUNNEL_ENTER_BIG_XENO_DELAY 120
#define TUNNEL_ENTER_LARVA_DELAY 10

/// The duration it takes a player controlled facehugger to leap
#define FACEHUGGER_LEAP_DURATION 2 SECONDS
/// The duration it takes a player controlled facehugger to hug a target lying down by clicking on it
#define FACEHUGGER_CLIMB_DURATION 1 SECONDS

// Defines for action types and click delays used by xenomorph/unarmedattack() and attack_alien().

/// Full attack delay.
#define XENO_ATTACK_ACTION 1
/// Noticeable but shorter than full delay.
#define XENO_NONCOMBAT_ACTION 2
/// No delay at all.
#define XENO_NO_DELAY_ACTION 3

/// Usually 1 second delay.
#define xeno_attack_delay(X) (X.next_move = world.time + (10 + X.caste.attack_delay + X.attack_speed_modifier))
/// 0.4 seconds, legacy 'open hand clicked something adjacent' delay.
#define xeno_noncombat_delay(X) (X.next_move = world.time + 4)
/// Usually half a second's delay.
#define xeno_miss_delay(X) (X.next_move = world.time + ((10 + X.caste.attack_delay + X.attack_speed_modifier) * 0.5))

// Determines how xenos interact with walls, normal nothing, sharp can destroy normal walls and window frame, very sharp reinforced ones.
#define CLAW_TYPE_NORMAL 1
#define CLAW_TYPE_SHARP 2
#define CLAW_TYPE_VERY_SHARP 3

#define XENO_HITS_TO_DESTROY_WALL 20
#define XENO_HITS_TO_DESTROY_WINDOW_FRAME 3
#define XENO_HITS_TO_DESTROY_R_WINDOW_FRAME 5
#define XENO_HITS_TO_DESTROY_BOLTED_DOOR 10
#define XENO_HITS_TO_DESTROY_WELDED_DOOR 15
#define XENO_HITS_TO_EXPOSE_WIRES_MIN 3
#define XENO_HITS_TO_EXPOSE_WIRES_MAX 4
#define XENO_HITS_TO_CUT_WIRES 10

#define XENO_ACTION_CLICK  0 // Just select the action (base). Toggles can use this too
#define XENO_ACTION_ACTIVATE 1 // Actually use the action SHOULD ONLY BE USED ON ACTIVABLE ACTIONS OR ELSE WILL NOT WORK
#define XENO_ACTION_QUEUE 2 // Tell the action handler to queue the action for next click
#define XENO_ACTION_TOGGLE 3 // Action does something actively when toggled

#define XENO_NOT_PRIMARY_ACTION -1    // NO primacy (never selected by default ability macros)
#define XENO_PRIMARY_ACTION_1 0   // Is this action a "primary" action?
#define XENO_PRIMARY_ACTION_2 1   // Second primary action
#define XENO_PRIMARY_ACTION_3 2   // Tertiary primary action
#define XENO_PRIMARY_ACTION_4 3   // 4th primary action (rarely used)
#define XENO_PRIMARY_ACTION_5 4   // ability creep is real

#define XENO_TECH_SECRETE_RESIN 5 //Macro for T1 build distrib secreting macro
#define XENO_CORROSIVE_ACID 6 //Macro for covering things in acid, universal ability
#define XENO_SCREECH 7 //Macro for queen screech
#define XENO_TAIL_STAB 8 //macro for tail stabs

#define NO_ACTION_CHARGES -1 // This ability does not have a limit to how many times it can be used

#define ACID_SPRAY_LINE 0
#define ACID_SPRAY_CONE 1
/// Defines for Abomination ability /datum/action/xeno_action/activable/feralfrenzy
#define SINGLETARGETGUT 0
#define AOETARGETGUT 1

#define HUD_PAIN_STATES_XENO   4
#define HUD_HEALTH_STATES_XENO 16
#define HUD_PLASMA_STATES_XENO 16
#define HUD_ARMOR_STATES_XENO  10

/// Multiplier for time taken for a xeno to place down a resin structure
#define BUILD_TIME_MULT_LESSER_DRONE 2
#define BUILD_TIME_MULT_XENO 1
#define BUILD_TIME_MULT_BUILDER 1
#define BUILD_TIME_MULT_HIVELORD 0.5

#define IGNORE_BUILD_DISTANCE -1

#define XENO_LEADER_HIVE_POS(X)   (X + 1)
#define GET_XENO_LEADER_NUM(X)  (X.hive_pos - 1)
#define IS_XENO_LEADER(X)    (X.hive_pos > 1)

#define NORMAL_XENO  0
#define XENO_QUEEN   1
#define XENO_LEADER  2
/// Nobody can create constructions. (Feral)
#define XENO_NOBODY  3

#define XENO_HIVE_AREA_SIZE 21 //The turf size from the centrepiece of a hive in which special things can be done (like building structures)

#define EGG_BURST  0
#define EGG_BURSTING  1
#define EGG_GROWING   2
#define EGG_GROWN  3
#define EGG_DESTROYED 4

#define EGG_MIN_GROWTH_TIME 100 //time it takes for the egg to mature once planted
#define EGG_MAX_GROWTH_TIME 150

#define FLAG_EMBRYO_PREDATOR 1 // Useful for passing down flags from an egg to the very moment an embryo is in someone

#define XENO_STARTING_CRYSTAL 100 //How much building resource the queen gets to start with

#define XENO_SLASH_ALLOWED 0
#define XENO_SLASH_FORBIDDEN 1
// Holds defines for /datum/caste_datum, which is the primary datum for the caste system,
// /datum/hive_status (self explanatory)
// and some of the var defines for the Xenomorph base type.

// Holds defines relevant to overall xeno balance

// Stopgap usage only. Use to unilaterally buff every Xenomorph.
// WARNING: These can fuck the entire game
#define XENO_UNIVERSAL_HPMULT 1 // Use to unilaterally buff every caste's total HP.
#define XENO_UNIVERSAL_PLASMAMULT 1 // Use to unilaterally buff every caste's total PLASMA.
#define XENO_UNIVERSAL_DAMAGEMULT 1 // Use to unilaterally buff every caste's DAMAGE.
#define XENO_UNIVERSAL_VEHICLE_DAMAGEMULT 1.5 // Used to unilaterally buff every caste's DAMAGE against vehicles.

#define XVX_UNIVERSAL_DAMAGEMULT 1.5 // Use to unilaterally buff every caste's DAMAGE against other xenos.

#define XVX_SLASH_DAMAGEMULT 1 * XVX_UNIVERSAL_DAMAGEMULT // 1.5 | Applies to any abilities that uses brute damage or slash damage
#define XVX_ACID_DAMAGEMULT 1.75 * XVX_UNIVERSAL_DAMAGEMULT // 2.625 | Applies to any abilities that apply acid damage (not including projectiles)
#define XVX_PROJECTILE_DAMAGEMULT 1.75 * XVX_UNIVERSAL_DAMAGEMULT // 2.625 | Applies to any abilities that use projectiles

#define XVX_STUN_LENGTHMULT 1.25

#define XVX_ARMOR_EFFECTIVEMULT 0.25

// Caste-specific
#define XVX_WARRIOR_HEALMULT 0.35

// Weed defines
#define WEED_LEVEL_WEAK 0
#define WEED_LEVEL_STANDARD  1.5
#define WEED_LEVEL_HARDY 1.6
#define WEED_LEVEL_HIVE   4

#define WEED_RANGE_STANDARD  3
#define WEED_RANGE_PYLON  5
#define WEED_RANGE_CORE   7

/// Multiplicative. The amount of damage xenos do to weeds.
#define WEED_XENO_DAMAGEMULT 0.25

#define WEED_HEALTH_STANDARD 5
#define WEED_HEALTH_HARDY 10
#define WEED_HEALTH_HIVE  15

#define NODE_HEALTH_GROWING  5
#define NODE_HEALTH_STANDARD 11
#define NODE_HEALTH_HIVE  30

#define PYLON_COVERAGE_MULT 1.5

#define WEED_BASE_GROW_SPEED (5 SECONDS)
#define WEED_BASE_DECAY_SPEED (10 SECONDS)

/// The time you must be dead to join as a xeno larva
#define XENO_JOIN_DEAD_LARVA_TIME (2.5 MINUTES)
/// The time you must be dead to join as xeno (not larva)
#define XENO_JOIN_DEAD_TIME (5 MINUTES)
/// The time of inactivity you cannot exceed to join as a xeno
#define XENO_JOIN_AFK_TIME_LIMIT (5 MINUTES)
/// The amount of time after round start before buried larva spawns are disallowed
#define XENO_BURIED_LARVA_TIME_LIMIT (30 MINUTES)

/// The time when xenos can start taking over comm towers
#define XENO_COMM_ACQUISITION_TIME (55 MINUTES)

/// The time it takes for a pylon to give one royal resin while activated
#define XENO_PYLON_ACTIVATION_COOLDOWN (5 MINUTES)

/// The time until you can re-corrupt a comms relay after the last pylon was destroyed
#define XENO_PYLON_DESTRUCTION_DELAY (5 MINUTES)

/// Evolution boost during hijack
#define XENO_HIJACK_EVILUTION_BUFF 10

/// For how long the buff lasts
#define XENO_HIJACK_EVILUTION_TIME (3 MINUTES)

/// If this is marine to xeno ratio during hijack, xenos see marines on tacmap
#define HIJACK_RATIO_FOR_TACMAP 0.8

/// Xenos need to have their number to marines ratio lower than this to get larvae from pylons
#define ENDGAME_LARVA_CAP_MULTIPLIER 0.5

/// What percent of their numbers xeno get from pylons
#define LARVA_ADDITION_MULTIPLIER 0.10

/// The time against away_timer when an AFK xeno larva can be replaced
#define XENO_LEAVE_TIMER_LARVA 80 //80 seconds
/// The time against away_timer when an AFK xeno (not larva) can be replaced
#define XENO_LEAVE_TIMER 300 //300 seconds
/// The time against away_timer when an AFK facehugger converts to a npc
#define XENO_FACEHUGGER_LEAVE_TIMER 420 //420 seconds
/// The time against away_timer when an AFK xeno gets listed in the available list so ghosts can get ready
#define XENO_AVAILABLE_TIMER 60 //60 seconds

/// The damage that xeno health gets divided by for banish tick damage
#define XENO_BANISHMENT_DMG_DIVISOR 23

/// Between 2% to 10% of explosion severity
#define WEED_EXPLOSION_DAMAGEMULT rand(2, 10)*0.01

/////////////////////////////////////////////////////////////////////////////////////
//
// Stat Baselines
//
// These provide the values for caste that everything is built on/scaled off of.
//
/////////////////////////////////////////////////////////////////////////////////////

// Armor levels
#define XENO_NO_ARMOR 0
#define XENO_ARMOR_TIER_1 20
#define XENO_ARMOR_TIER_2 25
#define XENO_ARMOR_TIER_3 30
#define XENO_ARMOR_TIER_4 35
#define XENO_ARMOR_TIER_5 40
#define XENO_ARMOR_TIER_7 50

// Explosive armor (think explosion resistance)
#define XENO_NO_EXPLOSIVE_ARMOR 0
#define XENO_EXPLOSIVE_ARMOR_TIER_1 10
#define XENO_EXPLOSIVE_ARMOR_TIER_2 20
#define XENO_EXPLOSIVE_ARMOR_TIER_4 40
#define XENO_EXPLOSIVE_ARMOR_TIER_5 50
#define XENO_EXPLOSIVE_ARMOR_TIER_6 60
#define XENO_EXPLOSIVE_ARMOR_TIER_7 70
#define XENO_EXPLOSIVE_ARMOR_TIER_8 80
#define XENO_EXPLOSIVE_ARMOR_TIER_10 100

// Health bands
#define XENO_HEALTH_LARVA 35 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_LESSER_DRONE 160 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_RUNNER 230 * XENO_UNIVERSAL_HPMULT // Killed by 1 PB
#define XENO_HEALTH_TIER_1 250 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_2 300 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_3 350 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_4 400 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_5 450 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_6 500 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_7 550 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_8 600 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_9 650 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_10 700 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_11 750 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_12 800 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_13 900 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_TIER_14 950 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_QUEEN 1000 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_IMMORTAL 1200 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_KING 1500 * XENO_UNIVERSAL_HPMULT

// Plasma bands
#define XENO_NO_PLASMA 0
#define XENO_PLASMA_TIER_1 100 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_2 200 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_3 300 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_4 400 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_5 500 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_6 600 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_8 800 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_TIER_10 1000 * XENO_UNIVERSAL_PLASMAMULT

// Plasma gain bands
#define XENO_PLASMA_GAIN_TIER_1 1
#define XENO_PLASMA_GAIN_TIER_2 1.5
#define XENO_PLASMA_GAIN_TIER_3 2
#define XENO_PLASMA_GAIN_TIER_4 2.5
#define XENO_PLASMA_GAIN_TIER_5 3
#define XENO_PLASMA_GAIN_TIER_6 3.5
#define XENO_PLASMA_GAIN_TIER_7 4
#define XENO_PLASMA_GAIN_TIER_8 4.5
#define XENO_PLASMA_GAIN_TIER_9 5
#define XENO_PLASMA_GAIN_TIER_10 5.5

// Health regen Multiplier band
#define XENO_REGEN_MULTIPLIER_TIER_1 1.05
#define XENO_REGEN_MULTIPLIER_TIER_2 1.10
#define XENO_REGEN_MULTIPLIER_TIER_3 1.15
#define XENO_REGEN_MULTIPLIER_TIER_4 1.20
#define XENO_REGEN_MULTIPLIER_TIER_5 1.25
#define XENO_REGEN_MULTIPLIER_TIER_6 1.30
#define XENO_REGEN_MULTIPLIER_TIER_7 1.35
#define XENO_REGEN_MULTIPLIER_TIER_8 1.40
#define XENO_REGEN_MULTIPLIER_TIER_9 1.45
#define XENO_REGEN_MULTIPLIER_TIER_10 1.50

// Armor factor
#define XENO_ARMOR_FACTOR_TIER_1 25
#define XENO_ARMOR_FACTOR_TIER_2 30
#define XENO_ARMOR_FACTOR_TIER_3 35
#define XENO_ARMOR_FACTOR_TIER_4 40
#define XENO_ARMOR_FACTOR_TIER_5 45
#define XENO_ARMOR_FACTOR_TIER_6 50
#define XENO_ARMOR_FACTOR_TIER_7 55
#define XENO_ARMOR_FACTOR_TIER_8 60
#define XENO_ARMOR_FACTOR_TIER_9 65
#define XENO_ARMOR_FACTOR_TIER_10 70
#define XENO_ARMOR_FACTOR_CRUSHER 200

// Evasion
#define XENO_EVASION_NONE 0
#define XENO_EVASION_LOW 10
#define XENO_EVASION_MEDIUM 15
#define XENO_EVASION_HIGH 20

// Speeds
#define XENO_SPEED_QUEEN 0.6
#define XENO_SPEED_TIER_1 0.4
#define XENO_SPEED_TIER_2 0.2
#define XENO_SPEED_TIER_3 0
#define XENO_SPEED_TIER_4 -0.2
#define XENO_SPEED_TIER_5 -0.4
#define XENO_SPEED_TIER_6 -0.6
#define XENO_SPEED_TIER_7 -0.8
#define XENO_SPEED_HELLHOUND -1
#define XENO_SPEED_TIER_8 -1.4
#define XENO_SPEED_TIER_9 -1.6
#define XENO_SPEED_TIER_10 -1.8
#define XENO_SPEED_RUNNER -2

// Xeno damage categories
#define XENO_DAMAGE_TIER_1 20 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_2 25 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_3 30 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_4 35 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_5 40 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_6 45 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_7 50 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_8 55 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_TIER_9 60 * XENO_UNIVERSAL_DAMAGEMULT

// Cost to make things, add +XENO_RESIN_BASE_COST to them all for actual cost
#define XENO_RESIN_BASE_COST 25
#define XENO_RESIN_WALL_COST 95
#define XENO_RESIN_WALL_QUEEN_COST 120
#define XENO_RESIN_WALL_THICK_COST 145
#define XENO_RESIN_WALL_REFLECT_COST 145
#define XENO_RESIN_WALL_MOVABLE_COST 145
#define XENO_RESIN_DOOR_COST 95
#define XENO_RESIN_DOOR_QUEEN_COST 100
#define XENO_RESIN_DOOR_THICK_COST 120
#define XENO_RESIN_MEMBRANE_COST 70
#define XENO_RESIN_MEMBRANE_QUEEN_COST 80
#define XENO_RESIN_MEMBRANE_THICK_COST 95
#define XENO_RESIN_NEST_COST 70
#define XENO_RESIN_STICKY_COST 30
#define XENO_RESIN_FAST_COST 10
#define XENO_RESIN_SPIKE_COST 100
#define XENO_RESIN_ACID_PILLAR_COST 250
#define XENO_RESIN_SHIELD_PILLAR_COST 250
#define XENO_RESIN_ACID_GRENADE_COST 500

// Cost to thicken constructions.
#define XENO_THICKEN_WALL_COST (XENO_RESIN_WALL_THICK_COST - XENO_RESIN_WALL_COST)
#define XENO_THICKEN_DOOR_COST (XENO_RESIN_DOOR_THICK_COST - XENO_RESIN_DOOR_COST)
#define XENO_THICKEN_MEMBRANE_COST (XENO_RESIN_MEMBRANE_THICK_COST - XENO_RESIN_MEMBRANE_COST)

#define RESIN_CONSTRUCTION_NO_MAX -1

// -------------- //
// STRAIN DEFINES //
// -------------- //

// Facehugger strain flags
#define FACEHUGGER_WATCHER "Watcher"

// Drone strain flags
#define DRONE_HEALER "Healer"
#define DRONE_GARDENER "Gardener"

// Hivelord strain flags
#define HIVELORD_RESIN_WHISPERER "Resin Whisperer"

// Carrier strain flags
#define CARRIER_EGGSAC "Eggsac"

// Boiler strain flags
#define BOILER_TRAPPER "Trapper"

// Runner strain flags
#define RUNNER_ACIDER "Acider"

// Lurker strain flags
#define LURKER_VAMPIRE "Vampire"

// Ravager strain flags
#define RAVAGER_HEDGEHOG "Hedgehog"
#define RAVAGER_BERSERKER "Berserker"

// Defender strain flags
#define DEFENDER_STEELCREST "Steelcrest"

// Crusher strain flags
#define CRUSHER_CHARGER "Charger"

// Praetorian strain flags
#define PRAETORIAN_VANGUARD "Vanguard"
#define PRAETORIAN_DANCER "Dancer"
#define PRAETORIAN_VALKYRIE "Valkyrie"
#define PRAETORIAN_OPPRESSOR "Oppressor"

/////////////////////////////////////////////////////////////////////////////////////
//
// Modifiers
//
// These below are used in the Xeno strain system to increase and decrease certain stats by strain
// USE THESE WITH SIGNS - postive will be ADDED, negative will be SUBTRACTED from the Xeno's
// previous stat. Bear in mind that the signs mean different things for different values.
//
/////////////////////////////////////////////////////////////////////////////////////

// Damage - this is applied as a flat nerf/buff to the xeno's average damage
#define XENO_DAMAGE_MOD_VERY_SMALL  5
#define XENO_DAMAGE_MOD_SMALL   10
#define XENO_DAMAGE_MOD_MED 15
#define XENO_DAMAGE_MOD_LARGE   20
#define XENO_DAMAGE_MOD_VERY_LARGE  25

// Overall health pool
#define XENO_HEALTH_MOD_VERY_SMALL  20
#define XENO_HEALTH_MOD_SMALL   40
#define XENO_HEALTH_MOD_MED 60
#define XENO_HEALTH_MOD_LARGE   80
#define XENO_HEALTH_MOD_VERY_LARGE  100
#define XENO_HEALTH_MOD_ACIDER  115

// Armor mods. Use the above defines for some guidance
// In general, +20 armor should be a little more than +20% effective HP, however,
// the higher the Xeno's base armor, the greater the effect.
#define XENO_ARMOR_MOD_TINY  2.5
#define XENO_ARMOR_MOD_VERY_SMALL  5
#define XENO_ARMOR_MOD_SMALL   10
#define XENO_ARMOR_MOD_MED 15
#define XENO_ARMOR_MOD_LARGE   20
#define XENO_ARMOR_MOD_VERY_LARGE  25

#define XENO_EXPOSIVEARMOR_MOD_VERY_SMALL  10
#define XENO_EXPOSIVEARMOR_MOD_SMALL   20
#define XENO_EXPOSIVEARMOR_MOD_MED 30
#define XENO_EXPOSIVEARMOR_MOD_LARGE   40
#define XENO_EXPOSIVEARMOR_MOD_VERY_LARGE  50

// Plasma
#define XENO_PLASMAPOOL_MOD_VERY_SMALL  20
#define XENO_PLASMAPOOL_MOD_SMALL   40
#define XENO_PLASMAPOOL_MOD_MED 60
#define XENO_PLASMAPOOL_MOD_LARGE   80
#define XENO_PLASMAPOOL_MOD_VERY_LARGE  100

// Plasma regen
#define XENO_PLASMAGAIN_MOD_SMALL 0.1
#define XENO_PLASMAGAIN_MOD_MED   0.2
#define XENO_PLASMAGAIN_MOD_LARGE 0.3

// Faster speed modifier (higher tiers mean greater increase in speed)
#define XENO_SPEED_FASTMOD_TIER_1    -0.05
#define XENO_SPEED_FASTMOD_TIER_2    -0.1
#define XENO_SPEED_FASTMOD_TIER_3    -0.15
#define XENO_SPEED_FASTMOD_TIER_4    -0.2
#define XENO_SPEED_FASTMOD_TIER_5 -0.25
#define XENO_SPEED_FASTMOD_TIER_6 -0.3
#define XENO_SPEED_FASTMOD_TIER_7 -0.35
#define XENO_SPEED_FASTMOD_TIER_8 -0.4
#define XENO_SPEED_FASTMOD_TIER_9 -0.45
#define XENO_SPEED_FASTMOD_TIER_10 -0.5

// Slower speed modifier (higher tiers mean greater decrease in speed)
#define XENO_SPEED_SLOWMOD_TIER_1       0.05
#define XENO_SPEED_SLOWMOD_TIER_2       0.1
#define XENO_SPEED_SLOWMOD_TIER_3       0.15
#define XENO_SPEED_SLOWMOD_TIER_4       0.20
#define XENO_SPEED_SLOWMOD_TIER_5       0.25
#define XENO_SPEED_SLOWMOD_TIER_6       0.30
#define XENO_SPEED_SLOWMOD_TIER_7       0.35
#define XENO_SPEED_SLOWMOD_TIER_8       0.4
#define XENO_SPEED_SLOWMOD_TIER_9       0.45
#define XENO_SPEED_SLOWMOD_TIER_10      0.5
#define XENO_SPEED_SLOWMOD_ZOOM		    0.75

// Neuro power
#define XENO_NEURO_TIER_1   1
#define XENO_NEURO_TIER_2   1.25
#define XENO_NEURO_TIER_3   1.5 // Threshold for sleep and daze
#define XENO_NEURO_TIER_4   1.75
#define XENO_NEURO_TIER_5   2

// Pheremone strength modifiers
#define XENO_PHERO_MOD_VERY_SMALL  0.25
#define XENO_PHERO_MOD_SMALL   0.5
#define XENO_PHERO_MOD_MED 0.75
#define XENO_PHERO_MOD_LARGE   1
#define XENO_PHERO_MOD_VERY_LARGE  1.25

// Evasion modifiers
#define XENO_EVASION_MOD_VERY_SMALL 3
#define XENO_EVASION_MOD_SMALL 6
#define XENO_EVASION_MOD_MED 9
#define XENO_EVASION_MOD_LARGE 12
#define XENO_EVASION_MOD_VERY_LARGE 15
#define XENO_EVASION_MOD_ULTRA 25

// Armor factor modifiers
#define XENO_ARMORFACTOR_MOD_VERY_SMALL 5
#define XENO_ARMORFACTOR_MOD_SMALL 10
#define XENO_ARMORFACTOR_MOD_MED 15
#define XENO_ARMORFACTOR_MOD_LARGE 20
#define XENO_ARMORFACTOR_MOD_VERY_LARGE 25

// Acid boost (I guess, this is used literally nowhere)
// Feel free to add more defines here if it ever becomes relevant
#define XENO_ACID_MOD_BOOST 1

// Weed boost (same as above)
#define XENO_WEED_BOOST 1

// Hive Pylon protection range
#define XENO_HIVE_PYLON_PROTECTION_RANGE 8

/////////////////////////////////////////////////////////////////////////////////////
//
// Default scaling values
//
// In the abscence of a scalar (documented below) these values are what are used
// to scale xeno stats by age.
//
/////////////////////////////////////////////////////////////////////////////////////

#define XENO_MULTIPLIER_HEALTH_YOUNG 1
#define XENO_MULTIPLIER_HEALTH_MATURE 1.25
#define XENO_MULTIPLIER_HEALTH_ELDER 1.4
#define XENO_MULTIPLIER_HEALTH_ANCIENT 1.5
#define XENO_MULTIPLIER_HEALTH_PRIMORDIAL 1.75

#define XENO_MULTIPLIER_DAMAGE_YOUNG 1
#define XENO_MULTIPLIER_DAMAGE_MATURE 1.2
#define XENO_MULTIPLIER_DAMAGE_ELDER 1.3
#define XENO_MULTIPLIER_DAMAGE_ANCIENT 1.35
#define XENO_MULTIPLIER_DAMAGE_PRIMORDIAL 1.45

#define XENO_MULTIPLIER_PLASMA_YOUNG 1
#define XENO_MULTIPLIER_PLASMA_MATURE 1.25
#define XENO_MULTIPLIER_PLASMA_ELDER 1.5
#define XENO_MULTIPLIER_PLASMA_ANCIENT 2
#define XENO_MULTIPLIER_PLASMA_PRIMORDIAL 2.25

#define XENO_MULTIPLIER_CRYSTAL_YOUNG 1
#define XENO_MULTIPLIER_CRYSTAL_MATURE 1.1
#define XENO_MULTIPLIER_CRYSTAL_ELDER 1.2
#define XENO_MULTIPLIER_CRYSTAL_ANCIENT 1.3
#define XENO_MULTIPLIER_CRYSTAL_PRIMORDIAL 1.5

#define XENO_MULTIPLIER_PLASMA_GAIN_YOUNG 1
#define XENO_MULTIPLIER_PLASMA_GAIN_MATURE 1.2
#define XENO_MULTIPLIER_PLASMA_GAIN_ELDER 1.4
#define XENO_MULTIPLIER_PLASMA_GAIN_ANCIENT 1.6
#define XENO_MULTIPLIER_PLASMA_GAIN_PRIMORDIAL 1.8

#define XENO_MULTIPLIER_ARMOR_FACTOR_YOUNG 0.6
#define XENO_MULTIPLIER_ARMOR_FACTOR_MATURE 1.1
#define XENO_MULTIPLIER_ARMOR_FACTOR_ELDER 1.15
#define XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT 1.20
#define XENO_MULTIPLIER_ARMOR_FACTOR_PRIMORDIAL 1.30

#define XENO_MULTIPLIER_EVASION_YOUNG 0.6
#define XENO_MULTIPLIER_EVASION_MATURE 1.10
#define XENO_MULTIPLIER_EVASION_ELDER 1.15
#define XENO_MULTIPLIER_EVASION_ANCIENT 1.20
#define XENO_MULTIPLIER_EVASION_PRIMORDIAL 1.3

/////////////////////////////////////////////////////////////////////////////////////////////
//
// Scalars
//
// These are used to adjust caste scaling. Define in them in the caste datum definitions
// for each age to override the default. Bear in mind that these scale from the base caste
// values; they are NOT multiplicative. The actual variables for doing that are down below.
//
/////////////////////////////////////////////////////////////////////////////////////////////

#define XENO_SCALAR_HEALTH_NONE 1
#define XENO_SCALAR_HEALTH_LOW 1.1
#define XENO_SCALAR_HEALTH_LOWMED 1.15
#define XENO_SCALAR_HEALTH_MED 1.2
#define XENO_SCALAR_HEALTH_MEDHIGH 1.25
#define XENO_SCALAR_HEALTH_HIGH 1.3
#define XENO_SCALAR_HEALTH_VERYHIGH 1.35
#define XENO_SCALAR_HEALTH_ULTRAHIGH 1.4
#define XENO_SCALAR_HEALTH_IMMORTAL 1.5
#define XENO_SCALAR_HEALTH_OHLAWD 1.7

#define XENO_SCALAR_DAMAGE_NONE 1
#define XENO_SCALAR_DAMAGE_LOW 1.1
#define XENO_SCALAR_DAMAGE_MED 1.2
#define XENO_SCALAR_DAMAGE_HIGH 1.3
#define XENO_SCALAR_DAMAGE_VERYHIGH 1.4
#define XENO_SCALAR_DAMAGE_ULTRAHIGH 1.5

#define XENO_SCALAR_PLASMA_NONE 1
#define XENO_SCALAR_PLASMA_LOW 1.25
#define XENO_SCALAR_PLASMA_MED 1.5
#define XENO_SCALAR_PLASMA_HIGH 1.75
#define XENO_SCALAR_PLASMA_VERYHIGH 2
#define XENO_SCALAR_PLASMA_ULTRAHIGH 2.25

#define XENO_SCALAR_PLASMA_GAIN_NONE 1
#define XENO_SCALAR_PLASMA_GAIN_LOW 1.15
#define XENO_SCALAR_PLASMA_GAIN_MED 1.3
#define XENO_SCALAR_PLASMA_GAIN_HIGH 1.45
#define XENO_SCALAR_PLASMA_GAIN_VERYHIGH 1.6
#define XENO_SCALAR_PLASMA_GAIN_ULTRAHIGH 1.75

#define XENO_SCALAR_ARMORFACTOR_NONE 1
#define XENO_SCALAR_ARMORFACTOR_LOW 1.05
#define XENO_SCALAR_ARMORFACTOR_MED 1.1
#define XENO_SCALAR_ARMORFACTOR_HIGH 1.15
#define XENO_SCALAR_ARMORFACTOR_VERYHIGH 1.20
#define XENO_SCALAR_ARMORFACTOR_ULTRAHIGH 1.25

#define XENO_SCALAR_EVASION_NONE 1
#define XENO_SCALAR_EVASION_LOW 1.05
#define XENO_SCALAR_EVASION_MED 1.1
#define XENO_SCALAR_EVASION_HIGH 1.15
#define XENO_SCALAR_EVASION_VERYHIGH 1.20
#define XENO_SCALAR_EVASION_ULTRAHIGH 1.25

#define XENO_STRUCTURE_BUILD_TIME    20

#define XENO_STRUCTURE_CORE  "hive core"
#define XENO_STRUCTURE_CLUSTER   "hive cluster"
#define XENO_STRUCTURE_PYLON "hive pylon"
#define XENO_STRUCTURE_EGGMORPH  "egg morpher"
#define XENO_STRUCTURE_RECOVERY  "recovery node"
#define XENO_STRUCTURE_NEST  "thick resin nest"

#define RESIN_TRAP_EMPTY 0
#define RESIN_TRAP_HUGGER 1
#define RESIN_TRAP_GAS 2
#define RESIN_TRAP_ACID1 3
#define RESIN_TRAP_ACID2 4
#define RESIN_TRAP_ACID3 5

// HIVECORE COOLDOWN TIME
#define HIVECORE_COOLDOWN 5 MINUTES

// Xeno 'pre-setup' duration, round time where the xenos will no longer be able to move hivecore without cooldowns or burrow up as larvae from the ground without a pool.
#define XENOMORPH_PRE_SETUP_CUTOFF 20 MINUTES

// Xeno shield HUD scale factor (1.5x so its easier to see, most times)
#define XENO_SHIELD_HUD_SCALE_FACTOR 1.5

// Xeno shield sources
#define XENO_SHIELD_SOURCE_GENERIC 0
#define XENO_SHIELD_SOURCE_RAVAGER 1
#define XENO_SHIELD_SOURCE_HEDGE_RAV 2
#define XENO_SHIELD_SOURCE_VANGUARD_PRAE 3
#define XENO_SHIELD_SOURCE_BASE_PRAE 4
#define XENO_SHIELD_SOURCE_CRUSHER 5
#define XENO_SHIELD_SOURCE_WARDEN_PRAE 6
#define XENO_SHIELD_SOURCE_GARDENER 8
#define XENO_SHIELD_SOURCE_SHIELD_PILLAR 9
#define XENO_SHIELD_SOURCE_CUMULATIVE_GENERIC 10
#define XENO_SHIELD_SOURCE_KING_BULWARKSPELL 11

//XENO CASTES
#define XENO_CASTE_LARVA  "Larva"
#define XENO_CASTE_PREDALIEN_LARVA   "Predalien Larva"
#define XENO_CASTE_FACEHUGGER "Facehugger"
#define XENO_CASTE_LESSER_DRONE "Lesser Drone"
#define XENO_T0_CASTES    list(XENO_CASTE_LARVA, XENO_CASTE_PREDALIEN_LARVA, XENO_CASTE_FACEHUGGER, XENO_CASTE_LESSER_DRONE)

//t1
#define XENO_CASTE_DRONE  "Drone"
#define XENO_CASTE_RUNNER "Runner"
#define XENO_CASTE_SENTINEL   "Sentinel"
#define XENO_CASTE_DEFENDER   "Defender"
#define XENO_T1_CASTES    list(XENO_CASTE_DRONE, XENO_CASTE_RUNNER, XENO_CASTE_SENTINEL, XENO_CASTE_DEFENDER)
//t2
#define XENO_CASTE_BURROWER   "Burrower"
#define XENO_CASTE_CARRIER    "Carrier"
#define XENO_CASTE_HIVELORD   "Hivelord"
#define XENO_CASTE_LURKER "Lurker"
#define XENO_CASTE_WARRIOR    "Warrior"
#define XENO_CASTE_SPITTER    "Spitter"
#define XENO_T2_CASTES    list(XENO_CASTE_BURROWER, XENO_CASTE_CARRIER, XENO_CASTE_HIVELORD, XENO_CASTE_LURKER, XENO_CASTE_WARRIOR, XENO_CASTE_SPITTER)
//t3
#define XENO_CASTE_BOILER "Boiler"
#define XENO_CASTE_PRAETORIAN "Praetorian"
#define XENO_CASTE_CRUSHER    "Crusher"
#define XENO_CASTE_RAVAGER    "Ravager"
#define XENO_T3_CASTES    list(XENO_CASTE_BOILER, XENO_CASTE_PRAETORIAN, XENO_CASTE_CRUSHER, XENO_CASTE_RAVAGER)

//Tier 4
#define XENO_CASTE_KING "King"
#define XENO_CASTE_QUEEN  "Queen"

//special
#define XENO_CASTE_PREDALIEN  "Predalien"
#define XENO_CASTE_HELLHOUND  "Hellhound"
#define XENO_SPECIAL_CASTES   list(XENO_CASTE_QUEEN, XENO_CASTE_PREDALIEN, XENO_CASTE_HELLHOUND)

#define ALL_XENO_CASTES list(XENO_CASTE_LARVA, XENO_CASTE_PREDALIEN_LARVA, XENO_CASTE_FACEHUGGER, XENO_CASTE_LESSER_DRONE, XENO_CASTE_DRONE, XENO_CASTE_RUNNER, XENO_CASTE_SENTINEL, XENO_CASTE_DEFENDER, XENO_CASTE_BURROWER, XENO_CASTE_CARRIER, XENO_CASTE_HIVELORD, XENO_CASTE_LURKER, XENO_CASTE_WARRIOR, XENO_CASTE_SPITTER, XENO_CASTE_BOILER, XENO_CASTE_PRAETORIAN, XENO_CASTE_CRUSHER, XENO_CASTE_RAVAGER, XENO_CASTE_QUEEN, XENO_CASTE_PREDALIEN, XENO_CASTE_HELLHOUND, XENO_CASTE_KING)

// Checks if two hives are allied to each other.
// PARAMETERS:
// source_hive integer  the hive to check the alliance of
// target_hive  integer  the target hive to see if the source_hive is allied to it.
#define HIVE_ALLIED_TO_HIVE(source_hive, target_hive) ((source_hive) == (target_hive) || GLOB.hive_datum[source_hive]?.faction_is_ally(GLOB.hive_datum[target_hive]?.internal_faction))

#define QUEEN_SPAWN_TIMEOUT (1 MINUTES)

#define FIRE_IMMUNITY_NONE				0
#define FIRE_IMMUNITY_NO_DAMAGE			(1<<0)
#define FIRE_IMMUNITY_NO_IGNITE			(1<<1)
#define FIRE_IMMUNITY_XENO_FRENZY		(1<<2)
#define FIRE_VULNERABILITY				(1<<3)

#define FIRE_MULTIPLIER_BASE	 	1
#define FIRE_MULTIPLIER_LOW		 	1.25
#define FIRE_MULTIPLIER_MEDIUM		1.5
#define FIRE_MULTIPLIER_HIGH		1.75 // Really starts chunking HP
#define FIRE_MULTIPLIER_EXTREME	 	2
#define FIRE_MULTIPLIER_DEADLY		3

#define WHISPERER_VIEWRANGE 10
#define TRAPPER_VIEWRANGE 13

#define SECRETE_RESIN_INTERRUPT -1
#define SECRETE_RESIN_FAIL 0
#define SECRETE_RESIN_SUCCESS 1

#define XENO_CHARGE_TRY_MOVE 0

//preferences-related defines

#define XENO_VISION_LEVEL_NO_NVG "No Night Vision"
#define XENO_VISION_LEVEL_MID_NVG "Half Night Vision"
#define XENO_VISION_LEVEL_HIGH_NVG "Three Quarters Night Vision"
#define XENO_VISION_LEVEL_FULL_NVG "Full Night Vision"


// drone fruits

#define XENO_FRUIT_LESSER "Lesser Resin Fruit"
#define XENO_FRUIT_GREATER "Greater Resin Fruit"
#define XENO_FRUIT_UNSTABLE "Unstable Resin Fruit"
#define XENO_FRUIT_SPORE "Spore Resin Fruit"
#define XENO_FRUIT_SPEED "Alacrit Resin Fruit"
#define XENO_FRUIT_PLASMA "Cruor Resin Fruit"


// turf weedable states
#define NOT_WEEDABLE 0
#define SEMI_WEEDABLE 1
#define FULLY_WEEDABLE 2

#define TAILSTAB_COOLDOWN_NONE 0
#define TAILSTAB_COOLDOWN_VERY_LOW 0.1
#define TAILSTAB_COOLDOWN_LOW 0.5
#define TAILSTAB_COOLDOWN_NORMAL 1
#define TAILSTAB_COOLDOWN_HIGH 1.5
#define TAILSTAB_COOLDOWN_VERY_HIGH 2

#define TAILSTAB_MOB_DAMAGE_MULTIPLIER 1.2
#define TAILSTAB_AIRLOCK_DAMAGE_MULTIPLIER 2

#define FRENZY_DAMAGE_MULTIPLIER 2

#define JOIN_AS_FACEHUGGER_DELAY (3 MINUTES)
#define JOIN_AS_LESSER_DRONE_DELAY (1 MINUTES)

// larva states
#define LARVA_STATE_BLOODY 0
#define LARVA_STATE_NORMAL 1
#define LARVA_STATE_MATURE 2

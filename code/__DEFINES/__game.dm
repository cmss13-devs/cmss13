#define RANGE_TURFS(RADIUS, CENTER) \
  block( \
    locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
    locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
  )

//Admin perms are in global.dm.

#define NO_FLAGS 0 // To make it even more clear that something is a bitfield

#define GLOBAL_PROC		"magic BS"

//Game defining directives.
#define MAIN_AI_SYSTEM "ARES v3.2"
#define MAIN_SHIP_ESCAPE_POD_NUMBER 18

// Maploader bounds indices
#define MAP_MINX 1
#define MAP_MINY 2
#define MAP_MINZ 3
#define MAP_MAXX 4
#define MAP_MAXY 5
#define MAP_MAXZ 6

#define MAP_MAXSIZE 300

#define MAP_ICE_COLONY "Ice Colony" // Highpop only
#define MAP_LV_624 "LV-624"
#define MAP_BIG_RED "Solaris Ridge"
#define MAP_PRISON_STATION "Fiorina Cellblocks"
#define MAP_PRISON_STATION_V3 "Fiorina Science Annex"
#define MAP_WHISKEY_OUTPOST "Whiskey Outpost" // Unused
#define MAP_DESERT_DAM "Trijent Dam"  // Highpop only
#define MAP_SOROKYNE_STRATA "Sorokyne Strata"
#define MAP_CORSAT "CORSAT" // Highpop only
#define MAP_KUTJEVO "Kutjevo Refinery"
#define MAP_ICE_COLONY_V3 "Shivas Snowball" //Ice Rework, low pop enabled.
#define MAP_HAUNTED_HOUSE_V2 "Haunted House V2"
#define MAP_RUNTIME "USS Runtime"

#define PLAYERCOUNT_LOWPOP_MAP_LIMIT 130 // number of players before we switch to lowpop maps only (LV, BR, Prison)

#define PREROUND_TIME 360 // time before the round starts

//A set of constants used to determine which type of mute an admin wishes to apply:
//Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO etc = (MUTE_IC << 1)
//Therefore there needs to be a gap between the flags for the automute flags
#define MUTE_IC			1
#define MUTE_OOC		2
#define MUTE_PRAY		4
#define MUTE_ADMINHELP	8
#define MUTE_DEADCHAT	16
#define MUTE_ALL		31

//Number of identical messages required to get the spam-prevention automute thing to trigger warnings and automutes
#define SPAM_TRIGGER_WARNING 5
#define SPAM_TRIGGER_AUTOMUTE 10

//Some constants for DB_Ban
#define BANTYPE_PERMA		1
#define BANTYPE_TEMP		2
#define BANTYPE_JOB_PERMA	3
#define BANTYPE_JOB_TEMP	4
#define BANTYPE_ANY_FULLBAN	5 //used to locate stuff to unban.

#define SEE_INVISIBLE_MINIMUM 5

#define SEE_INVISIBLE_OBSERVER_NOLIGHTING 15

#define INVISIBILITY_LIGHTING 20

#define SEE_INVISIBLE_LIVING 25

#define SEE_INVISIBLE_LEVEL_ONE 35	//Used by some stuff in code. It's really poorly organized.
#define INVISIBILITY_LEVEL_ONE 35	//Used by some stuff in code. It's really poorly organized.

#define SEE_INVISIBLE_LEVEL_TWO 45	//Used by some other stuff in code. It's really poorly organized.
#define INVISIBILITY_LEVEL_TWO 45	//Used by some other stuff in code. It's really poorly organized.

#define INVISIBILITY_OBSERVER 60
#define SEE_INVISIBLE_OBSERVER 60

#define INVISIBILITY_MAXIMUM 100

//Object specific defines
#define CANDLE_LUM 3 //For how bright candles are


//Preference toggles//
//toggles_sound
#define SOUND_ADMINHELP	1
#define SOUND_MIDI		2
#define SOUND_AMBIENCE	4
#define SOUND_LOBBY		8
#define SOUND_INTERNET	16
#define SOUND_REBOOT	32

//toggles_chat
#define CHAT_OOC			1
#define CHAT_DEAD			2
#define CHAT_GHOSTEARS		4
#define CHAT_GHOSTSIGHT		8
#define CHAT_PRAYER			16
#define CHAT_RADIO			32
#define CHAT_ATTACKLOGS		64
#define CHAT_DEBUGLOGS		128
#define CHAT_LOOC			256
#define CHAT_GHOSTRADIO 	512
#define SHOW_TYPING 		1024
#define CHAT_FFATTACKLOGS 	2048
#define CHAT_GHOSTHIVEMIND	4096
#define CHAT_NICHELOGS		8192

//toggles_ghost
#define GHOST_HEALTH_SCAN  (1<<0)

//toggles_flashing
#define FLASH_ROUNDSTART		(1<<0)
#define FLASH_ROUNDEND			(1<<1)
#define FLASH_CORPSEREVIVE		(1<<2)
#define FLASH_ADMINPM			(1<<3)
#define FLASH_UNNEST			(1<<4)
#define FLASH_POOLSPAWN			(1<<5)

//toggles_langchat
#define LANGCHAT_SEE_EMOTES		(1<<0)

//toggles_ert
#define PLAY_LEADER (1<<0)
#define PLAY_MEDIC (1<<1)
#define PLAY_ENGINEER (1<<2)
#define PLAY_HEAVY (1<<3)
#define PLAY_SMARTGUNNER (1<<4)
#define PLAY_SYNTH (1<<5)
#define PLAY_MISC (1<<6)

//=================================================

#define TOGGLES_CHAT_DEFAULT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_ATTACKLOGS|CHAT_LOOC|CHAT_GHOSTHIVEMIND)

#define TOGGLES_GHOST_DEFAULT (GHOST_HEALTH_SCAN)

#define TOGGLES_LANGCHAT_DEFAULT (LANGCHAT_SEE_EMOTES)

#define TOGGLES_SOUND_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|SOUND_INTERNET)

#define TOGGLES_FLASHING_DEFAULT (FLASH_ROUNDSTART|FLASH_ROUNDEND|FLASH_CORPSEREVIVE|FLASH_ADMINPM|FLASH_UNNEST)

#define TOGGLES_ERT_DEFAULT (PLAY_LEADER|PLAY_MEDIC|PLAY_ENGINEER|PLAY_HEAVY|PLAY_SMARTGUNNER|PLAY_SYNTH|PLAY_MISC)


// Game Intents
#define INTENT_HELP 1
#define INTENT_DISARM 2
#define INTENT_GRAB 4
#define INTENT_HARM 8

/*
	Shuttles
*/

// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
// note that this is multiplied by 10 in the shuttle controller. Hence, this is not defined in deciseconds but in real seconds

#define DOCK_ATTEMPT_TIMEOUT 			20 SECONDS	//how long in ticks we wait before assuming the docking controller is broken or blown up.
#define DROPSHIP_WARMUP_TIME			10 SECONDS
#define DROPSHIP_DROP_MSG_DELAY			30 SECONDS
#define DROPSHIP_TRANSIT_DURATION		100 SECONDS	// 100 seconds
#define DROPSHIP_CORSAT_DURATION		30 SECONDS  // 30 seconds
#define ELEVATOR_TRANSIT_DURATION		5 SECONDS	// 5 seconds
#define TRANSIT_POD_TRANSIT_DURATION	30 SECONDS 	// 30 seconds
#define DROPSHIP_CRASH_TRANSIT_DURATION	3 MINUTES	// 180 seconds. 3 minutes
#define ERT_SHUTTLE_TRANSIT_DURATION    30 SECONDS	// what are these comments for

#define SHUTTLE_RECHARGE  2 MINUTES // 2 minutes
#define ELEVATOR_RECHARGE 15 SECONDS  // 15 seconds

//Shuttle moving status
//#define SHUTTLE_IDLE		0
#define SHUTTLE_WARMUP		1
#define SHUTTLE_INTRANSIT	2
#define SHUTTLE_CRASHED		3

//Ferry shuttle processing status
#define IDLE_STATE		0
#define WAIT_LAUNCH		1
#define FORCE_LAUNCH	2
#define WAIT_ARRIVE		3
#define WAIT_FINISH		4
#define FORCE_CRASH		5

//Security levels
#define SEC_LEVEL_GREEN	0
#define SEC_LEVEL_BLUE	1
#define SEC_LEVEL_RED	2
#define SEC_LEVEL_DELTA	3

//Alarm levels.
#define ALARM_WARNING_FIRE 	(1<<0)
#define ALARM_WARNING_ATMOS	(1<<1)
#define ALARM_WARNING_EVAC	(1<<2)
#define ALARM_WARNING_READY	(1<<3)
#define ALARM_WARNING_DOWN	(1<<4)
#define ALARM_LOCKDOWN		(1<<5)

//some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26	//Used to trigger removal from a processing list

//=================================================
#define HOSTILE_STANCE_IDLE 1
#define HOSTILE_STANCE_ALERT 2
#define HOSTILE_STANCE_ATTACK 3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED 5
//=================================================

#define ROUNDSTART_LOGOUT_REPORT_TIME 10 MINUTES //Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

//=================================================
//Game mode related defines.

#define TRANSITIONEDGE	3 //Distance from edge to move to another z-level

//Flags for zone sleeping
#define GET_RANDOM_FREQ rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.


// Ceilings
// Ceiling types
// CEILING_PROTECTION_TIER_X are thresholds for blocking shit, everything else is
// for handling ceiling behaviors (eg debris)

/// Do not block any ordnance
#define CEILING_NO_PROTECTION 0
#define CEILING_NONE 0.1
#define CEILING_GLASS 0.2

/// Blocks mortar placement, lasing, and medevac
#define CEILING_PROTECTION_TIER_1 1
#define CEILING_METAL 1.1

/// Blocks CAS signals, supply drops, fultoning, and mortar fire
#define CEILING_PROTECTION_TIER_2 2
#define CEILING_UNDERGROUND_ALLOW_CAS 2.1
#define CEILING_UNDERGROUND_METAL_ALLOW_CAS 2.2

/// Blocks CAS fire
#define CEILING_PROTECTION_TIER_3 3
#define CEILING_UNDERGROUND_BLOCK_CAS 3.1
#define CEILING_UNDERGROUND_METAL_BLOCK_CAS 3.2

/// Blocks OB fire
#define CEILING_PROTECTION_TIER_4 4
#define CEILING_DEEP_UNDERGROUND 4.1
#define CEILING_DEEP_UNDERGROUND_METAL 4.2
#define CEILING_REINFORCED_METAL 4.3
#define CEILING_RESIN 4.4
#define CEILING_MAX 4.5

// Helpers
/// Only use the CEILING_PROTECTION_TIER_X defines for `protection_level`
#define CEILING_IS_PROTECTED(ceiling, protection_level) (ceiling >= protection_level)


// Default font settings
#define FONT_SIZE "5pt"
#define DEFAULT_FONT_COLOR "#09f"
#define FONT_STYLE "Arial Black"
#define SCROLL_SPEED 2

#define WEAPON_DELAY_NO_EFFECT 0
#define WEAPON_DELAY_NO_FIRE 1
#define WEAPON_DELAY_SCATTER 2
#define WEAPON_DELAY_ACCURACY 4
#define WEAPON_DELAY_SCATTER_AND_ACCURACY 6

#define WEAPON_GUARANTEED_DELAY 0.1

// Defines for M56D states
#define M56D_DMG_NONE 0
#define M56D_DMG_SLIGHT 1
#define M56D_DMG_MODERATE 2
#define M56D_DMG_HEAVY 3

// Defines for barricade states
#define BARRICADE_DMG_NONE 0
#define BARRICADE_DMG_SLIGHT 1
#define BARRICADE_DMG_MODERATE 2
#define BARRICADE_DMG_HEAVY 3

#define BARRICADE_BSTATE_FORTIFIED 	3 // Used by handrails to indicate reinforcing
#define BARRICADE_BSTATE_SECURED 	2 // fresh barricade
#define BARRICADE_BSTATE_UNSECURED 	1 // intermediate state before cade is movable (no apparent effect on health)
#define BARRICADE_BSTATE_MOVABLE 	0 // ready to be deconstructed and can be moved

// Defines for sandbag build stages
#define BARRICADE_SANDBAG_1 1
#define BARRICADE_SANDBAG_2 2
#define BARRICADE_SANDBAG_3 3
#define BARRICADE_SANDBAG_4 4
#define BARRICADE_SANDBAG_5 5

// Defines for sandbag tresholds
#define BARRICADE_SANDBAG_TRESHOLD_1	75
#define BARRICADE_SANDBAG_TRESHOLD_2	150
#define BARRICADE_SANDBAG_TRESHOLD_3	225
#define BARRICADE_SANDBAG_TRESHOLD_4	300
#define BARRICADE_SANDBAG_TRESHOLD_5	450

// Defines for wall types
#define WALL_METAL "metal"
#define WALL_HULL "testwall"
#define WALL_WHITE "wwall"
#define WALL_SULACO "sulaco"
#define WALL_HANGAR "hangar"
#define WALL_REINFORCED "rwall"
#define WALL_REINFORCED_RESEARCH "research"
#define WALL_REINFORCED_IRON "iron"
#define WALL_REINFORCED_CHIGUSA "chigusa"
#define WALL_REINFORCED_BUNKER "bunker"
#define WALL_RESIN "resin"
#define WALL_THICKRESIN "thickresin"
#define WALL_MEMBRANE "membrane"
#define WALL_THICKMEMBRANE "thickmembrane"
#define WALL_BONE_RESIN "bone_resin"
#define WALL_CAVE "cavewall"
#define WALL_WOOD "wood"
#define WALL_GOLD "gold"
#define WALL_CULT "cult"
#define WALL_STONE "stone"
#define WALL_STRATA_ICE "strata_ice"
#define WALL_STRATA_ICE_DIRTY "strata_ice_dirty"
#define WALL_JUNGLE_UPDATED "jungle_veg"
#define WALL_STRATA_OUTPOST_RIBBED "strata_ribbed_outpost_"
#define WALL_STRATA_OUTPOST_BARE "strata_bare_outpost_"
#define WALL_SHIVA_ICE "shiva_ice"
#define WALL_SHIVA_FAB "shiva_fab"
#define WALL_SHIVA_FAB_R "shiva_fab_r"
#define WALL_SHIVA_FAB_ORANGE "shiva_fab_oj"
#define WALL_SHIVA_FAB_BLUE "shiva_fab_blu"
#define WALL_SHIVA_FAB_PINK "shiva_fab_pnk"
#define WALL_SHIVA_FAB_WHITE "shiva_fab_wht"
#define WALL_SHIVA_FAB_RED "shiva_fab_red"
#define WALL_DOME "dome"
#define WALL_DOMER "r_dome"
#define WALL_SOLARIS "solaris_interior"
#define WALL_SOLARISR "solaris_interior_r"
#define WALL_SOLARIS_ROCK "solaris_rock"
#define WALL_KUTJEVO_ROCK "rock"
#define WALL_KUTJEVO_ROCK_BORDER "rock_border"
#define WALL_KUTJEVO_COLONY "colony"
#define WALL_KUTJEVO_COLONYR "colonyr"
#define WALL_DEVWALL "devwall"
#define WALL_DEVWALL_R "devwall_r"
#define WALL_HUNTERSHIP "metal"//DMI specific name

//Defines for dropship weapon gimbals
#define GIMBAL_LEFT -1
#define GIMBAL_CENTER 0
#define GIMBAL_RIGHT 1

//Defines for dropship firemission status
#define FIRE_MISSION_ALL_GOOD 0
#define FIRE_MISSION_CODE_ERROR 1
#define FIRE_MISSION_BAD_COOLDOWN 2
#define FIRE_MISSION_BAD_OFFSET 4
#define FIRE_MISSION_WEAPON_REMOVED 8
#define FIRE_MISSION_WEAPON_UNUSABLE 16
#define FIRE_MISSION_WEAPON_OUT_OF_AMMO 32

//Defines for firemission state
#define FIRE_MISSION_STATE_IDLE 0
#define FIRE_MISSION_STATE_IN_TRANSIT 1
#define FIRE_MISSION_STATE_ON_TARGET 2
#define FIRE_MISSION_STATE_FIRING 4
#define FIRE_MISSION_STATE_OFF_TARGET 8
#define FIRE_MISSION_STATE_COOLDOWN 16

//Defines for the ticker
#define GAME_STATE_COMPILE_FINISHED	5

// Misc client defines
#define MIN_FPS 0
#define MAX_FPS 100

// Defines for shuttles (primarily to separate dropships and elevators)
#define SHUTTLE_DROPSHIP 1
#define SHUTTLE_ELEVATOR 2
#define SHUTTLE_GROUND   3

// Misc game defines
#define EXTINGUISHER_WATER_USE_AMT	5 // Amount of water consumed by extinguisher per use //why is this a define let alone a GLOBAL define oh my good lord

// Chat delay amounts
#define CHAT_SAY_DELAY      2
#define CHAT_SAY_DELAY_SPAM 10
#define CHAT_OOC_DELAY      5
#define CHAT_OOC_DELAY_SPAM 10

// Decorator Priorities
#define DECORATOR_USUAL 0
#define DECORATOR_MAP_SPECIFIC 5
#define DECORATOR_MONTH_SPECIFIC 10
#define DECORATOR_DAY_SPECIFIC 20
#define DECORATOR_HIGHEST_PRIORITY 50

// Chat message types
#define CHAT_TYPE_OTHER 0
#define CHAT_TYPE_BEING_HIT 1
#define CHAT_TYPE_WEAPON_USE 2
#define CHAT_TYPE_ARMOR_DAMAGE 4
#define CHAT_TYPE_MELEE_HIT 8
#define CHAT_TYPE_FLUFF_ACTION 16
#define CHAT_TYPE_COMBAT_ACTION 32
#define CHAT_TYPE_XENO_COMBAT 64
#define CHAT_TYPE_XENO_FLUFF 128
#define CHAT_TYPE_TAKING_HIT 256
#define CHAT_TYPE_PAIN 512

#define CHAT_TYPE_ALL ((1<<16) - 1) // this is so if we have newer flags, we still have ALL working. This will work for 16 first flags
#define CHAT_TYPE_TARGETS_ME CHAT_TYPE_TAKING_HIT

// Used for pre-setting tgchat message type as combat messages
#define CHAT_TYPE_ALL_COMBAT (CHAT_TYPE_BEING_HIT|CHAT_TYPE_WEAPON_USE|CHAT_TYPE_ARMOR_DAMAGE|CHAT_TYPE_MELEE_HIT|CHAT_TYPE_COMBAT_ACTION|CHAT_TYPE_XENO_COMBAT|CHAT_TYPE_TAKING_HIT)

// Window skin types
#define TOGGLE_WINDOW_SKIN 1

// Quadtree values

/// Max amount of player coordinates in a quadtree cell
#define QUADTREE_CAPACITY 12
/// Minimum X width up to which we keep dividing the tree (meaning cells can be half that)
#define QUADTREE_BOUNDARY_MINIMUM_WIDTH 12
/// Minimum Y height up to which we keep dividing the tree (meaning cells can be half that)
#define QUADTREE_BOUNDARY_MINIMUM_HEIGHT 12


#define QTREE_EXCLUDE_OBSERVER 1
#define QTREE_SCAN_MOBS 2 //Return mob list instead of client list

// Ship section bounds

#define UPPER_DECK "Upper deck"
#define LOWER_DECK "Lower deck"
#define FORESHIP "Foreship"
#define MIDSHIP "Midship"
#define AFTSHIP "Aftship"

// Turf protection levels

#define TURF_PROTECTION_NONE 0
#define TURF_PROTECTION_MORTAR 1
#define TURF_PROTECTION_CAS 2
#define TURF_PROTECTION_OB 3

// Anything above the deck boundary is the upper deck, anything below is the lower deck
// This is exclusive, so anything ON the boundary is an edge case that's neither on the upper nor the lower deck
#define ALMAYER_DECK_BOUNDARY 101

// These are inclusive bounds. Anything between them is regarded as the midship
// I.e. the foreship is x = 0 to and including ALMAYER_FORE_BOUNDARY
#define ALMAYER_FORE_BOUNDARY 121
#define ALMAYER_AFT_BOUNDARY 197

/proc/get_accurate_dist(var/turf/A, var/turf/B)
	var/dist
	if(!A || !B)
		dist = 0
	else
		var/dx = abs(A.x - B.x)
		var/dy = abs(A.y - B.y)
		if(dx>=dy)	dist = (0.934*dx) + (0.427*dy)
		else		dist = (0.427*dx) + (0.934*dy)

	return dist

// Beams
/// For beams with an infinite duration (deletion is handled separately)
#define BEAM_INFINITE_DURATION -1

/// Used for calculations with delta_time when figuring how much "amount" to give per "time"
/// `amount` - The number to get per time
/// `time` - The time period in which to gain this amount
/// To be used with delta_time. Multiplied by 10 to convert from deciseconds to seconds
#define AMOUNT_PER_TIME(amount, time) ((amount / (time))*10)

// Local message mode. Used to decide wheter message should be dispatched on the radio.
#define MESSAGE_MODE_LOCAL 1
// The number of channels you can multibroadcast at a time
#define MULTIBROADCAST_MAX_CHANNELS 4

// Performance toggle flags
/// Set conservative MC timings on game start
#define PERF_TOGGLE_LAZYSS (1<<0)
/// Disable bloody footprints
#define PERF_TOGGLE_NOBLOODPRINTS (1<<1)
/// Disable file-based attacklogs
#define PERF_TOGGLE_ATTACKLOGS (1<<2)
/// Disables loading/ticking shuttle controllers
#define PERF_TOGGLE_SHUTTLES (1<<3)
/// Disables loading Techwebs and additional Z-Levels
#define PERF_TOGGLE_TECHWEBS (1<<4)

//Admin perms are in global.dm.

/// To make it even more clear that something is a bitfield.
#define NO_FLAGS 0

#define GLOBAL_PROC "magic BS"

//Game defining directives.
#define MAIN_AI_SYSTEM "ARES v3.2"

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
#define MAP_RUNTIME "USS Runtime"
#define MAP_LV522_CHANCES_CLAIM "LV-522 Chance's Claim"
#define MAP_LV759_HYBRISA_PROSPERA "LV-759 Hybrisa Prospera" // Highpop Only
#define MAP_NEW_VARADERO "New Varadero"//ice colony underground but as its own map
#define MAP_CHINOOK "Chinook 91 GSO" //admin level

#define GAMEMODE_WHISKEY_OUTPOST "Whiskey Outpost"
#define GAMEMODE_HIVE_WARS "Hive Wars"

/// Number of players before we switch to lowpop maps only (LV, BR, Prison).
#define PLAYERCOUNT_LOWPOP_MAP_LIMIT 130
/// Time before the round starts.
#define PREROUND_TIME 360

//A set of constants used to determine which type of mute an admin wishes to apply:
//Please read and understand the muting/automuting stuff before changing these. MUTE_IC_AUTO etc = (MUTE_IC << 1)
//Therefore there needs to be a gap between the flags for the automute flags
#define MUTE_IC 1
#define MUTE_OOC 2
#define MUTE_PRAY 4
#define MUTE_ADMINHELP 8
#define MUTE_DEADCHAT 16
#define MUTE_ALL 31

//Number of identical messages required to get the spam-prevention automute thing to trigger warnings and automutes
#define SPAM_TRIGGER_WARNING 5
#define SPAM_TRIGGER_AUTOMUTE 10

//Some constants for DB_Ban
#define BANTYPE_PERMA 1
#define BANTYPE_TEMP 2
#define BANTYPE_JOB_PERMA 3
#define BANTYPE_JOB_TEMP 4
#define BANTYPE_ANY_FULLBAN 5 //used to locate stuff to unban.

#define SEE_INVISIBLE_MINIMUM 5

#define SEE_INVISIBLE_OBSERVER_NOLIGHTING 15

#define INVISIBILITY_LIGHTING 20

#define SEE_INVISIBLE_LIVING 25

#define SEE_INVISIBLE_LEVEL_ONE 35 //Used by some stuff in code. It's really poorly organized.
#define INVISIBILITY_LEVEL_ONE 35 //Used by some stuff in code. It's really poorly organized.

#define SEE_INVISIBLE_LEVEL_TWO 45 //Used by some other stuff in code. It's really poorly organized.
#define INVISIBILITY_LEVEL_TWO 45 //Used by some other stuff in code. It's really poorly organized.

#define HIDE_INVISIBLE_OBSERVER 59 // define for when we want to hide all observer mobs.

#define INVISIBILITY_OBSERVER 60
#define SEE_INVISIBLE_OBSERVER 60

#define INVISIBILITY_MAXIMUM 100

#define INVISIBILITY_ABSTRACT 101 //only used for abstract objects that aren't really "there" but can't be datums

//Object specific defines

/// For how bright candles are.
#define CANDLE_LUM 3


//Preference toggles//
//toggles_sound
#define SOUND_ADMINHELP (1<<0)
#define SOUND_MIDI (1<<1)
#define SOUND_AMBIENCE (1<<2)
#define SOUND_LOBBY (1<<3)
#define SOUND_INTERNET (1<<4) // Unused currently. Kept for default prefs compat only
#define SOUND_REBOOT (1<<5)
#define SOUND_ADMIN_MEME (1<<6)
#define SOUND_ADMIN_ATMOSPHERIC (1<<7)
#define SOUND_ARES_MESSAGE (1<<8)
#define SOUND_OBSERVER_ANNOUNCEMENTS (1<<9)
#define SOUND_FAX_MACHINE (1<<10)

//toggles_chat
#define CHAT_OOC (1<<0)
#define CHAT_DEAD (1<<1)
#define CHAT_GHOSTEARS (1<<2)
#define CHAT_GHOSTSIGHT (1<<3)
#define CHAT_PRAYER (1<<4)
#define CHAT_RADIO (1<<5)
#define CHAT_ATTACKLOGS (1<<6)
#define CHAT_DEBUGLOGS (1<<7)
#define CHAT_LOOC (1<<8)
#define CHAT_GHOSTRADIO (1<<9)
#define SHOW_TYPING (1<<10)
#define CHAT_FFATTACKLOGS (1<<11)
#define CHAT_GHOSTHIVEMIND (1<<12)
#define CHAT_NICHELOGS (1<<13)
#define CHAT_LISTENINGBUG (1<<14)

//toggles_ghost
#define GHOST_HEALTH_SCAN  (1<<0)

//toggles_flashing
#define FLASH_ROUNDSTART (1<<0)
#define FLASH_ROUNDEND (1<<1)
#define FLASH_CORPSEREVIVE (1<<2)
#define FLASH_ADMINPM (1<<3)
#define FLASH_UNNEST (1<<4)
#define FLASH_POOLSPAWN (1<<5)

//toggles_langchat
#define LANGCHAT_SEE_EMOTES (1<<0)

//toggles_ert
#define PLAY_LEADER (1<<0)
#define PLAY_MEDIC (1<<1)
#define PLAY_ENGINEER (1<<2)
#define PLAY_HEAVY (1<<3)
#define PLAY_SMARTGUNNER (1<<4)
#define PLAY_SYNTH (1<<5)
#define PLAY_MISC (1<<6)

//toggles_ert_pred
#define PLAY_MERC (1<<0)
#define PLAY_TWE (1<<1)
#define PLAY_UPP (1<<2)
#define PLAY_CLF (1<<3)
#define PLAY_XENO_T2 (1<<4)
#define PLAY_XENO_T3 (1<<5)

//toggles_admin
/// Splits admin tabs in Statpanel
#define SPLIT_ADMIN_TABS (1<<0)
#define ADMIN_STEALTHMODE (1<<1)
#define ADMIN_AFK_SAFE (1<<2)

//=================================================

#define TOGGLES_CHAT_DEFAULT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_LOOC|CHAT_GHOSTHIVEMIND|CHAT_FFATTACKLOGS)

#define TOGGLES_GHOST_DEFAULT (GHOST_HEALTH_SCAN)

#define TOGGLES_LANGCHAT_DEFAULT (LANGCHAT_SEE_EMOTES)

#define TOGGLES_SOUND_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|SOUND_INTERNET|SOUND_ADMIN_MEME|SOUND_ADMIN_ATMOSPHERIC|SOUND_OBSERVER_ANNOUNCEMENTS|SOUND_FAX_MACHINE)

#define TOGGLES_FLASHING_DEFAULT (FLASH_ROUNDSTART|FLASH_ROUNDEND|FLASH_CORPSEREVIVE|FLASH_ADMINPM|FLASH_UNNEST)

#define TOGGLES_ERT_DEFAULT (PLAY_LEADER|PLAY_MEDIC|PLAY_ENGINEER|PLAY_HEAVY|PLAY_SMARTGUNNER|PLAY_SYNTH|PLAY_MISC)

#define TOGGLES_ERT_GROUNDS (PLAY_MERC|PLAY_TWE|PLAY_UPP|PLAY_CLF|PLAY_XENO_T2|PLAY_XENO_T3)

#define TOGGLES_ADMIN_DEFAULT (ADMIN_AFK_SAFE)

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

/// how long in ticks we wait before assuming the docking controller is broken or blown up.
#define DOCK_ATTEMPT_TIMEOUT 20 SECONDS
#define DROPSHIP_WARMUP_TIME 10 SECONDS
#define DROPSHIP_DROP_MSG_DELAY 30 SECONDS
#define DROPSHIP_DROP_FIRE_DELAY 20 SECONDS
#define DROPSHIP_TRANSIT_DURATION 100 SECONDS
#define DROPSHIP_CORSAT_DURATION 30 SECONDS
#define ELEVATOR_TRANSIT_DURATION 5 SECONDS
#define TRANSIT_POD_TRANSIT_DURATION 30 SECONDS
#define DROPSHIP_CRASH_TRANSIT_DURATION 3 MINUTES
#define ERT_SHUTTLE_TRANSIT_DURATION 30 SECONDS

#define SHUTTLE_RECHARGE  2 MINUTES
#define ELEVATOR_RECHARGE 15 SECONDS

//Shuttle moving status
//#define SHUTTLE_IDLE 0
#define SHUTTLE_WARMUP 1
#define SHUTTLE_INTRANSIT 2

//Ferry shuttle processing status
#define IDLE_STATE 0
#define WAIT_LAUNCH 1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE 3
#define WAIT_FINISH 4
#define FORCE_CRASH 5

//Security levels
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_BLUE 1
#define SEC_LEVEL_RED 2
#define SEC_LEVEL_DELTA 3

//Alarm levels.
// flags_alarm_state
#define ALARM_WARNING_FIRE (1<<0)
#define ALARM_WARNING_ATMOS (1<<1)
#define ALARM_WARNING_EVAC (1<<2)
#define ALARM_WARNING_READY (1<<3)
#define ALARM_WARNING_DOWN (1<<4)
#define ALARM_LOCKDOWN (1<<5)

//=================================================
#define HOSTILE_STANCE_IDLE 1
#define HOSTILE_STANCE_ALERT 2
#define HOSTILE_STANCE_ATTACK 3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED 5
//=================================================

/// Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.
#define ROUNDSTART_LOGOUT_REPORT_TIME 10 MINUTES

//=================================================
//Game mode related defines.

/// Distance from edge to move to another z-level.
#define TRANSITIONEDGE 3

//Flags for zone sleeping

/// Frequency stuff only works with 45kbps oggs.
#define GET_RANDOM_FREQ rand(32000, 55000)
#define GET_RANDOM_FREQ_MINOR rand(42000, 48000)

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
#define CEILING_SANDSTONE_ALLOW_CAS 1.2

/// Blocks CAS signals, supply drops, fultoning, and mortar fire
#define CEILING_PROTECTION_TIER_2 2
#define CEILING_UNDERGROUND_ALLOW_CAS 2.1
#define CEILING_UNDERGROUND_METAL_ALLOW_CAS 2.2

/// Blocks CAS fire
#define CEILING_PROTECTION_TIER_3 3
#define CEILING_UNDERGROUND_BLOCK_CAS 3.1
#define CEILING_UNDERGROUND_METAL_BLOCK_CAS 3.2
#define CEILING_UNDERGROUND_SANDSTONE_BLOCK_CAS 3.3

/// Blocks OB fire
#define CEILING_PROTECTION_TIER_4 4
#define CEILING_DEEP_UNDERGROUND 4.1
#define CEILING_DEEP_UNDERGROUND_METAL 4.2
#define CEILING_REINFORCED_METAL 4.3
#define CEILING_RESIN 4.4
#define CEILING_MAX 4.5

// Helpers
/// Only use the CEILING_PROTECTION_TIER_X defines for `protection_level`
#define CEILING_IS_PROTECTED(ceiling, protection_level) ((ceiling) >= (protection_level))

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

#define BARRICADE_BSTATE_FORTIFIED 3 // Used by handrails to indicate reinforcing
#define BARRICADE_BSTATE_SECURED 2 // fresh barricade

/// Intermediate state before cade is movable (no apparent effect on health).
#define BARRICADE_BSTATE_UNSECURED 1
/// Ready to be deconstructed and can be moved.
#define BARRICADE_BSTATE_MOVABLE 0

// Defines for sandbag build stages
#define BARRICADE_SANDBAG_1 1
#define BARRICADE_SANDBAG_2 2
#define BARRICADE_SANDBAG_3 3
#define BARRICADE_SANDBAG_4 4
#define BARRICADE_SANDBAG_5 5

// Defines for sandbag tresholds
#define BARRICADE_SANDBAG_TRESHOLD_1 75
#define BARRICADE_SANDBAG_TRESHOLD_2 150
#define BARRICADE_SANDBAG_TRESHOLD_3 225
#define BARRICADE_SANDBAG_TRESHOLD_4 300
#define BARRICADE_SANDBAG_TRESHOLD_5 450

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
#define WALL_AICORE "aiwall"

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
#define FIRE_MISSION_BAD_DIRECTION 64
#define FIRE_MISSION_NOT_EXECUTABLE -1

//Defines for firemission state
#define FIRE_MISSION_STATE_IDLE 0
#define FIRE_MISSION_STATE_IN_TRANSIT 1
#define FIRE_MISSION_STATE_ON_TARGET 2
#define FIRE_MISSION_STATE_FIRING 4
#define FIRE_MISSION_STATE_OFF_TARGET 8
#define FIRE_MISSION_STATE_COOLDOWN 16

//Defines for the ticker
#define GAME_STATE_COMPILE_FINISHED 5

// Misc client defines
#define MIN_FPS 0
#define MAX_FPS 100

// Defines for shuttles (primarily to separate dropships and elevators)
#define SHUTTLE_DROPSHIP 1
#define SHUTTLE_ELEVATOR 2
#define SHUTTLE_GROUND   3

// Misc game defines

/// Amount of water consumed by extinguisher per use.//why is this a define let alone a GLOBAL define oh my good lord
#define EXTINGUISHER_WATER_USE_AMT 5

// Chat delay amounts
#define CHAT_SAY_DELAY   2
#define CHAT_SAY_DELAY_SPAM 10
#define CHAT_OOC_DELAY   5
#define CHAT_OOC_DELAY_SPAM 10

/// Max characters per minute allowed to speak
#define CHAT_CPM_ALLOWED  1500
/// Minimum character length counted for a single message
#define CHAT_CPM_MINIMUM  50
/// Buffer period over which speaking budget is considered
#define CHAT_CPM_PERIOD   5 MINUTES

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

/// This is so if we have newer flags, we still have ALL working. This will work for 16 first flags.
#define CHAT_TYPE_ALL ((1<<16) - 1)

#define CHAT_TYPE_TARGETS_ME CHAT_TYPE_TAKING_HIT

/// Used for pre-setting tgchat message type as combat messages
#define CHAT_TYPE_ALL_COMBAT (CHAT_TYPE_BEING_HIT|CHAT_TYPE_WEAPON_USE|CHAT_TYPE_ARMOR_DAMAGE|CHAT_TYPE_MELEE_HIT|CHAT_TYPE_COMBAT_ACTION|CHAT_TYPE_XENO_COMBAT|CHAT_TYPE_TAKING_HIT)

/// Window skin types
#define TOGGLE_WINDOW_SKIN 1

// Quadtree values

/// Max amount of player coordinates in a quadtree cell
#define QUADTREE_CAPACITY 12
/// Minimum X width up to which we keep dividing the tree (meaning cells can be half that)
#define QUADTREE_BOUNDARY_MINIMUM_WIDTH 12
/// Minimum Y height up to which we keep dividing the tree (meaning cells can be half that)
#define QUADTREE_BOUNDARY_MINIMUM_HEIGHT 12


#define QTREE_EXCLUDE_OBSERVER 1

/// Return mob list instead of client list.
#define QTREE_SCAN_MOBS 2

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

/// Convert a turf protection level to a ceiling protection level
/proc/get_ceiling_protection_level(turf_protection_level)
	switch(turf_protection_level)
		if(TURF_PROTECTION_OB)
			return CEILING_PROTECTION_TIER_4
		if(TURF_PROTECTION_CAS)
			return CEILING_PROTECTION_TIER_3
		if(TURF_PROTECTION_MORTAR)
			return CEILING_PROTECTION_TIER_2
		else
			return CEILING_NO_PROTECTION

// Anything above the deck boundary is the upper deck, anything below is the lower deck
// This is exclusive, so anything ON the boundary is an edge case that's neither on the upper nor the lower deck
#define ALMAYER_DECK_BOUNDARY 101

// These are inclusive bounds. Anything between them is regarded as the midship
// I.e. the foreship is x = 0 to and including ALMAYER_FORE_BOUNDARY
#define ALMAYER_FORE_BOUNDARY 121
#define ALMAYER_AFT_BOUNDARY 197

/proc/get_accurate_dist(turf/A, turf/B)
	var/dist
	if(!A || !B)
		dist = 0
	else
		var/dx = abs(A.x - B.x)
		var/dy = abs(A.y - B.y)
		if(dx>=dy)
			dist = (0.934*dx) + (0.427*dy)
		else
			dist = (0.427*dx) + (0.934*dy)

	return dist

// Beams
/// For beams with an infinite duration (deletion is handled separately)
#define BEAM_INFINITE_DURATION -1

/// Used for calculations with delta_time when figuring how much "amount" to give per "time"
/// `amount` - The number to get per time
/// `time` - The time period in which to gain this amount
/// To be used with delta_time. Multiplied by 10 to convert from deciseconds to seconds
#define AMOUNT_PER_TIME(amount, time) (((amount) / (time))*10)

// Local message mode. Used to decide wheter message should be dispatched on the radio.
#define MESSAGE_MODE_LOCAL 1
// The number of channels you can multibroadcast at a time
#define MULTIBROADCAST_MAX_CHANNELS 4

// Performance toggle flags
/// Set conservative MC timings on game start
// perf_flags
#define PERF_TOGGLE_LAZYSS (1<<0)
/// Disable bloody footprints
#define PERF_TOGGLE_NOBLOODPRINTS (1<<1)
/// Disable file-based attacklogs
#define PERF_TOGGLE_ATTACKLOGS (1<<2)
/// Disables loading/ticking shuttle controllers
#define PERF_TOGGLE_SHUTTLES (1<<3)
/// Disables loading Techwebs and additional Z-Levels
#define PERF_TOGGLE_TECHWEBS (1<<4)

/// Maptext styles
#define MAP_STYLESHEET ".maptext { font-family: 'Small Fonts'; font-size: 7px; -dm-text-outline: 1px black; color: white; line-height: 1.1; } .center { text-align: center; } .langchat { font-family: 'Small Fonts'; font-size: 7px; -dm-text-outline: 1px black; } .langchat_small { font-size: 6px; } .langchat_yell { font-weight: bold; font-size: 10px; } .langchat_bolded { font-weight: bold; font-size: 8px; } .langchat_announce { font-weight: bold; font-size: 12px; } .langchat_bolditalicbig {font-weight: bold; font-size: 24px; font-style: italic; } .langchat_italic {font-style: italic; }"

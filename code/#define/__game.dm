//Admin perms are in global.dm.

#define DEBUG 0
#define r_TRU return TRUE //Handy shorthand.
#define r_FAL return FALSE

//Game defining directives.
#define SURFACE_Z_LEVELS list(1)
#define MAIN_SHIP_Z_LEVEL 3 //the main ship
#define MAIN_SHIP_AND_DROPSHIPS_Z_LEVELS list(3,4) //the main ship and the z level where dropships transit
#define ADMIN_Z_LEVEL 2
#define LOW_ORBIT_Z_LEVEL 4 //where the Almayer dropships stand when in transit.
#define GAME_PLAY_Z_LEVELS list(1,3,4)
#define MAIN_AI_SYSTEM "ARES v3.2"
#define MAIN_SHIP_ESCAPE_POD_NUMBER 18

#define MAP_ICE_COLONY "Ice Colony" // Highpop only
#define MAP_LV_624 "LV-624"
#define MAP_BIG_RED "Solaris Ridge"
#define MAP_PRISON_STATION "Prison Station"
#define MAP_WHISKEY_OUTPOST "Whiskey Outpost" // Unused
#define MAP_DESERT_DAM "Trijent Dam"  // Highpop only

#define PLAYERCOUNT_LOWPOP_MAP_LIMIT 130 // number of players before we switch to lowpop maps only (LV, BR, Prison)

/*
Trash Authority Directives
Defines for when we need to give commands to the trash authority in how to handle trash.
These are used with qdel (clean delete). For example, qdel(atom, TA_REVIVE_ME) would tell the TA to throw the atom into the recycler.
*/
#define TA_TRASH_ME		1 //Trash it.
#define TA_REVIVE_ME	2 //Not killing this one, instead adding it to the recycler. Call this on bullets, for example.
#define TA_PURGE_ME		3 //Purge it, but later. Not different from adding it to queue regularly as the trash authority will incinerate it when possible.
#define TA_PURGE_ME_NOW	4 //Purge it immediately. Generally don't want to use this.
#define TA_IGNORE_ME	5 //Ignore this atom, don't do anything with it. In case the atom will die on its own or something.
					 	  //Shouldn't usually use this as garbage collection is far better.

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
//=================================================

#define TOGGLES_CHAT_DEFAULT (CHAT_OOC|CHAT_DEAD|CHAT_GHOSTEARS|CHAT_GHOSTSIGHT|CHAT_PRAYER|CHAT_RADIO|CHAT_ATTACKLOGS|CHAT_LOOC|CHAT_GHOSTHIVEMIND)

#define TOGGLES_SOUND_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY)


// Game Intents
#define HELP_INTENT		"help"
#define HARM_INTENT		"harm"
#define GRAB_INTENT		"grab"
#define DISARM_INTENT	"disarm"


/*
	Shuttles
*/

// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
// note that this is multiplied by 10 in the shuttle controller. Hence, this is not defined in deciseconds but in real seconds

#define DOCK_ATTEMPT_TIMEOUT 			SECONDS_20	//how long in ticks we wait before assuming the docking controller is broken or blown up.
#define DROPSHIP_TRANSIT_DURATION		SECONDS_100	// 100 seconds
#define ELEVATOR_TRANSIT_DURATION		SECONDS_5	// 5 seconds
#define DROPSHIP_CRASH_TRANSIT_DURATION	SECONDS_90	// 90 seconds

#define SHUTTLE_RECHARGE  MINUTES_2 // 2 minutes
#define ELEVATOR_RECHARGE SECONDS_15  // 15 seconds

//Shuttle moving status
#define SHUTTLE_IDLE		0
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
#define ALARM_WARNING_FIRE 	1
#define ALARM_WARNING_ATMOS	2
#define ALARM_WARNING_EVAC	4
#define ALARM_WARNING_READY	8
#define ALARM_WARNING_DOWN	16

//some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26	//Used to trigger removal from a processing list

//=================================================
#define HOSTILE_STANCE_IDLE 1
#define HOSTILE_STANCE_ALERT 2
#define HOSTILE_STANCE_ATTACK 3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED 5
//=================================================

#define ROUNDSTART_LOGOUT_REPORT_TIME MINUTES_10 //Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.


//=================================================

//computer3 error codes, move lower in the file when it passes dev -Sayu
 #define PROG_CRASH      1  // Generic crash
 #define MISSING_PERIPHERAL  2  // Missing hardware
 #define BUSTED_ASS_COMPUTER  4  // Self-perpetuating error.  BAC will continue to crash forever.
 #define MISSING_PROGRAM    8  // Some files try to automatically launch a program.  This is that failing.
 #define FILE_DRM      16  // Some files want to not be copied/moved.  This is them complaining that you tried.
 #define NETWORK_FAILURE  32
//=================================================
//Game mode related defines.

var/list/accessable_z_levels = list("1" = 10, "3" = 10, "4" = 10, "5" = 70)
//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
//(Exceptions: extended, sandbox and nuke) -Errorage
//Was list("3" = 30, "4" = 70).
//Spacing should be a reliable method of getting rid of a body -- Urist.
//Go away Urist, I'm restoring this to the longer list. ~Errorage

#define TRANSITIONEDGE	3 //Distance from edge to move to another z-level


var/static/list/scarySounds = list('sound/weapons/thudswoosh.ogg','sound/weapons/Taser.ogg','sound/weapons/armbomb.ogg','sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg','sound/voice/hiss5.ogg','sound/voice/hiss6.ogg','sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg','sound/items/Welder.ogg','sound/items/Welder2.ogg','sound/machines/airlock.ogg','sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
//Flags for zone sleeping
#define ZONE_ACTIVE 1
#define ZONE_SLEEPING 0
#define GET_RANDOM_FREQ rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

//ceiling types
#define CEILING_NONE 0
#define CEILING_GLASS 1
#define CEILING_METAL 2
#define CEILING_UNDERGROUND 3
#define CEILING_UNDERGROUND_METAL 4
#define CEILING_DEEP_UNDERGROUND 5
#define CEILING_DEEP_UNDERGROUND_METAL 5

// Default font settings
#define FONT_SIZE "5pt"
#define FONT_COLOR "#09f"
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

// Defines for wall types
#define WALL_METAL (1<<1)
#define WALL_HULL (1<<2)
#define WALL_WHITE (1<<3)
#define WALL_SULACO (1<<4)
#define WALL_HANGAR (1<<5)
#define WALL_REINFORCED (1<<6)
#define WALL_REINFORCED_RESEARCH (1<<7)
#define WALL_REINFORCED_IRON (1<<8)
#define WALL_REINFORCED_CHIGUSA (1<<9)
#define WALL_REINFORCED_BUNKER (1<<10)
#define WALL_RESIN (1<<11)
#define WALL_THICKRESIN (1<<12)
#define WALL_MEMBRANE (1<<13)
#define WALL_THICKMEMBRANE (1<<14)
#define WALL_CAVE (1<<15)
#define WALL_WOOD (1<<16)
#define WALL_GOLD (1<<17)
#define WALL_CULT (1<<18)
#define WALL_STONE (1<<19)

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
#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

// Misc client defines
#define MIN_FPS 0
#define MAX_FPS 100

// Defines for shuttles (primarily to separate dropships and elevators)
#define SHUTTLE_DROPSHIP 1
#define SHUTTLE_ELEVATOR 2

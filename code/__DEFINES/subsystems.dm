//! Defines for subsystems and overlays
//!
//! Lots of important stuff in here, make sure you have your brain switched on
//! when editing this file

//! ## Timing subsystem
/**
* Don't run if there is an identical unique timer active
*
* if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
* and returns the id of the existing timer
*/
#define TIMER_UNIQUE (1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE (1<<1)

/**
* Timing should be based on how timing progresses on clients, not the server.
*
* Tracking this is more expensive,
* should only be used in conjuction with things that have to progress client side, such as
* animate() or sound()
*/
#define TIMER_CLIENT_TIME (1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE (1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT (1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP (1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME (1<<6)

///Empty ID define
#define TIMER_ID_NULL -1

/// Used to trigger object removal from a processing list
#define PROCESS_KILL 26

//! ## Initialization subsystem

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 2
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 1

//! ### Initialization hints

///Nothing happens
#define INITIALIZE_HINT_NORMAL 0
/**
 * call LateInitialize at the end of all atom Initalization
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitialize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

///Call qdel on the atom after intialization
#define INITIALIZE_HINT_QDEL 2

///Call LateInitialize on roundstart
#define INITIALIZE_HINT_ROUNDSTART 3

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(flags_atom & INITIALIZED)) {\
		var/previous_initialized_value = SSatoms.initialized;\
		SSatoms.initialized = INITIALIZATION_INNEW_MAPLOAD;\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, FALSE, args);\
		SSatoms.initialized = previous_initialized_value;\
	}\
}

//! ### SS initialization hints
/**
 * Negative values incidate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guaranteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2

/// The default return value which must be overridden. Will succeed with a warning.
#define SS_INIT_NONE -1

/// Subsystem initialized sucessfully.
#define SS_INIT_SUCCESS 2

/// Successful, but don't print anything. Useful if subsystem was disabled.
#define SS_INIT_NO_NEED 3

//! ### SS initialization load orders
// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define SS_INIT_PROFILER 86
#define SS_INIT_INPUT   85
#define SS_INIT_TOPIC 83
#define SS_INIT_LOBBYART 82
#define SS_INIT_INFLUXDRIVER 28
#define SS_INIT_GARBAGE 24
#define SS_INIT_EVENTS 23.5
#define SS_INIT_HIJACK 22.6
#define SS_INIT_REDIS 22.5
#define SS_INIT_REAGENTS 22.1
#define SS_INIT_MAPPING 22
#define SS_INIT_NIGHTMARE   21.5
#define SS_INIT_TIMETRACK 21.1
#define SS_INIT_HUMANS  21
#define SS_INIT_WHO 20
#define SS_INIT_POWER   19
#define SS_INIT_PREDSHIPS 18
#define SS_INIT_INFLUXMCSTATS 12
#define SS_INIT_INFLUXSTATS 11
#define SS_INIT_LIGHTING 10
#define SS_INIT_LAW 6
#define SS_INIT_FZ_TRANSITIONS 5
#define SS_INIT_PROJECTILES 4.1
#define SS_INIT_ATOMS   4
#define SS_INIT_DECORATOR   3.7
#define SS_INIT_SHUTTLE 3.5
#define SS_INIT_LANDMARK    3.2
#define SS_INIT_MACHINES   3
#define SS_INIT_INTERIOR 2.7
#define SS_INIT_TECHTREE    2.5
#define SS_INIT_RADIO 2
#define SS_INIT_ASSETS 1
#define SS_INIT_TIMER   100
#define SS_INIT_UNSPECIFIED 0
#define SS_INIT_TICKER -21
#define SS_INIT_VOTE   -23
#define SS_INIT_DATABASE   -27
#define SS_INIT_ENTITYMANAGER   -28
#define SS_INIT_PLAYTIME   -29
#define SS_INIT_STICKY -30
#define SS_INIT_OBJECTIVES -32
#define SS_INIT_MINIMAP    -34
#define SS_INIT_STATPANELS -98
#define SS_INIT_CHAT    -100 //Should be last to ensure chat remains smooth during init.

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)

#define SS_PRIORITY_INPUT   1000
#define SS_PRIORITY_TIMER   700
#define SS_PRIORITY_AUTOFIRE 450
#define SS_PRIORITY_SOUND   250
#define SS_PRIORITY_TICKER  200
#define SS_PRIORITY_NIGHTMARE   180
#define SS_PRIORITY_QUADTREE    160
#define SS_PRIORITY_CHAT    155
#define SS_PRIORITY_STATPANEL    154
#define SS_PRIORITY_CELLAUTO    152
#define SS_PRIORITY_PROJECTILES 151
#define SS_PRIORITY_MOB 150
#define SS_PRIORITY_XENO    149
#define SS_PRIORITY_HUMAN   148
#define SS_PRIORITY_STAMINA 126
#define SS_PRIORITY_COMPONENT   125
#define SS_PRIORITY_NANOUI  120
#define SS_PRIORITY_TGUI    120
#define SS_PRIORITY_HIVE_STATUS 112
#define SS_PRIORITY_SHIELD_PILLAR  111
#define SS_PRIORITY_VOTE    110
#define SS_PRIORITY_FAST_OBJECTS   105
#define SS_PRIORITY_OBJECTS 104
#define SS_PRIORITY_DECORATOR    99
#define SS_PRIORITY_EFFECTS        97
#define SS_PRIORITY_FASTEFFECTS    96
#define SS_PRIORITY_HIJACK 97
#define SS_PRIORITY_POWER   95
#define SS_PRIORITY_OLDEFFECTS 92
#define SS_PRIORITY_MACHINERY   90
#define SS_PRIORITY_FZ_TRANSITIONS 88
#define SS_PRIORITY_ROUND_RECORDING 83
#define SS_PRIORITY_SHUTTLE 80
#define SS_PRIORITY_EVENT   65
#define SS_PRIORITY_DISEASE 60
#define SS_PRIORITY_DEFENSES 55
#define SS_PRIORITY_ENTITY    37
#define SS_PRIORITY_DEFCON  35
#define SS_PRIORITY_ACID_PILLAR    34
#define SS_PRIORITY_SOUNDLOOPS	   31
#define SS_PRIORITY_UNSPECIFIED 30
#define SS_PRIORITY_PROCESS 25
#define SS_PRIORITY_SOUNDSCAPE    24
#define SS_PRIORITY_INFLUXDRIVER  23
#define SS_PRIORITY_PAGER_STATUS   22
#define SS_PRIORITY_LIGHTING    20
#define SS_PRIORITY_TRACKING    19
#define SS_PRIORITY_DATABASE    15
#define SS_PRIORITY_MINIMAPS 11
#define SS_PRIORITY_PING    10
#define SS_PRIORITY_INFLUXMCSTATS 9
#define SS_PRIORITY_INFLUXSTATS 8
#define SS_PRIORITY_PLAYTIME    5
#define SS_PRIORITY_PERFLOGGING 4
#define SS_PRIORITY_GARBAGE 2
#define SS_PRIORITY_INACTIVITY  1
#define SS_PRIORITY_ADMIN   0

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

//SSticker.current_state values
/// Game is loading
#define GAME_STATE_STARTUP 0
/// Game is loaded and in pregame lobby
#define GAME_STATE_PREGAME 1
/// Game is attempting to start the round
#define GAME_STATE_SETTING_UP 2
/// Game has round in progress
#define GAME_STATE_PLAYING 3
/// Game has round finished
#define GAME_STATE_FINISHED 4

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
	* * timer_subsystem the subsystem to insert this timer into
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"

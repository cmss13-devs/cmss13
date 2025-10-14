// Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

///from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_NEW_Z "!new_z"
/// sent after world.maxx and/or world.maxy are expanded: (has_exapnded_world_maxx, has_expanded_world_maxy)
#define COMSIG_GLOB_EXPANDED_WORLD_BOUNDS "!expanded_world_bounds"
///from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_VEHICLE_ORDERED "!vehicle_ordered"
/// from /datum/controller/subsystem/ticker/fire
#define COMSIG_GLOB_MODE_PREGAME_LOBBY "!mode_pregame_lobby"
///from /datum/game_mode/proc/pre_setup
#define COMSIG_GLOB_MODE_PRESETUP "!mode_presetup"
///from /datum/game_mode/proc/post_setup
#define COMSIG_GLOB_MODE_POSTSETUP "!mode_postsetup"
///from /datum/game_mode/proc/ds_first_landed
#define COMSIG_GLOB_DS_FIRST_LANDED "!ds_first_landed"
///from /mob/living/carbon/human/death
#define COMSIG_GLOB_MARINE_DEATH "!marine_death"
///from /mob/living/carbon/xenomorph/death
#define COMSIG_GLOB_XENO_DEATH "!xeno_death"
/// called after a successful var edit somewhere in the world: (list/args)
#define COMSIG_GLOB_VAR_EDIT "!var_edit"

#define COMSIG_GLOB_CONFIG_LOADED "!config_loaded"

///from /mob/living/carbon/xenomorph/initialize
#define COMSIG_GLOB_XENO_SPAWN "!xeno_spawn"

#define COMSIG_GLOB_REMOVE_VOTE_BUTTON "!remove_vote_button"

/// Called from /client/New() when a client logs in to the game: (client)
#define COMSIG_GLOB_CLIENT_LOGGED_IN "!client_logged_in"

/// Called from /mob/Login() when a client logs into a mob: (mob)
#define COMSIG_GLOB_MOB_LOGGED_IN "!mob_logged_in"

///from /datum/controller/subsystem/ticker/PostSetup
#define COMSIG_GLOB_POST_SETUP "!post_setup"

///from /proc/set_security_level
#define COMSIG_GLOB_SECURITY_LEVEL_CHANGED "!security_level_changed"

/// Called by (/datum/round_event_control/RunEvent).
#define COMSIG_GLOB_RANDOM_EVENT "!random_event"
	/// Do not allow this random event to continue.
	#define CANCEL_RANDOM_EVENT (1<<0)

// Used for smothering fires upon weather event start/stop
#define COMSIG_GLOB_WEATHER_CHANGE "!weather_event_changed"

/// From /obj/structure/machinery/telecomms/proc/tcomms_shutdown(), called when the relay turns off
#define COMSIG_GLOB_GROUNDSIDE_TELECOMM_TURNED_OFF "!groundside_telecomm_turned_off"

/// From /datum/admins/proc/force_predator_round()
#define COMSIG_GLOB_PREDATOR_ROUND_TOGGLED "!predator_round_toggled"

/// From /datum/game_mode/colonialmarines/proc/check_ground_humans()
#define COMSIG_GLOB_GROUNDSIDE_FORSAKEN_HANDLING "!groundside_forsaken_handling"

#define COMSIG_GLOB_BOOST_XENOMORPH_WALLS "!boost_xenomorph_walls"

#define COMSIG_GLOB_STOP_BOOST_XENOMORPH_WALLS "!stop_boost_xenomorph_walls"


/// From
#define COMSIG_GLOB_YAUTJA_ARMORY_OPENED "!yautja_armory_opened"

/// For opening hunting grounds shutters
#define COMSIG_GLOB_YAUTJA_PRESERVE_OPENED "!yautja_preserve_opened"

/// For closing hunting grounds shutters
#define COMSIG_GLOB_YAUTJA_PRESERVE_CLOSED "!yautja_preserve_closed"

/// From /proc/biohazard_lockdown()
#define COMSIG_GLOB_RESEARCH_LOCKDOWN "!research_lockdown_closed"
#define COMSIG_GLOB_RESEARCH_LIFT "!research_lockdown_opened"
/// From /proc/aicore_lockdown()
#define COMSIG_GLOB_AICORE_LOCKDOWN "!aicore_lockdown_closed"
#define COMSIG_GLOB_AICORE_LIFT "!aicore_lockdown_opened"

/// From /obj/structure/machinery/power/power_generator/reactor/proc/set_overloading() : (set_overloading)
#define COMSIG_GLOB_GENERATOR_SET_OVERLOADING "!generator_set_overloading"

#define COMSIG_GLOB_HIJACK_IMPACTED "!hijack_impacted"
#define COMSIG_GLOB_HIJACK_LANDED "!hijack_landed"

/// From /datum/controller/subsystem/hijack/fire()
#define COMSIG_GLOB_FUEL_PUMP_UPDATE "!fuel_pump_update"

/// From /obj/structure/machinery/computer/overwatch/proc/fire_bombard() : (turf/bombarded)
#define COMSIG_GLOB_ORBITAL_BOMBARDMENT "!orbital_bombardment"

/// From /mob/living/xenomorph/death() : (dead_queen)
#define COMSIG_GLOB_QUEEN_DEATH "!queen_death"

/// From /datum/dropship_hijack/almayer/proc/check_final_approach() : (impact_turf)
#define COMSIG_GLOB_DROPSHIP_IMPACT "!dropship_impact"

/// From /obj/structure/machinery/computer/shuttle/dropship/flight/attack_alien() : (hacked_console)
#define COMSIG_GLOB_DROPSHIP_LOCKED "!dropship_locked"

/// From /datum/cas_fire_envelope/proc/execute_firemission_unsafe() : (impact_turf)
#define COMSIG_GLOB_FIREMISSION_IMBOUND "!firemission_imbound"

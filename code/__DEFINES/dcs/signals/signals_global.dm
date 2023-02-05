// Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

///from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_NEW_Z "!new_z"
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

///from /mob/living/carbon/xenomorph/initialize
#define COMSIG_GLOB_XENO_SPAWN "!xeno_spawn"

#define COMSIG_GLOB_REMOVE_VOTE_BUTTON "!remove_vote_button"

#define COMSIG_GLOB_CLIENT_LOGIN "!client_login"

#define COMSIG_GLOB_MOB_LOGIN "!mob_login"

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

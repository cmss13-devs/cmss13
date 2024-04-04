#define COMSIG_CLIENT_LMB_DOWN "client_lmb_down"
#define COMSIG_CLIENT_LMB_UP "client_lmb_up"
#define COMSIG_CLIENT_LMB_DRAG "client_lmb_drag"

#define COMSIG_CLIENT_KEY_DOWN "client_key_down"
#define COMSIG_CLIENT_KEY_UP "client_key_up"

///from /mob/do_click(): (atom/A, list/mods)
#define COMSIG_CLIENT_PRE_CLICK "client_pre_click"

#define COMSIG_CLIENT_RESET_VIEW "client_reset_view"

#define COMSIG_CLIENT_MOB_MOVE "client_mob_move"
	#define COMPONENT_OVERRIDE_MOVE (1<<0)

/// Called after one or more verbs are added: (list of verbs added)
#define COMSIG_CLIENT_VERB_ADDED "client_verb_added"

/// Called after one or more verbs are added: (list of verbs added)
#define COMSIG_CLIENT_VERB_REMOVED "client_verb_removed"

/// Called from /mob/Login() after a client logs into a mob: (mob)
#define COMSIG_CLIENT_MOB_LOGGED_IN "client_mob_logged_in"

/// Called when something is added to a client's screen : /client/proc/add_to_screen(screen_add)
#define COMSIG_CLIENT_SCREEN_ADD "client_screen_add"

/// Called when something is removed from a client's screen : /client/proc/remove_from_screen(screen_remove)
#define COMSIG_CLIENT_SCREEN_REMOVE "client_screen_remove"

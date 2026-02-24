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

/// Called when escape menu is opened CLIENT_VERB(open_escape_menu)
#define COMSIG_CLIENT_ESCAPE_MENU_OPEN "client_escape_menu_opened"

/// Called when something is added to a client's screen : /client/proc/add_to_screen(screen_add)
#define COMSIG_CLIENT_SCREEN_ADD "client_screen_add"

/// Called when something is removed from a client's screen : /client/proc/remove_from_screen(screen_remove)
#define COMSIG_CLIENT_SCREEN_REMOVE "client_screen_remove"

/// Called when the eye is modified through the set_eye() setter : /client/proc/set_eye(new_eye)
#define COMSIG_CLIENT_EYE_CHANGED "client_eye_changed"

/// Called when pixel_x is modified through the set_pixel_x() setter : /client/proc/set_pixel_x(new_pixel_x)
#define COMSIG_CLIENT_PIXEL_X_CHANGED "client_pixel_x_changed"

/// Called when pixel_y is modified through the set_pixel_y() setter : /client/proc/set_pixel_y(new_pixel_y)
#define COMSIG_CLIENT_PIXEL_Y_CHANGED "client_pixel_y_changed"

/// Called when view is modified through the change_view() setter : /client/proc/change_view(new_view)
#define COMSIG_CLIENT_VIEW_CHANGED "client_changed_view"

/// Called in /client/proc/PreLogin() after a client's mob has been logged into
#define COMSIG_CLIENT_LOGGED_IN "client_logged_in"

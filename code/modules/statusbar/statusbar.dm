#define SHOW_ON_STATUSBAR(type)\
##type/MouseEntered(location, control, params){\
	var/client/client = usr.client;\
	if(client.prefs?.hide_statusbar){\
		winset(client, "mapwindow.status_bar", "is-visible=false");\
		return;\
	}\
	winset(client, "mapwindow.status_bar", "text=\"[name]\"");\
};\
##type/MouseExited(location, control, params){\
	var/client/client = usr.client;\
	if(client.prefs?.hide_statusbar){\
		return;\
	}\
	winset(client, "mapwindow.status_bar", "text=\"\"");\
}

SHOW_ON_STATUSBAR(/mob)
SHOW_ON_STATUSBAR(/obj/item)
SHOW_ON_STATUSBAR(/obj/structure)
SHOW_ON_STATUSBAR(/obj/effect)
SHOW_ON_STATUSBAR(/atom/movable/screen/action_button)
SHOW_ON_STATUSBAR(/atom/movable/screen/gun)
SHOW_ON_STATUSBAR(/atom/movable/screen/throw_catch)
SHOW_ON_STATUSBAR(/atom/movable/screen/drop)
SHOW_ON_STATUSBAR(/atom/movable/screen/resist)
SHOW_ON_STATUSBAR(/atom/movable/screen/act_intent)
SHOW_ON_STATUSBAR(/atom/movable/screen/pull)
SHOW_ON_STATUSBAR(/atom/movable/screen/xenonightvision)
SHOW_ON_STATUSBAR(/atom/movable/screen/toggle_inv)
SHOW_ON_STATUSBAR(/obj/vehicle)
SHOW_ON_STATUSBAR(/turf/closed)

#undef SHOW_ON_STATUSBAR

#define SHOW_ON_STATUSBAR(type)\
##type/MouseEntered(location, control, params){\
	var/client/client = usr.client;\
	if(client.prefs?.hide_statusbar){\
		return;\
	}\
	winset(client, "atom_name", "text=\"[name]\"");\
};\
##type/MouseExited(location, control, params){\
	var/client/client = usr.client;\
	if(client.prefs?.hide_statusbar){\
		return;\
	}\
	winset(client, "atom_name", "text=\"\"");\
}

SHOW_ON_STATUSBAR(/mob)
SHOW_ON_STATUSBAR(/obj/item)
SHOW_ON_STATUSBAR(/obj/structure)
SHOW_ON_STATUSBAR(/obj/effect)
SHOW_ON_STATUSBAR(/obj/screen/action_button)
SHOW_ON_STATUSBAR(/obj/screen/gun)
SHOW_ON_STATUSBAR(/obj/screen/throw_catch)
SHOW_ON_STATUSBAR(/obj/screen/drop)
SHOW_ON_STATUSBAR(/obj/screen/resist)
SHOW_ON_STATUSBAR(/obj/screen/act_intent)
SHOW_ON_STATUSBAR(/obj/screen/pull)
SHOW_ON_STATUSBAR(/obj/screen/xenonightvision)
SHOW_ON_STATUSBAR(/obj/screen/toggle_inv)
SHOW_ON_STATUSBAR(/obj/vehicle)
SHOW_ON_STATUSBAR(/turf/closed)

#undef SHOW_ON_STATUSBAR

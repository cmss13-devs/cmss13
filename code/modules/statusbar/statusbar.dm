#define SHOW_ON_STATUSBAR(type)\
##type/MouseEntered(location, control, params){\
	var/client/client = usr.client;\
	if(client.prefs?.hide_statusbar){\
		winset(client, "mapwindow.status_bar", "is-visible=false");\
		return;\
	}\
	var/display_text = name;\
	if(isxeno(usr) && ishuman(src)) {\
		var/mob/living/carbon/human/H = src;\
		var/h_desc = GLOB.human_gender_descriptors[H.gender] || "strange";\
		display_text = "a [h_desc] tall host";\
	}\
	else if(ishuman(usr) && isxeno(src)) {\
		var/mob/living/carbon/xenomorph/X = src;\
		var/x_desc = GLOB.xeno_caste_descriptors[X.caste_type] || "strange";\
		display_text = "a [x_desc] alien";\
	}\
	winset(client, "mapwindow.status_bar", "text=\"[display_text]\"");\
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

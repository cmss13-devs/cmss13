/datum/keybinding/movement
	category = CATEGORY_MOVEMENT
	weight = WEIGHT_HIGHEST

/datum/keybinding/movement/north
	hotkey_keys = list("W", "North")
	name = "North"
	full_name = "Move North"
	description = "Moves your character north"
	keybind_signal = COMSIG_KB_MOVEMENT_NORTH_DOWN

/datum/keybinding/movement/northface
	hotkey_keys = list("Alt+North", "Alt+W")
	name = "face_north"
	full_name = "Face North"
	description = "Face north"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_NORTH_DOWN

/datum/keybinding/movement/northface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.northfaceperm()
	return TRUE

/datum/keybinding/movement/south
	hotkey_keys = list("S", "South")
	name = "South"
	full_name = "Move South"
	description = "Moves your character south"
	keybind_signal = COMSIG_KB_MOVEMENT_SOUTH_DOWN

/datum/keybinding/movement/southface
	hotkey_keys = list("Alt+South", "Alt+S")
	name = "face_south"
	full_name = "Face South"
	description = "Face south"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_SOUTH_DOWN

/datum/keybinding/movement/southface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.southfaceperm()
	return TRUE
/datum/keybinding/movement/west
	hotkey_keys = list("A", "West")
	name = "West"
	full_name = "Move West"
	description = "Moves your character left"
	keybind_signal = COMSIG_KB_MOVEMENT_WEST_DOWN

/datum/keybinding/movement/westface
	hotkey_keys = list("Alt+West", "Alt+A")
	name = "face_west"
	full_name = "Face West"
	description = "Face west"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_WEST_DOWN

/datum/keybinding/movement/westface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.westfaceperm()
	return TRUE

/datum/keybinding/movement/east
	hotkey_keys = list("D", "East")
	name = "East"
	full_name = "Move East"
	description = "Moves your character east"
	keybind_signal = COMSIG_KB_MOVEMENT_EAST_DOWN

/datum/keybinding/movement/eastface
	hotkey_keys = list("Alt+East", "Alt+D")
	name = "face_east"
	full_name = "Face East"
	description = "Face east"
	keybind_signal = COMSIG_KB_MOVEMENT_FACE_EAST_DOWN

/datum/keybinding/movement/eastface/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.eastfaceperm()
	return TRUE

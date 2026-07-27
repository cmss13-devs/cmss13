GLOBAL_LIST_EMPTY(classic_keybinding_list_by_key)
GLOBAL_LIST_EMPTY(hotkey_keybinding_list_by_key)

GLOBAL_LIST_EMPTY(keybindings_by_name)

// This is a mapping from JS keys to Byond - ref: https://keycode.info/
GLOBAL_LIST_INIT(_kbMap, list(
	"UP" = "North",
	"ARROWUP" = "North",
	"RIGHT" = "East",
	"ARROWRIGHT" = "East",
	"DOWN" = "South",
	"ARROWDOWN" = "South",
	"LEFT" = "West",
	"ARROWLEFT" = "West",
	"INSERT" = "Insert",
	"HOME" = "Northwest",
	"PAGEUP" = "Northeast",
	"DEL" = "Delete", // Unlikely this is correct now
	"DELETE" = "Delete",
	"END" = "Southwest",
	"PAGEDOWN" = "Southeast",
	"SPACEBAR" = "Space",
	"ENTER" = "Return",
	"ALT" = "Alt",
	"SHIFT" = "Shift",
	"CONTROL" = "Ctrl",
	"MULTIPLY" = "Multiply",
	"DIVIDE" = "Divide",
	"SUBTRACT" = "Subtract",
	"ADD" = "Add",
	"DECIMAL" = "Decimal",
	"CLEAR" = "Center",
	"PAUSE" = "Pause",
	"CONTEXTMENU" = "Apps",
	"NUMLOCK" = "Numlock",
	"SCROLLLOCK" = "Scroll",
	"MEDIANEXTTRACK" = "MediaNext",
	"MEDIAPLAYPAUSE" = "MediaPlayPause",
	"MEDIASTOP" = "MediaStop",
	"MEDIAPREVIOUSTRACK" = "MediaPrev",
	"VOLUMEMUTE" = "VolumeMute",
	"VOLUMEUP" = "VolumeUp",
	"VOLUMEDOWN" = "VolumeDown",
	))

///List of ckeys that have seen a blurb of a given key.
GLOBAL_LIST_EMPTY(blurb_witnesses)

/// dict of ckey -> last occupied mob
GLOBAL_LIST_EMPTY(ckey_to_occupied_mob)

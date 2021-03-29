GLOBAL_LIST_EMPTY(classic_keybinding_list_by_key)
GLOBAL_LIST_EMPTY(hotkey_keybinding_list_by_key)

// This is a mapping from JS keys to Byond - ref: https://keycode.info/
GLOBAL_LIST_INIT(_kbMap, list(
	"UP" = "North",
	"RIGHT" = "East",
	"DOWN" = "South",
	"LEFT" = "West",
	"INSERT" = "Insert",
	"HOME" = "Northwest",
	"PAGEUP" = "Northeast",
	"DEL" = "Delete",
	"END" = "Southwest",
	"PAGEDOWN" = "Southeast",
	"SPACEBAR" = "Space",
	"ENTER" = "Return",
	"ALT" = "Alt",
	"SHIFT" = "Shift",
	"CONTROL" = "Ctrl"
	))

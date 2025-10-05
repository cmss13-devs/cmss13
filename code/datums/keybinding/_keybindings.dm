GLOBAL_LIST_EMPTY(keybinding_signal_map) // SS220 EDIT ADDICTION

/datum/keybinding
	var/list/hotkey_keys
	var/list/classic_keys
	var/name
	var/full_name
	var/description = ""
	var/category = CATEGORY_MISC
	var/weight = WEIGHT_LOWEST
	var/keybind_signal
	var/list/keybinding_signal_map = list() // SS220 EDIT ADDICTION

/datum/keybinding/New()
	if(!keybind_signal)
		CRASH("Keybind [src] called unredefined down() without a keybind_signal.")
	// SS220 START EDIT ADDICTION
	if(!isnull(name))
		GLOB.keybinding_signal_map[keybind_signal] = lowertext(replacetext(name, " ", "_"))
	// SS220 END EDIT ADDICTION
	// Default keys to the master "hotkey_keys"
	if(LAZYLEN(hotkey_keys) && !islist(classic_keys))
		classic_keys = hotkey_keys.Copy()

/datum/keybinding/proc/down(client/user)
	SHOULD_CALL_PARENT(TRUE)
	return SEND_SIGNAL(user.mob, keybind_signal) & COMPONENT_KB_ACTIVATED

/datum/keybinding/proc/up(client/user)
	return FALSE

/datum/keybinding/proc/can_use(client/user)
	return TRUE

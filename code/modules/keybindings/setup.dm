// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return
/datum/proc/key_up(key, client/user) // Called when a key is released
	return
/datum/proc/keyLoop(client/user) // Called once every frame
	set waitfor = FALSE
	return

/// Erases macros set by the keybinding system
/client/proc/erase_all_macros()
	var/erase_output = ""
	var/list/macro_set = params2list(winget(src, "default.*", "command")) // The third arg doesnt matter here as we're just removing them all
	for(var/k in 1 to length(macro_set))
		var/list/split_name = splittext(macro_set[k], ".")

		if(findtext(split_name[2], "srvkeybinds-") == 1)
			var/macro_name = "[split_name[1]].[split_name[2]]" // [3] is "command"
			erase_output = "[erase_output];[macro_name].parent=null"
	winset(src, null, erase_output)

/// Request blocking update of keybinds to client, clearing old ones
/client/proc/set_macros()
	reset_held_keys() // Reset key buffer to clear state
	erase_all_macros()

	var/list/macro_set = SSinput.macro_set
	for(var/k in 1 to length(macro_set))
		var/key = macro_set[k]
		var/command = macro_set[key]
		winset(src, "srvkeybinds-[REF(key)]", "parent=default;name=[key];command=[command]")
	winset(src, null, "input.focus=true")
	update_special_keybinds()

GLOBAL_LIST_INIT(keybind_combos, list(
	"Alt",
	"Ctrl",
	"Shift"
))

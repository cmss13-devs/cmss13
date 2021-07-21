GLOBAL_LIST_INIT(ui_data_keybindings, generate_keybind_ui_data())

/proc/generate_keybind_ui_data()
	. = list()
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		.[kb.category] += list(list(
			"name" = kb.name,
			"full_name" = kb.full_name,
			"hotkey" = kb.hotkey_keys,
			"classic" = kb.classic_keys,
		))

/datum/tgui_macro
	var/client/owner
	var/datum/preferences/prefs

/datum/tgui_macro/New(var/client/C, var/datum/preferences/P)
	. = ..()
	owner = C
	if(C)
		INVOKE_ASYNC(C, /client/proc/set_macros)
	prefs = P

/datum/tgui_macro/ui_data(mob/user)
	. = list()
	.["keybinds"] = prefs.key_bindings

/datum/tgui_macro/ui_static_data(mob/user)
	. = list()
	.["glob_keybinds"] = GLOB.ui_data_keybindings

/datum/tgui_macro/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_macro/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(user.client != owner)
		return UI_CLOSE

/datum/tgui_macro/tgui_interact(mob/user, datum/tgui/ui)
	if(user.client != owner)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KeyBinds", "Keybind Preference")
		ui.open()

/datum/tgui_macro/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_keybind")
			var/kb_name = params["keybind_name"]

			var/list/kbinds = prefs.key_bindings

			var/old_key = params["old_key"]

			var/mods = sortList(params["key_mods"]).Join("+")

			var/full_key = params["key"]
			if(mods)
				full_key = "[mods]+[full_key]"

			if(!params["key"])
				if(kbinds[old_key])
					kbinds[old_key] -= kb_name
					if(!length(kbinds[old_key]))
						kbinds -= old_key
				INVOKE_ASYNC(owner, /client/proc/set_macros)
				prefs.save_preferences()
				return

			var/list/tempList = list()
			for(var/i in splittext(full_key, "+"))
				if(GLOB._kbMap[i])
					tempList += GLOB._kbMap[i]
				else
					tempList += i
			full_key = tempList.Join("+")

			if(kb_name in kbinds[full_key]) //We pressed the same key combination that was already bound here, so let's remove to re-add and re-sort.
				kbinds[full_key] -= kb_name

			if(kbinds[old_key])
				kbinds[old_key] -= kb_name
				if(!length(kbinds[old_key]))
					kbinds -= old_key

			kbinds[full_key] += list(kb_name)
			kbinds[full_key] = sortList(kbinds[full_key])

			prefs.save_preferences()
			INVOKE_ASYNC(owner, /client/proc/set_macros)
			return TRUE
		if("clear_keybind")
			var/list/kbinds = prefs.key_bindings
			var/kb_name = params["keybinding"]
			var/list/keys = params["key"]
			if(!islist(keys))
				return

			for(var/key in keys)
				if(kbinds[key])
					kbinds[key] -= kb_name
					if(!length(kbinds[key]))
						kbinds -= key

			prefs.save_preferences()
			return TRUE
		if("clear_all_keybinds")
			var/choice = tgui_alert(owner, "Would you prefer 'hotkey' or 'classic' defaults?", "Setup keybindings", list("Hotkey", "Classic", "Cancel"))
			if(choice == "Cancel")
				return TRUE
			prefs.hotkeys = (choice == "Hotkey")
			prefs.key_bindings = (prefs.hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
			INVOKE_ASYNC(owner, /client/proc/set_macros)
			prefs.save_preferences()
			return TRUE

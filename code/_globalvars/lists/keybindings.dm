GLOBAL_LIST_INIT(keybindings_by_name, init_keybindings())

/// Creates and sorts all the keybinding datums
/proc/init_keybindings()
	. = list()
	for(var/KB in subtypesof(/datum/keybinding))
		var/datum/keybinding/keybinding = KB
		if(!initial(keybinding.keybind_signal) || !initial(keybinding.name))
			continue
		add_keybinding(new keybinding, .)
	//init_emote_keybinds()

/// Adds an instanced keybinding to the global tracker
/proc/add_keybinding(datum/keybinding/instance, var/list/to_add_to)
	to_add_to[instance.name] = instance

	// Classic
	if(LAZYLEN(instance.classic_keys))
		for(var/bound_key in instance.classic_keys)
			LAZYADD(GLOB.classic_keybinding_list_by_key[bound_key], list(instance.name))

	// Hotkey
	if(LAZYLEN(instance.hotkey_keys))
		for(var/bound_key in instance.hotkey_keys)
			LAZYADD(GLOB.hotkey_keybinding_list_by_key[bound_key], list(instance.name))

/*
/proc/init_emote_keybinds()
	for(var/i in subtypesof(/datum/emote))
		var/datum/emote/faketype = i
		if(!initial(faketype.key))
			continue
		var/datum/keybinding/emote/emote_kb = new
		emote_kb.link_to_emote(faketype)
		add_keybinding(emote_kb)
*/

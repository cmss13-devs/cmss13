/datum/controller/configuration
	name = "Configuration"

	var/directory = "config"
	var/map_directory = "map_config"

	var/warned_deprecated_configs = FALSE
	var/hiding_entries_by_type = TRUE //Set for readability, admins can set this to FALSE if they want to debug it
	var/list/entries
	var/list/entries_by_type

	var/list/list/maplist
	var/list/defaultmaps

	var/list/modes // allowed modes
	var/list/gamemode_cache
	var/list/mode_names

	var/motd
	var/policy

	var/static/regex/ic_filter_regex

/datum/controller/configuration/proc/admin_reload()
	if(IsAdminAdvancedProcCall())
		return
	log_admin("[key_name(usr)] has forcefully reloaded the configuration from disk.")
	message_admins("[key_name_admin(usr)] has forcefully reloaded the configuration from disk.")
	full_wipe()
	Load(world.params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])


/datum/controller/configuration/proc/Load(_directory)
	if(IsAdminAdvancedProcCall()) //If admin proccall is detected down the line it will horribly break everything.
		return
	if(_directory)
		directory = _directory
	if(entries)
		CRASH("/datum/controller/configuration/Load() called more than once!")
	InitEntries()
	LoadModes()
	if(fexists("[directory]/config.txt") && LoadEntries("config.txt") <= 1)
		var/list/legacy_configs = list("dbconfig.txt")
		for(var/I in legacy_configs)
			if(fexists("[directory]/[I]"))
				log_config("No $include directives found in config.txt! Loading legacy [legacy_configs.Join("/")] files...")
				for(var/J in legacy_configs)
					LoadEntries(J)
				break
	loadmaplist(CONFIG_GROUND_MAPS_FILE, GROUND_MAP)
	loadmaplist(CONFIG_SHIP_MAPS_FILE, SHIP_MAP)
	LoadChatFilter()

	if(Master)
		Master.OnConfigLoad()


/datum/controller/configuration/proc/loadmaplist(filename, maptype)
	log_config("Loading config file [filename]...")
	filename = "[map_directory]/[filename]"
	var/list/Lines = file2list(filename)

	var/datum/map_config/currentmap
	for(var/t in Lines)
		if(!t)
			continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/command = null
		var/data = null

		if(pos)
			command = lowertext(copytext(t, 1, pos))
			data = copytext(t, pos + 1)
		else
			command = lowertext(t)

		if(!command)
			continue

		if(!currentmap && command != "map")
			continue

		switch(command)
			if("map")
				currentmap = load_map_config("maps/[data].json")
				if(currentmap.defaulted)
					log_config("Failed to load map config for [data]!")
					currentmap = null
			if("minplayers", "minplayer")
				currentmap.config_min_users = text2num(data)
			if("maxplayers", "maxplayer")
				currentmap.config_max_users = text2num(data)
			if("weight", "voteweight")
				currentmap.voteweight = text2num(data)
			if("default", "defaultmap")
				LAZYINITLIST(defaultmaps)
				defaultmaps[maptype] = currentmap
			if("endmap")
				LAZYINITLIST(maplist)
				LAZYINITLIST(maplist[maptype])
				maplist[maptype][currentmap.map_name] = currentmap
				currentmap = null
			if("disabled")
				currentmap = null
			else
				log_config("Unknown command in map vote config: '[command]'")


/datum/controller/configuration/proc/full_wipe()
	if(IsAdminAdvancedProcCall())
		return
	entries_by_type.Cut()
	QDEL_LIST_ASSOC_VAL(entries)
	entries = null
	for(var/list/map in maplist)
		QDEL_LIST_ASSOC_VAL(map)
	maplist = null
	QDEL_LIST_ASSOC_VAL(defaultmaps)
	defaultmaps = null


/datum/controller/configuration/Destroy()
	full_wipe()
	config = null

	return ..()


/datum/controller/configuration/proc/InitEntries()
	var/list/_entries = list()
	entries = _entries
	var/list/_entries_by_type = list()
	entries_by_type = _entries_by_type

	for(var/I in typesof(/datum/config_entry)) //typesof is faster in this case
		var/datum/config_entry/current_entry = I
		if(initial(current_entry.abstract_type) == I)
			continue
		current_entry = new I
		var/esname = current_entry.name
		var/datum/config_entry/test = _entries[esname]
		if(test)
			log_config("Error: [test.type] has the same name as [current_entry.type]: [esname]! Not initializing [current_entry.type]!")
			qdel(current_entry)
			continue
		_entries[esname] = current_entry
		_entries_by_type[I] = current_entry


/datum/controller/configuration/proc/RemoveEntry(datum/config_entry/CE)
	entries -= CE.name
	entries_by_type -= CE.type


/datum/controller/configuration/proc/LoadEntries(filename, list/stack = list())
	if(IsAdminAdvancedProcCall())
		return

	var/filename_to_test = world.system_type == MS_WINDOWS ? lowertext(filename) : filename
	if(filename_to_test in stack)
		log_config("Warning: Config recursion detected ([english_list(stack)]), breaking!")
		return
	stack = stack + filename_to_test

	log_config("Loading config file [filename]...")
	var/list/lines = file2list("[directory]/[filename]")
	var/list/_entries = entries
	for(var/config in lines)
		config = trim(config)
		if(!config)
			continue

		var/firstchar = config[1]
		if(firstchar == "#")
			continue

		var/lockthis = firstchar == "@"
		if(lockthis)
			config = copytext(config, length(firstchar) + 1)

		var/pos = findtext(config, " ")
		var/entry = null
		var/value = null

		if(pos)
			entry = lowertext(copytext(config, 1, pos))
			value = copytext(config, pos + length(config[pos]))
		else
			entry = lowertext(config)

		if(!entry)
			continue

		if(entry == "$include")
			if(!value)
				log_config("Warning: Invalid $include directive: [value]")
			else
				LoadEntries(value, stack)
				++.
			continue

		var/datum/config_entry/current_entry = _entries[entry]
		if(!current_entry)
			log_config("Unknown setting in configuration: '[entry]'")
			continue

		if(lockthis)
			current_entry.protection |= CONFIG_ENTRY_LOCKED

		if(current_entry.deprecated_by)
			var/datum/config_entry/new_ver = entries_by_type[current_entry.deprecated_by]
			var/new_value = current_entry.DeprecationUpdate(value)
			var/good_update = istext(new_value)
			log_config("Entry [entry] is deprecated and will be removed soon. Migrate to [new_ver.name]![good_update ? " Suggested new value is: [new_value]" : ""]")
			if(!warned_deprecated_configs)
				DelayedMessageAdmins("This server is using deprecated configuration settings. Please check the logs and update accordingly.")
				warned_deprecated_configs = TRUE
			if(good_update)
				value = new_value
				current_entry = new_ver
			else
				warning("[new_ver.type] is deprecated but gave no proper return for DeprecationUpdate()")

		var/validated = current_entry.ValidateAndSet(value)
		if(!validated)
			log_config("Failed to validate setting \"[value]\" for [entry]")
		else
			if(current_entry.modified && !current_entry.dupes_allowed)
				log_config("Duplicate setting for [entry] ([value], [current_entry.resident_file]) detected! Using latest.")

		current_entry.resident_file = filename

		if(validated)
			current_entry.modified = TRUE

	++.


/datum/controller/configuration/can_vv_get(var_name)
	return (var_name != NAMEOF(src, entries_by_type) || !hiding_entries_by_type) && ..()


/datum/controller/configuration/stat_entry(msg)
	msg = "Edit"
	return msg


/datum/controller/configuration/proc/Get(entry_type)
	var/datum/config_entry/current_entry = entry_type
	var/entry_is_abstract = initial(current_entry.abstract_type) == entry_type
	if(entry_is_abstract)
		CRASH("Tried to retrieve an abstract config_entry: [entry_type]")
	current_entry = entries_by_type[entry_type]
	if(!current_entry)
		CRASH("Missing config entry for [entry_type]!")
	if((current_entry.protection & CONFIG_ENTRY_HIDDEN) && IsAdminAdvancedProcCall() && GLOB.LastAdminCalledProc == "Get" && GLOB.LastAdminCalledTargetRef == "[REF(src)]")
		log_admin_private("Config access of [entry_type] attempted by [key_name(usr)]")
		return
	return current_entry.config_entry_value


/datum/controller/configuration/proc/Set(entry_type, new_val)
	var/datum/config_entry/current_entry = entry_type
	var/entry_is_abstract = initial(current_entry.abstract_type) == entry_type
	if(entry_is_abstract)
		CRASH("Tried to set an abstract config_entry: [entry_type]")
	current_entry = entries_by_type[entry_type]
	if(!current_entry)
		CRASH("Missing config entry for [entry_type]!")
	if((current_entry.protection & CONFIG_ENTRY_LOCKED) && IsAdminAdvancedProcCall() && GLOB.LastAdminCalledProc == "Set" && GLOB.LastAdminCalledTargetRef == "[REF(src)]")
		log_admin_private("Config rewrite of [entry_type] to [new_val] attempted by [key_name(usr)]")
		return
	return current_entry.ValidateAndSet("[new_val]")


/datum/controller/configuration/proc/LoadModes()
	gamemode_cache = typecacheof(/datum/game_mode, TRUE)
	modes = list()
	mode_names = list()
	for(var/T in gamemode_cache)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/mode = new T()
		if(mode.config_tag)
			if(!(mode.config_tag in modes)) //Ensure each mode is added only once
				modes += mode.config_tag
				mode_names[mode.config_tag] = mode.name
		GLOB.gamemode_roles[mode.name] = mode.get_roles_list()
		qdel(mode)

/datum/controller/configuration/proc/pick_mode(mode_name)
	for(var/T in gamemode_cache)
		var/datum/game_mode/mode = T
		var/ct = initial(mode.config_tag)
		if(ct && ct == mode_name)
			return new T
	return new /datum/game_mode/extended()


/datum/controller/configuration/proc/LoadChatFilter()
	var/list/in_character_filter = list()

	if(!fexists("[directory]/in_character_filter.txt"))
		return

	log_config("Loading config file in_character_filter.txt...")

	for(var/line in file2list("[directory]/in_character_filter.txt"))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		in_character_filter += REGEX_QUOTE(line)

	ic_filter_regex = in_character_filter.len ? regex("\\b([jointext(in_character_filter, "|")])\\b", "i") : null

//Message admins when you can.
/datum/controller/configuration/proc/DelayedMessageAdmins(text)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(message_admins), text), 0)

/datum/admins/proc/change_ground_map()
	set category = "Server"
	set name = "M: Change Ground Map"

	if(!check_rights(R_SERVER))
		return

	var/list/maprotatechoices = list()
	for(var/map in config.maplist[GROUND_MAP])
		var/datum/map_config/VM = config.maplist[GROUND_MAP][map]
		var/mapname = VM.map_name
		if(VM == config.defaultmaps[GROUND_MAP])
			mapname += " (Default)"

		if(VM.config_min_users > 0 || VM.config_max_users > 0)
			mapname += " \["
			if(VM.config_min_users > 0)
				mapname += "[VM.config_min_users]"
			else
				mapname += "0"
			mapname += "-"
			if(VM.config_max_users > 0)
				mapname += "[VM.config_max_users]"
			else
				mapname += "inf"
			mapname += "\]"

		maprotatechoices[mapname] = VM

	var/chosenmap = tgui_input_list(usr, "Выберите карту", "Смена карты", maprotatechoices)
	if(!chosenmap)
		return

	var/datum/map_config/VM = maprotatechoices[chosenmap]
	if(!SSmapping.changemap(VM, GROUND_MAP))
		to_chat(usr, SPAN_WARNING("Не удалось поменять карту."))
		return

	log_admin("[key_name(usr)] меняет карту на [VM.map_name].")
	message_admins("[key_name_admin(usr)] меняет карту на [VM.map_name].")

/datum/admins/proc/vote_ground_map()
	set category = "Server"
	set name = "M: Start Ground Map Vote"

	if(!check_rights(R_SERVER))
		return

	SSvote.initiate_vote("groundmap", usr.ckey)
	log_admin("[key_name(usr)] начал голосование за карту.")
	message_admins("[key_name_admin(usr)] начал голосование за карту.")

/datum/admins/proc/override_ground_map()
	set category = "Server"
	set name = "M: Override Next Map"

	if(!check_rights(R_SERVER))
		return

	var/map_type = tgui_alert(usr, "Сменить карту корабля или планеты?", "Выбор карты", list(GROUND_MAP, SHIP_MAP, "ОТМЕНИТЬ"))
	if(map_type == "ОТМЕНИТЬ")
		return

	var/map = input(usr, "Выберите кастомную карту для следующего раунда","Загрузить карту") as null|file
	if(!map)
		return
	if(copytext("[map]", -4) != ".dmm")//4 == length(".dmm")
		to_chat(usr,  SPAN_WARNING("Имя файлы должно заканчиваться на '.dmm': [map]"), confidential = TRUE)
		return

	message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] is overriding the next '[map_type]' map with a custom one."))
	fcopy(map, "data/[OVERRIDE_MAPS_TO_FILENAME[map_type]]")
	if(tgui_alert(usr, "Do you want to upload a custom map config or use defaults? Config controls things like survivors and monkey types, camouflages, lore messages, map items, nightmare, special environmental features...", "Map Config Flavor", list("Default", "Override")) == "Override")
		tgui_alert(usr, "Choose the custom map configuration for next round. Make sure it's VALID. It MUST have \"override_map\":true !", "Warning", list("OK!"))
		var/map_config = input(usr, "Choose custom map configuration to upload", "Upload Map Config") as null|file
		if(map_config)
			var/parse_check = json_decode(file2text(map_config))
			if(parse_check && parse_check["override_map"])
				fcopy(map_config, MAP_TO_FILENAME[map_type])
				tgui_alert(usr, "Done, using uploaded map_config. ALWAYS check at start of round that the map loaded correctly when using this. Passing a map vote or changing it with verb vote will revert these changes. Good luck!", "One little thing...", list("OK"))
				message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] overrode next '[map_type]' map with '[map]' and '[map_config]' for settings."))
				return
		to_chat(usr, SPAN_ADMINNOTICE("Couldn't retrieve map_config file or it was invalid, using default config."))

	fcopy(OVERRIDE_DEFAULT_MAP_CONFIG[map_type], MAP_TO_FILENAME[map_type])
	tgui_alert(usr, "Done, using default map_config ('Unknown' map). ALWAYS check at start of round that the map loaded correctly when using this. Passing a map vote or changing it with verb vote will revert these changes. Good luck!", "One little thing...", list("OK"))
	message_admins(SPAN_ADMINNOTICE("[key_name_admin(usr)] overrode next '[map_type]' map with '[map]' and default settings."))

/datum/admins/proc/change_ship_map()
	set category = "Server"
	set name = "M: Change Ship Map"

	if(!check_rights(R_SERVER))
		return

	var/list/maprotatechoices = list()
	for(var/map in config.maplist[SHIP_MAP])
		var/datum/map_config/VM = config.maplist[SHIP_MAP][map]
		var/mapname = VM.map_name
		if(VM == config.defaultmaps[SHIP_MAP])
			mapname += " (Default)"

		if(VM.config_min_users > 0 || VM.config_max_users > 0)
			mapname += " \["
			if(VM.config_min_users > 0)
				mapname += "[VM.config_min_users]"
			else
				mapname += "0"
			mapname += "-"
			if(VM.config_max_users > 0)
				mapname += "[VM.config_max_users]"
			else
				mapname += "inf"
			mapname += "\]"

		maprotatechoices[mapname] = VM

	var/chosenmap = tgui_input_list(usr, "Choose a ship map to change to", "Change Ship Map", maprotatechoices)
	if(!chosenmap)
		return

	var/datum/map_config/VM = maprotatechoices[chosenmap]
	if(!SSmapping.changemap(VM, SHIP_MAP))
		to_chat(usr, SPAN_WARNING("Failed to change the ship map."))
		return

	log_admin("[key_name(usr)] changed the ship map to [VM.map_name].")
	message_admins("[key_name_admin(usr)] changed the ship map to [VM.map_name].")

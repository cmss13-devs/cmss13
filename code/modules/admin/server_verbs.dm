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

	var/chosenmap = input("Choose a ground map to change to", "Change Ground Map") as null|anything in maprotatechoices
	if(!chosenmap)
		return

	var/datum/map_config/VM = maprotatechoices[chosenmap]
	if(!SSmapping.changemap(VM, GROUND_MAP))
		to_chat(usr, "<span class='warning'>Failed to change the ground map.</span>")
		return

	log_admin("[key_name(usr)] changed the map to [VM.map_name].")
	message_admins("[key_name_admin(usr)] changed the map to [VM.map_name].")

/datum/admins/proc/vote_ground_map()
	set category = "Server"
	set name = "M: Start Ground Map Vote"

	if(!check_rights(R_SERVER))
		return

	SSvote.initiate_vote("groundmap", usr.ckey)
	log_admin("[key_name(usr)] started a groundmap vote.")
	message_admins("[key_name_admin(usr)] started a groundmap vote.")

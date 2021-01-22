GLOBAL_DATUM_INIT(vox_panel, /datum/vox_panel_tgui, new)

/datum/vox_panel_tgui
	var/name = "VOX Panel"

/datum/vox_panel_tgui/tgui_interact(mob/user, datum/tgui/ui)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VoxPanel", "VOX Panel")
		ui.open()
		ui.set_autoupdate(FALSE)


/datum/vox_panel_tgui/ui_state(mob/user)
	return GLOB.admin_state

/datum/vox_panel_tgui/ui_static_data(mob/user)
	. = list()
	.["glob_vox_types"] = GLOB.vox_types
	.["factions"] = FACTION_LIST_HUMANOID

/datum/vox_panel_tgui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!check_rights(R_SOUNDS))
		return

	switch(action)
		if("play_to_players")
			var/list/factions = params["factions"]
			if(!islist(factions))
				return

			if(!(params["vox_type"] in GLOB.vox_types))
				return

			var/list/vox = GLOB.vox_types[params["vox_type"]]
			var/message = "[params["message"]]" // Sanitize by converting into a string

			var/list/to_play_to = list()
			for(var/i in GLOB.player_list)
				var/mob/M = i
				if(M.stat == DEAD || (M.faction in factions))
					to_play_to |= M.client

			play_sound_vox(message, to_play_to, vox, usr.client, text2num(params["volume"]))
			var/factions_string = factions.Join(", ")
			message_staff("[key_name_admin(usr)] has sent a VOX report of type '[params["vox_type"]]' with an input of '[message]' to [factions_string].")
		if("play_to_self")
			if(!(params["vox_type"] in GLOB.vox_types))
				return

			var/list/vox = GLOB.vox_types[params["vox_type"]]
			var/message = "[params["message"]]" // Sanitize by converting into a string

			play_sound_vox(message, usr.client, vox, usr.client, text2num(params["volume"]))

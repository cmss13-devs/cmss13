// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"
	set desc = "Use to show general or faction-related custom event info, provided an admin set one."

	var/category = "Global"

	var/datum/custom_event_info/custom_event

	if(mob && !isobserver(mob) && !isnewplayer(mob))
		if(!mob.faction || !GLOB.custom_event_info_list[mob.faction.faction_name])
			to_chat(src, SPAN_WARNING("\n\n[mob] has none or incorrect faction set or faction message datum was not found, tell a dev!\n\n"))
			custom_event = GLOB.custom_event_info_list["Global"]
		else
			category = tgui_input_list(src, "Select category.", "Custom Event Info", list("Global", mob.faction.faction_name))
			custom_event = GLOB.custom_event_info_list[category]

		custom_event.show_player_event_info(src)
		return

	else
		custom_event = GLOB.custom_event_info_list["Global"]
		custom_event.show_player_event_info(src)
		return

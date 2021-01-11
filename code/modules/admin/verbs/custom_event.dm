// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"
	set desc = "Use to show general or faction-related custom event info, provided an admin set one."

	var/category = "Global"

	var/datum/custom_event_info/CEI

	if(mob && !isobserver(mob) && !isnewplayer(mob))

		if(isXeno(mob))
			var/mob/living/carbon/Xenomorph/X = mob
			if(!X.hive || !GLOB.custom_event_info_list[X.hive.name])
				to_chat(src, SPAN_WARNING("\n\n[X] has none or incorrect hive set or hive message datum was not found, tell a dev!\n\n"))
				CEI = GLOB.custom_event_info_list["Global"]
			else
				category = tgui_input_list(src, "Select category.", "Custom Event Info", list("Global", X.hive.name))
				CEI = GLOB.custom_event_info_list[category]

			CEI.show_player_event_info(src)
			return

		else if(!mob.faction || !GLOB.custom_event_info_list[mob.faction])
			to_chat(src, SPAN_WARNING("\n\n[mob] has none or incorrect faction set or faction message datum was not found, tell a dev!\n\n"))
			CEI = GLOB.custom_event_info_list["Global"]
		else
			category = tgui_input_list(src, "Select category.", "Custom Event Info", list("Global", mob.faction))
			CEI = GLOB.custom_event_info_list[category]

		CEI.show_player_event_info(src)
		return

	else
		CEI = GLOB.custom_event_info_list["Global"]
		CEI.show_player_event_info(src)
		return

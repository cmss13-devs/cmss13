// normal verb for players to view info
/client/verb/cmd_view_custom_event()
	set category = "OOC"
	set name = "Custom Event Info"
	set desc = "Use to show general or faction-related custom event info, provided an admin set one."

	check_event_info("Global", src)
	if(mob && !isobserver(mob) && !isnewplayer(mob) && mob.faction)
		check_event_info(mob.faction.code_identificator, src)

/mob/new_player/Logout()
	if(ready)
		GLOB.readied_players--
	ready = FALSE

	QDEL_NULL(lobby_window)

	var/client/exiting_client = GLOB.directory[persistent_ckey]
	if(exiting_client)
		winset(exiting_client, "lobby_browser", "is-disabled=true;is-visible=false")

		if(!exiting_client.prefs.hide_statusbar)
			winset(exiting_client, "mapwindow.status_bar", "is-visible=true")

	GLOB.new_player_list -= src

	. = ..()
	if(!spawning)//Here so that if they are spawning and log out, the other procs can play out and they will have a mob to come back to.
		key = null//We null their key before deleting the mob, so they are properly kicked out.
		qdel(src)

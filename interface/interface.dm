//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( CONFIG_GET(string/wikiurl) )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(CONFIG_GET(string/wikiurl))
	else
		to_chat(src, SPAN_DANGER("The wiki URL is not set in the server configuration."))
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = 1
	if( CONFIG_GET(string/forumurl) )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(CONFIG_GET(string/forumurl))
	else
		to_chat(src, SPAN_DANGER("The forum URL is not set in the server configuration."))
	return

/client/verb/rules()
	set name = "rules"
	set desc = "Read our rules."
	set hidden = 1
	if( CONFIG_GET(string/rulesurl) )
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(CONFIG_GET(string/rulesurl))
	else
		to_chat(src, SPAN_DANGER("The rules URL is not set in the server configuration."))
	return

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.tgui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "font-style=;")

/client/verb/discord()
	set name = "Discord"
	set desc = "Join our Discord! Meet and talk with other players in the server."
	set hidden = 1

	src << link("https://discordapp.com/invite/TByu8b5")
	return

/client/verb/submitbug()
	set name = "Submit Bug"
	set desc = "Submit a bug."
	set hidden = 1

	if(alert("Please search for the bug first to make sure you aren't posting a duplicate.",,"Ok","Cancel")=="Cancel")
		return
	src << link(URL_ISSUE_TRACKER)
	return

/client/verb/set_fps()
	set name = "Set FPS"
	set desc = "Set client FPS. 20 is the default"
	set category = "Preferences"
	var/fps = tgui_input_number(usr,"New FPS Value. 0 is server-sync. Higher values cause more desync. Values over 30 not recommended.","Set FPS", 0, MAX_FPS, MIN_FPS)
	if(world.byond_version >= 511 && byond_version >= 511 && fps >= MIN_FPS && fps <= MAX_FPS)
		vars["fps"] = fps
		prefs.fps = fps
		prefs.save_preferences()
	return

/client/verb/edit_hotkeys()
	set name = "Edit Hotkeys"
	set category = "Preferences"
	prefs.macros.tgui_interact(usr)

/client/var/client_keysend_amount = 0
/client/var/next_keysend_reset = 0
/client/var/next_keysend_trip_reset = 0
/client/var/keysend_tripped = FALSE

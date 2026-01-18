//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
CLIENT_VERB(wiki)
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = TRUE
	if( CONFIG_GET(string/wikiurl) )
		if(tgui_alert(src, "This will open the wiki in your browser. Are you sure?", "Confirm", list("Yes", "No")) != "Yes")
			return
		src << link(CONFIG_GET(string/wikiurl))
	else
		to_chat(src, SPAN_DANGER("The wiki URL is not set in the server configuration."))
	return

CLIENT_VERB(forum)
	set name = "forum"
	set desc = "Visit the forum."
	set hidden = TRUE
	if( CONFIG_GET(string/forumurl) )
		if(tgui_alert(src, "This will open the forum in your browser. Are you sure?", "Confirm", list("Yes", "No")) != "Yes")
			return
		src << link(CONFIG_GET(string/forumurl))
	else
		to_chat(src, SPAN_DANGER("The forum URL is not set in the server configuration."))
	return

CLIENT_VERB(rules)
	set name = "rules"
	set desc = "Read our rules."
	set hidden = TRUE
	if( CONFIG_GET(string/rulesurl) )
		if(tgui_alert(src, "This will open the rules in your browser. Are you sure?", "Confirm", list("Yes", "No")) != "Yes")
			return
		src << link(CONFIG_GET(string/rulesurl))
	else
		to_chat(src, SPAN_DANGER("The rules URL is not set in the server configuration."))
	return

CLIENT_VERB(changelog)
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.tgui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		stat_panel.send_message("changelog_read", TRUE)

CLIENT_VERB(discord)
	set name = "Discord"
	set desc = "Join our Discord! Meet and talk with other players in the server."
	set hidden = TRUE

	if(tgui_alert(src, "This will open the discord in your browser. Are you sure?", "Confirm", list("Yes", "No")) != "Yes")
		return

	src << link("[CONFIG_GET(string/discordurl)]")
	return

CLIENT_VERB(submitbug)
	set name = "Submit Bug"
	set desc = "Submit a bug."
	set hidden = TRUE
	if(!usr)
		return
	var/datum/tgui_bug_report_form/report = new(usr)

	report.tgui_interact(usr)
	return

CLIENT_VERB(set_fps)
	set name = "Set FPS"
	set desc = "Set client FPS. 20 is the default"
	set category = "Preferences"
	var/fps = tgui_input_number(usr,"New FPS Value. 0 is server-sync. Higher values cause more desync.","Set FPS", 0, MAX_FPS, MIN_FPS)
	if(world.byond_version >= 511 && byond_version >= 511 && fps >= MIN_FPS && fps <= MAX_FPS)
		vars["fps"] = fps
		prefs.fps = fps
		prefs.save_preferences()
	return

CLIENT_VERB(edit_hotkeys)
	set name = "Edit Hotkeys"
	set category = "Preferences"
	prefs.macros.tgui_interact(usr)

/client/var/client_keysend_amount = 0
/client/var/next_keysend_reset = 0
/client/var/next_keysend_trip_reset = 0
/client/var/keysend_tripped = FALSE

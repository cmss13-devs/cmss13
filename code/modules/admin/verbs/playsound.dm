/client/proc/play_admin_sound()
	set category = "Admin.Fun"
	set name = "Play Admin Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/sound_mode = tgui_input_list(src, "Play a sound from which source?", "Select Source", list("Web", "Upload"))
	if(!sound_mode)
		return

	var/list/data = list()
	var/log_title = TRUE
	var/web_sound_input
	var/asset_name
	var/must_send_assets = FALSE
	var/announce_title = TRUE

	if(sound_mode == "Web")
		var/ytdl = CONFIG_GET(string/invoke_youtubedl)
		if(!ytdl)
			to_chat(src, SPAN_BOLDWARNING("Youtube-dl was not configured, action unavailable"), confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
			return

		web_sound_input = input("Enter content URL (supported sites only)", "Play Internet Sound via youtube-dl") as text|null
		if(!istext(web_sound_input) || !length(web_sound_input))
			return

		web_sound_input = trim(web_sound_input)

		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, SPAN_WARNING("Non-http(s) URIs are not allowed."))
			to_chat(src, SPAN_WARNING("For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website."))
			return

		var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_url_scrub(web_sound_input)]\"")
		var/errorlevel = output[SHELLEO_ERRORLEVEL]
		var/stdout = output[SHELLEO_STDOUT]
		var/stderr = output[SHELLEO_STDERR]

		if(errorlevel)
			to_chat(src, SPAN_WARNING("Youtube-dl URL retrieval FAILED: [stderr]"))
			return

		try
			data = json_decode(stdout)
		catch(var/exception/e)
			to_chat(src, SPAN_WARNING("Youtube-dl JSON parsing FAILED: [e]: [stdout]"))
			return

	else if(sound_mode == "Upload")
		var/current_transport = CONFIG_GET(string/asset_transport)
		if(!current_transport || current_transport == "simple")
			if(tgui_alert(usr, "WARNING: Your server is using simple asset transport. Sounds will have to be sent directly to players, which may freeze the game for long durations. Are you SURE?", "Really play direct sound?", list("Yes", "No")) != "Yes")
				return
			must_send_assets = TRUE

		var/soundfile = input(usr, "Choose a sound file to play", "Upload Sound") as null|file
		if(!soundfile)
			return

		var/static/regex/only_extension = regex(@{"^.*\.([a-z0-9]{1,5})$"}, "gi")
		var/extension = only_extension.Replace("[soundfile]", "$1")
		if(!length(extension))
			to_chat(src, SPAN_WARNING("Invalid filename extension."))
			return

		var/static/playsound_notch = 1
		asset_name = "admin_sound_[playsound_notch++].[extension]"
		SSassets.transport.register_asset(asset_name, soundfile)
		message_admins("[key_name_admin(src)] uploaded admin sound '[soundfile]' to asset transport.")

		var/static/regex/remove_extension = regex(@{"\.[a-z0-9]+$"}, "gi")
		data["title"] = remove_extension.Replace("[soundfile]", "")
		data["url"] = SSassets.transport.get_asset_url(asset_name)
		web_sound_input = "[soundfile]"
		log_title = FALSE

	var/title
	var/web_sound_url = ""
	var/list/music_extra_data = list()
	if(data["url"])
		music_extra_data["link"] = data["url"]
		music_extra_data["title"] = data["title"]
		web_sound_url = data["url"]
		title = data["title"]
		music_extra_data["start"] = data["start_time"]
		music_extra_data["end"] = data["end_time"]

	if(!must_send_assets && web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, SPAN_BOLDWARNING("BLOCKED: Content URL not using http(s) protocol"), confidential = TRUE)
		to_chat(src, SPAN_WARNING("The media provider returned a content URL that isn't using the HTTP or HTTPS protocol"), confidential = TRUE)
		return

	switch(tgui_alert(src, "Show the name of this sound to the players?", "Sound Name", list("Yes","No","Cancel")))
		if("No")
			music_extra_data["title"] = "Admin sound"
			announce_title = FALSE
		if("Cancel")
			return

	var/list/targets = list()
	var/list/sound_type_list = list(
		"Meme" = SOUND_ADMIN_MEME,
		"Atmospheric" = SOUND_ADMIN_ATMOSPHERIC
	)

	var/style = tgui_input_list(src, "Who do you want to play this to?", "Select Listeners", list("Globally", "Xenos", "Marines", "Ghosts", "All In View Range", "Single Mob"))
	var/sound_type = tgui_input_list(src, "What kind of sound is this?", "Select Sound Type", sound_type_list)
	sound_type = sound_type_list[sound_type]

	switch(style)
		if("Globally")
			targets = GLOB.mob_list
		if("Xenos")
			targets = GLOB.xeno_mob_list + GLOB.dead_mob_list
		if("Marines")
			targets = GLOB.human_mob_list + GLOB.dead_mob_list
		if("Ghosts")
			targets = GLOB.observer_list + GLOB.dead_mob_list
		if("All In View Range")
			var/list/atom/ranged_atoms = urange(usr.client.view, get_turf(usr))
			for(var/mob/receiver in ranged_atoms)
				targets += receiver
		if("Single Mob")
			var/list/mob/all_mobs = sortmobs()
			var/list/mob/all_client_mobs = list()
			for(var/mob/mob in all_mobs)
				if(mob.client)
					all_client_mobs += mob
			var/mob/choice = tgui_input_list(src, "Select the mob to play to:","Select Mob", all_client_mobs)
			if(QDELETED(choice))
				return
			targets.Add(choice)
		else
			return

	for(var/mob/mob as anything in targets)
		var/client/client = mob?.client
		if((client?.prefs?.toggles_sound & SOUND_MIDI) && (client?.prefs?.toggles_sound & sound_type))
			if(must_send_assets)
				SSassets.transport.send_assets(client, asset_name)
			client?.tgui_panel?.play_music(web_sound_url, music_extra_data)
			if(announce_title)
				to_chat(client, SPAN_BOLDANNOUNCE("An admin played: [music_extra_data["title"]]"), confidential = TRUE)
		else
			client?.tgui_panel?.stop_music()

	log_admin("[key_name(src)] played admin sound: [web_sound_input] -[log_title ? " [title] -" : ""] [style]")
	message_admins("[key_name_admin(src)] played admin sound: [web_sound_input] -[log_title ? " [title] -" : ""] [style]")

/client/proc/stop_admin_sound()
	set category = "Admin.Fun"
	set name = "Stop Admin Sounds"

	if(!check_rights(R_SOUNDS))
		return

	for(var/i in GLOB.clients)
		var/client/C = i
		C.tgui_panel.stop_music()

	log_admin("[key_name(src)] stopped the currently playing web sounds.")
	message_admins("[key_name_admin(src)] stopped the currently playing web sounds.")


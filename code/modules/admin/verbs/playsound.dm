/client/proc/play_web_sound()
	set category = "Admin.Fun"
	set name = "Play Internet Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(src, SPAN_BOLDWARNING("Youtube-dl was not configured, action unavailable"), confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return

	var/web_sound_input = input("Enter content URL (supported sites only)", "Play Internet Sound via youtube-dl") as text|null
	if(!istext(web_sound_input) || !length(web_sound_input))
		return

	web_sound_input = trim(web_sound_input)

	if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
		to_chat(src, SPAN_WARNING("Non-http(s) URIs are not allowed."))
		to_chat(src, SPAN_WARNING("For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website."))
		return

	var/web_sound_url = ""
	var/list/music_extra_data = list()
	var/title

	var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_url_scrub(web_sound_input)]\"")
	var/errorlevel = output[SHELLEO_ERRORLEVEL]
	var/stdout = output[SHELLEO_STDOUT]
	var/stderr = output[SHELLEO_STDERR]

	if(errorlevel)
		to_chat(src, SPAN_WARNING("Youtube-dl URL retrieval FAILED: [stderr]"))
		return

	var/list/data = list()
	try
		data = json_decode(stdout)
	catch(var/exception/e)
		to_chat(src, SPAN_WARNING("Youtube-dl JSON parsing FAILED: [e]: [stdout]"))
		return

	if(data["url"])
		music_extra_data["link"] = data["url"]
		music_extra_data["title"] = data["title"]
		web_sound_url = data["url"]
		title = data["title"]
		music_extra_data["start"] = data["start_time"]
		music_extra_data["end"] = data["end_time"]

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, SPAN_BOLDWARNING("BLOCKED: Content URL not using http(s) protocol"), confidential = TRUE)
		to_chat(src, SPAN_WARNING("The media provider returned a content URL that isn't using the HTTP or HTTPS protocol"), confidential = TRUE)
		return

	var/list/targets = list()
	var/list/sound_type_list = list(
		"Meme" = SOUND_ADMIN_MEME,
		"Atmospheric" = SOUND_ADMIN_ATMOSPHERIC
	)
	var/style = tgui_input_list(src, "Who do you want to play this to?", "Select Listeners", list("Globally", "Xenos", "Marines", "Ghosts", "All Inview", "Single Inview"))
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
		if("All Inview")
			targets = viewers(usr.client.view, src)
		if("Single Inview")
			var/mob/choice = tgui_input_list(src, "Select the mob to play to:","Select Mob", sortmobs())
			if(QDELETED(choice))
				return
			targets.Add(choice)
		else
			return

	for(var/i in targets)
		var/mob/M = i
		var/client/client = M?.client
		if((client?.prefs.toggles_sound & SOUND_INTERNET) && (client?.prefs.toggles_sound & sound_type))
			client?.tgui_panel?.play_music(web_sound_url, music_extra_data)
		else
			client?.tgui_panel?.stop_music()

	log_admin("[key_name(src)] played web sound: [web_sound_input] - [title] - [style]")
	message_admins("[key_name_admin(src)] played web sound: [web_sound_input] - [title] - [style]")

/client/proc/stop_web_sound()
	set category = "Admin.Fun"
	set name = "Stop Internet Sounds"

	if(!check_rights(R_SOUNDS))
		return

	for(var/i in GLOB.clients)
		var/client/C = i
		C.tgui_panel.stop_music()

	log_admin("[key_name(src)] stopped the currently playing web sounds.")
	message_admins("[key_name_admin(src)] stopped the currently playing web sounds.")

/client/proc/play_sound(S as sound)
	set category = "Admin.Fun"
	set name = "Play Midi Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/freq = 1
	var/vol = tgui_input_number(src, "What volume would you like the sound to play at?", "Volume", 25, 100, 1)
	if(!vol)
		return
	vol = clamp(vol, 1, 100)

	var/sound/admin_sound = new()
	admin_sound.file = S
	admin_sound.priority = 250
	admin_sound.channel = SOUND_CHANNEL_ADMIN_MIDI
	admin_sound.frequency = freq
	admin_sound.wait = 1
	admin_sound.repeat = FALSE
	admin_sound.status = SOUND_STREAM
	admin_sound.volume = vol

	var/showtitle = FALSE
	var/res = alert(src, "Show the title of this song to the players?",, "Yes","No", "Cancel")
	switch(res)
		if("Yes")
			showtitle = TRUE
		if("Cancel")
			return

	var/list/targets = list()
	var/list/sound_type_list = list(
		"Meme" = SOUND_ADMIN_MEME,
		"Atmospheric" = SOUND_ADMIN_ATMOSPHERIC
	)
	var/style = tgui_input_list(src, "Who do you want to play this to?", "Select Listeners", list("Globally", "Xenos", "Marines", "Ghosts", "All Inview", "Single Inview"))
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
		if("All Inview")
			targets = viewers(usr.client.view, src)
		if("Single Inview")
			var/mob/choice = tgui_input_list(src, "Select the mob to play to:","Select Mob", sortmobs())
			if(QDELETED(choice))
				return
			targets.Add(choice)
		else
			return

	for(var/items in targets)
		var/mob/Mob = items
		var/client/client = Mob?.client
		if((client?.prefs.toggles_sound & SOUND_INTERNET) && (client?.prefs.toggles_sound & sound_type))
			admin_sound.volume = vol * client?.admin_music_volume
			SEND_SOUND(Mob, admin_sound)
			admin_sound.volume = vol
			if(showtitle)
				to_chat(client, SPAN_BOLDANNOUNCE("An admin played: [S]"), confidential = TRUE)

	log_admin("[key_name(src)] played midi sound [S] - [style]")
	message_admins("[key_name_admin(src)] played midi sound [S] - [style]")

/client/proc/stop_sound()
	set category = "Admin.Fun"
	set name = "Stop Midi Sounds"

	if(!check_rights(R_SOUNDS))
		return

	for(var/mob/M in GLOB.player_list)
		if(M.client)
			SEND_SOUND(M, sound(null))

	log_admin("[key_name(src)] stopped midi sounds.")
	message_admins("[key_name_admin(src)] stopped midi sounds.")

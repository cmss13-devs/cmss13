/client/proc/play_web_sound()
	set category = "Admin.Fun"
	set name = "Play Internet Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(src, "<span class='boldwarning'>Youtube-dl was not configured, action unavailable</span>", confidential = TRUE) //Check config.txt for the INVOKE_YOUTUBEDL value
		return

	var/web_sound_input = input("Enter content URL (supported sites only, leave blank to stop playing)", "Play Internet Sound via youtube-dl") as text|null
	if(istext(web_sound_input))
		var/web_sound_url = ""
		var/stop_web_sounds = FALSE
		var/list/music_extra_data = list()
		if(length(web_sound_input))

			web_sound_input = trim(web_sound_input)
			if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
				to_chat(src, "<span class='boldwarning'>Non-http(s) URIs are not allowed.</span>", confidential = TRUE)
				to_chat(src, "<span class='warning'>For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website.</span>", confidential = TRUE)
				return
			var/shell_scrubbed_input = shell_url_scrub(web_sound_input)
			var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
			var/errorlevel = output[SHELLEO_ERRORLEVEL]
			var/stdout = output[SHELLEO_STDOUT]
			var/stderr = output[SHELLEO_STDERR]
			if(!errorlevel)
				var/list/data
				try
					data = json_decode(stdout)
				catch(var/exception/e)
					to_chat(src, "<span class='boldwarning'>Youtube-dl JSON parsing FAILED:</span>", confidential = TRUE)
					to_chat(src, "<span class='warning'>[e]: [stdout]</span>", confidential = TRUE)
					return

				if (data["url"])
					web_sound_url = data["url"]
					var/title = "[data["title"]]"
					var/webpage_url = title
					if (data["webpage_url"])
						webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
					music_extra_data["start"] = data["start_time"]
					music_extra_data["end"] = data["end_time"]
					music_extra_data["link"] = data["webpage_url"]
					music_extra_data["title"] = data["title"]

					var/res = alert(usr, "Show the title of and link to this song to the players?\n[title]",, "No", "Yes", "Cancel")
					switch(res)
						if("Yes")
							to_chat(world, "<span class='boldannounce'>An admin played: [webpage_url]</span>", confidential = TRUE)
						if("Cancel")
							return

					log_admin("[key_name(src)] played web sound: [web_sound_input]")
					message_admins("[key_name(src)] played web sound: [web_sound_input]")
			else
				to_chat(src, "<span class='boldwarning'>Youtube-dl URL retrieval FAILED:</span>", confidential = TRUE)
				to_chat(src, "<span class='warning'>[stderr]</span>", confidential = TRUE)

		else //pressed ok with blank
			log_admin("[key_name(src)] stopped web sound")
			message_admins("[key_name(src)] stopped web sound")
			web_sound_url = null
			stop_web_sounds = TRUE

		if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
			to_chat(src, "<span class='boldwarning'>BLOCKED: Content URL not using http(s) protocol</span>", confidential = TRUE)
			to_chat(src, "<span class='warning'>The media provider returned a content URL that isn't using the HTTP or HTTPS protocol</span>", confidential = TRUE)
			return
		if(web_sound_url || stop_web_sounds)
			for(var/m in GLOB.player_list)
				var/mob/M = m
				var/client/C = M.client
				if(C.prefs.toggles_sound & SOUND_INTERNET)
					if(!stop_web_sounds)
						C.tgui_panel?.play_music(web_sound_url, music_extra_data)
					else
						C.tgui_panel?.stop_music()

/client/proc/play_sound(S as sound)
	set category = "Admin.Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))
		return

	var/freq = 1
	var/vol = input(usr, "What volume would you like the sound to play at?",, 100) as null|num
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

	var/res = alert(usr, "Show the title of this song to the players?",, "Yes","No", "Cancel")
	switch(res)
		if("Yes")
			to_chat(world, "<span class='boldannounce'>An admin played: [S]</span>", confidential = TRUE)
		if("Cancel")
			return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]")

	for(var/mob/M in GLOB.player_list)
		if(M.client.prefs.toggles_sound & SOUND_MIDI)
			admin_sound.volume = vol * M.client.admin_music_volume
			SEND_SOUND(M, admin_sound)
			admin_sound.volume = vol

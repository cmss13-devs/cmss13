/// Dynamically timed tutorial message display. Reads a list of dialogue in a tutorial scene, calculates and returns the delay until text is read by the player.
/datum/tutorial/proc/dynamic_message_to_player(list/script, list/atom/movable/screen/text/screen_text/message_atoms)
	var/final_fade_out_delay
	var/scene_length = 0 SECONDS
	for(var/message in script)
		var/list/lines_to_skip = list()
		var/static/html_locate_regex = regex("<.*>")
		var/tag_position = findtext(message, html_locate_regex)
		var/reading_tag = TRUE
		while(tag_position)
			if(reading_tag)
				if(message[tag_position] == ">")
					reading_tag = FALSE
				lines_to_skip += tag_position
				tag_position++
			else
				tag_position = findtext(message, html_locate_regex, tag_position)
				reading_tag = TRUE

		var/word_count = 0
		var/valid_letter_count = 0
		for(var/character in 1 to length_char(message))
			if(character in lines_to_skip)
				character++
				continue
			// ASCII 32 = spacebar thing
			if(text2ascii(message, character) == 32)
				word_count++
			valid_letter_count++
			character++

		if(!word_count)
			return

		if(script[length(script)] == message)
			final_fade_out_delay = message_atoms[message].fade_out_time
		else
			message_atoms[message].fade_out_time = 0

		var/message_reading_time = max(ceil(word_count * 0.26), 1.5) SECONDS
		var/message_printing_time = (valid_letter_count * message_atoms[message].play_delay) / message_atoms[message].letters_per_update SECONDS
		message_atoms[message].fade_out_delay = message_reading_time
		scene_length += (message_reading_time + message_printing_time)

		tutorial_mob.play_screen_text(message, message_atoms[message], rgb(103, 214, 146))

	return scene_length + final_fade_out_delay

/// Broadcast a message to the player's screen
/datum/tutorial/proc/message_to_player(message, message_type = /atom/movable/screen/text/screen_text/command_order/tutorial, dynamic_timing)
	if(dynamic_timing)
		return dynamic_message_to_player(list(message), list(message = new message_type()))
	tutorial_mob.play_screen_text(message, message_type, rgb(103, 214, 146))

/datum/tutorial/proc/speech_to_player(datum/tutorial_speech_preset/speaker, dynamic_timing, list/script)
	if(!speaker)
		return
	var/list/message_atoms = list()
	for(var/message in script)
		var/atom/movable/screen/text/screen_text/message_atom
		message_atom = new speaker.message_type(null, null, speaker.speaker_name, speaker.portrait_icon, speaker.portrait_icon_state, speaker.text_color)
		message_atom.header = speaker.text_header
		message_atom.sound_to_play = pick(speaker.speech_sounds)
		message_atoms[message] = message_atom

	if(dynamic_timing)
		return dynamic_message_to_player(script, message_atoms)

	for(var/message in script)
		tutorial_mob.play_screen_text(message, message_atoms[message], rgb(103, 214, 146))

/atom/movable/screen/text/screen_text/hypersleep_status
	maptext_height = 480
	maptext_width = 480
	maptext_x = 0
	maptext_y = -500
	screen_loc = "LEFT,TOP-3"
	play_delay = 0.25
	letters_per_update = 1
	fade_out_delay = 2 SECONDS
	style_open = "<span style='font-size:15pt; text-align:center; color: #3375F8; font-family: \"VCR OSD Mono\"' valign='top'>"
	style_close = "</span>"

/atom/movable/screen/text/screen_text/hypersleep_status/Initialize(mapload)
	. = ..()
	add_filter("text_glow", 2, drop_shadow_filter(x = 0, y = 0, size = 3, color = "#2461da"))

/atom/movable/screen/text/screen_text/tutorial_potrait
	screen_loc = "WEST:6,TOP-3"
	maptext_height = 64
	maptext_width = 400
	maptext_x = 66
	maptext_y = 0
	letters_per_update = 2 // overall, pretty fast while not immediately popping in
	play_delay = 0.1
	fade_out_delay = 4.5 SECONDS
	fade_out_time = 0.5 SECONDS
	layer = INTRO_LAYER
	plane = INTRO_PLANE
	style_open = "<span class='langchat' style=font-size:20pt;text-align:left valign='top'>"
	style_close = "</span>"

/atom/movable/screen/text/screen_text/tutorial_potrait/Initialize(mapload, datum/hud/hud_owner, name, icon_to_use, image_to_play)
	. = ..()
	add_filter("text_glow", 2, drop_shadow_filter(x = 0, y = 0, size = 1, color = "#6cf0b9"))
	var/image/alertimage = image(icon_to_use, icon_state = image_to_play)
	alertimage.appearance_flags = APPEARANCE_UI
	overlays += alertimage
	var/atom/movable/holding_movable = new
	holding_movable.appearance_flags = APPEARANCE_UI|KEEP_TOGETHER
	holding_movable.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/mutable_appearance/mugshot_name = mutable_appearance()
	mugshot_name.appearance_flags = APPEARANCE_UI
	mugshot_name.maptext_width = 66 // 64 (the icon) + 1 buffer each side
	mugshot_name.maptext_x = -1
	mugshot_name.maptext_y = -1
	mugshot_name.plane = plane
	mugshot_name.layer = layer+0.3

	if(!name)
		name = ""
	mugshot_name.maptext = "<span class='langchat' style=font-size:6px;text-align:center>[name]</span>"

	holding_movable.overlays += mugshot_name

	vis_contents += holding_movable

/atom/movable/screen/text/screen_text/tutorial_potrait/play_to_client()
	if(sound_to_play)
		playsound_client(player, sound_to_play, player.mob, 25, FALSE)
	to_chat(player.mob, SPAN_NOTICE(text_to_play))
	return ..()

/datum/tutorial_speech_preset
	var/speaker_name
	var/portrait_icon = 'icons/ui_icons/screen_alert_images.dmi'
	var/portrait_icon_state

	var/static/list/speech_sounds = list(
		'sound/machines/telephone/talk_phone4.ogg',
		'sound/machines/telephone/talk_phone2.ogg',
		'sound/machines/telephone/talk_phone3.ogg',
	)
	var/message_type = /atom/movable/screen/text/screen_text/tutorial_potrait

	var/text_color
	var/text_header
	var/style_open
	var/style_close

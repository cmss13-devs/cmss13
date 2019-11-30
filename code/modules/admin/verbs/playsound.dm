/client/proc/play_imported_sound(S as sound)
	set category = "Fun"
	set name = "Play Imported Sound"
	set desc = "Play a sound imported from anywhere on your computer."
	if(!check_rights(R_SOUNDS))	return

	if(midi_playing)
		to_chat(usr, "No. An Admin already played a midi recently.")
		return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250

	switch( alert("Play sound globally or locally?", "Sound", "Global", "Local", "Individual", "Cancel") )
		if("Global")
			for(var/mob/M in player_list)
				if(M.client.prefs.toggles_sound & SOUND_MIDI)
					SSmidi.queue(M, uploaded_sound)
					heard_midi++
		if("Local")
			playsound(get_turf(src.mob), uploaded_sound, 50, 0)
			for(var/mob/M in view())
				heard_midi++
		if("Individual")
			var/mob/target = input("Select a mob to play sound to:", "List of All Mobs") as null|anything in mob_list
			if(istype(target,/mob/))
				if(target.client.prefs.toggles_sound & SOUND_MIDI)
					target << uploaded_sound
					heard_midi = "[target] ([target.key])"
				else
					heard_midi = 0
		if("Cancel")
			return

	 
	if(isnum(heard_midi))
		log_admin("[key_name(src)] played sound `[S]` for [heard_midi] player(s). [clients.len - heard_midi] player(s) have disabled admin midis.")
		message_admins("[key_name_admin(src)] played sound `[S]` for [heard_midi] player(s). [clients.len - heard_midi] player(s) have disabled admin midis.", 1)
	else
		log_admin("[key_name(src)] played sound `[S]` for [heard_midi].")
		message_admins("[key_name_admin(src)] played sound `[S]` for [heard_midi].", 1)
		return
		

	// A 30 sec timer used to show Admins how many players are silencing the sound after it starts - see preferences_toggles.dm
	var/midi_playing_timer = 30 SECONDS // Should match with the midi_silenced spawn() in preferences_toggles.dm
	midi_playing = 1
	spawn(midi_playing_timer)
		midi_playing = 0
		message_admins("'Silence Current Midi' usage reporting 30-sec timer has expired. [total_silenced] player(s) silenced the midi in the first 30 seconds out of [heard_midi] total player(s) that have 'Play Admin Midis' enabled. <span style='color: red'>[round((total_silenced / heard_midi) * 100)]% of players don't want to hear it, and likely more if the midi is longer than 30 seconds.</span>")
		heard_midi = 0
		total_silenced = 0



/client/proc/play_sound_from_list()
	set category = "Fun"
	set name = "Play Sound From List"
	set desc = "Play a sound already in the project from a pre-made list."
	if(!check_rights(R_SOUNDS))	return

	var/list/sounds = file2list("sound/soundlist.txt");
	sounds += "--CANCEL--"

	var/melody = input("Select a sound to play", "Sound list", "--CANCEL--") in sounds

	if(melody == "--CANCEL--")	return

	play_imported_sound(melody)
	 

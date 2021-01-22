GLOBAL_LIST_EMPTY(vox_types)

/proc/play_sound_vox(var/sentence, var/list/players, var/list/vox, var/client/caller, var/volume = 1)
	if(!islist(players))
		players = list(players)

	// Need to separate these so that they can be distinguished
	sentence = replacetext(sentence, ".", " .")
	sentence = replacetext(sentence, ",", " ,")

	var/list/sounds = list()
	var/list/bad_words = list()
	for(var/word in splittext(lowertext(sentence), " "))
		if(!(word in vox))
			bad_words += word
			continue

		var/sound_file = vox[word]
		sounds += sound_file

	if(caller && length(bad_words))
		var/missed_words = jointext(bad_words, ", ")
		to_chat(caller, SPAN_WARNING("Couldn't find the sound files for: [missed_words]"))

	for(var/s in sounds)
		var/sound/S = sound(s, wait=TRUE, channel=SOUND_CHANNEL_VOX, volume=volume)
		S.status=SOUND_STREAM
		for(var/c in players)
			var/client/C = c
			if(C.prefs.hear_vox)
				sound_to(c, S)

/client/proc/cmd_admin_vox_panel()
	set name = "VOX: Panel"
	set category = "Admin.Panels"

	if(!admin_holder || !(admin_holder.rights & R_SOUNDS))
		to_chat(src, "Only administrators may use this command.")
		return

	GLOB.vox_panel.tgui_interact(mob)

//toggles
/client/proc/toggle_hear_radio()
	set name = "Show/Hide RadioChatter"
	set category = "Preferences"
	set desc = "Toggle seeing radiochatter from radios and speakers"
	if(!admin_holder) return
	prefs.toggles_chat ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles_chat & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from radios or speakers")

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences"
	set desc = "Toggle hearing a notification when admin PMs are recieved"
	if(!admin_holder)	return
	prefs.toggles_sound ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles_sound & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences"
	set desc = "Toggles seeing prayers"
	prefs.toggles_chat ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.toggles_chat & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles_sound ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_LOBBY)
		to_chat(src, "You will now hear music in the game lobby.")
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		to_chat(src, "You will no longer hear music in the game lobby.")
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = SOUND_CHANNEL_LOBBY) // stop the jamsz

/client/verb/togglemidis()
	set name = "Silence Current Midi"
	set category = "Preferences"
	set desc = "Toggles hearing sounds uploaded by admins"
	// prefs.toggles_sound ^= SOUND_MIDI // Toggle on/off
	// prefs.save_preferences() // We won't save the change - it'll be a temporary switch instead of permanent, but they can still make it permanent in character setup.
	if(prefs.toggles_sound & SOUND_MIDI) // Not using && midi_playing here - since we can't tell how long an admin midi is, the user should always be able to turn it off at any time.
		to_chat(src, "The currently playing midi has been silenced.")
		var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = SOUND_CHANNEL_ADMIN_MIDI)
		break_sound.priority = 250
		src << break_sound	//breaks the client's sound output on SOUND_CHANNEL_ADMIN_MIDI
		if(src.mob.client.midi_silenced)	return
		if(midi_playing)
			total_silenced++
			message_staff("A player has silenced the currently playing midi. Total: [total_silenced] player(s).", 1)
			src.mob.client.midi_silenced = 1
			spawn(SECONDS_30) // Prevents message_admins() spam. Should match with the midi_playing_timer spawn() in playsound.dm
				src.mob.client.midi_silenced = 0
	else
		to_chat(src, "You have 'Play Admin Midis' disabled in your Character Setup, so this verb is useless to you.")

/client/verb/togglechat()
	set name = "Toggle Abovehead Chat"
	set category = "Preferences"
	set desc = "Toggles abovehead chat until you change body"

	prefs.lang_chat_disabled = ~prefs.lang_chat_disabled
	prefs.save_preferences()
	to_chat(src, "You will [(!prefs.lang_chat_disabled) ? "now" : "no longer"] see messages above head.")

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences"
	set desc = "Toggles seeing OutOfCharacter chat"
	prefs.toggles_chat ^= CHAT_OOC
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.toggles_chat & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel.")

/client/verb/listen_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences"
	set desc = "Toggles seeing Local OutOfCharacter chat"
	prefs.toggles_chat ^= CHAT_LOOC
	prefs.save_preferences()

	to_chat(src, "You will [(prefs.toggles_chat & CHAT_LOOC) ? "now" : "no longer"] see messages on the LOOC channel.")

/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences"
	set desc = "Toggles hearing ambient sound effects"
	prefs.toggles_sound ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_AMBIENCE)
		to_chat(src, "You will now hear ambient sounds.")
		if(soundOutput)
			soundOutput.update_ambience(null, TRUE)
	else
		to_chat(src, "You will no longer hear ambient sounds.")
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = SOUND_CHANNEL_AMBIENCE)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = SOUND_CHANNEL_SOUNDSCAPE)

//be special
/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."
	var/role_flag = be_special_flags[role]

	if(!role_flag)	return
	prefs.be_special ^= role_flag
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")

/client/verb/toggle_window_skin()
	set name = "Toggle Night Mode"
	set category = "Preferences"
	set desc = "Toggles between the white window skin or the night window skin."

	prefs.window_skin ^= TOGGLE_WINDOW_SKIN
	if(prefs.window_skin & TOGGLE_WINDOW_SKIN)
		to_chat(src, "You're now running the night skin for your windows.")
		set_night_skin()
	else
		to_chat(src, "You're now running the white skin for your windows.")
		set_white_skin()
	prefs.save_preferences()

	if(chatOutput)
		chatOutput.check_window_skin()

/client/verb/toggle_prefs() // Toggle whether anything will happen when you click yourself in non-help intent
	set name = "Toggle Preferences"
	set category = "Preferences"
	set desc = "Toggles a specific toggleable preference"

	var/list/pref_buttons = list(
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_ignore_self'>Toggle the Ability to Hurt Yourself</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_help_intent_safety'>Toggle Help Intent Safety</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_auto_eject'>Toggle Guns Auto-Ejecting Magazines</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_auto_eject_to_hand'>Toggle Guns Auto-Ejecting Magazines to Your Hands</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_eject_to_hand'>Toggle 'Unload Weapon' Ejecting Magazines to Your Hands</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_automatic_punctuation'>Toggle Automatic Punctuation</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_middle_mouse_click'>Toggle Middle Mouse Ability Activation</a><br>"
	)

	var/dat = ""
	for (var/pref_button in pref_buttons)
		dat += "[pref_button]\n"

	var/height = 50+22*length(pref_buttons)

	show_browser(src, dat, "Toggle Preferences", "togglepreferences", "size=475x[height]")

/client/proc/toggle_ignore_self() // Toggle whether anything will happen when you click yourself in non-help intent
	prefs.toggle_prefs ^= TOGGLE_IGNORE_SELF
	if(prefs.toggle_prefs & TOGGLE_IGNORE_SELF)
		to_chat(src, "Clicking on yourself in non-help intent will no longer do anything.")
	else
		to_chat(src, "Clicking on yourself in non-help intent can harm you again.")
	prefs.save_preferences()

/client/proc/toggle_help_intent_safety() // Toggle whether anything will happen when you click on someone with help intent
	prefs.toggle_prefs ^= TOGGLE_HELP_INTENT_SAFETY
	if(prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY)
		to_chat(src, "Help intent will now be completely harmless.")
	else
		to_chat(src, "Help intent can perform harmful actions again.")
	prefs.save_preferences()

/client/proc/toggle_auto_eject() // Toggle whether guns with auto-ejectors will automatically eject magazines
	prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_OFF
	if(prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF)
		var/msg = "Guns with auto-ejectors will no longer automatically eject their magazines."
		if (prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND)
			prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
			msg += " The preference for auto-ejecting magazines to your hand has been toggled off."
		to_chat(src, msg)
	else
		to_chat(src, "Guns with auto-ejectors will automatically eject their magazines.")
	prefs.save_preferences()

/client/proc/toggle_auto_eject_to_hand() // Toggle whether guns with auto-ejectors will eject their magazines to your offhand
	prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND)
		var/msg = "Guns with auto-ejectors will eject their magazines to your offhand."
		if (prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF)
			prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_OFF
			msg += " The preference for removing magazine auto-ejecting has been toggled off."
		to_chat(src, msg)
	else
		to_chat(src, "Guns with auto-ejectors will no longer eject their magazines to your offhand.")
	prefs.save_preferences()

/client/proc/toggle_eject_to_hand() // Toggle whether unloading a magazine with the 'Unload Weapon' verb will put the magazine in your offhand
	prefs.toggle_prefs ^= TOGGLE_EJECT_MAGAZINE_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND)
		to_chat(src, "The 'Unload Weapon' verb will put magazines in your offhand.")
	else
		to_chat(src, "The 'Unload Weapon' verb will no longer put magazines in your offhand.")
	prefs.save_preferences()

/client/proc/toggle_automatic_punctuation() // Toggle whether your sentences are automatically punctuated
	prefs.toggle_prefs ^= TOGGLE_AUTOMATIC_PUNCTUATION
	if(prefs.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		to_chat(src, "Your messages will automatically be punctuated if they are not punctuated already.")
	else
		to_chat(src, "Your messages will no longer be automatically punctuated if they are not punctuated already.")
	prefs.save_preferences()

/client/proc/toggle_middle_mouse_click() // Toggle whether abilities should use middle or shift clicking
	prefs.toggle_prefs ^= TOGGLE_MIDDLE_MOUSE_CLICK
	if (prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK)
		to_chat(src, SPAN_NOTICE("Your selected ability will now be activated with middle clicking."))
	else
		to_chat(src, SPAN_NOTICE("Your selected ability will now be activated with shift clicking."))

	prefs.save_preferences()

//------------ GHOST PREFERENCES ---------------------------------

/client/proc/show_ghost_preferences() // Shows ghost-related preferences.
	set name = "Y: Show Ghost Prefs"
	set category = "Preferences"
	set desc = "Shows ghost-related preferences."

	verbs += ghost_prefs_verbs
	verbs -= /client/proc/show_ghost_preferences

/client/proc/hide_ghost_preferences() // Hides ghost-related preferences.
	set name = "Y: Hide Ghost Prefs"
	set category = "Preferences"
	set desc = "Hides ghost-related preferences."

	verbs -= ghost_prefs_verbs
	verbs += /client/proc/show_ghost_preferences

/client/proc/toggle_ghost_hivemind()
	set name = "Y: Toggle GhostHivemind"
	set category = "Preferences"
	set desc = "Toggle seeing all chatter from the Xenomorph Hivemind"
	prefs.toggles_chat ^= CHAT_GHOSTHIVEMIND
	to_chat(src, "As a ghost, you will [(prefs.toggles_chat & CHAT_GHOSTHIVEMIND) ? "now see chatter from the Xenomorph Hivemind" : "no longer see chatter from the Xenomorph Hivemind"].")
	prefs.save_preferences()

/client/proc/deadchat() // Deadchat toggle is usable by anyone.
	set name = "Y: Toggle Deadchat"
	set category = "Preferences"
	set desc ="Toggles seeing DeadChat"
	prefs.toggles_chat ^= CHAT_DEAD
	prefs.save_preferences()

	if(src.admin_holder && (admin_holder.rights & R_MOD))
		to_chat(src, "You will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")
	else
		to_chat(src, "As a ghost, you will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")

/client/proc/toggle_ghost_ears()
	set name = "Y: Toggle GhostEars"
	set category = "Preferences"
	set desc = "Toggle Between seeing all mob speech, and only speech of nearby mobs"
	prefs.toggles_chat ^= CHAT_GHOSTEARS
	to_chat(src, "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"].")
	prefs.save_preferences()

/client/proc/toggle_ghost_sight()
	set name = "Y: Toggle GhostSight"
	set category = "Preferences"
	set desc = "Toggle Between seeing all mob emotes, and only emotes of nearby mobs"
	prefs.toggles_chat ^= CHAT_GHOSTSIGHT
	to_chat(src, "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"].")
	prefs.save_preferences()

/client/proc/toggle_ghost_radio()
	set name = "Y: Toggle GhostRadio"
	set category = "Preferences"
	set desc = "Toggle between hearing all radio chatter, or only from nearby speakers"
	prefs.toggles_chat ^= CHAT_GHOSTRADIO
	to_chat(src, "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTRADIO) ? "hear all radio chat in the world" : "only hear from nearby speakers"].")
	prefs.save_preferences()

/client/proc/toggle_ghost_hud()
	set name = "Y: Toggle Ghost HUDs"
	set category = "Preferences"
	set desc = "Use to change which HUDs you want to have by default when you become an observer."

	var/hud_choice = input("Choose a HUD to toggle", "Toggle HUD prefs", null) as null|anything in list("Medical HUD", "Security HUD", "Squad HUD", "Xeno Status HUD", "Faction UPP HUD", "Faction W-Y HUD", "Faction RESS HUD", "Faction CLF HUD")
	if(!hud_choice)
		return
	prefs.observer_huds[hud_choice] = !prefs.observer_huds[hud_choice]
	prefs.save_preferences()

	to_chat(src, "You toggled [hud_choice] to be [prefs.observer_huds[hud_choice] ? "ON" : "OFF"] by default when you are observer.")

	if(!isobserver(usr))
		return
	var/mob/dead/observer/O = usr
	var/datum/mob_hud/H
	switch(hud_choice)
		if("Medical HUD")
			H = huds[MOB_HUD_MEDICAL_OBSERVER]
		if("Security HUD")
			H = huds[MOB_HUD_SECURITY_ADVANCED]
		if("Squad HUD")
			H = huds[MOB_HUD_SQUAD_OBSERVER]
		if("Xeno Status HUD")
			H = huds[MOB_HUD_XENO_STATUS]
		if("Faction UPP HUD")
			H = huds[MOB_HUD_FACTION_UPP]
		if("Faction W-Y HUD")
			H = huds[MOB_HUD_FACTION_WY]
		if("Faction RESS HUD")
			H = huds[MOB_HUD_FACTION_RESS]
		if("Faction CLF HUD")
			H = huds[MOB_HUD_FACTION_CLF]

	O.HUD_toggled[hud_choice] = prefs.observer_huds[hud_choice]
	if(O.HUD_toggled[hud_choice])
		H.add_hud_to(O)
	else
		H.remove_hud_from(O)

//------------ COMBAT CHAT MESSAGES PREFERENCES ---------------------

//Made all chat combat-related logs added by Neth and several others to be hidden by default and shown when clicked respected verb. Reason: too cluttered preferences.
/client/proc/show_combat_chat_preferences() // Shows additional chat logs preferences.
	set category = "Preferences"
	set name = "Z: Show Combat Chat Prefs"
	set desc = "Shows additional chat preferences for combat and ghost messages."

	verbs += combat_chat_prefs_verbs
	verbs -= /client/proc/show_combat_chat_preferences

/client/proc/hide_combat_chat_preferences() // Hides additional chat logs preferences.
	set category = "Preferences"
	set name = "Z: Hide Combat Chat Prefs"
	set desc = "Hides additional chat preferences for combat and ghost messages."

	verbs -= combat_chat_prefs_verbs
	verbs += /client/proc/show_combat_chat_preferences

/client/proc/toggle_chat_shooting()
	set name = "Z: Toggle Firing Messages"
	set category = "Preferences"
	set desc = ".Enable or Disable messages informing about weapon fire"
	prefs.chat_display_preferences ^= CHAT_TYPE_WEAPON_USE
	to_chat(src, "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_WEAPON_USE) ? "see all weapon fire messages" : "never see weapon fire messages"].")
	prefs.save_preferences()

/client/proc/toggle_chat_xeno_attack()
	set name = "Z: Toggle Xeno Attack Messages"
	set category = "Preferences"
	set desc = ".Enable or Disable messages informing about xeno attacks"
	prefs.chat_display_preferences ^= CHAT_TYPE_XENO_COMBAT
	to_chat(src, "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_XENO_COMBAT) ? "see all xeno attack messages" : "never see xeno attack messages"].")
	prefs.save_preferences()

/client/proc/toggle_chat_xeno_armor()
	set name = "Z: Toggle Xeno Armor Messages"
	set category = "Preferences"
	set desc = ".Enable or Disable messages informing about xeno armor"
	prefs.chat_display_preferences ^= CHAT_TYPE_ARMOR_DAMAGE
	to_chat(src, "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_ARMOR_DAMAGE) ? "see all xeno armor messages" : "never see xeno armor messages"].")
	prefs.save_preferences()

/client/proc/toggle_chat_someone_hit()
	set name = "Z: Toggle Someone Hit Messages"
	set category = "Preferences"
	set desc = ".Enable or Disable messages informing about someone being hit"
	prefs.chat_display_preferences ^= CHAT_TYPE_TAKING_HIT
	to_chat(src, "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_TAKING_HIT) ? "see all player hit messages" : "never see player hit messages"].")
	prefs.save_preferences()

/client/proc/toggle_chat_you_hit()
	set name = "Z: Toggle You Hit Messages"
	set category = "Preferences"
	set desc = ".Enable or Disable messages informing about you being hit"
	prefs.chat_display_preferences ^= CHAT_TYPE_BEING_HIT
	to_chat(src, "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_BEING_HIT) ? "see you being hit messages" : "never see you being hit messages"].")
	prefs.save_preferences()

/client/proc/toggle_chat_you_pain()
	set name = "Z: Toggle Pain Messages"
	set category = "Preferences"
	set desc = ".Enable or Disable messages informing about you being in pain"
	prefs.chat_display_preferences ^= CHAT_TYPE_PAIN
	to_chat(src, "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_PAIN) ? "see you being in pain messages" : "never see you being in pain messages"].")
	prefs.save_preferences()

var/list/combat_chat_prefs_verbs = list(
	/client/proc/toggle_chat_shooting,
	/client/proc/toggle_chat_xeno_attack,
	/client/proc/toggle_chat_xeno_armor,
	/client/proc/toggle_chat_someone_hit,
	/client/proc/toggle_chat_you_hit,
	/client/proc/toggle_chat_you_pain,
	/client/proc/hide_combat_chat_preferences)

var/list/ghost_prefs_verbs = list(
	/client/proc/toggle_ghost_ears,
	/client/proc/toggle_ghost_sight,
	/client/proc/toggle_ghost_radio,
	/client/proc/toggle_ghost_hivemind,
	/client/proc/deadchat,
	/client/proc/toggle_ghost_hud,
	/client/proc/hide_ghost_preferences)

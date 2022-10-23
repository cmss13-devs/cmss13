//toggles
/client/proc/toggle_hear_radio()
	set name = "Show/Hide Radio Chatter"
	set category = "Preferences.Chat"
	set desc = "Toggle seeing radio chatter from radios and speakers"
	if(!admin_holder) return
	prefs.toggles_chat ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, SPAN_BOLDNOTICE("You will [(prefs.toggles_chat & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from radios or speakers"))

/client/proc/toggleadminhelpsound()
	set name = "Hear/Silence Adminhelps"
	set category = "Preferences.Sound"
	set desc = "Toggle hearing a notification when admin PMs are received"
	if(!admin_holder)	return
	prefs.toggles_sound ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr,SPAN_BOLDNOTICE( "You will [(prefs.toggles_sound & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive."))

/client/proc/toggleprayers()
	set name = "Show/Hide Prayers"
	set category = "Preferences.Chat"
	set desc = "Toggles seeing prayers"
	prefs.toggles_chat ^= CHAT_PRAYER
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("You will [(prefs.toggles_chat & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat."))

/client/verb/toggletitlemusic()
	set name = "Hear/Silence LobbyMusic"
	set category = "Preferences.Sound"
	set desc = "Toggles hearing the GameLobby music"
	prefs.toggles_sound ^= SOUND_LOBBY
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_LOBBY)
		to_chat(src, SPAN_BOLDNOTICE("You will now hear music in the game lobby."))
		if(istype(mob, /mob/new_player))
			playtitlemusic()
	else
		to_chat(src, SPAN_BOLDNOTICE("You will no longer hear music in the game lobby."))
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = SOUND_CHANNEL_LOBBY) // stop the jamsz

/client/verb/togglerebootsound()
	set name = "Hear/Silence Reboot Sound"
	set category = "Preferences.Sound"
	set desc = "Toggles hearing the server reboot sound effect."
	prefs.toggles_sound ^= SOUND_REBOOT
	prefs.save_preferences()
	to_chat(src, "You will [(prefs.toggles_sound & SOUND_REBOOT) ? "now" : "no longer"] hear server reboot sounds.")

/client/verb/togglemidis()
	set name = "Silence Current Midi"
	set category = "Preferences.Sound"
	set desc = "Toggles hearing sounds uploaded by admins"
	// prefs.toggles_sound ^= SOUND_MIDI // Toggle on/off
	// prefs.save_preferences() // We won't save the change - it'll be a temporary switch instead of permanent, but they can still make it permanent in character setup.
	if(prefs.toggles_sound & SOUND_MIDI) // Not using && midi_playing here - since we can't tell how long an admin midi is, the user should always be able to turn it off at any time.
		to_chat(src, SPAN_BOLDNOTICE("The currently playing midi has been silenced."))
		var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = SOUND_CHANNEL_ADMIN_MIDI)
		break_sound.priority = 250
		src << break_sound	//breaks the client's sound output on SOUND_CHANNEL_ADMIN_MIDI
		if(src.mob.client.midi_silenced)	return
		if(midi_playing)
			total_silenced++
			message_staff("A player has silenced the currently playing midi. Total: [total_silenced] player(s).", 1)
			src.mob.client.midi_silenced = 1
			spawn(30 SECONDS) // Prevents message_admins() spam. Should match with the midi_playing_timer spawn() in playsound.dm
				src.mob.client.midi_silenced = 0
	else
		to_chat(src, SPAN_BOLDNOTICE("You have 'Play Admin Midis' disabled in your Character Setup, so this verb is useless to you."))

/client/verb/togglechat()
	set name = "Toggle Abovehead Chat"
	set category = "Preferences.Chat"
	set desc = "Toggles abovehead chat until you change body"

	prefs.lang_chat_disabled = ~prefs.lang_chat_disabled
	prefs.save_preferences()
	to_chat(src,SPAN_BOLDNOTICE( "You will [(!prefs.lang_chat_disabled) ? "now" : "no longer"] see messages above head."))

/client/verb/togglechatemotes()
	set name = "Toggle Abovehead Chat Emotes"
	set category = "Preferences.Chat"
	set desc = "Toggles seeing emotes in abovehead chat"

	prefs.toggles_langchat ^= LANGCHAT_SEE_EMOTES
	prefs.save_preferences()
	to_chat(src,SPAN_BOLDNOTICE( "You will [(prefs.toggles_langchat & LANGCHAT_SEE_EMOTES) ? "now" : "no longer"] see emotes in abovehead chat."))

/client/verb/toggle_permission_errors()
	set name = "Toggle Permission Errors"
	set category = "Preferences.Chat"
	set desc = "Toggles error messages due to missing permissions."

	prefs.show_permission_errors = !prefs.show_permission_errors
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("You will [(prefs.show_permission_errors) ? "now" : "no longer"] see permission error messages."))

/client/verb/listen_ooc()
	set name = "Show/Hide OOC"
	set category = "Preferences.Chat"
	set desc = "Toggles seeing OutOfCharacter chat"
	prefs.toggles_chat ^= CHAT_OOC
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("You will [(prefs.toggles_chat & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel."))

/client/verb/listen_looc()
	set name = "Show/Hide LOOC"
	set category = "Preferences.Chat"
	set desc = "Toggles seeing Local OutOfCharacter chat"
	prefs.toggles_chat ^= CHAT_LOOC
	prefs.save_preferences()

	to_chat(src, SPAN_BOLDNOTICE("You will [(prefs.toggles_chat & CHAT_LOOC) ? "now" : "no longer"] see messages on the LOOC channel."))

/client/verb/Toggle_Soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set name = "Hear/Silence Ambience"
	set category = "Preferences.Sound"
	set desc = "Toggles hearing ambient sound effects"
	prefs.toggles_sound ^= SOUND_AMBIENCE
	prefs.save_preferences()
	if(prefs.toggles_sound & SOUND_AMBIENCE)
		to_chat(src,SPAN_BOLDNOTICE( "You will now hear ambient sounds."))
		if(soundOutput)
			soundOutput.update_ambience(null, null, TRUE)
	else
		to_chat(src,SPAN_BOLDNOTICE( "You will no longer hear ambient sounds."))
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = SOUND_CHANNEL_AMBIENCE)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = SOUND_CHANNEL_SOUNDSCAPE)

/client/verb/toggle_roundstart_flash()
	set name = "Toggle Roundstart Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "Toggles the taskbar flashing when the round starts."

	prefs.toggles_flashing ^= FLASH_ROUNDSTART
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_ROUNDSTART)
		to_chat(src,  SPAN_BOLDNOTICE("The icon on your taskbar will now flash when the Tip of the Round is played right before the start of the round."))
	else
		to_chat(src,  SPAN_BOLDNOTICE("The icon on your taskbar will no longer flash when the Tip of the Round is played right before the start of the round."))

/client/verb/toggle_roundend_flash()
	set name = "Toggle Roundend Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "Toggles the taskbar flashing when the round ends."

	prefs.toggles_flashing ^= FLASH_ROUNDEND
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_ROUNDEND)
		to_chat(src,  SPAN_BOLDNOTICE("The icon on your taskbar will now flash when the round ends."))
	else
		to_chat(src, SPAN_BOLDNOTICE( "The icon on your taskbar will no longer flash when the round ends."))

/client/verb/toggle_corpserevive_flash()
	set name = "Toggle Revival Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "Toggles the taskbar flashing when your corpse gets revived."

	prefs.toggles_flashing ^= FLASH_CORPSEREVIVE
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_CORPSEREVIVE)
		to_chat(src,  SPAN_BOLDNOTICE("The icon on your taskbar will now flash when your corpse gets revived."))
	else
		to_chat(src, SPAN_BOLDNOTICE( "The icon on your taskbar will no longer flash when your corpse gets revived."))

/client/verb/toggle_unnest_flash()
	set name = "Toggle Unnest Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "Toggles the taskbar flashing when you get unnested and can reenter your body."

	prefs.toggles_flashing ^= FLASH_UNNEST
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_UNNEST)
		to_chat(src,  SPAN_BOLDNOTICE("The icon on your taskbar will now flash when you get unnested and can reenter your body."))
	else
		to_chat(src, SPAN_BOLDNOTICE( "The icon on your taskbar will no longer flash when you get unnested and can reenter your body."))

/client/verb/toggle_newlarva_flash()
	set name = "Toggle Larva Unpool Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "Toggles the taskbar flashing when you get spawned in as a xeno larva from the spawn pool."

	prefs.toggles_flashing ^= FLASH_POOLSPAWN
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_POOLSPAWN)
		to_chat(src,  SPAN_BOLDNOTICE("The icon on your taskbar will now flash when you get spawned as a pooled larva."))
	else
		to_chat(src, SPAN_BOLDNOTICE( "The icon on your taskbar will no longer flash when you get spawned as a pooled larva."))


/client/verb/toggle_adminpm_flash()
	set name = "Toggle Admin PM Flash"
	set category = "Preferences.TaskbarFlashing"
	set desc = "Toggles the taskbar flashing when you an admin messages you."

	prefs.toggles_flashing ^= FLASH_ADMINPM
	prefs.save_preferences()
	if(prefs.toggles_flashing & FLASH_ADMINPM)
		to_chat(src, SPAN_BOLDNOTICE("The icon on your taskbar will now flash when an admin messages you."))
	else
		to_chat(src, SPAN_BOLDNOTICE("The icon on your taskbar will no longer flash when an admin messages you. Warning, use at own risk."))

//be special
/client/verb/toggle_be_special(role in be_special_flags)
	set name = "Toggle SpecialRole Candidacy"
	set category = "Preferences"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."
	var/role_flag = be_special_flags[role]

	if(!role_flag)	return
	prefs.be_special ^= role_flag
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible)."))

/client/verb/toggle_fullscreen_preference()
	set name = "Toggle Fullscreen Preference"
	set category = "Preferences"
	set desc = "Toggles whether the game window will be true fullscreen or normal."

	prefs.toggle_prefs ^= TOGGLE_FULLSCREEN
	prefs.save_preferences()
	toggle_fullscreen(prefs.toggle_prefs & TOGGLE_FULLSCREEN)

/client/verb/toggle_ambient_occlusion()
	set name = "Toggle Ambient Occlusion"
	set category = "Preferences"
	set desc = "Toggles whether the game will have ambient occlusion on."

	prefs.toggle_prefs ^= TOGGLE_AMBIENT_OCCLUSION
	prefs.save_preferences()
	var/atom/movable/screen/plane_master/game_world/plane_master = locate() in src.screen
	if (!plane_master)
		return
	plane_master.backdrop(src.mob)

/client/verb/toggle_member_publicity()
	set name = "Toggle Membership Publicity"
	set category = "Preferences"
	set desc = "Toggles if other players can see that you are a BYOND member (OOC logo)."

	prefs.toggle_prefs ^= TOGGLE_MEMBER_PUBLIC
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("Others can[(prefs.toggle_prefs & TOGGLE_MEMBER_PUBLIC) ? "" : "'t"] now see if you are a BYOND member."))

/client/verb/toggle_ooc_country_flag()
	set name = "Toggle Country Flag"
	set category = "Preferences"
	set desc = "Toggles if your country flag (based on what country your IP is connecting from) is displayed in OOC chat."

	if(!(CONFIG_GET(flag/ooc_country_flags)))
		to_chat(src, SPAN_WARNING("Country Flags in OOC are disabled in the current server configuration!"))
		return

	prefs.toggle_prefs ^= TOGGLE_OOC_FLAG
	prefs.save_preferences()
	to_chat(src, SPAN_BOLDNOTICE("Your country flag [(prefs.toggle_prefs & TOGGLE_OOC_FLAG) ? "will now" : "will now not"] appear before your name in OOC chat."))

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
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_middle_mouse_click'>Toggle Middle Mouse Ability Activation</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_clickdrag_override'>Toggle Combat Click-Drag Override</a><br>",
		"<a href='?src=\ref[src];action=proccall;procpath=/client/proc/toggle_dualwield'>Toggle Alternate-Fire Dual Wielding</a><br>"
	)

	var/dat = ""
	for (var/pref_button in pref_buttons)
		dat += "[pref_button]\n"

	var/height = 50+22*length(pref_buttons)

	show_browser(src, dat, "Toggle Preferences", "togglepreferences", "size=475x[height]")

/client/proc/toggle_ignore_self() // Toggle whether anything will happen when you click yourself in non-help intent
	prefs.toggle_prefs ^= TOGGLE_IGNORE_SELF
	if(prefs.toggle_prefs & TOGGLE_IGNORE_SELF)
		to_chat(src,SPAN_BOLDNOTICE( "Clicking on yourself in non-help intent will no longer do anything."))
	else
		to_chat(src, SPAN_BOLDNOTICE("Clicking on yourself in non-help intent can harm you again."))
	prefs.save_preferences()

/client/proc/toggle_help_intent_safety() // Toggle whether anything will happen when you click on someone with help intent
	prefs.toggle_prefs ^= TOGGLE_HELP_INTENT_SAFETY
	if(prefs.toggle_prefs & TOGGLE_HELP_INTENT_SAFETY)
		to_chat(src, SPAN_BOLDNOTICE("Help intent will now be completely harmless."))
	else
		to_chat(src, SPAN_BOLDNOTICE("Help intent can perform harmful actions again."))
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
		to_chat(src, SPAN_BOLDNOTICE("Guns with auto-ejectors will automatically eject their magazines."))
	prefs.save_preferences()

/client/proc/toggle_auto_eject_to_hand() // Toggle whether guns with auto-ejectors will eject their magazines to your offhand
	prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_TO_HAND)
		var/msg = "Guns with auto-ejectors will eject their magazines to your offhand."
		if (prefs.toggle_prefs & TOGGLE_AUTO_EJECT_MAGAZINE_OFF)
			prefs.toggle_prefs ^= TOGGLE_AUTO_EJECT_MAGAZINE_OFF
			msg += " The preference for removing magazine auto-ejecting has been toggled off."
		to_chat(src, SPAN_BOLDNOTICE(msg))
	else
		to_chat(src, SPAN_BOLDNOTICE("Guns with auto-ejectors will no longer eject their magazines to your offhand."))
	prefs.save_preferences()

/client/proc/toggle_eject_to_hand() // Toggle whether unloading a magazine with the 'Unload Weapon' verb will put the magazine in your offhand
	prefs.toggle_prefs ^= TOGGLE_EJECT_MAGAZINE_TO_HAND
	if(prefs.toggle_prefs & TOGGLE_EJECT_MAGAZINE_TO_HAND)
		to_chat(src, SPAN_BOLDNOTICE("The 'Unload Weapon' verb will put magazines in your offhand."))
	else
		to_chat(src, SPAN_BOLDNOTICE("The 'Unload Weapon' verb will no longer put magazines in your offhand."))
	prefs.save_preferences()

/client/proc/toggle_automatic_punctuation() // Toggle whether your sentences are automatically punctuated
	prefs.toggle_prefs ^= TOGGLE_AUTOMATIC_PUNCTUATION
	if(prefs.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		to_chat(src, SPAN_BOLDNOTICE("Your messages will automatically be punctuated if they are not punctuated already."))
	else
		to_chat(src, SPAN_BOLDNOTICE("Your messages will no longer be automatically punctuated if they are not punctuated already."))
	prefs.save_preferences()

/client/proc/toggle_middle_mouse_click() // Toggle whether abilities should use middle or shift clicking
	prefs.toggle_prefs ^= TOGGLE_MIDDLE_MOUSE_CLICK
	if (prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK)
		to_chat(src, SPAN_NOTICE("Your selected ability will now be activated with middle clicking."))
	else
		to_chat(src, SPAN_NOTICE("Your selected ability will now be activated with shift clicking."))
	prefs.save_preferences()

/client/proc/toggle_clickdrag_override() //Toggle whether mousedown clicks immediately when on disarm or harm intent to prevent click-dragging from 'eating' attacks.
	prefs.toggle_prefs ^= TOGGLE_COMBAT_CLICKDRAG_OVERRIDE
	if(prefs.toggle_prefs & TOGGLE_COMBAT_CLICKDRAG_OVERRIDE)
		to_chat(src,SPAN_BOLDNOTICE( "Depressing the mouse button on disarm or harm intent will now click the target immediately, even if you hold it down -- unless you're click-dragging yourself, an ally, or an object in your inventory."))
	else
		to_chat(src,SPAN_BOLDNOTICE( "Click-dragging now blocks clicks from going through."))
	prefs.save_preferences()

/client/proc/toggle_dualwield() //Toggle whether dual-wielding fires both guns at once or swaps between them.
	prefs.toggle_prefs ^= TOGGLE_ALTERNATING_DUAL_WIELD
	if(prefs.toggle_prefs & TOGGLE_ALTERNATING_DUAL_WIELD)
		to_chat(src, SPAN_BOLDNOTICE("Dual-wielding now switches between guns, as long as the other gun is loaded."))
	else
		to_chat(src, SPAN_BOLDNOTICE("Dual-wielding now fires both guns simultaneously."))
	prefs.save_preferences()

/client/proc/toggle_middle_mouse_swap_hands() //Toggle whether middle click swaps your hands
	prefs.toggle_prefs ^= TOGGLE_MIDDLE_MOUSE_SWAP_HANDS
	to_chat(src, SPAN_BOLDNOTICE("Middle Click [(prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_SWAP_HANDS) ? "will" : "will no longer"] swap your hands."))
	prefs.save_preferences()

//------------ GHOST PREFERENCES ---------------------------------

/client/proc/show_ghost_preferences() // Shows ghost-related preferences.
	set name = "Show Ghost Prefs"
	set category = "Preferences"
	set desc = "Shows ghost-related preferences."

	add_verb(src, ghost_prefs_verbs)
	remove_verb(src, /client/proc/show_ghost_preferences)

/client/proc/hide_ghost_preferences() // Hides ghost-related preferences.
	set name = "Hide Ghost Prefs"
	set category = "Preferences"
	set desc = "Hides ghost-related preferences."

	remove_verb(src, ghost_prefs_verbs)
	add_verb(src, /client/proc/show_ghost_preferences)

/client/proc/toggle_ghost_hivemind()
	set name = "Toggle GhostHivemind"
	set category = "Preferences.Ghost"
	set desc = "Toggle seeing all chatter from the Xenomorph Hivemind"
	prefs.toggles_chat ^= CHAT_GHOSTHIVEMIND
	to_chat(src,SPAN_BOLDNOTICE( "As a ghost, you will [(prefs.toggles_chat & CHAT_GHOSTHIVEMIND) ? "now see chatter from the Xenomorph Hivemind" : "no longer see chatter from the Xenomorph Hivemind"]."))
	prefs.save_preferences()

/client/proc/deadchat() // Deadchat toggle is usable by anyone.
	set name = "Toggle Deadchat"
	set category = "Preferences.Ghost"
	set desc ="Toggles seeing DeadChat"
	prefs.toggles_chat ^= CHAT_DEAD
	prefs.save_preferences()

	if(src.admin_holder && (admin_holder.rights & R_MOD))
		to_chat(src,SPAN_DANGER( "You will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat."))
	else
		to_chat(src,SPAN_BOLDNOTICE( "As a ghost, you will [(prefs.toggles_chat & CHAT_DEAD) ? "now" : "no longer"] see deadchat."))

/client/proc/toggle_ghost_ears()
	set name = "Toggle GhostEars"
	set category = "Preferences.Ghost"
	set desc = "Toggle Between seeing all mob speech, and only speech of nearby mobs"
	prefs.toggles_chat ^= CHAT_GHOSTEARS
	to_chat(src, SPAN_BOLDNOTICE("As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"]."))
	prefs.save_preferences()

/client/proc/toggle_ghost_sight()
	set name = "Toggle GhostSight"
	set category = "Preferences.Ghost"
	set desc = "Toggle Between seeing all mob emotes, and only emotes of nearby mobs"
	prefs.toggles_chat ^= CHAT_GHOSTSIGHT
	to_chat(src, SPAN_BOLDNOTICE("As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"]."))
	prefs.save_preferences()

/client/proc/toggle_ghost_radio()
	set name = "Toggle GhostRadio"
	set category = "Preferences.Ghost"
	set desc = "Toggle between hearing all radio chatter, or only from nearby speakers"
	prefs.toggles_chat ^= CHAT_GHOSTRADIO
	to_chat(src,SPAN_BOLDNOTICE( "As a ghost, you will now [(prefs.toggles_chat & CHAT_GHOSTRADIO) ? "hear all radio chat in the world" : "only hear from nearby speakers"]."))
	prefs.save_preferences()

/client/proc/toggle_ghost_hud()
	set name = "Toggle Ghost HUDs"
	set category = "Preferences.Ghost"
	set desc = "Use to change which HUDs you want to have by default when you become an observer."

	var/hud_choice = tgui_input_list(usr, "Choose a HUD to toggle", "Toggle HUD prefs", list("Medical HUD", "Security HUD", "Squad HUD", "Xeno Status HUD", "Faction UPP HUD", "Faction Wey-Yu HUD", "Faction RESS HUD", "Faction CLF HUD"))
	if(!hud_choice)
		return
	prefs.observer_huds[hud_choice] = !prefs.observer_huds[hud_choice]
	prefs.save_preferences()

	to_chat(src, SPAN_BOLDNOTICE("You toggled [hud_choice] to be [prefs.observer_huds[hud_choice] ? "ON" : "OFF"] by default when you are observer."))

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
			H = huds[MOB_HUD_FACTION_OBSERVER]
		if("Xeno Status HUD")
			H = huds[MOB_HUD_XENO_STATUS]
		if("Faction UPP HUD")
			H = huds[MOB_HUD_FACTION_UPP]
		if("Faction Wey-Yu HUD")
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

/client/proc/toggle_ghost_health_scan()
	set name = "Toggle Health Scan"
	set category = "Preferences.Ghost"

	prefs.toggles_ghost ^= GHOST_HEALTH_SCAN
	prefs.save_preferences()
	to_chat(usr, "As a ghost, you will [prefs.toggles_ghost & GHOST_HEALTH_SCAN ? "now" : "no longer"] be able to scan health of living mobs via right click menu.")
	if(isobserver(usr))
		if(prefs.toggles_ghost & GHOST_HEALTH_SCAN)
			add_verb(usr, /mob/dead/observer/proc/scan_health)
		else
			remove_verb(usr, /mob/dead/observer/proc/scan_health)

GLOBAL_LIST_INIT(ghost_orbits, list(GHOST_ORBIT_CIRCLE, GHOST_ORBIT_TRIANGLE, GHOST_ORBIT_SQUARE, GHOST_ORBIT_HEXAGON, GHOST_ORBIT_PENTAGON))

/client/proc/pick_ghost_orbit()
	set name = "Pick Ghost Orbit Shape"
	set category = "Preferences.Ghost"
	set desc = "Toggle in what manner you orbit mobs while a ghost"
	var/new_orbit = tgui_input_list(src, "Choose your ghostly orbit:", "Ghost Customization", GLOB.ghost_orbits)
	if(!new_orbit)
		return

	prefs.ghost_orbit = new_orbit
	prefs.save_preferences()

	to_chat(src, SPAN_NOTICE("You will now orbit in a [new_orbit] shape as a ghost."))

	if(!isobserver(mob))
		return

	var/mob/dead/observer/O = mob
	O.ghost_orbit = new_orbit

//------------ COMBAT CHAT MESSAGES PREFERENCES ---------------------

//Made all chat combat-related logs added by Neth and several others to be hidden by default and shown when clicked respected verb. Reason: too cluttered preferences.
/client/proc/show_combat_chat_preferences() // Shows additional chat logs preferences.
	set category = "Preferences"
	set name = "Show Combat Chat Prefs"
	set desc = "Shows additional chat preferences for combat and ghost messages."

	add_verb(src, combat_chat_prefs_verbs)
	remove_verb(src, /client/proc/show_combat_chat_preferences)

/client/proc/hide_combat_chat_preferences() // Hides additional chat logs preferences.
	set category = "Preferences"
	set name = "Hide Combat Chat Prefs"
	set desc = "Hides additional chat preferences for combat and ghost messages."

	remove_verb(src, combat_chat_prefs_verbs)
	add_verb(src, /client/proc/show_combat_chat_preferences)

/client/proc/toggle_chat_shooting()
	set name = "Toggle Firing Messages"
	set category = "Preferences.Combat"
	set desc = ".Enable or Disable messages informing about weapon fire"
	prefs.chat_display_preferences ^= CHAT_TYPE_WEAPON_USE
	to_chat(src,SPAN_BOLDNOTICE( "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_WEAPON_USE) ? "see all weapon fire messages" : "never see weapon fire messages"]."))
	prefs.save_preferences()

/client/proc/toggle_chat_xeno_attack()
	set name = "Toggle Xeno Attack Messages"
	set category = "Preferences.Combat"
	set desc = ".Enable or Disable messages informing about xeno attacks"
	prefs.chat_display_preferences ^= CHAT_TYPE_XENO_COMBAT
	to_chat(src, SPAN_BOLDNOTICE("As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_XENO_COMBAT) ? "see all xeno attack messages" : "never see xeno attack messages"]."))
	prefs.save_preferences()

/client/proc/toggle_chat_xeno_armor()
	set name = "Toggle Xeno Armor Messages"
	set category = "Preferences.Combat"
	set desc = ".Enable or Disable messages informing about xeno armor"
	prefs.chat_display_preferences ^= CHAT_TYPE_ARMOR_DAMAGE
	to_chat(src, SPAN_BOLDNOTICE("As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_ARMOR_DAMAGE) ? "see all xeno armor messages" : "never see xeno armor messages"]."))
	prefs.save_preferences()

/client/proc/toggle_chat_someone_hit()
	set name = "Toggle Someone Hit Messages"
	set category = "Preferences.Combat"
	set desc = ".Enable or Disable messages informing about someone being hit"
	prefs.chat_display_preferences ^= CHAT_TYPE_TAKING_HIT
	to_chat(src,SPAN_BOLDNOTICE( "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_TAKING_HIT) ? "see all player hit messages" : "never see player hit messages"]."))
	prefs.save_preferences()

/client/proc/toggle_chat_you_hit()
	set name = "Toggle You Hit Messages"
	set category = "Preferences.Combat"
	set desc = ".Enable or Disable messages informing about you being hit"
	prefs.chat_display_preferences ^= CHAT_TYPE_BEING_HIT
	to_chat(src,SPAN_BOLDNOTICE( "As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_BEING_HIT) ? "see you being hit messages" : "never see you being hit messages"]."))
	prefs.save_preferences()

/client/proc/toggle_chat_you_pain()
	set name = "Toggle Pain Messages"
	set category = "Preferences.Combat"
	set desc = ".Enable or Disable messages informing about you being in pain"
	prefs.chat_display_preferences ^= CHAT_TYPE_PAIN
	to_chat(src, SPAN_BOLDNOTICE("As a player, you will now [(prefs.chat_display_preferences & CHAT_TYPE_PAIN) ? "see you being in pain messages" : "never see you being in pain messages"]."))
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
	/client/proc/toggle_ghost_health_scan,
	/client/proc/pick_ghost_orbit,
	/client/proc/hide_ghost_preferences)

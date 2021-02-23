
var/global/normal_ooc_colour = "#1c52f5"

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC.OOC"

	if(usr.talked == 2)
		to_chat(usr, SPAN_DANGER("Your spam has been consumed for it's nutritional value."))
		return
	if((usr.talked == 1) && (usr.chatWarn >= 5))
		usr.talked = 2
		to_chat(usr, SPAN_DANGER("You have been flagged for spam.  You may not speak for at least [usr.chatWarn] seconds (if you spammed alot this might break and never unmute you).  This number will increase each time you are flagged for spamming"))
		if(usr.chatWarn > 10)
			message_staff("[key_name(usr, usr.client)] is spamming like crazy, their current chatwarn is [usr.chatWarn]. ")
		addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked, TRUE, TRUE), usr.chatWarn * CHAT_OOC_DELAY_SPAM, TIMER_UNIQUE)
		return
	else if(usr.talked == 1)
		to_chat(usr, SPAN_NOTICE("You just said something, take a breath."))
		usr.chatWarn++
		return

	if(!mob)	return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = trim(strip_html(msg))
	if(!msg)	return

	if(!(prefs.toggles_chat & CHAT_OOC))
		to_chat(src, SPAN_DANGER("You have OOC muted."))
		return

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		if(!ooc_allowed) //Send to LOOC instead
			looc(msg)
			return
		if(!dooc_allowed && (mob.stat == DEAD || isobserver(mob)))
			to_chat(usr, SPAN_DANGER("OOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, SPAN_DANGER("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			message_staff("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")
	GLOB.STUI.ooc.Add("\[[time_stamp()]] <font color='#display_colour'>OOC: [mob.name]/[key]: [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_OOC_CHAT

	var/display_colour = CONFIG_GET(string/ooc_color_normal)
	if(admin_holder && !admin_holder.fakekey)
		display_colour = CONFIG_GET(string/ooc_color_other)
		if(admin_holder.rights & R_DEBUG)
			display_colour = CONFIG_GET(string/ooc_color_debug)
		if(admin_holder.rights & R_MOD)
			display_colour = CONFIG_GET(string/ooc_color_mods)
		if(admin_holder.rights & R_ADMIN)
			display_colour = CONFIG_GET(string/ooc_color_admin)
		if(admin_holder.rights & R_COLOR)
			display_colour = prefs.ooccolor
	else if(donator)
		display_colour = prefs.ooccolor
	if(!display_colour) // if invalid R_COLOR choice
		display_colour = CONFIG_GET(string/ooc_color_default)

	for(var/client/C in GLOB.clients)
		if(C.prefs.toggles_chat & CHAT_OOC)
			var/display_name = src.key
			to_chat(C, "<font color='[display_colour]'><span class='ooc'>[src.donator ? "\[D\] " : ""]<span class='prefix'>OOC: [display_name]</span>: <span class='message'>[msg]</span></span></font>")

	usr.talked = 1
	addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked), CHAT_OOC_DELAY, TIMER_UNIQUE)

/client/proc/set_ooc_color_global(newColor as color)
	set name = "OOC Text Color - Global"
	set desc = "Set to yellow for eye burning goodness."
	set category = "OOC.OOC"
	normal_ooc_colour = newColor


/client/verb/looc(msg as text)
	set name = "LOOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC.OOC"

	if(usr.talked == 2)
		to_chat(usr, SPAN_DANGER("Your spam has been consumed for it's nutritional value."))
		return
	if((usr.talked == 1) && (usr.chatWarn >= 5))
		usr.talked = 2
		to_chat(usr, SPAN_DANGER("You have been flagged for spam.  You may not speak for at least [usr.chatWarn] seconds (if you spammed alot this might break and never unmute you).  This number will increase each time you are flagged for spamming"))
		if(usr.chatWarn >10)
			message_staff("[key_name(usr, usr.client)] is spamming like crazy, their current chatwarn is [usr.chatWarn]. ")
		addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked, TRUE, TRUE), usr.chatWarn * CHAT_OOC_DELAY_SPAM, TIMER_UNIQUE)
		return
	else if(usr.talked == 1)
		to_chat(usr, SPAN_NOTICE("You just said something, take a breath."))
		usr.chatWarn++
		return


	if(!mob)	return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use LOOC.")
		return

	msg = trim(strip_html(msg))
	if(!msg)	return

	if(!(prefs.toggles_chat & CHAT_LOOC))
		to_chat(src, SPAN_DANGER("You have LOOC muted."))
		return

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		if(!looc_allowed)
			to_chat(src, SPAN_DANGER("LOOC is globally muted"))
			return
		if(!dlooc_allowed && (mob.stat == DEAD || isobserver(mob)))
			to_chat(usr, SPAN_DANGER("LOOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, SPAN_DANGER("You cannot use LOOC (muted)."))
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			message_staff("[key_name_admin(src)] has attempted to advertise in LOOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")
	GLOB.STUI.ooc.Add("\[[time_stamp()]] <font color='#6699CC'>LOOC: [mob.name]/[key]: [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_OOC_CHAT
	var/list/heard = get_mobs_in_view(7, src.mob)
	var/mob/S = src.mob

	var/display_name = S.key
	if(S.stat != DEAD && !isobserver(S))
		display_name = S.name

	// Handle non-admins
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C.admin_holder && (C.admin_holder.rights & R_MOD))
			continue //they are handled after that

		if(C.prefs.toggles_chat & CHAT_LOOC)
			to_chat(C, "<font color='#6699CC'><span class='ooc'><span class='prefix'>LOOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

	// Now handle admins
	display_name = S.key
	if(S.stat != DEAD && !isobserver(S))
		display_name = "[S.name]/([S.key])"

	for(var/client/C in GLOB.admins)
		if(!C.admin_holder || !(C.admin_holder.rights & R_MOD))
			continue

		if(C.prefs.toggles_chat & CHAT_LOOC)
			var/prefix = "(R)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			to_chat(C, "<font color='#6699CC'><span class='ooc'><span class='prefix'>[prefix]:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")
	usr.talked = 1
	addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked), CHAT_OOC_DELAY, TIMER_UNIQUE)

/client/verb/round_info()
	set name = "Current Map" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Information about the current round"
	set category = "OOC"
	to_chat_spaced(usr, html = FONT_SIZE_LARGE(SPAN_NOTICE("The current map is [SSmapping.configs[GROUND_MAP].map_name]")))

// Sometimes the game fails to close NanoUIs, seemingly at random. This makes it impossible to open new ones
// If this happens, let the player manually close them all
/client/verb/fixnanoui()
	set name = "Fix Interfaces"
	set desc = "Fixes all broken interfaces by forcing all existing ones to close"
	set category = "OOC.Fix"

	if(!mob)
		return

	for(var/I in mob.open_uis)
		var/datum/nanoui/ui = I
		if(!QDELETED(ui))
			ui.close()

	log_tgui(src, "Closing all tgui windows.", context = "verb/fixnanoui")
	var/closed_windows = SStgui.close_user_uis(usr)

	to_chat(mob, SPAN_NOTICE("<b>All interfaces have been forcefully closed. Please try re-opening them. (Closed [closed_windows] windows)</b>"))

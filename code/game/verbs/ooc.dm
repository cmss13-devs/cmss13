
var/global/normal_ooc_colour = "#1c52f5"

/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"

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
	STUI.ooc.Add("\[[time_stamp()]] <font color='#display_colour'>OOC: [mob.name]/[key]: [msg]</font><br>")
	STUI.processing |= STUI_LOG_OOC_CHAT
	var/display_colour = normal_ooc_colour
	if(admin_holder && !admin_holder.fakekey && !AHOLD_IS_ONLY_MENTOR(admin_holder))
		display_colour = "#2e78d9"	//light blue
		if(admin_holder.rights & R_MOD && !(admin_holder.rights & R_ADMIN))
			display_colour = "#184880"	//dark blue
		if(admin_holder.rights & R_DEBUG && !(admin_holder.rights & R_ADMIN))
			display_colour = "#1b521f"	//dark green
		else if(admin_holder.rights & R_COLOR)
			if(config.allow_admin_ooccolor)
				display_colour = prefs.ooccolor
			else
				display_colour = "#b82e00"	//orange
	if(donator)
		display_colour = prefs.ooccolor

	for(var/client/C in GLOB.clients)
		if(C.prefs.toggles_chat & CHAT_OOC)
			var/display_name = src.key
			if(admin_holder && (admin_holder.rights & R_MOD))
				if(admin_holder.fakekey)
					if(C.admin_holder)
						display_name = "[admin_holder.fakekey]/([src.key])"
					else
						display_name = admin_holder.fakekey
			to_chat(C, "<font color='[display_colour]'><span class='ooc'>[src.donator ? "\[D\] " : ""]<span class='prefix'>OOC: [display_name]</span>: <span class='message'>[msg]</span></span></font>")
	
	usr.talked = 1
	addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked), CHAT_OOC_DELAY, TIMER_UNIQUE)

/client/proc/set_ooc_color_global(newColor as color)
	set name = "OOC Text Color - Global"
	set desc = "Set to yellow for eye burning goodness."
	set category = "OOC"
	normal_ooc_colour = newColor


/client/verb/looc(msg as text)
	set name = "LOOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

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
	STUI.ooc.Add("\[[time_stamp()]] <font color='#6699CC'>LOOC: [mob.name]/[key]: [msg]</font><br>")
	STUI.processing |= STUI_LOG_OOC_CHAT
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
			if(admin_holder && (admin_holder.rights & R_MOD))
				if(admin_holder.fakekey)
					if(C.admin_holder)
						display_name = "[admin_holder.fakekey]/([src.key])"
					else
						display_name = admin_holder.fakekey
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
	to_chat(usr, SPAN_NOTICE("The current map is [map_tag]"))


/client/verb/old_chat()
	set name = "Old Chat"
	set category = "OOC"
	if(alert(src, "Are you sure you want to switch back to the old chat?", "", "Yes", "Cancel") == "Yes")
		if(chatOutput)
			chatOutput.oldChat = TRUE
		winset(src, "output", "is-visible=true;is-disabled=false")
		winset(src, "browseroutput", "is-visible=false")


/client/verb/reload_chat()
	set name = "Reload Goonchat"
	set category = "OOC"
	if (!chatOutput)
		chatOutput = new /datum/chatOutput(src)
		chatOutput.start()
		if(alert(src, "Goonchat is starting up again, wait for a bit before answering. Is it fixed?", "", "Yes", "No") == "No")
			chatOutput.load()
	else if (chatOutput.loaded)
		chatOutput.loaded = FALSE
		chatOutput.start()
		if(alert(src, "Goonchat is starting up again, wait for a bit before answering. Is it fixed?", "", "Yes", "No") == "No")
			chatOutput.load()
	else
		chatOutput.start()
		if(alert(src, "Goonchat is starting up again, wait for a bit before answering. Is it fixed?", "", "Yes", "No") == "No")
			chatOutput.load()

// Sometimes the game fails to close NanoUIs, seemingly at random. This makes it impossible to open new ones
// If this happens, let the player manually close them all
/client/verb/fixnanoui()
	set name = "Fix NanoUI"
	set desc = "Fixes NanoUI by forcing all existing ones to close"
	set category = "OOC"

	if(!mob)
		return

	for(var/datum/nanoui/ui in mob.open_uis)
		if(!QDELETED(ui))
			ui.close()

	to_chat(mob, SPAN_NOTICE("<b>All NanoUIs have been forcefully closed. Please try re-opening them.</b>"))

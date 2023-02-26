/client/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC.OOC"

	if(!mob) return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = trim(strip_html(msg))
	if(!msg) return

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
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	if(!attempt_talking(msg))
		return

	log_ooc("[mob.name]/[key] : [msg]")
	GLOB.STUI.ooc.Add("\[[time_stamp()]] <font color='#display_colour'>OOC: [mob.name]/[key]: [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_OOC_CHAT

	var/display_colour = GLOB.ooc_color_override
	if(!display_colour)
		display_colour = CONFIG_GET(string/ooc_color_normal)
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

	msg = process_chat_markup(msg, list("*"))

	for(var/client/C in GLOB.clients)
		if(C.prefs.toggles_chat & CHAT_OOC)
			var/display_name = src.key
			if(prefs.unlock_content)
				if(prefs.toggle_prefs & TOGGLE_MEMBER_PUBLIC)
					var/byond = icon('icons/effects/effects.dmi', "byondlogo")
					display_name = "[icon2html(byond, GLOB.clients)][display_name]"
			if(CONFIG_GET(flag/ooc_country_flags))
				if(prefs.toggle_prefs & TOGGLE_OOC_FLAG)
					display_name = "[country2chaticon(src.country, GLOB.clients)][display_name]"
			to_chat(C, "<font color='[display_colour]'><span class='ooc linkify'>[src.donator ? "\[D\] " : ""]<span class='prefix'>OOC: [display_name]</span>: <span class='message'>[msg]</span></span></font>")
/client/proc/set_ooc_color_global(newColor as color)
	set name = "OOC Text Color - Global"
	set desc = "Set to yellow for eye burning goodness."
	set category = "OOC.OOC"
	GLOB.ooc_color_override = newColor


/client/verb/looc(msg as text)
	set name = "LOOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC.OOC"

	if(!mob) return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use LOOC.")
		return

	msg = trim(strip_html(msg))
	if(!msg) return

	if(!(prefs.toggles_chat & CHAT_LOOC))
		to_chat(src, SPAN_DANGER("You have LOOC muted."))
		return

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		if(!looc_allowed)
			to_chat(src, SPAN_DANGER("LOOC is globally muted"))
			return
		if(!dlooc_allowed && (mob.stat != CONSCIOUS || isobserver(mob)))
			to_chat(usr, SPAN_DANGER("Sorry, you cannot utilize LOOC while dead or incapacitated."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, SPAN_DANGER("You cannot use LOOC (muted)."))
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			message_admins("[key_name_admin(src)] has attempted to advertise in LOOC: [msg]")
			return

	if(!attempt_talking(msg))
		return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")
	GLOB.STUI.ooc.Add("\[[time_stamp()]] <font color='#6699CC'>LOOC: [mob.name]/[key]: [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_OOC_CHAT
	var/list/heard = get_mobs_in_view(7, src.mob)
	var/mob/S = src.mob

	var/display_name = S.key
	if(S.stat != DEAD && !isobserver(S))
		display_name = S.name

	msg = process_chat_markup(msg, list("*"))

	// Handle non-admins
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C.admin_holder && (C.admin_holder.rights & R_MOD))
			continue //they are handled after that

		if(C.prefs.toggles_chat & CHAT_LOOC)
			to_chat(C, "<font color='#f557b8'><span class='ooc linkify'><span class='prefix'>LOOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

	if(mob.looc_overhead || ooc_allowed)
		var/transmit_language = isxeno(mob) ? LANGUAGE_XENOMORPH : LANGUAGE_ENGLISH
		mob.langchat_speech(msg, heard, GLOB.all_languages[transmit_language], "#ff47d7")

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
			to_chat(C, "<font color='#f557b8'><span class='ooc linkify'><span class='prefix'>[prefix]:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>")

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

/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"

	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.split;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/split_width = text2num(split_size[1])

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.split", "splitter=[pct]")

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		pct += delta
		winset(src, "mainwindow.split", "splitter=[pct]")

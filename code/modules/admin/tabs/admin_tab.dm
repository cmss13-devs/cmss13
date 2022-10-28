/client/proc/deadmin_self()
	set name = "De-Admin"
	set category = "Admin"

	if(!admin_holder)
		return

	if(alert("Confirm deadmin? This procedure can be reverted at any time and will not carry over to next round, but you will lose all your admin powers in the meantime.", , "Yes", "No") == "No")
		return

	message_staff("[src] de-admined themselves.")
	add_verb(src, /client/proc/readmin_self)
	deadmin()
	to_chat(src, "<br><br><span class='centerbold'><big>You are now a normal player. You can ascend back to adminhood at any time using the 'Re-admin Self' verb in your Admin panel.</big></span><br>")

/client/proc/readmin_self()
	set name = "Re-Admin"
	set category = "Admin"

	remove_verb(src, /client/proc/readmin_self)
	readmin()
	to_chat(src, "<br><br><span class='centerbold'><big>You have ascended back to adminhood. All your verbs should be back where you left them.</big></span><br>")
	message_staff("[src] re-admined themselves.")

/client/proc/becomelarva()
	set name = "Lose Larva Protection"
	set desc = "Remove your protection from becoming a larva."
	set category = "Admin.Game"

	if(!admin_holder)
		return

	if(istype(mob,/mob/dead/observer))
		var/mob/dead/observer/ghost = mob
		if(ghost.adminlarva == 0)
			ghost.adminlarva = 1
			to_chat(usr, SPAN_BOLDNOTICE("You have disabled your larva protection."))
		else if(ghost.adminlarva == 1)
			ghost.adminlarva = 0
			to_chat(usr, SPAN_BOLDNOTICE("You have re-activated your larva protection."))
		else
			to_chat(usr, SPAN_BOLDNOTICE("Something went wrong tell a coder"))
	else if(istype(mob,/mob/new_player))
		to_chat(src, "<font color='red'>Error: Lose larva Protection: Can't lose larva protection whilst in the lobby. Observe first.</font>")
	else
		to_chat(src, "<font color='red'>Error: Lose larva Protection: You must be a ghost to use this.</font>")

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin.Panels"

	if(admin_holder)
		admin_holder.unbanpanel()
	return

/client/proc/player_panel_new()
	set name = "Player Panel"
	set category = "Admin.Panels"

	if(admin_holder)
		admin_holder.player_panel_new()
	return

/client/proc/admin_ghost()
	set name = "Aghost"
	set category = "Admin.Game"

	if(!check_rights(R_MOD))
		return

	var/new_STUI = 0
	if(usr.open_uis)
		for(var/datum/nanoui/ui in usr.open_uis)
			if(ui.title == "STUI")
				new_STUI = 1
				ui.close()
				continue
			if(ui.allowed_user_stat == -1)
				ui.close()
				continue
	if(istype(mob,/mob/dead/observer))
		//re-enter
		var/mob/dead/observer/ghost = mob
		ghost.can_reenter_corpse = TRUE
		ghost.reenter_corpse()
		return

	if(istype(mob,/mob/new_player))
		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
		return

	//ghostize
	log_admin("[key_name(usr)] admin ghosted.")

	var/mob/body = mob
	body.ghostize(TRUE, TRUE)
	if(body && !body.key)
		body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		if(body.client)
			body.client.change_view(world_view_size) //reset view range to default.

		//re-open STUI
	if(new_STUI)
		GLOB.STUI.tgui_interact(mob)

/client/proc/invismin()
	set name = "Invismin"
	set category = "Admin.Game"

	if(!check_rights(R_MOD))
		return

	if(admin_holder.fakekey)
		admin_holder.fakekey = null
		if(isobserver(mob))
			mob.invisibility = initial(mob.invisibility)
			mob.alpha = initial(mob.alpha)
			mob.mouse_opacity = initial(mob.mouse_opacity)
	else
		admin_holder.fakekey = "John Titor"
		if(isobserver(mob))
			mob.invisibility = INVISIBILITY_MAXIMUM
			mob.alpha = 0
			mob.mouse_opacity = 0

	admin_holder.invisimined = !admin_holder.invisimined

	to_chat(src, SPAN_NOTICE("You have turned invismin [admin_holder.fakekey ? "ON" : "OFF"]"))
	log_admin("[key_name_admin(usr)] has turned invismin [admin_holder.fakekey ? "ON" : "OFF"]")

/datum/admins/proc/announce()
	set name = "Admin Announcement"
	set desc = "Announce your desires to the world"
	set category = "Admin.Game"

	if(!check_rights(0))
		return
	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_chat_spaced(world, type = MESSAGE_TYPE_SYSTEM, html = SPAN_ANNOUNCEMENT_HEADER_ADMIN(" <b>[usr.client.admin_holder.fakekey ? "Administrator" : usr.key] Announces:</b>\n \t [message]"))
		log_admin("Announce: [key_name(usr)] : [message]")

/datum/admins/proc/player_notes_show(var/key as text)
	set name = "Player Notes Show"
	set category = "Admin"
	if (!istype(src,/datum/admins))
		src = usr.client.admin_holder
	if (!istype(src,/datum/admins) || !(src.rights & R_MOD))
		to_chat(usr, "Error: you are not an admin!")
		return

	var/datum/entity/player/P = get_player_from_key(key)
	if(!P.migrated_notes)
		to_chat(usr, "Error: notes not yet migrated for that key. Please try again in 5 minutes.")
		return

	var/dat = "<html>"
	dat += "<body>"

	var/list/datum/view_record/note_view/NL = DB_VIEW(/datum/view_record/note_view, DB_COMP("player_ckey", DB_EQUALS, key))
	for(var/datum/view_record/note_view/N as anything in NL)
		var/admin_ckey = N.admin_ckey
		var/confidential_text = N.is_confidential ? " \[CONFIDENTIALLY\]" : ""
		var/color = "#008800"
		if(N.note_category && (N.note_category != NOTE_ADMIN))
			continue
		if(N.is_ban)
			var/ban_text = N.ban_time ? "Banned for [N.ban_time] | " : ""
			color = "#880000"
			dat += "<font color=[color]>[ban_text][N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i>[confidential_text] on <i><font color=blue>[N.date]</i></font> "
		else
			if(N.is_confidential)
				color = "#AA0055"

			dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i>[confidential_text] on <i><font color=blue>[N.date]</i></font> "
		dat += "<br><br>"

	dat += "<br>"
	dat += "<A href='?src=\ref[src];[HrefToken()];add_player_info=[key]'>Add Note</A><br>"
	dat += "<A href='?src=\ref[src];[HrefToken()];add_player_info_confidential=[key]'>Add Confidential Note</A><br>"
	dat += "<A href='?src=\ref[src];[HrefToken()];player_notes_all=[key]'>Show Complete Record</A><br>"

	dat += "</body></html>"
	show_browser(usr, dat, "Admin record for [key]", "adminplayerinfo", "size=480x480")

/datum/admins/proc/sleepall()
	set name = "Sleep All"
	set category = "Admin.InView"
	set hidden = 1

	if(!check_rights(0))
		return

	if(alert("This will sleep ALL mobs within your view range (for Administration purposes). Are you sure?",,"Yes","Cancel") == "Cancel")
		return
	for(var/mob/living/M in view(usr.client))
		M.KnockOut(3) // prevents them from exiting the screen range
		M.sleeping = 9999999 //if they're not, sleep them and add the sleep icon, so other marines nearby know not to mess with them.
		M.AddSleepingIcon()

	message_staff("[key_name(usr)] used Toggle Sleep In View.")

/datum/admins/proc/wakeall()
	set name = "Wake All"
	set category = "Admin.InView"
	set hidden = 1

	if(!check_rights(0))
		return

	if(alert("This wake ALL mobs within your view range (for Administration purposes). Are you sure?",,"Yes","Cancel") == "Cancel")
		return
	for(var/mob/living/M in view(usr.client))
		M.sleeping = 0 //set their sleep to zero and remove their icon
		M.RemoveSleepingIcon()

	message_staff("[key_name(usr)] used Toggle Wake In View.")

/client/proc/cmd_admin_say(msg as text)
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set category = "Admin"
	set hidden = 1

	if(!check_rights(R_ADMIN))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	log_adminpm("ADMIN : [key_name(src)] : [msg]")

	var/color = "adminsay"
	if(ishost(usr))
		color = "headminsay"

	if(check_rights(R_ADMIN,0))
		msg = "<span class='[color]'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
		for(var/client/C in GLOB.admins)
			if(R_ADMIN & C.admin_holder.rights)
				to_chat(C, msg)

/datum/admins/proc/alertall()
	set name = "Alert All"
	set category = "Admin.InView"
	set hidden = TRUE

	if(!check_rights(R_MOD))
		return

	var/message = input(src, "Input your custom admin alert text:", "Message") as text|null
	if(!message) return
	var/color = input(src, "Input your message color:", "Color Selector") as color|null
	if(!color) return

	for(var/mob/living/mob in view(usr.client))
		show_blurb(mob, 15, message, null, "center", "center", color, null, null, 1)
	log_admin("[key_name(src)] sent an In View admin alert with custom message [message].")
	message_staff("[key_name(src)] sent an In View admin alert with custom message [message].")

/datum/admins/proc/directnarrateall()
	set name = "Direct Narrate All"
	set category = "Admin.InView"
	set hidden = TRUE

	if(!check_rights(R_MOD))
		return

	var/message = input("Message:", text("Enter the text you wish to appear to your target:")) as text|null
	if(!message)
		return

	for(var/mob/living/mob in view(usr.client))
		to_chat(mob, SPAN_ANNOUNCEMENT_HEADER_BLUE(message))
	log_admin("[key_name(src)] sent a Direct Narrate in View with custom message \"[message]\".")
	message_staff("[key_name(src)] sent a Direct Narrate in View with custom message \"[message]\".")

#define SUBTLE_MESSAGE_IN_HEAD "Voice in Head"
#define SUBTLE_MESSAGE_WEYLAND "Weyland-Yutani"
#define SUBTLE_MESSAGE_USCM "USCM High Command"
#define SUBTLE_MESSAGE_FACTION "Faction Specific"

/datum/admins/proc/subtlemessageall()
	set name = "Subtle Message All"
	set category = "Admin.InView"
	set hidden = TRUE

	if(!check_rights(R_MOD))
		return

	var/list/subtle_message_options = list(SUBTLE_MESSAGE_IN_HEAD, SUBTLE_MESSAGE_WEYLAND, SUBTLE_MESSAGE_USCM, SUBTLE_MESSAGE_FACTION)
	var/message_option = tgui_input_list(usr, "Choose the method of subtle messaging", "", subtle_message_options)

	if(message_option == SUBTLE_MESSAGE_FACTION)
		var/faction = input("Choose which faction", "") as text|null
		if(!faction)
			return
		message_option = faction

	var/input = input("Contents of the message", text("Subtle PM to In View")) as text|null
	if(!input)
		return

	var/message
	switch(message_option)
		if(SUBTLE_MESSAGE_IN_HEAD)
			message = SPAN_ANNOUNCEMENT_HEADER_BLUE("You hear a voice in your head... [input]")
		else
			message = SPAN_DANGER("Message received through headset. [message_option] Transmission <b>\"[input]\"</b>")

	for(var/mob/living/carbon/human/mob in view(usr.client))
		if(message_option == SUBTLE_MESSAGE_IN_HEAD)
			to_chat(mob, message)
		else
			if(mob.get_type_in_ears(/obj/item/device/radio/headset))
				to_chat(mob, message)
	message_staff("[key_name(usr)] used Subtle Message All In View from [message_option], saying \"[input]\".")

#undef SUBTLE_MESSAGE_IN_HEAD
#undef SUBTLE_MESSAGE_WEYLAND
#undef SUBTLE_MESSAGE_USCM
#undef SUBTLE_MESSAGE_FACTION

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)

/client/proc/cmd_mod_say(msg as text)
	set name = "Msay"
	set category = "Admin"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	if(findtext(msg, "@") || findtext(msg, "#"))
		var/list/link_results = check_asay_links(msg)
		if(length(link_results))
			msg = link_results[ASAY_LINK_NEW_MESSAGE_INDEX]
			link_results[ASAY_LINK_NEW_MESSAGE_INDEX] = null
			var/list/pinged_admin_clients = link_results[ASAY_LINK_PINGED_ADMINS_INDEX]
			for(var/iter_ckey in pinged_admin_clients)
				var/client/iter_admin_client = pinged_admin_clients[iter_ckey]
				if(!iter_admin_client?.admin_holder)
					continue
				window_flash(iter_admin_client)
				SEND_SOUND(iter_admin_client.mob, sound('sound/misc/asay_ping.ogg'))

	log_adminpm("MOD: [key_name(src)] : [msg]")

	var/color = "mod"
	if (check_rights(R_ADMIN,0))
		color = "adminmod"

	var/channel = "MOD:"
	channel = "[admin_holder.rank]:"
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			to_chat(C, "<span class='[color]'><span class='prefix'>[channel]</span> <EM>[key_name(src,1)]</EM> (<A HREF='?src=\ref[C.admin_holder];[HrefToken(forceGlobal = TRUE)];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>")

/client/proc/get_mod_say()
	var/msg = input(src, null, "msay \"text\"") as text|null
	cmd_mod_say(msg)

/client/proc/cmd_mentor_say(msg as text)
	set name = "MentorSay"
	set category = "OOC"
	set hidden = 0

	if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	log_adminpm("MENTOR: [key_name(src)] : [msg]")

	var/color = "mentorsay"
	var/channel = "Mentor:"
	channel = "[admin_holder.rank]:"
	if(check_rights(R_MOD|R_ADMIN,0))
		color = "staffsay"

	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD|R_MENTOR) & C.admin_holder.rights)
			to_chat(C, "<span class='[color]'><span class='prefix'>[channel]</span> <EM>([usr.key])</EM>: <span class='message'>[msg]</span></span>")

/client/proc/get_mentor_say()
	var/msg = input(src, null, "mentorsay \"text\"") as text|null
	cmd_mentor_say(msg)

/client/proc/enable_admin_verbs()
	set name = "Admin Verbs - Show"
	set category = "Admin"

	add_verb(src, admin_verbs_hideable)
	remove_verb(src, /client/proc/enable_admin_verbs)

	if(!(admin_holder.rights & R_DEBUG))
		remove_verb(src, /client/proc/proccall_atom)
	if(!(admin_holder.rights & R_POSSESS))
		remove_verb(src, /client/proc/release)
		remove_verb(src, /client/proc/possess)

/client/proc/hide_admin_verbs()
	set name = "Admin Verbs - Hide"
	set category = "Admin"

	remove_verb(src, admin_verbs_hideable)
	add_verb(src, /client/proc/enable_admin_verbs)

/client/proc/rejuvenate_all_in_view()
	set name = "Rejuvenate All"
	set category = "Admin.InView"
	set hidden = 1

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(alert("This will rejuvenate ALL mobs within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	for(var/mob/living/M in view())
		M.rejuvenate(FALSE)

	message_staff(WRAP_STAFF_LOG(usr, "ahealed everyone in [get_area(usr)] ([usr.x],[usr.y],[usr.z])."), usr.x, usr.y, usr.z)


/client/proc/rejuvenate_all_humans_in_view()
	set name = "Rejuvenate All Humans"
	set category = "Admin.InView"
	set hidden = 1

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(alert("This will rejuvenate ALL humans within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	for(var/mob/living/carbon/human/M in view())
		M.rejuvenate(FALSE)

	message_staff(WRAP_STAFF_LOG(usr, "ahealed all humans in [get_area(usr)] ([usr.x],[usr.y],[usr.z])"), usr.x, usr.y, usr.z)

/client/proc/rejuvenate_all_revivable_humans_in_view()
	set name = "Rejuvenate Revivable Human"
	set category = "Admin.InView"
	set hidden = 1

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(alert("This will rejuvenate ALL revivable humans within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	for(var/mob/living/carbon/human/M in view())
		if(!isHumanStrict(M) && !isHumanSynthStrict(M))
			continue

		if(M.stat != DEAD)
			M.rejuvenate(FALSE)
			continue

		if(!M.undefibbable && M.stat == DEAD)
			M.rejuvenate(FALSE)
			continue

	message_staff(WRAP_STAFF_LOG(usr, "ahealed all revivable humans in [get_area(usr)] ([usr.x],[usr.y],[usr.z])"), usr.x, usr.y, usr.z)

/client/proc/rejuvenate_all_xenos_in_view()
	set name = "Rejuvenate Xenos"
	set category = "Admin.InView"
	set hidden = 1

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	if(alert("This will rejuvenate ALL xenos within your view range. Are you sure?",,"Yes","Cancel") == "Cancel")
		return

	for(var/mob/living/carbon/Xenomorph/X in view())
		X.rejuvenate(FALSE)

	message_staff(WRAP_STAFF_LOG(usr, "ahealed all xenos in [get_area(usr)] ([usr.x],[usr.y],[usr.z])"), usr.x, usr.y, usr.z)

// ----------------------------
// PANELS
// ----------------------------
/datum/admins/proc/teleport_panel()
	if(!check_rights(R_MOD, 0))
		return

	var/dat = {"
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_area'>Jump to Area</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_turf'>Jump to Turf</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_mob'>Jump to Mob</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_obj'>Jump to Object</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_key'>Jump to Ckey</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_coord'>Jump to Coordinates</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=jump_to_offset_coord'>Jump to Offset Coordinates</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=get_mob'>Teleport Mob to You</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=get_key'>Teleport Ckey to You</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=teleport_mob_to_area'>Teleport Mob to Area</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=teleport_mobs_in_range'>Mass Teleport Mobs in Range</A><BR>
		<A href='?src=\ref[src];[HrefToken()];teleport=teleport_mobs_by_faction'>Mass Teleport Mobs to You by Faction</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "Teleport Panel", "teleports")
	return

/client/proc/teleport_panel()
	set name = "Teleport Panel"
	set category = "Admin.Panels"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	admin_holder.teleport_panel()

/datum/admins/proc/vehicle_panel()
	if(!check_rights(R_MOD, 0))
		return

	var/dat = {"
		<A href='?src=\ref[src];[HrefToken()];vehicle=remove_clamp'>Remove Vehicle Clamp</A><BR>
		Forcibly removes vehicle clamp from vehicle selected from a list. Drops it under the vehicle.<BR>
		<A href='?src=\ref[src];[HrefToken()];vehicle=repair_vehicle'>Repair Vehicle</A><BR>
		Fully restores vehicle modules and hull health.<BR>
		"}

	show_browser(usr, dat, "Vehicle Panel", "vehicles")
	return

/client/proc/vehicle_panel()
	set name = "Vehicle Panel"
	set category = "Admin.Panels"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	admin_holder.vehicle_panel()

/datum/admins/proc/in_view_panel()
	var/dat = {"
		<A href='?src=\ref[src];[HrefToken()];inviews=rejuvenateall'>Rejuvenate All Mobs In View</A><BR>
		<BR>
		<A href='?src=\ref[src];[HrefToken()];inviews=rejuvenatemarine'>Rejuvenate Only Humans In View</A><BR>
	 	<A href='?src=\ref[src];[HrefToken()];inviews=rejuvenaterevivemarine'>Rejuvenate Only Revivable Humans In View</A><BR>
		<BR>
		<A href='?src=\ref[src];[HrefToken()];inviews=rejuvenatexeno'>Rejuvenate Only Xenos In View</A><BR>
		<BR>
		<A href='?src=\ref[src];[HrefToken()];inviews=sleepall'>Sleep All In View</A><BR>
		<A href='?src=\ref[src];[HrefToken()];inviews=wakeall'>Wake All In View</A><BR>

		<A href='?src=\ref[src];[HrefToken()];inviews=directnarrateall'>Direct Narrate In View</A><BR>
		<A href='?src=\ref[src];[HrefToken()];inviews=alertall'>Alert Message In View</A><BR>
		<A href='?src=\ref[src];[HrefToken()];inviews=subtlemessageall'>Subtle Message In View</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "In View Panel", "inviews")
	return

/client/proc/in_view_panel()
	set name = "In View Panel"
	set category = "Admin.InView"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	admin_holder.in_view_panel()

/client/proc/toggle_lz_resin()
	set name = "Toggle LZ Weeding"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	set_lz_resin_allowed(!GLOB.resin_lz_allowed)
	message_staff("[src] has [GLOB.resin_lz_allowed ? "allowed xenos to weed" : "disallowed from weeding"] near the LZ.")

/proc/set_lz_resin_allowed(var/allowed = TRUE)
	if(allowed)
		for(var/area/A in all_areas)
			A.is_resin_allowed = TRUE
		msg_admin_niche("Areas close to landing zones are now weedable.")
	else
		for(var/area/A in all_areas)
			A.is_resin_allowed = initial(A.is_resin_allowed)
		msg_admin_niche("Areas close to landing zones cannot be weeded now.")
	GLOB.resin_lz_allowed = allowed

/client/proc/toggle_ob_spawn() // not really a flag but i'm cheating here
	set name = "Toggle OB Spawn"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	GLOB.spawn_ob = !GLOB.spawn_ob
	message_staff("[src] has [GLOB.spawn_ob ? "allowed OBs to spawn" : "prevented OBs from spawning"] at roundstart.")

/client/proc/toggle_sniper_upgrade()
	set name = "Toggle Engi Sniper Upgrade"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_NO_SNIPER_SENTRY
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_SNIPER_SENTRY) ? "disallowed engineers from picking" : "allowed engineers to pick"] long-range sentry upgrades.")

/client/proc/toggle_attack_dead()
	set name = "Toggle Attack Dead"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_NO_ATTACK_DEAD
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_ATTACK_DEAD) ? "prevented dead mobs from being" : "allowed dead mobs to be"] attacked.")

/client/proc/toggle_strip_drag()
	set name = "Toggle Strip/Drag Dead"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_NO_STRIPDRAG_ENEMY
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) ? "prevented dead humans from being" : "allowed dead humans to be"] stripped and dragged around by non-matching IFF players.")

/client/proc/toggle_uniform_strip()
	set name = "Toggle Uniform Strip Dead"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_STRIP_NONUNIFORM_ENEMY
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_STRIP_NONUNIFORM_ENEMY) ? "allowed dead humans to be stripped of everything but their uniform, boots, armor, helmet, and ID" : "prevented dead humans from being stripped of anything"].")
	if(!MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY))
		message_staff("WARNING: Dead enemy players can still be stripped of everything, as the Strip/Drag toggle flag isn't active.")

/client/proc/toggle_strong_defibs()
	set name = "Toggle Strong Defibs"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_STRONG_DEFIBS
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_STRONG_DEFIBS) ? "allowed defibs to ignore armor" : "made defibs operate normally"].")

/client/proc/toggle_blood_optimization()
	set name = "Toggle Blood Optimization"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_BLOOD_OPTIMIZATION
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_BLOOD_OPTIMIZATION) ? "toggled blood optimization on" : "toggled blood optimization off"].")

/client/proc/toggle_combat_cas()
	set name = "Toggle Combat CAS Equipment"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_NO_COMBAT_CAS
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_COMBAT_CAS) ? "toggled combat CAS off" : "toggled combat CAS on"].")

/client/proc/toggle_lz_protection()
	set name = "Toggle LZ Mortar Protection"
	set category = "Admin.Flags"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("A mode hasn't been selected yet!"))
		return

	SSticker.mode.toggleable_flags ^= MODE_LZ_PROTECTION
	message_staff("[src] has [MODE_HAS_TOGGLEABLE_FLAG(MODE_LZ_PROTECTION) ? "toggled LZ protection on, mortars can no longer fire there" : "toggled LZ protection off, mortars can now fire there"].")

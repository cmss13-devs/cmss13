/client/proc/deadmin_self()
	set name = "A: De-Admin"
	set category = "Admin"

	if(!admin_holder)
		return

	if(alert("Confirm deadmin? This procedure can be reverted at any time and will not carry over to next round, but you will lose all your admin powers in the meantime.", , "Yes", "No") == "No")
		return

	message_staff("[src] de-admined themselves.")
	verbs += /client/proc/readmin_self
	deadmin()
	to_chat(src, "<br><br><span class='centerbold'><big>You are now a normal player. You can ascend back to adminhood at any time using the 'Re-admin Self' verb in your Admin panel.</big></span><br>")

/client/proc/readmin_self()
	set name = "A: Re-Admin"
	set category = "Admin"

	verbs -= /client/proc/readmin_self
	readmin()
	to_chat(src, "<br><br><span class='centerbold'><big>You have ascended back to adminhood. All your verbs should be back where you left them.</big></span><br>")
	message_staff("[src] re-admined themselves.")

/client/proc/becomelarva()
	set name = "X: Lose Larva Protection"
	set desc = "Remove your protection from becoming a larva."
	set category = "Admin"

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
	set name = "C: Unban Panel"
	set category = "Admin"

	if(admin_holder)
		admin_holder.unbanpanel()
	return

/client/proc/player_panel_new()
	set name = "C: Player Panel"
	set category = "Admin"

	if(admin_holder)
		admin_holder.player_panel_new()
	return

/client/proc/admin_ghost()
	set name = "A: Aghost"
	set category = "Admin"

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
	body.ghostize(TRUE)
	if(body && !body.key)
		body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		if(body.client)
			body.client.change_view(world_view_size) //reset view range to default.

		//re-open STUI
	if(new_STUI)
		GLOB.STUI.ui_interact(mob)

/datum/admins/proc/announce()
	set name = "X: Admin Announcement"
	set desc = "Announce your desires to the world"
	set category = "Admin"

	if(!check_rights(0))
		return
	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		to_world(SPAN_ANNOUNCEMENT_HEADER_BLUE(" <b>[usr.client.admin_holder.fakekey ? "Administrator" : usr.key] Announces:</b>\n \t [message]"))
		log_admin("Announce: [key_name(usr)] : [message]")

/datum/admins/proc/player_notes_show(var/key as text)
	set name = "D: Player Notes Show"
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
	for(var/datum/view_record/note_view/N in NL)
		var/admin_ckey = N.admin_ckey
		var/confidential_text = N.is_confidential ? " \[CONFIDENTIALLY\]" : ""
		if(N.is_ban)
			var/time_d = N.ban_time ? "Banned for [N.ban_time] minutes | " : ""
			var/color = N.is_confidential ? "#880000" : "#5555AA"
			dat += "<font color=[color]>[time_d][N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i>[confidential_text] on <i><font color=blue>[N.date]</i></font> "
		else
			var/color = N.is_confidential ? "#AA0055" : "#008800"
			dat += "<font color=[color]>[N.text]</font> <i>by [admin_ckey] ([N.admin_rank])</i>[confidential_text] on <i><font color=blue>[N.date]</i></font> "
		if(admin_ckey == usr.ckey || admin_ckey == "Adminbot" || ishost(usr))
			dat += "<A href='?src=\ref[src];remove_player_info=[key];remove_index=[N.id]'>Remove</A>"
		dat += "<br><br>"

	dat += "<br>"
	dat += "<A href='?src=\ref[src];add_player_info=[key]'>Add Note</A><br>"
	dat += "<A href='?src=\ref[src];add_player_info_confidential=[key]'>Add Confidential Note</A><br>"
	dat += "<A href='?src=\ref[src];player_notes_copy=[key]'>Copy Player Notes</A><br>"

	dat += "</body></html>"
	show_browser(usr, dat, "Info on [key]", "adminplayerinfo", "size=480x480")

/datum/admins/proc/sleepall()
	set name = "In View Sleep All"
	set category = "Admin"
	set hidden = 1

	if(!check_rights(0))
		return

	if(alert("This will toggle a sleep/awake status on ALL mobs within your view range (for Administration purposes). Are you sure?",,"Yes","Cancel") == "Cancel")
		return
	for(var/mob/living/M in view())
		if (M.sleeping > 0) //if they're already slept, set their sleep to zero and remove the icon
			M.sleeping = 0
			M.RemoveSleepingIcon()
		else
			M.sleeping = 9999999 //if they're not, sleep them and add the sleep icon, so other marines nearby know not to mess with them.
			M.AddSleepingIcon()

	message_staff("[key_name(usr)] used Toggle Sleep In View.")
	return

/datum/admins/proc/viewUnheardAhelps()
	set name = "X: View Unheard Ahelps"
	set desc = "View any Ahelps that went unanswered"
	set category = "Admin"

	var/body = "<body>"
	body += "<br>"

	for(var/CID in unansweredAhelps)
		body += "[unansweredAhelps[CID]]" //If I have done these correctly, it should have the options bar as well a mark and noresponse

	body += "<br><br></body>"

	show_browser(src, body, "Unheard Ahelps", "ahelps", "size=800x300")

/client/proc/cmd_admin_say(msg as text)
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set category = "Admin"
	set hidden = 1

	if(!check_rights(R_ADMIN))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	log_admin("ADMIN : [key_name(src)] : [msg]")
	GLOB.STUI.staff.Add("\[[time_stamp()]] <font color='#800080'>ADMIN: [key_name(src)] : [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_STAFF_CHAT

	var/color = "adminsay"
	if(ishost(usr))
		color = "headminsay"

	if(check_rights(R_ADMIN,0))
		msg = "<span class='[color]'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=admin_holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
		for(var/client/C in GLOB.admins)
			if(R_ADMIN & C.admin_holder.rights)
				to_chat(C, msg)

/client/proc/cmd_mod_say(msg as text)
	set name = "Msay"
	set category = "Admin"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("MOD: [key_name(src)] : [msg]")
	GLOB.STUI.staff.Add("\[[time_stamp()]] <font color='#b82e00'>MOD: [key_name(src)] : [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_STAFF_CHAT

	if (!msg)
		return
	var/color = "mod"
	if (check_rights(R_ADMIN,0))
		color = "adminmod"

	var/channel = "MOD:"
	channel = "[admin_holder.rank]:"
	for(var/client/C in GLOB.admins)
		if((R_ADMIN|R_MOD) & C.admin_holder.rights)
			to_chat(C, "<span class='[color]'><span class='prefix'>[channel]</span> <EM>[key_name(src,1)]</EM> (<A HREF='?src=\ref[C.admin_holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>")

/client/proc/enable_admin_mob_verbs()
	set name = "Z: Mob Admin Verbs - Show"
	set category = "Admin"

	verbs += admin_mob_verbs_hideable
	verbs -= /client/proc/enable_admin_mob_verbs

/client/proc/hide_admin_mob_verbs()
	set name = "Z: Mob Admin Verbs - Hide"
	set category = "Admin"

	verbs -= admin_mob_verbs_hideable
	verbs += /client/proc/enable_admin_mob_verbs

/client/proc/rejuvenate_all_in_view()
	set name = "In View Rejuvenate All"
	set category = "Admin"
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
	set name = "In View Rejuvenate All Humans"
	set category = "Admin"
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
	set name = "In View Rejuvenate Revivable Human"
	set category = "Admin"
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
	set name = "In View Rejuvenate Xenos"
	set category = "Admin"
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
		<A href='?src=\ref[src];teleport=jump_to_area'>Jump to Area</A><BR>
		<A href='?src=\ref[src];teleport=jump_to_turf'>Jump to Turf</A><BR>
		<A href='?src=\ref[src];teleport=jump_to_mob'>Jump to Mob</A><BR>
		<A href='?src=\ref[src];teleport=jump_to_obj'>Jump to Object</A><BR>
		<A href='?src=\ref[src];teleport=jump_to_key'>Jump to Ckey</A><BR>
		<A href='?src=\ref[src];teleport=jump_to_coord'>Jump to Coordinates</A><BR>
		<A href='?src=\ref[src];teleport=get_mob'>Teleport Mob to You</A><BR>
		<A href='?src=\ref[src];teleport=get_key'>Teleport Ckey to You</A><BR>
		<A href='?src=\ref[src];teleport=teleport_mob_to_area'>Teleport Mob to Area</A><BR>
		<A href='?src=\ref[src];teleport=teleport_mobs_in_range'>Mass Teleport Mobs in Range</A><BR>
		<A href='?src=\ref[src];teleport=teleport_mobs_by_faction'>Mass Teleport Mobs to You by Faction</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "Teleport Panel", "teleports")
	return

/client/proc/teleport_panel()
	set name = "C: Teleport Panel"
	set category = "Admin"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	admin_holder.teleport_panel()

/datum/admins/proc/vehicle_panel()
	if(!check_rights(R_MOD, 0))
		return

	var/dat = {"
		<A href='?src=\ref[src];vehicle=remove_clamp'>Remove Clamp from Tank</A><BR>
		<A href='?src=\ref[src];vehicle=remove_players'>Eject Players from Tank</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "Vehicle Panel", "vehicles")
	return

/client/proc/vehicle_panel()
	set name = "C: Vehicle Panel"
	set category = "Admin"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	admin_holder.vehicle_panel()

/datum/admins/proc/in_view_panel()
	var/dat = {"
		<A href='?src=\ref[src];inviews=rejuvenateall'>Rejuvenate All Mobs In View</A><BR>
		<BR>
		<A href='?src=\ref[src];inviews=rejuvenatemarine'>Rejuvenate Only Humans In View</A><BR>
	 	<A href='?src=\ref[src];inviews=rejuvenaterevivemarine'>Rejuvenate Only Revivable Humans In View</A><BR>
		<BR>
		<A href='?src=\ref[src];inviews=rejuvenatexeno'>Rejuvenate Only Xenos In View</A><BR>
		<BR>
		<A href='?src=\ref[src];inviews=sleepall'>Sleep All In View</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "In View Panel", "inviews")
	return

/client/proc/in_view_panel()
	set name = "C: In View Panel"
	set category = "Admin"

	if(!admin_holder || !check_rights(R_MOD, FALSE))
		return

	admin_holder.in_view_panel()

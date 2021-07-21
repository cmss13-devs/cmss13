/client/proc/cmd_mentor_check_new_players()	//Allows mentors / admins to determine who the newer players are.
	set category = "Admin"
	set name = "Check new Players"

	if(!admin_holder)
		to_chat(src, "You do not have permission to use this.")
		return

	if(!CLIENT_IS_STAFF(src))
		if(!CLIENT_HAS_RIGHTS(src, R_MENTOR))
			to_chat(src, "Only staff members have permission to use this.")
			return
		if(!CONFIG_GET(flag/mentor_tools))
			to_chat(src, "Mentors do not have permission to use this.")
	
	var/age = alert(src, "Age check", "Show accounts up to how many days old ?", "7", "30" , "All")

	if(age == "All")
		age = 9999999
	else
		age = text2num(age)

	var/missing_ages = FALSE
	var/msg = ""

	for(var/client/C in GLOB.clients)
		if(C.player_age == "Requires database")
			missing_ages = 1
			continue
		if(C.player_age < age)
			msg += "[key_name(C, 1, 1, CLIENT_IS_STAFF(src))]: account is [C.player_age] days old<br>"

	if(missing_ages)
		to_chat(src, "Some accounts did not have proper ages set in their clients.  This function requires database to be present")

	if(msg != "")
		show_browser(src, msg, "Check New Players", "Player_age_check")
	else
		to_chat(src, "No matches for that age range found.")

/proc/cmd_admin_mute(mob/M as mob, mute_type, automute = 0)
	if(automute && !CONFIG_GET(flag/automute_on))
		return FALSE
	if(!M.client)
		to_chat(usr, SPAN_WARNING("This mob doesn't have a client tied to it."))
		return FALSE
	else
		if(!usr || !usr.client)
			return FALSE
		if(!usr.client.admin_holder || !(usr.client.admin_holder.rights & R_MOD))
			to_chat(usr, SPAN_WARNING("Error: You don't have permission to do this."))
			return FALSE
		if(M.client.admin_holder && (M.client.admin_holder.rights & R_MOD))
			to_chat(usr, SPAN_WARNING("Error: You cannot mute an admin/mod."))
			return FALSE

	var/muteunmute
	var/mute_string

	switch(mute_type)
		if(MUTE_IC)			mute_string = "IC (say and emote)"
		if(MUTE_OOC)		mute_string = "OOC"
		if(MUTE_PRAY)		mute_string = "pray"
		if(MUTE_ADMINHELP)	mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)	mute_string = "deadchat and DSAY"
		if(MUTE_ALL)		mute_string = "everything"
		else				return FALSE

	if(automute)
		muteunmute = "auto-muted"
		M.client.prefs.muted |= mute_type
		message_staff("SPAM AUTOMUTE: [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
		to_chat(M, "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin.")

		return FALSE

	if(M.client.prefs.muted & mute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |= mute_type

	message_staff("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	to_chat(M, "You have been [muteunmute] from [mute_string].")

/client/proc/toggle_own_ghost_vis()
	set name = "Show/Hide Own Ghost"
	set desc = "Toggle your visibility as a ghost to other ghosts."
	set category = "Preferences.Ghost"

	if(!admin_holder || !(admin_holder.rights & R_MOD)) return

	if(isobserver(usr))
		if(usr.invisibility <> 60 && usr.layer <> 4.0)
			usr.invisibility = 60
			usr.layer = MOB_LAYER
			to_chat(usr, SPAN_WARNING("Ghost visibility returned to normal."))
		else
			usr.invisibility = 70
			usr.layer = BELOW_MOB_LAYER
			to_chat(usr, SPAN_WARNING("Your ghost is now invisibile to other ghosts."))
		log_admin("Admin [key_name(src)] has toggled Ordukai Mode.")
	else
		to_chat(usr, SPAN_WARNING("You need to be a ghost in order to use this."))

// bite me
var/global/explosive_antigrief_on = TRUE
/client/proc/toggle_explosive_antigrief()
	set name = "Toggle Explosive Antigrief"
	set category = "Admin.Game"

	explosive_antigrief_on = !explosive_antigrief_on
	message_staff(FONT_SIZE_LARGE("[key_name_admin(usr)] has [explosive_antigrief_on ? "enabled" : "disabled"] explosive antigrief"))

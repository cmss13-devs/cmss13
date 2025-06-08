
#define ANTIGRIEF_OPTION_ENABLED "Enabled"
#define ANTIGRIEF_OPTION_NEW_PLAYERS "Enabled for New Players"
#define ANTIGRIEF_OPTION_DISABLED "Disabled"

/client/proc/cmd_mentor_check_new_players() //Allows mentors / admins to determine who the newer players are.
	set category = "Admin"
	set name = "Check new Players"

	if(!admin_holder)
		to_chat(src, "You do not have permission to use this.")
		return

	if(!CLIENT_IS_STAFF(src))
		if(!CLIENT_IS_MENTOR(src))
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
		if(MUTE_IC)
			mute_string = "IC (say and emote)"
		if(MUTE_OOC)
			mute_string = "OOC"
		if(MUTE_PRAY)
			mute_string = "pray"
		if(MUTE_ADMINHELP)
			mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)
			mute_string = "deadchat and DSAY"
		if(MUTE_ALL)
			mute_string = "everything"
		else
			return FALSE

	if(automute)
		muteunmute = "auto-muted"
		M.client.prefs.muted |= mute_type
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
		to_chat(M, "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin.")

		return FALSE

	if(M.client.prefs.muted & mute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |= mute_type

	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	to_chat(M, "You have been [muteunmute] from [mute_string].")

/client/proc/toggle_own_ghost_vis()
	set name = "Show/Hide Own Ghost"
	set desc = "Toggle your visibility as a ghost to other ghosts."
	set category = "Preferences.Ghost"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		return

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

/client/proc/set_explosive_antigrief()
	set name = "Set Explosive Antigrief"
	set category = "Admin.Game"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		return


	var/antigrief_choice = tgui_input_list(usr, "Select the preferred antigrief type:", "Select", list(ANTIGRIEF_OPTION_ENABLED, ANTIGRIEF_OPTION_NEW_PLAYERS, ANTIGRIEF_OPTION_DISABLED))
	if(!antigrief_choice)
		return

	switch(antigrief_choice)
		if(ANTIGRIEF_OPTION_DISABLED)
			CONFIG_SET(number/explosive_antigrief, ANTIGRIEF_DISABLED)
			message_admins(FONT_SIZE_LARGE("[key_name_admin(usr)] has disabled explosive antigrief."))
		if(ANTIGRIEF_OPTION_ENABLED)
			message_admins(FONT_SIZE_LARGE("[key_name_admin(usr)] has fully enabled explosive antigrief for all players."))
			CONFIG_SET(number/explosive_antigrief, ANTIGRIEF_ENABLED)
		if(ANTIGRIEF_OPTION_NEW_PLAYERS)
			message_admins(FONT_SIZE_LARGE("[key_name_admin(usr)] has enabled explosive antigrief for new players (less than 10 total human hours)."))
			CONFIG_SET(number/explosive_antigrief, ANTIGRIEF_NEW_PLAYERS)
		else
			message_admins(FONT_SIZE_LARGE("Error! [key_name_admin(usr)] attempted to toggle explosive antigrief but the selected value was [antigrief_choice]. Setting it to enabled."))
			CONFIG_SET(number/explosive_antigrief, ANTIGRIEF_ENABLED)

/client/proc/check_explosive_antigrief()
	set name = "Check Explosive Antigrief"
	set category = "Admin.Game"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		return

	switch(CONFIG_GET(number/explosive_antigrief))
		if(ANTIGRIEF_DISABLED)
			to_chat(src, SPAN_BOLDNOTICE("Explosive antigrief is currently disabled."))
		if(ANTIGRIEF_ENABLED)
			to_chat(src, SPAN_BOLDNOTICE("Explosive antigrief is currently fully enabled."))
		if(ANTIGRIEF_NEW_PLAYERS)
			to_chat(src, SPAN_BOLDNOTICE("Explosive antigrief is currently enabled for new players."))
		else
			to_chat(src, SPAN_BOLDNOTICE("Explosive antigrief has an unknown value... you should probably fix that."))

/client/proc/set_dropship_airlock()
	set name = "Set Dropship Airlock"
	set category = "Admin.Shuttles"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		return

	var/list/inner_ports = list()
	for(var/obj/docking_port/stationary/marine_dropship/airlock/inner/inner_port in GLOB.dropship_airlock_docking_ports)
		inner_ports += inner_port

	var/obj/docking_port/stationary/marine_dropship/airlock/inner/selected_inner = tgui_input_list(usr, "Select a dropship airlock to set", "Select", inner_ports)
	if(selected_inner.undergoing_admin_command)
		if(tgui_alert(usr, "This airlock is currently processing [selected_inner.undergoing_admin_command] as a command. Do you want to send a second command at the same time? THIS MAY CAUSE ISSUES.", "Proceed?", list("Yes", "No")) != "Yes")
			return

	var/choice = tgui_input_list(usr, "What do you want to do to the dropship airlock? (Player control is currently [selected_inner.allow_processing_to_end ? "enabled" : "disabled"])", "Set", list("Enable Player Control", "Disable Player Control", "Return Dropship", "Exit Dropship", "Specific Control"))
	switch(choice)
		if("Enable Player Control")
			if(selected_inner.allow_processing_to_end)
				return
			selected_inner.allow_processing_to_end = TRUE
			selected_inner.processing = FALSE
			to_chat(usr, SPAN_WARNING("You have enabled player control for the dropship at airlock [selected_inner]"))
			log_admin("Admin [key_name(src)] has enabled player control for the dropship at airlock [selected_inner]")
		if("Disable Player Control")
			selected_inner.allow_processing_to_end = FALSE
			selected_inner.processing = TRUE
			to_chat(usr, SPAN_WARNING("You have disabled player control for the dropship at airlock [selected_inner]"))
			log_admin("Admin [key_name(src)] has disabled player control for the dropship at airlock [selected_inner]")
		if("Return Dropship")
			selected_inner.undergoing_admin_command = "Return Dropship"
			selected_inner.allow_processing_to_end = FALSE
			selected_inner.processing = TRUE
			var/time_to_process = selected_inner.force_process(DROPSHIP_AIRLOCK_GO_UP)
			addtimer(CALLBACK(selected_inner, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, end_of_admin_command)), time_to_process)
			to_chat(usr, SPAN_WARNING("You have begun to return the dropship."))
			log_admin("Admin [key_name(src)] has begun to return the dropship to [selected_inner]")
		if("Exit Dropship")
			selected_inner.undergoing_admin_command = "Exit Dropship"
			selected_inner.allow_processing_to_end = FALSE
			selected_inner.processing = TRUE
			var/time_to_process = selected_inner.force_process(DROPSHIP_AIRLOCK_GO_DOWN)
			addtimer(CALLBACK(selected_inner, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, end_of_admin_command)), time_to_process)
			to_chat(usr, SPAN_WARNING("You have begun to exit the dropship."))
			log_admin("Admin [key_name(src)] has begun to exit the dropship from [selected_inner]")
		if("Specific Control")
			selected_inner.undergoing_admin_command = "\improper Specific Control"
			selected_inner.allow_processing_to_end = FALSE
			selected_inner.processing = TRUE
			to_chat(usr, SPAN_WARNING("You have begin to enter specific controls for the dropship at [selected_inner]"))
			log_admin("Admin [key_name(src)] has begun to enter specific control for the dropship at [selected_inner]")
			var/specific_choice = tgui_input_list(usr, "Which specific control do you want to effectuate? (MAY BREAK IMMERSION, ESPECIALLY DROPSHIP RAISE/LOWER)", "Set", list("[selected_inner.playing_airlock_alarm ? "Disable Airlock Alarm" : "Enable Airlock Alarm"]", "[selected_inner.open_inner_airlock ? "Close Inner Airlock" : "Open Inner Airlock"]", "[selected_inner.lowered_dropship ? "Raise Dropship" : "Lower Dropship"]", "[selected_inner.open_outer_airlock ? "Close Outer Airlock" : "Open Outer Airlock"]", "Declamp Dropship"))
			switch(specific_choice)
				if("Disable Airlock Alarm")
					selected_inner.update_airlock_alarm(FALSE, TRUE)
				if("Enable Airlock Alarm")
					selected_inner.update_airlock_alarm(TRUE, TRUE)
				if("Close Inner Airlock")
					selected_inner.update_inner_airlock(FALSE, TRUE)
				if("Open Inner Airlock")
					selected_inner.update_inner_airlock(TRUE, TRUE)
				if("Lower Dropship")
					selected_inner.update_dropship_height(FALSE, TRUE)
				if("Raise Dropship")
					selected_inner.update_dropship_height(TRUE, TRUE)
				if("Close Outer Airlock")
					selected_inner.update_outer_airlock(FALSE, TRUE)
				if("Open Outer Airlock")
					selected_inner.update_outer_airlock(TRUE, TRUE)
				if("Declamp Dropship")
					selected_inner.update_clamps(TRUE, TRUE)
			addtimer(CALLBACK(selected_inner, TYPE_PROC_REF(/obj/docking_port/stationary/marine_dropship/airlock/inner, end_of_admin_command)), DROPSHIP_AIRLOCK_MAX_THEORETICAL_UPDATE_PERIOD)

#undef ANTIGRIEF_OPTION_ENABLED
#undef ANTIGRIEF_OPTION_NEW_PLAYERS
#undef ANTIGRIEF_OPTION_DISABLED

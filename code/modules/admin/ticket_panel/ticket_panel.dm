#define ADMIN_TAB "admin"
#define MENTOR_TAB "mentor"

/datum/ticket_panel
	var/selected_tab = ADMIN_TAB
	var/selected_ticket = null

/datum/ticket_panel/Destroy(force, ...)
	SStgui.close_uis(src)
	return ..()

/datum/ticket_panel/proc/get_player_info(client/user_client)
	if(!user_client || !user_client.mob)
		return null

	var/mob/target_mob = user_client.mob
	var/list/info = list()

	if(target_mob.real_name)
		info["ic_name"] = target_mob.real_name

	var/datum/faction/target_faction = GLOB.faction_datums[target_mob.faction]
	if(target_faction)
		info["faction"] = target_faction.name
	else if(target_mob.faction)
		info["faction"] = "[target_mob.faction]"
	else
		info["faction"] = FACTION_NEUTRAL

	if(isobserver(target_mob))
		info["role"] = "Ghost"
	else if(isxeno(target_mob))
		var/mob/living/carbon/xenomorph/target_xenomorph = target_mob
		info["role"] = target_xenomorph.caste_type
	else if(ishuman(target_mob))
		var/mob/living/carbon/human/target_human = target_mob
		if(target_human.comm_title)
			info["role"] = target_human.comm_title
		else if(target_human.job)
			info["role"] = target_human.job
	else if(target_mob.job)
		info["role"] = target_mob.job

	return info


/datum/ticket_panel/proc/format_adminhelp_ticket(datum/admin_help/ahelp_thread, client/viewer = null)
	var/status = ahelp_thread.state == AHELP_ACTIVE ? "open" : ahelp_thread.state == AHELP_RESOLVED ? "resolved" : "closed" // just setting some readable names, I suppose

	var/list/formatted_responses = list()
	for(var/key in ahelp_thread.ticket_interactions)
		var/list/interaction = ahelp_thread.ticket_interactions[key]
		formatted_responses += list(interaction)

	var/list/player_info = get_player_info(ahelp_thread.initiator)

	return list(
		"id" = ahelp_thread.id,
		"subject" = ahelp_thread.subject,
		"author" = ahelp_thread.initiator_key_name || "Unknown",
		"message" = ahelp_thread.initial_message || "No message",
		"latest_message" = ahelp_thread.latest_message,
		"status" = status,
		"timestamp" = ahelp_thread.time_activity["opened_at"],
		"closed_at" = ahelp_thread.time_activity["closed_at"],
		"claimed_by" = ahelp_thread.marked_admin_key_name,
		"all_responses" = formatted_responses,
		"viewer_is_claiming" = (ahelp_thread.marked_admin == (viewer ? viewer.username() : usr?.username()) ? TRUE : FALSE),
		"is_archived" = (ahelp_thread.state != AHELP_ACTIVE),
		"ic_name" = player_info ? player_info["ic_name"] : null,
		"faction" = player_info ? player_info["faction"] : null,
		"role" = player_info ? player_info["role"] : null
	)

/datum/ticket_panel/proc/format_mentorhelp_ticket(datum/mentorhelp/mentor_help_thread, client/viewer = null)
	if(!viewer)
		viewer = usr.client

	var/status = mentor_help_thread.open ? (mentor_help_thread.mentor ? "claimed" : "open") : "closed"

	var/list/player_info = get_player_info(mentor_help_thread.author)

	var/ic_name = (player_info ? player_info["ic_name"] : null) || mentor_help_thread.get_author_ic_name()
	var/faction = (player_info ? player_info["faction"] : null) || mentor_help_thread.get_author_faction()
	var/role = (player_info ? player_info["role"] : null) || mentor_help_thread.get_author_role()

	var/list/formatted_responses = list()
	for(var/key in mentor_help_thread.ticket_interactions)
		var/list/interaction = mentor_help_thread.ticket_interactions[key]
		var/list/filtered_interaction = interaction.Copy()

		filtered_interaction["author"] = mentor_help_thread.get_display_name(viewer, interaction["author"])

		if(viewer && !CLIENT_IS_STAFF(viewer))
			if(mentor_help_thread.author_key && filtered_interaction["message"])
				filtered_interaction["message"] = replacetext(filtered_interaction["message"], mentor_help_thread.author_key, ic_name)

		formatted_responses += list(filtered_interaction)

	var/display_author = mentor_help_thread.get_display_name(viewer, mentor_help_thread.author)

	var/display_msg = mentor_help_thread.initial_message
	var/display_latest = mentor_help_thread.latest_message
	if(viewer && !CLIENT_IS_STAFF(viewer))
		if(mentor_help_thread.author_key)
			display_msg = replacetext(display_msg, mentor_help_thread.author_key, ic_name)
			display_latest = replacetext(display_latest, mentor_help_thread.author_key, ic_name)

	return list(
		"id" = mentor_help_thread.id,
		"subject" = mentor_help_thread.subject,
		"author" = display_author || "Unknown",
		"message" = display_msg || "No message",
		"latest_message" = display_latest,
		"status" = status,
		"timestamp" = mentor_help_thread.time_activity["opened_at"],
		"closed_at" = mentor_help_thread.time_activity["closed_at"],
		"claimed_by" = mentor_help_thread.mentor ? mentor_help_thread.mentor.username() : null,
		"all_responses" = formatted_responses,
		"viewer_is_claiming" = (mentor_help_thread.mentor && (mentor_help_thread.mentor.username() == viewer?.username()) ? TRUE : FALSE),
		"is_archived" = !mentor_help_thread.open,
		"ic_name" = ic_name,
		"faction" = faction,
		"role" = role
	)

/datum/ticket_panel/ui_data(mob/user)
	if(!user?.client)
		return

	var/client/user_client = user.client
	if(!user_client.ticket_panel)
		user_client.ticket_panel = new /datum/ticket_panel()

	var/list/data = list(
		"is_admin" = CLIENT_IS_STAFF(user_client) ? TRUE: FALSE,
		"is_mentor" = CLIENT_IS_MENTOR(user_client) ? TRUE : FALSE,
		"selected_tab" = user_client.ticket_panel.selected_tab,
		"selected_ticket" = user_client.ticket_panel.selected_ticket,
		"admin_open_tickets" = list(),
		"mentor_open_tickets" = list(),
		"admin_archived_tickets" = list(),
		"mentor_archived_tickets" = list()
	)

	if(CLIENT_IS_STAFF(user.client))
		for(var/datum/admin_help/ahelp_thread in GLOB.ahelp_tickets.active_tickets)
			data["admin_open_tickets"] += list(format_adminhelp_ticket(ahelp_thread, user_client))

		for(var/datum/admin_help/ahelp_thread in GLOB.ahelp_tickets.closed_tickets)
			data["admin_archived_tickets"] += list(format_adminhelp_ticket(ahelp_thread, user_client))

		for(var/datum/admin_help/ahelp_thread in GLOB.ahelp_tickets.resolved_tickets)
			data["admin_archived_tickets"] += list(format_adminhelp_ticket(ahelp_thread, user_client))

	for(var/id in GLOB.mentorhelp_manager.active_tickets)
		var/datum/mentorhelp/mentor_help_thread = GLOB.mentorhelp_manager.get_ticket_by_id(id)
		if(istype(mentor_help_thread))
			data["mentor_open_tickets"] += list(format_mentorhelp_ticket(mentor_help_thread, user_client))

	for(var/id in GLOB.mentorhelp_manager.archived_tickets)
		var/datum/mentorhelp/mentor_help_thread = GLOB.mentorhelp_manager.get_ticket_by_id(id)
		if(istype(mentor_help_thread))
			data["mentor_archived_tickets"] += list(format_mentorhelp_ticket(mentor_help_thread, user_client))

	return data

/datum/ticket_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/current_client = ui.user.client
	var/client/parent_client = current_client
	var/mob/current_mob = ui.user
	var/mob/parent_mob = current_mob

	if(!CLIENT_IS_STAFF(current_client))
		selected_tab = MENTOR_TAB

	switch(action)
		if("refresh")
			return TRUE

		if("select_tab")
			if(params["tab"] == ADMIN_TAB && !CLIENT_IS_STAFF(current_client))
				return FALSE
			if(!current_client.ticket_panel)
				parent_client.ticket_panel = new /datum/ticket_panel()
			parent_client.ticket_panel.selected_tab = params["tab"]
			parent_client.ticket_panel.selected_ticket = null
			return TRUE

		if("select_ticket")
			if(!parent_client.ticket_panel)
				parent_client.ticket_panel = new /datum/ticket_panel()
			parent_client.ticket_panel.selected_ticket = text2num(params["ticket_id"])
			return TRUE

		if("start_adminhelp")
			if(!CLIENT_IS_STAFF(current_client))
				tgui_alert(parent_mob, "Silly! You need to be an admin to use this feature.")
				return FALSE

			var/list/possible_targets = list()
			for(var/client/target in GLOB.clients)
				if(!target.mob)
					continue
				possible_targets[target] = "[target.key]"

			if(!LAZYLEN(possible_targets))
				tgui_alert(parent_mob, "No players available to message.")
				return FALSE

			var/client/target = tgui_input_list(parent_mob, "Select a player to message:", "New Adminhelp", possible_targets)
			if(!target || !istype(target) || !target.mob)
				return FALSE

			if(istype(target.current_ticket) && target.current_ticket.state == AHELP_ACTIVE)
				parent_client.ticket_panel.selected_tab = ADMIN_TAB
				parent_client.ticket_panel.selected_ticket = target.current_ticket.id
				to_chat(parent_mob, SPAN_NOTICE("Switched to existing admin ticket for [target.username()]"))
				return TRUE

			parent_client.cmd_admin_pm(target, null)
			return TRUE

		if("start_mentorhelp")
			if(!CLIENT_IS_MENTOR(current_client) && !CLIENT_IS_STAFF(current_client))
				tgui_alert(parent_mob, "You need to be a mentor or admin to use this feature.")
				return FALSE

			var/list/possible_targets = list()
			for(var/client/target in GLOB.clients)
				if(!target.mob)
					continue
				var/ic_name = target.mob.real_name || target.mob.name || "Unknown"
				if(CLIENT_IS_STAFF(current_client))
					possible_targets[target] = "[target.username()]/([ic_name])"
				else
					possible_targets[target] = "[ic_name]"

			if(!LAZYLEN(possible_targets))
				tgui_alert(parent_mob, "No non-staff players available to message.")
				return FALSE

			var/client/target = tgui_input_list(parent_mob, "Select a player to message:", "New Mentorhelp", possible_targets)
			if(!target || !istype(target) || !target.mob)
				return FALSE

			if(istype(target.current_mhelp) && target.current_mhelp.open)
				parent_client.ticket_panel.selected_tab = MENTOR_TAB
				parent_client.ticket_panel.selected_ticket = target.current_mhelp.id
				to_chat(parent_mob, SPAN_NOTICE("Switched to existing mentor ticket for [target.current_mhelp.get_display_name(current_client, target)]"))
				return TRUE

			if(GLOB.mentorhelp_manager.get_active_ticket_by_ckey(target.username()))
				to_chat(current_mob, SPAN_WARNING("This user already has an open mentor ticket. Please close it first or use the existing one."), confidential = TRUE)
				return FALSE

			var/msg = tgui_input_text(current_mob, "Enter your message:", "New Mentorhelp")
			if(!msg)
				return FALSE

			var/datum/mentorhelp/mentor_help_thread = GLOB.mentorhelp_manager.create_ticket(target, msg)
			mentor_help_thread.notify(SPAN_PURPLE("[mentor_help_thread.get_display_name(null, current_client)] started a mentor conversation with [mentor_help_thread.get_display_name(current_client, target)]"),
				unformatted_text = "[mentor_help_thread.get_display_name(null, parent_client)] started a mentor conversation with [mentor_help_thread.get_display_name(current_client, target)]")
			mentor_help_thread.initial_message = msg
			mentor_help_thread.toggle_mark(parent_client)
			mentor_help_thread.Respond(msg, parent_client)

			return TRUE

		if("open_player_panel")
			if(!current_client.admin_holder)
				to_chat(parent_mob, SPAN_WARNING("You don't have permission to open a player panel."))
				return FALSE

			var/mob/player
			var/ticket_id = text2num(params["ticket_id"])

			switch(selected_tab)
				if(ADMIN_TAB)
					var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
					if(!istype(ahelp_thread))
						to_chat(current_mob, SPAN_WARNING("Invalid admin ticket selected."))
						return FALSE
					player = ahelp_thread.initiator.mob

				if(MENTOR_TAB)
					var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
					if(!istype(mentor_help_thread))
						to_chat(current_mob, SPAN_WARNING("Invalid mentor ticket selected."))
						return FALSE
					player = mentor_help_thread.author.mob

			if(!player || !player.username())
				to_chat(current_mob, SPAN_WARNING("Could not find player associated with this ticket."))
				return FALSE

			current_client.admin_holder.show_player_panel(player)
			return TRUE

		if("autoreply")
			var/ticket_id = text2num(params["ticket_id"])
			if(selected_tab == ADMIN_TAB)
				var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(ahelp_thread)
					ahelp_thread.AutoReply()
					return TRUE
			else
				var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
				if(mentor_help_thread)
					mentor_help_thread.autoresponse(current_client)
					return TRUE

		if("reopen_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			if(selected_tab == ADMIN_TAB)
				var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(!ahelp_thread)
					to_chat(current_mob, SPAN_WARNING("Invalid admin ticket selected."))
					return FALSE

				var/client/target = ahelp_thread.initiator
				if(!target)
					to_chat(current_mob, SPAN_WARNING("Could not find player associated with this ticket."))
					return FALSE

				if(target.current_ticket && target.current_ticket.state == AHELP_ACTIVE)
					to_chat(current_mob, SPAN_WARNING("This user already has an open ticket. Please close it first or use the existing one."), confidential = TRUE)
					return FALSE
				ahelp_thread.Reopen()

				return TRUE
			else
				var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
				if(!mentor_help_thread)
					to_chat(current_mob, SPAN_WARNING("Invalid mentor ticket selected."))
					return FALSE

				if(GLOB.mentorhelp_manager.get_active_ticket_by_ckey(mentor_help_thread.author_key))
					to_chat(current_mob, SPAN_WARNING("This user already has an open mentor ticket. Please close it first or use the existing one."), confidential = TRUE)
					return FALSE

				mentor_help_thread.reopen()

				return TRUE

		if("close_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			switch(selected_tab)
				if(ADMIN_TAB)
					var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
					if(ahelp_thread)
						if(ahelp_thread.marked_admin && ahelp_thread.marked_admin != current_mob.username())
							to_chat(current_mob, SPAN_WARNING("You don't have permission to close this ticket."))
							return
						if(ahelp_thread.state != AHELP_ACTIVE)
							to_chat(current_mob, SPAN_WARNING("This ticket is already [ahelp_thread.state == AHELP_RESOLVED ? "resolved" : "closed"]."))
							return
						ahelp_thread.Resolve(current_mob.username(), FALSE)
						message_admins("[key_name_admin(current_mob)] closed ticket #[ticket_id]")
						log_admin("Ticket #[ticket_id] closed by [key_name(current_mob)]")
				if(MENTOR_TAB)
					var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
					if(mentor_help_thread)
						if(!mentor_help_thread.open)
							to_chat(current_mob, SPAN_WARNING("This mentor ticket is already closed."))
							return

						if(mentor_help_thread.mentor && mentor_help_thread.mentor.username() != current_mob.username() && !CLIENT_IS_STAFF(current_client))
							to_chat(current_mob, SPAN_WARNING("You don't have permission to close this ticket."))
							return

						mentor_help_thread.close(current_client)
						log_admin_private("Mentor ticket from [mentor_help_thread.author_key] closed by [key_name(current_mob)]")
					else
						to_chat(current_mob, SPAN_WARNING("This ticket does not exist or has been deleted."))
			return TRUE

		if("claim_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			switch(selected_tab)
				if(ADMIN_TAB)
					var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
					if(ahelp_thread)
						if(ahelp_thread.marked_admin)
							if(ahelp_thread.marked_admin == current_mob.username())
								ahelp_thread.unmark_ticket()
								message_admins("[key_name_admin(current_mob)] unclaimed ticket #[ticket_id]")
							else
								ahelp_thread.mark_ticket(current_mob)
						else
							ahelp_thread.mark_ticket(current_mob)
							message_admins("[key_name_admin(current_mob)] claimed ticket #[ticket_id]")
				else
					var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
					if(!mentor_help_thread)
						return FALSE

					if(mentor_help_thread.mentor)
						if(mentor_help_thread.mentor.username() == current_mob.username())
							mentor_help_thread.unmark(current_client)
						else
							mentor_help_thread.toggle_mark(current_client)
					else
						mentor_help_thread.toggle_mark(current_client)

			return TRUE

		if("defer_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			switch(selected_tab)
				if(ADMIN_TAB)
					var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
					if(ahelp_thread)
						ahelp_thread.defer_to_mentors()
				if(MENTOR_TAB)
					var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
					if(mentor_help_thread)
						mentor_help_thread.defer_to_admins(current_client)
			return TRUE

		if("reply_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			if(!ticket_id)
				return

			var/message = tgui_input_text(current_mob, "Enter your response:", "Reply to Ticket", multiline = TRUE)
			if(!message || !current_mob.client)
				return

			if(selected_tab == ADMIN_TAB)
				var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(ahelp_thread)
					if(!ahelp_thread.marked_admin)
						ahelp_thread.mark_ticket(current_mob)
					current_client.cmd_admin_pm(ahelp_thread.initiator, message)
			else
				var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
				if(mentor_help_thread)
					if(!mentor_help_thread.mentor)
						mentor_help_thread.toggle_mark(current_client)
					mentor_help_thread.Respond(message, current_client)

			return TRUE

		if("set_subject")
			var/ticket_id = text2num(params["ticket_id"])
			if(!ticket_id)
				return

			if(selected_tab == ADMIN_TAB)
				var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(ahelp_thread)
					var/new_subject = tgui_input_text(current_mob, "Enter a subject for this ticket:", "Set Ticket Subject", ahelp_thread.subject, 100)
					if(!new_subject)
						return
					ahelp_thread.set_subject(new_subject, current_client)
			else
				var/datum/mentorhelp/mentor_help_thread = mentorhelp_by_id(ticket_id)
				if(!mentor_help_thread)
					to_chat(current_mob, SPAN_WARNING("This ticket does not exist."))
					return
				var/new_subject = tgui_input_text(current_mob, "Enter a subject for this ticket:", "Set Ticket Subject", mentor_help_thread.subject, 100)
				if(!new_subject)
					return
				mentor_help_thread.set_subject(new_subject, current_mob.client)
			return TRUE

		if("get_author_notes")
			if(!check_client_rights(current_client, R_BAN))
				to_chat(current_mob, SPAN_NOTICE("You don't have permission to view author notes."))
				return FALSE

			if(!(selected_tab == ADMIN_TAB))
				to_chat(current_mob, SPAN_WARNING("You can only view author notes from admin tickets."))
				return FALSE

			var/ticket_id = text2num(params["ticket_id"])
			var/datum/admin_help/ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
			if(!ahelp_thread)
				to_chat(current_mob, SPAN_WARNING("Unable to find ticket."))
				return FALSE

			var/mob/noted_mob = ahelp_thread.initiator.mob
			if(!noted_mob || !noted_mob.username())
				to_chat(current_mob, SPAN_WARNING("Unable to find mob."))
				return FALSE

			var/datum/player_action/show_notes = GLOB.pp_actions["show_notes"]
			if(show_notes)
				show_notes.act(current_client, noted_mob)

			return TRUE

		if("ban_author")
			if(!check_client_rights(current_client, R_BAN))
				to_chat(current_mob, SPAN_WARNING("You don't have permission to ban players."))
				return FALSE

			var/ticket_id = text2num(params["ticket_id"])
			if(!ticket_id)
				return FALSE

			var/datum/admin_help/ahelp_thread
			if(selected_tab == ADMIN_TAB)
				ahelp_thread = GLOB.ahelp_tickets.TicketByID(ticket_id)
			else
				to_chat(current_mob, SPAN_WARNING("Can only ban from admin tickets."))
				return FALSE

			if(!ahelp_thread || !ahelp_thread.initiator)
				to_chat(current_mob, SPAN_WARNING("Unable to find ticket or player."))
				return FALSE

			var/mob/banned_mob = ahelp_thread.initiator.mob
			if(!current_mob || !current_mob.username())
				to_chat(current_mob, SPAN_WARNING("Unable to find player to ban."))
				return FALSE

			var/choice = tgui_alert(current_mob, "Are you sure you want to permaban [banned_mob.username()]?", "Ban [banned_mob.username()]", list("Ban", "Cancel"))

			if(!choice || (choice == "Cancel"))
				return FALSE

			var/datum/player_action/perm_ban = GLOB.pp_actions["permanent_ban"]
			if(!perm_ban)
				return FALSE
			if(!perm_ban.act(current_client, banned_mob))
				return FALSE

			ahelp_thread.Resolve(current_mob.username(), FALSE)
			message_admins("[key_name_admin(current_mob)] banned [key_name_admin(banned_mob)] and closed ticket #[ticket_id]")
			log_admin("Ticket #[ticket_id] closed by [key_name(current_mob)] after banning [banned_mob.username()]")
			return TRUE

/datum/ticket_panel/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TicketPanel", "Ticket Panel")
		ui.set_autoupdate(FALSE)
		ui.open()


/datum/ticket_panel/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/admins/proc/ticket_panel()
	set name = "Ticket panel"
	set desc = "Allows you to see tickets open for adminhelps and mentorhelps."
	set category = "Admin"

	if(!CLIENT_IS_MENTOR(usr.client) && !CLIENT_IS_STAFF(usr.client))
		to_chat(usr, SPAN_WARNING("You need to be an admin or mentor in order to access this panel..."))
		return

	var/datum/ticket_panel/ticket_panel = usr.client.ticket_panel

	if(!ticket_panel)
		ticket_panel = new()
		usr.client.ticket_panel = ticket_panel

	ticket_panel.tgui_interact(usr)

#undef ADMIN_TAB
#undef MENTOR_TAB

GLOBAL_DATUM_INIT(TICKETPANEL, /datum/ticket_panel, new)

/datum/ticket_panel
	var/selected_tab = "admin"
	var/selected_ticket = null
	var/entered_message = ""

/datum/ticket_panel/New(mob/M)
	. = ..()

	if(CLIENT_IS_MENTOR(M.client))
		selected_tab = "mentor"

/datum/ticket_panel/Destroy(force, ...)
	SStgui.close_uis(src)
	return ..()

/datum/ticket_panel/proc/format_adminhelp_ticket(datum/admin_help/AH)
	var/status = AH.state == AHELP_ACTIVE ? "open" : AH.state == AHELP_RESOLVED ? "resolved" : "closed" // just setting some readable names, I suppose

	var/list/formatted_responses = list()
	for(var/key in AH.ticket_interactions)
		var/list/interaction = AH.ticket_interactions[key]
		formatted_responses += list(interaction)

	return list(
		"id" = AH.id,
		"subject" = AH.subject,
		"author" = AH.initiator_key_name || "Unknown",
		"message" = AH.initial_message || "No message",
		"latest_message" = AH.latest_message,
		"status" = status,
		"timestamp" = AH.time_activity["opened_at"],
		"closed_at" = AH.time_activity["closed_at"],
		"claimed_by" = AH.marked_admin,
		"all_responses" = formatted_responses,
		"viewer_is_claiming" = (AH.marked_admin == usr.ckey ? TRUE : FALSE),
		"entered_message" = entered_message,
		"is_archived" = (AH.state != AHELP_ACTIVE)
	)

/datum/ticket_panel/proc/format_mentorhelp_ticket(datum/mentorhelp/MH)
	var/status = MH.open ? (MH.mentor ? "claimed" : "open") : "closed"

	var/list/formatted_responses = list()
	for(var/key in MH.ticket_interactions)
		var/list/interaction = MH.ticket_interactions[key]
		formatted_responses += list(interaction)

	return list(
		"id" = MH.id,
		"subject" = MH.subject,
		"author" = MH.author_key || "Unknown",
		"message" = MH.initial_message || "No message",
		"latest_message" = MH.latest_message,
		"status" = status,
		"timestamp" = MH.time_activity["opened_at"],
		"closed_at" = MH.time_activity["closed_at"],
		"claimed_by" = MH.mentor ? MH.mentor.ckey : null,
		"all_responses" = formatted_responses,
		"viewer_is_claiming" = (MH.mentor && (MH.mentor.ckey == usr.ckey) ? TRUE : FALSE),
		"is_archived" = !MH.open
	)

/datum/ticket_panel/ui_data(mob/user)
	var/list/data = list(
		"is_admin" = CLIENT_IS_STAFF(user.client) ? TRUE: FALSE,
		"is_mentor" = CLIENT_IS_MENTOR(user.client) ? TRUE : FALSE,
		"selected_tab" = selected_tab,
		"selected_ticket" = selected_ticket,
		"admin_open_tickets" = list(),
		"mentor_open_tickets" = list(),
		"admin_archived_tickets" = list(),
		"mentor_archived_tickets" = list()
	)

	if(CLIENT_IS_STAFF(user.client))
		for(var/datum/admin_help/AH in GLOB.ahelp_tickets.active_tickets)
			data["admin_open_tickets"] += list(format_adminhelp_ticket(AH))

		for(var/datum/admin_help/AH in GLOB.ahelp_tickets.closed_tickets)
			data["admin_archived_tickets"] += list(format_adminhelp_ticket(AH))

		for(var/datum/admin_help/AH in GLOB.ahelp_tickets.resolved_tickets)
			data["admin_archived_tickets"] += list(format_adminhelp_ticket(AH))

	for(var/id in GLOB.mentorhelp_manager.active_tickets)
		var/datum/mentorhelp/MH = GLOB.mentorhelp_manager.get_ticket_by_id(id)
		if(istype(MH))
			data["mentor_open_tickets"] += list(format_mentorhelp_ticket(MH))

	for(var/id in GLOB.mentorhelp_manager.archived_tickets)
		var/datum/mentorhelp/MH = GLOB.mentorhelp_manager.get_ticket_by_id(id)
		if(istype(MH))
			data["mentor_archived_tickets"] += list(format_mentorhelp_ticket(MH))

	return data

/datum/ticket_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/client/C = usr.client
	var/mob/M = C.mob

	switch(action)
		if("refresh")
			return TRUE

		if("select_tab")
			if(params["tab"] == "admin" && !CLIENT_IS_STAFF(usr.client))
				return FALSE
			selected_tab = params["tab"]
			selected_ticket = null
			return TRUE

		if("select_ticket")
			selected_ticket = text2num(params["ticket_id"])
			return TRUE

		if("start_adminhelp")
			if(!CLIENT_IS_STAFF(C))
				tgui_alert(usr, "Silly! You need to be an admin to use this feature.")
				return FALSE

			var/list/possible_targets = list()
			for(var/client/target in GLOB.clients)
				if(!target.mob)
					continue
				possible_targets[target] = "[target.key]"

			if(!LAZYLEN(possible_targets))
				tgui_alert(usr, "No players available to message.")
				return FALSE

			var/client/target = tgui_input_list(usr, "Select a player to message:", "New Adminhelp", possible_targets)
			if(!target || !istype(target) || !target.mob)
				return FALSE

			if(istype(target.current_ticket) && target.current_ticket.state == AHELP_ACTIVE)
				selected_tab = "admin"
				selected_ticket = target.current_ticket.id
				to_chat(usr, "<span class='notice'>Switched to existing admin ticket for [target.key]</span>")
				return TRUE

			C.cmd_admin_pm(target, null)
			return TRUE

		if("start_mentorhelp")
			if(!CLIENT_IS_MENTOR(C) && !CLIENT_IS_STAFF(C))
				tgui_alert(usr, "You need to be a mentor or admin to use this feature.")
				return FALSE

			var/list/possible_targets = list()
			for(var/client/target in GLOB.clients)
				if(!target.mob)
					continue
				possible_targets[target] = "[target.key]"

			if(!LAZYLEN(possible_targets))
				tgui_alert(usr, "No non-staff players available to message.")
				return FALSE

			var/client/target = tgui_input_list(usr, "Select a player to message:", "New Mentorhelp", possible_targets)
			if(!target || !istype(target) || !target.mob)
				return FALSE

			if(istype(target.current_mhelp) && target.current_mhelp.open)
				selected_tab = "mentor"
				selected_ticket = target.current_mhelp.id
				to_chat(usr, "<span class='notice'>Switched to existing mentor ticket for [target.key]</span>")
				return TRUE

			if(GLOB.mentorhelp_manager.get_active_ticket_by_ckey(target.ckey))
				to_chat(usr, SPAN_WARNING("This user already has an open mentor ticket. Please close it first or use the existing one."), confidential = TRUE)
				return FALSE

			var/msg = tgui_input_text(usr, "Enter your message:", "New Mentorhelp")
			if(!msg)
				return FALSE

			var/datum/mentorhelp/MH = GLOB.mentorhelp_manager.create_ticket(target, msg)
			MH.notify("<font color='purple'>[usr.key] started a mentor conversation with [target.key]</font>",
				unformatted_text = "[usr.key] started a mentor conversation with [target.key]")
			MH.initial_message = msg
			MH.mark(C)
			MH.Respond(msg, C)

			return TRUE

		if("open_player_panel")
			if(!M.client.admin_holder)
				to_chat(usr, SPAN_WARNING("You don't have permission to open a player panel."))
				return FALSE

			var/mob/player
			var/ticket_id = text2num(params["ticket_id"])

			switch(selected_tab)
				if("admin")
					var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
					if(!istype(AH))
						to_chat(usr, SPAN_WARNING("Invalid admin ticket selected."))
						return FALSE
					player = AH.initiator.mob

				if("mentor")
					var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
					if(!istype(MH))
						to_chat(usr, SPAN_WARNING("Invalid mentor ticket selected."))
						return FALSE
					player = MH.author.mob

			if(!player || !player.ckey)
				to_chat(usr, SPAN_WARNING("Could not find player associated with this ticket."))
				return FALSE

			M.client.admin_holder.show_player_panel(player)
			return TRUE

		if("autoreply")
			var/ticket_id = text2num(params["ticket_id"])
			if(selected_tab == "admin")
				var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(AH)
					AH.AutoReply()
					return TRUE
			else
				var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
				if(MH)
					MH.autoresponse(M.client)
					return TRUE

		if("reopen_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			if(selected_tab == "admin")
				var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(!AH)
					to_chat(usr, SPAN_WARNING("Invalid admin ticket selected."))
					return FALSE

				var/client/target = AH.initiator
				if(!target)
					to_chat(usr, SPAN_WARNING("Could not find player associated with this ticket."))
					return FALSE

				if(target.current_ticket && target.current_ticket.state == AHELP_ACTIVE)
					to_chat(usr, SPAN_WARNING("This user already has an open ticket. Please close it first or use the existing one."), confidential = TRUE)
					return FALSE
				AH.Reopen()

				return TRUE
			else
				var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
				if(!MH)
					to_chat(usr, SPAN_WARNING("Invalid mentor ticket selected."))
					return FALSE

				if(GLOB.mentorhelp_manager.get_active_ticket_by_ckey(MH.author_key))
					to_chat(usr, SPAN_WARNING("This user already has an open mentor ticket. Please close it first or use the existing one."), confidential = TRUE)
					return FALSE

				MH.reopen()

				return TRUE

		if("close_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			if(selected_tab == "admin")
				var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(AH)
					if(AH.marked_admin != usr.ckey)
						to_chat(usr, SPAN_WARNING("You don't have permission to close this ticket."))
						return
					if(AH.state != AHELP_ACTIVE)
						to_chat(usr, SPAN_WARNING("This ticket is already [AH.state == AHELP_RESOLVED ? "resolved" : "closed"]."))
						return
					AH.Resolve(usr.ckey, FALSE)
					message_admins("[key_name_admin(usr)] closed ticket #[ticket_id]")
					log_admin("Ticket #[ticket_id] closed by [key_name(usr)]")
			else
				var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
				if(MH)
					if(!MH.open)
						to_chat(usr, SPAN_WARNING("This mentor ticket is already closed."))
						return

					if(MH.mentor && MH.mentor.ckey != usr.ckey && !CLIENT_IS_STAFF(usr.client))
						to_chat(usr, SPAN_WARNING("You don't have permission to close this ticket."))
						return

					MH.close(usr.client)
					message_mentors("[key_name_admin(usr)] closed mentor ticket from [MH.author_key]")
					log_admin_private("Mentor ticket from [MH.author_key] closed by [key_name(usr)]")
				else
					to_chat(usr, SPAN_WARNING("This ticket does not exist or has been deleted."))
			return TRUE

		if("claim_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			if(selected_tab == "admin")
				var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(AH)
					if(AH.marked_admin)
						if(AH.marked_admin == usr.ckey)
							AH.unmark_ticket()
							message_admins("[key_name_admin(usr)] unclaimed ticket #[ticket_id]")
						else
							to_chat(usr, SPAN_WARNING("This ticket is already claimed by [AH.marked_admin]."))
					else
						AH.mark_ticket(M)
						message_admins("[key_name_admin(usr)] claimed ticket #[ticket_id]")
			else
				var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
				if(!MH)
					return FALSE

				if(MH.mentor)
					if(MH.mentor.ckey == usr.ckey)
						MH.unmark(usr.client)
						message_mentors("[key_name_admin(usr)] unclaimed mentor ticket from [MH.author_key]")
					else
						to_chat(usr, SPAN_WARNING("This ticket is already claimed by [MH.mentor.ckey]."))
				else
					MH.mark(usr.client)
					message_mentors("[key_name_admin(usr)] claimed mentor ticket from [MH.author_key]")

			return TRUE

		if("update_message")
			var/updated_message = params["message"]
			if(!updated_message)
				return
			entered_message = sanitize(updated_message)
			return TRUE

		if("reply_ticket")
			var/ticket_id = text2num(params["ticket_id"])
			if(!ticket_id || !entered_message)
				return

			if(selected_tab == "admin")
				var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(AH)
					M.client.cmd_admin_pm(AH.initiator, entered_message)

			else
				var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
				if(MH)
					MH.Respond(entered_message, M.client)

			entered_message = ""

			return TRUE

		if("set_subject")
			var/ticket_id = text2num(params["ticket_id"])
			if(!ticket_id)
				return

			if(selected_tab == "admin")
				var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
				if(AH)
					var/new_subject = tgui_input_text(usr, "Enter a subject for this ticket:", "Set Ticket Subject", AH.subject, 100)
					if(!new_subject)
						return
					AH.set_subject(new_subject, usr.client)
			else
				var/datum/mentorhelp/MH = mentorhelp_by_id(ticket_id)
				if(!MH)
					to_chat(usr, SPAN_WARNING("This ticket does not exist."))
					return
				var/new_subject = tgui_input_text(usr, "Enter a subject for this ticket:", "Set Ticket Subject", MH.subject, 100)
				if(!new_subject)
					return
				MH.set_subject(new_subject, M.client)
			return TRUE

		if("get_author_notes")
			if(!check_rights(R_BAN))
				to_chat(usr, SPAN_NOTICE("You don't have permission to view author notes."))
				return FALSE

			if(!(selected_tab == "admin"))
				to_chat(usr, SPAN_WARNING("You can only view author notes from admin tickets."))
				return FALSE

			var/ticket_id = text2num(params["ticket_id"])
			var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
			if(!AH)
				to_chat(usr, SPAN_WARNING("Unable to find ticket."))
				return FALSE

			var/mob/noted_mob = AH.initiator.mob
			if(!noted_mob || !noted_mob.ckey)
				to_chat(usr, SPAN_WARNING("Unable to find mob."))
				return FALSE

			var/datum/player_action/show_notes = GLOB.pp_actions["show_notes"]
			if(show_notes)
				show_notes.act(usr.client, noted_mob)

			return TRUE

		if("ban_author")
			if(!check_rights(R_BAN))
				to_chat(usr, SPAN_WARNING("You don't have permission to ban players."))
				return FALSE

			var/ticket_id = text2num(params["ticket_id"])
			if(!ticket_id)
				return FALSE

			var/datum/admin_help/AH
			if(selected_tab == "admin")
				AH = GLOB.ahelp_tickets.TicketByID(ticket_id)
			else
				to_chat(usr, SPAN_WARNING("Can only ban from admin tickets."))
				return FALSE

			if(!AH || !AH.initiator)
				to_chat(usr, SPAN_WARNING("Unable to find ticket or player."))
				return FALSE

			var/mob/banned_mob = AH.initiator.mob
			if(!M || !M.ckey)
				to_chat(usr, SPAN_WARNING("Unable to find player to ban."))
				return FALSE

			var/choice = tgui_alert(usr, "Are you sure you want to permaban [banned_mob.ckey]?", "Ban [banned_mob.ckey]", list("Ban", "Cancel"))

			if(!choice || (choice == "Cancel"))
				return FALSE

			var/datum/player_action/perm_ban = GLOB.pp_actions["permanent_ban"]
			if(!perm_ban)
				return FALSE
			perm_ban.act(usr.client, banned_mob)

			AH.Resolve(usr.ckey, FALSE)
			message_admins("[key_name_admin(usr)] banned [key_name_admin(banned_mob)] and closed ticket #[ticket_id]")
			log_admin("Ticket #[ticket_id] closed by [key_name(usr)] after banning [banned_mob.ckey]")
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

	GLOB.TICKETPANEL.tgui_interact(usr)


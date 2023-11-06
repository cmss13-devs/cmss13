// #################### Working Joe Ticket Console #####################
/obj/structure/machinery/computer/working_joe
	name = "APOLLO Maintenance Controller"
	desc = "A console built to facilitate Working Joes and their operation, allowing for simple allocation of resources."
	icon = 'icons/obj/structures/machinery/ares.dmi'
	icon_state = "console"
	exproof = TRUE

	/// The ID used to link all devices.
	var/datum/ares_link/link
	/// The datacore storing all the information.
	var/datum/ares_datacore/datacore

	var/current_menu = "login"
	var/last_menu = ""

	var/authentication = APOLLO_ACCESS_LOGOUT
	/// The last person to login.
	var/last_login


/obj/structure/machinery/computer/working_joe/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link)
		new_link.ticket_computers += src
		link = new_link
		new_link.linked_systems += src
	if(!datacore)
		datacore = GLOB.ares_datacore
	return TRUE

/obj/structure/machinery/computer/working_joe/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/computer/working_joe/proc/delink()
	if(link)
		link.ticket_computers -= src
		link.linked_systems -= src
		link = null
	datacore = null

/obj/structure/machinery/computer/working_joe/Destroy()
	delink()
	return ..()

// ------ Maintenance Controller UI ------ //
/obj/structure/machinery/computer/working_joe/attack_hand(mob/user as mob)
	if(..() || !allowed(usr) || inoperable())
		return FALSE

	tgui_interact(user)
	return TRUE

/obj/structure/machinery/computer/working_joe/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WorkingJoe", name)
		ui.open()

/obj/structure/machinery/computer/working_joe/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu
	data["last_page"] = last_menu

	data["logged_in"] = last_login

	data["access_text"] = "access level [authentication], [ares_auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = security_level
	data["worldtime"] = world.time

	data["access_log"] = list()
	data["access_log"] += datacore.apollo_login_list

	data["apollo_log"] = list()
	data["apollo_log"] += datacore.apollo_log

	var/list/logged_maintenance = list()
	for(var/datum/ares_ticket/maintenance/maint_ticket as anything in link.tickets_maintenance)
		if(!istype(maint_ticket))
			continue
		var/lock_status = TICKET_OPEN
		switch(maint_ticket.ticket_status)
			if(TICKET_REJECTED, TICKET_CANCELLED, TICKET_COMPLETED)
				lock_status = TICKET_CLOSED

		var/list/current_maint = list()
		current_maint["id"] = maint_ticket.ticket_id
		current_maint["time"] = maint_ticket.ticket_time
		current_maint["priority_status"] = maint_ticket.ticket_priority
		current_maint["category"] = maint_ticket.ticket_name
		current_maint["details"] = maint_ticket.ticket_details
		current_maint["status"] = maint_ticket.ticket_status
		current_maint["submitter"] = maint_ticket.ticket_submitter
		current_maint["assignee"] = maint_ticket.ticket_assignee
		current_maint["lock_status"] = lock_status
		current_maint["ref"] = "\ref[maint_ticket]"
		logged_maintenance += list(current_maint)
	data["maintenance_tickets"] = logged_maintenance

	var/list/logged_access = list()
	var/list/requesting_access = list()
	for(var/datum/ares_ticket/access/access_ticket as anything in link.tickets_access)
		var/lock_status = TICKET_OPEN
		switch(access_ticket.ticket_status)
			if(TICKET_REJECTED, TICKET_CANCELLED, TICKET_REVOKED)
				lock_status = TICKET_CLOSED

		var/list/current_ticket = list()
		current_ticket["id"] = access_ticket.ticket_id
		current_ticket["time"] = access_ticket.ticket_time
		current_ticket["priority_status"] = access_ticket.ticket_priority
		current_ticket["title"] = access_ticket.ticket_name
		current_ticket["details"] = access_ticket.ticket_details
		current_ticket["status"] = access_ticket.ticket_status
		current_ticket["submitter"] = access_ticket.ticket_submitter
		current_ticket["assignee"] = access_ticket.ticket_assignee
		current_ticket["lock_status"] = lock_status
		current_ticket["ref"] = "\ref[access_ticket]"
		logged_access += list(current_ticket)

		if(lock_status == TICKET_OPEN)
			requesting_access += access_ticket.ticket_name
	data["access_tickets"] = logged_access

	return data

/obj/structure/machinery/computer/working_joe/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(inoperable())
		return UI_DISABLED

/obj/structure/machinery/computer/working_joe/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/playsound = TRUE
	var/mob/living/carbon/human/operator = usr

	switch (action)
		if("go_back")
			if(!last_menu)
				return to_chat(usr, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")

			var/obj/item/card/id/idcard = operator.get_active_hand()
			if(istype(idcard))
				authentication = get_ares_access(idcard)
				last_login = idcard.registered_name
			else if(operator.wear_id)
				idcard = operator.wear_id
				if(istype(idcard))
					authentication = get_ares_access(idcard)
					last_login = idcard.registered_name
			else
				to_chat(operator, SPAN_WARNING("You require an ID card to access this terminal!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(authentication)
				datacore.apollo_login_list += "[last_login] at [worldtime2text()], Access Level [authentication] - [ares_auth_to_text(authentication)]."
			current_menu = "main"

		if("logout")
			last_menu = current_menu
			current_menu = "login"
			datacore.apollo_login_list += "[last_login] logged out at [worldtime2text()]."

		if("home")
			last_menu = current_menu
			current_menu = "main"
		if("page_logins")
			last_menu = current_menu
			current_menu = "login_records"
		if("page_apollo")
			last_menu = current_menu
			current_menu = "apollo"
		if("page_request")
			last_menu = current_menu
			current_menu = "access_requests"
		if("page_report")
			last_menu = current_menu
			current_menu = "maint_reports"
		if("page_tickets")
			last_menu = current_menu
			current_menu = "access_tickets"
		if("page_maintenance")
			last_menu = current_menu
			current_menu = "maint_claim"

		if("new_report")
			var/priority_report = FALSE
			var/maint_type = tgui_input_list(operator, "What is the type of maintenance item you wish to report?", "Report Category", GLOB.maintenance_categories, 30 SECONDS)
			switch(maint_type)
				if("Major Structural Damage", "Fire", "Communications Failure",	"Power Generation Failure")
					priority_report = TRUE

			if(!maint_type)
				return FALSE
			var/details = tgui_input_text(operator, "What are the details for this report?", "Ticket Details", encode = FALSE)
			if(!details)
				return FALSE

			if((authentication >= APOLLO_ACCESS_REPORTER) && !priority_report)
				var/is_priority = tgui_alert(operator, "Is this a priority report?", "Priority designation", list("Yes", "No"))
				if(is_priority == "Yes")
					priority_report = TRUE

			var/confirm = alert(operator, "Please confirm the submission of your maintenance report. \n\n Priority: [priority_report ? "Yes" : "No"]\n Category: '[maint_type]'\n Details: '[details]'\n\n Is this correct?", "Confirmation", "Yes", "No")
			if(confirm == "Yes")
				if(link)
					var/datum/ares_ticket/maintenance/maint_ticket = new(last_login, maint_type, details, priority_report)
					link.tickets_maintenance += maint_ticket
					if(priority_report)
						ares_apollo_talk("Priority Maintenance Report: [maint_type] - ID [maint_ticket.ticket_id]. Seek and resolve.")
					log_game("ARES: Maintenance Ticket '\ref[maint_ticket]' created by [key_name(operator)] as [last_login] with Category '[maint_type]' and Details of '[details]'.")
					return TRUE
			return FALSE

		if("claim_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			var/claim = TRUE
			var/assigned = ticket.ticket_assignee
			if(assigned)
				if(assigned == last_login)
					var/prompt = tgui_alert(usr, "You already claimed this ticket! Do you wish to drop your claim?", "Unclaim ticket", list("Yes", "No"))
					if(prompt != "Yes")
						return FALSE
					/// set ticket back to pending
					ticket.ticket_assignee = null
					ticket.ticket_status = TICKET_PENDING
					return claim
				var/choice = tgui_alert(usr, "This ticket has already been claimed by [assigned]! Do you wish to override their claim?", "Claim Override", list("Yes", "No"))
				if(choice != "Yes")
					claim = FALSE
			if(claim)
				ticket.ticket_assignee = last_login
				ticket.ticket_status = TICKET_ASSIGNED
			return claim

		if("cancel_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			if(ticket.ticket_submitter != last_login)
				to_chat(usr, SPAN_WARNING("You cannot cancel a ticket that does not belong to you!"))
				return FALSE
			to_chat(usr, SPAN_WARNING("[ticket.ticket_type] [ticket.ticket_id] has been cancelled."))
			ticket.ticket_status = TICKET_CANCELLED
			if(ticket.ticket_priority)
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been cancelled.")
			return TRUE

		if("mark_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			if(ticket.ticket_assignee != last_login && ticket.ticket_assignee) //must be claimed by you or unclaimed.)
				to_chat(usr, SPAN_WARNING("You cannot update a ticket that is not assigned to you!"))
				return FALSE
			var/choice = tgui_alert(usr, "What do you wish to mark the ticket as?", "Mark", list(TICKET_COMPLETED, TICKET_REJECTED), 20 SECONDS)
			switch(choice)
				if(TICKET_COMPLETED)
					ticket.ticket_status = TICKET_COMPLETED
				if(TICKET_REJECTED)
					ticket.ticket_status = TICKET_REJECTED
				else
					return FALSE
			if(ticket.ticket_priority)
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been [choice] by [last_login].")
			to_chat(usr, SPAN_NOTICE("[ticket.ticket_type] [ticket.ticket_id] marked as [choice]."))
			return TRUE

		if("new_access")
			var/obj/item/card/id/idcard = operator.get_active_hand()
			var/has_id = FALSE
			if(istype(idcard))
				has_id = TRUE
			else if(operator.wear_id)
				idcard = operator.wear_id
				if(istype(idcard))
					has_id = TRUE
			if(!has_id)
				to_chat(operator, SPAN_WARNING("You require an ID card to request an access ticket!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(idcard.registered_name != last_login)
				to_chat(operator, SPAN_WARNING("This ID card does not match the active login!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			var/details = tgui_input_text(operator, "What is the purpose of this access ticket?", "Ticket Details", encode = FALSE)
			if(!details)
				return FALSE

			var/confirm = alert(operator, "Please confirm the submission of your access ticket request.\n\nHolder: '[last_login]'\nDetails: '[details]'\n\nIs this correct?", "Confirmation", "Yes", "No")
			if(confirm != "Yes" || !link)
				return FALSE
			var/datum/ares_ticket/access/access_ticket = new(last_login, details, FALSE, idcard.registered_gid)
			link.waiting_ids += idcard
			link.tickets_access += access_ticket
			log_game("ARES: Access Ticket '\ref[access_ticket]' created by [key_name(operator)] as [last_login] with Details of '[details]'.")
			message_admins(SPAN_STAFF_IC("[key_name_admin(operator)] created a new ARES Access Ticket."), 1)
			ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] requesting access for '[details].")
			return TRUE

		if("return_access")
			playsound = FALSE
			var/datum/ares_ticket/access/access_ticket
			for(var/datum/ares_ticket/access/possible_ticket in link.tickets_access)
				if(possible_ticket.ticket_status != TICKET_GRANTED)
					continue
				if(possible_ticket.ticket_name != last_login)
					continue
				access_ticket = possible_ticket
				break

			for(var/obj/item/card/id/identification in link.active_ids)
				if(!istype(identification))
					continue
				if(identification.registered_gid != access_ticket.user_id_num)
					continue

				access_ticket.ticket_status = TICKET_RETURNED
				identification.access -= ACCESS_MARINE_AI_TEMP
				identification.modification_log += "Temporary AI Access self-returned by [key_name(operator)]."

				to_chat(operator, SPAN_NOTICE("Temporary Access Ticket surrendered."))
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] surrendered their access.")

				authentication = get_ares_access(identification)
				if(authentication)
					datacore.apollo_login_list += "[last_login] at [worldtime2text()], Surrendered Temporary Access Ticket."
				return TRUE

			to_chat(operator, SPAN_WARNING("This ID card does not have an access ticket!"))
			playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
			return FALSE

		if("auth_access")
			playsound = FALSE
			var/datum/ares_ticket/access/access_ticket = locate(params["ticket"])
			if(!access_ticket)
				return FALSE
			for(var/obj/item/card/id/identification in link.waiting_ids)
				if(!istype(identification))
					continue
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(last_login, operator)
				access_ticket.ticket_status = TICKET_GRANTED
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] was granted access by [last_login].")
				return TRUE
			for(var/obj/item/card/id/identification in link.active_ids)
				if(!istype(identification))
					continue
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(last_login, operator)
				access_ticket.ticket_status = TICKET_REVOKED
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] had access revoked by [last_login].")
				return TRUE
			return FALSE

		if("reject_access")
			var/datum/ares_ticket/access/access_ticket = locate(params["ticket"])
			if(!istype(access_ticket))
				return FALSE
			if(access_ticket.ticket_assignee != last_login && access_ticket.ticket_assignee) //must be claimed by you or unclaimed.)
				to_chat(usr, SPAN_WARNING("You cannot update a ticket that is not assigned to you!"))
				return FALSE
			access_ticket.ticket_status = TICKET_REJECTED
			to_chat(usr, SPAN_NOTICE("[access_ticket.ticket_type] [access_ticket.ticket_id] marked as rejected."))
			ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] was rejected access by [last_login].")
			return TRUE

	if(playsound)
		playsound(src, "keyboard_alt", 15, 1)

/obj/item/card/id/proc/handle_ares_access(logged_in, mob/user)
	var/operator = key_name(user)
	var/datum/ares_link/link = GLOB.ares_link
	if(logged_in == MAIN_AI_SYSTEM)
		if(!user)
			operator = "[MAIN_AI_SYSTEM] (Sensor Trip)"
		else
			operator = "[user.ckey]/([MAIN_AI_SYSTEM])"
	if(ACCESS_MARINE_AI_TEMP in access)
		access -= ACCESS_MARINE_AI_TEMP
		link.active_ids -= src
		modification_log += "Temporary AI access revoked by [operator]"
		to_chat(user, SPAN_NOTICE("Access revoked from [registered_name]."))
	else
		access += ACCESS_MARINE_AI_TEMP
		modification_log += "Temporary AI access granted by [operator]"
		to_chat(user, SPAN_NOTICE("Access granted to [registered_name]."))
		link.waiting_ids -= src
		link.active_ids += src
	return TRUE

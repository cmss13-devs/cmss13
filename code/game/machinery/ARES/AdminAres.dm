/client/proc/cmd_admin_open_ares()
	set name = "Open ARES Interface"
	set category = "Admin.Factions"

	if(!check_rights(R_MOD))
		to_chat(usr, SPAN_WARNING("You do not have access to this command."))
		return FALSE

	if(!SSticker.mode)
		to_chat(usr, SPAN_WARNING("The round has not started yet."))
		return FALSE

	if(!GLOB.ares_link || !GLOB.ares_link.admin_interface || !GLOB.ares_link.interface)
		to_chat(usr, SPAN_BOLDWARNING("ERROR: ARES Link or Interface not found!"))
		return FALSE
	GLOB.ares_link.tgui_interact(mob)
	var/mob/user = usr
	var/log = "[key_name(user)] opened the remote ARES Interface."
	if(user.job)
		log = "[key_name(user)] ([user.job]) opened the remote ARES Interface."
	log_admin(log)

/datum/ares_console_admin
	var/current_menu = "login"
	var/last_menu = ""

	var/authentication = ARES_ACCESS_BASIC

	/// The last admin to login.
	var/last_login
	/// The currently logged in admin.
	var/logged_in
	/// A record of who logged in and when.
	var/list/access_list = list()
	var/list/deleted_1to1 = list()


/datum/ares_link/tgui_interact(mob/user, datum/tgui/ui)
	if(!interface || !admin_interface)
		to_chat(user, SPAN_WARNING("ARES ADMIN DATA LINK FAILED"))
		return FALSE
	ui = SStgui.try_update_ui(user, GLOB.ares_link, ui)
	if(!ui)
		ui = new(user, GLOB.ares_link, "AresAdmin", "ARES Admin Interface")
		ui.open()

/datum/ares_link/ui_data(mob/user)
	if(!interface)
		to_chat(user, SPAN_WARNING("ARES ADMIN DATA LINK FAILED"))
		return FALSE
	var/list/data = list()

	data["admin_login"] = "[admin_interface.logged_in], [user.client.admin_holder?.rank]"
	data["admin_access_log"] = list()
	data["admin_access_log"] += admin_interface.access_list

	data["current_menu"] = admin_interface.current_menu
	data["last_page"] = admin_interface.last_menu

	data["logged_in"] = interface.last_login
	data["sudo"] = interface.sudo_holder ? TRUE : FALSE

	data["access_text"] = "[interface.sudo_holder ? "(SUDO)," : ""] access level [interface.authentication], [interface.ares_auth_to_text(interface.authentication)]."
	data["access_level"] = interface.authentication

	data["alert_level"] = security_level
	data["evac_status"] = EvacuationAuthority.evac_status
	data["worldtime"] = world.time

	data["access_log"] = list()
	data["access_log"] += interface.access_list
	data["apollo_log"] = list()
	data["apollo_log"] += apollo_log

	data["deleted_conversation"] = list()
	data["deleted_conversation"] += admin_interface.deleted_1to1

	data["distresstime"] = interface.ares_distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["mission_failed"] = SSticker.mode.is_in_endgame
	data["nuketimelock"] = NUCLEAR_TIME_LOCK
	data["nuke_available"] = interface.nuke_available

	var/list/logged_announcements = list()
	for(var/datum/ares_record/announcement/broadcast as anything in interface.records_announcement)
		var/list/current_broadcast = list()
		current_broadcast["time"] = broadcast.time
		current_broadcast["title"] = broadcast.title
		current_broadcast["details"] = broadcast.details
		current_broadcast["ref"] = "\ref[broadcast]"
		logged_announcements += list(current_broadcast)
	data["records_announcement"] = logged_announcements

	var/list/logged_alerts = list()
	for(var/datum/ares_record/security/security_alert as anything in interface.records_security)
		var/list/current_alert = list()
		current_alert["time"] = security_alert.time
		current_alert["title"] = security_alert.title
		current_alert["details"] = security_alert.details
		current_alert["ref"] = "\ref[security_alert]"
		logged_alerts += list(current_alert)
	data["records_security"] = logged_alerts

	var/list/logged_flights = list()
	for(var/datum/ares_record/flight/flight_log as anything in interface.records_flight)
		var/list/current_flight = list()
		current_flight["time"] = flight_log.time
		current_flight["title"] = flight_log.title
		current_flight["details"] = flight_log.details
		current_flight["user"] = flight_log.user
		current_flight["ref"] = "\ref[flight_log]"
		logged_flights += list(current_flight)
	data["records_flight"] = logged_flights

	var/list/logged_bioscans = list()
	for(var/datum/ares_record/bioscan/scan as anything in interface.records_bioscan)
		var/list/current_scan = list()
		current_scan["time"] = scan.time
		current_scan["title"] = scan.title
		current_scan["details"] = scan.details
		current_scan["ref"] = "\ref[scan]"
		logged_bioscans += list(current_scan)
	data["records_bioscan"] = logged_bioscans

	var/list/logged_bombs = list()
	for(var/datum/ares_record/bombardment/bomb as anything in interface.records_bombardment)
		var/list/current_bomb = list()
		current_bomb["time"] = bomb.time
		current_bomb["title"] = bomb.title
		current_bomb["details"] = bomb.details
		current_bomb["user"] = bomb.user
		current_bomb["ref"] = "\ref[bomb]"
		logged_bombs += list(current_bomb)
	data["records_bombardment"] = logged_bombs

	var/list/logged_deletes = list()
	for(var/datum/ares_record/deletion/deleted as anything in interface.records_deletion)
		if(!istype(deleted))
			continue
		var/list/current_delete = list()
		current_delete["time"] = deleted.time
		current_delete["title"] = deleted.title
		current_delete["details"] = deleted.details
		current_delete["user"] = deleted.user
		current_delete["ref"] = "\ref[deleted]"
		logged_deletes += list(current_delete)
	data["records_deletion"] = logged_deletes

	var/list/logged_discussions = list()
	for(var/datum/ares_record/deleted_talk/deleted_convo as anything in interface.records_deletion)
		if(!istype(deleted_convo))
			continue
		var/list/deleted_disc = list()
		deleted_disc["time"] = deleted_convo.time
		deleted_disc["title"] = deleted_convo.title
		deleted_disc["ref"] = "\ref[deleted_convo]"
		logged_discussions += list(deleted_disc)
	data["deleted_discussions"] = logged_discussions

	var/list/logged_orders = list()
	for(var/datum/ares_record/requisition_log/req_order as anything in interface.records_asrs)
		if(!istype(req_order))
			continue
		var/list/current_order = list()
		current_order["time"] = req_order.time
		current_order["details"] = req_order.details
		current_order["title"] = req_order.title
		current_order["user"] = req_order.user
		current_order["ref"] = "\ref[req_order]"
		logged_orders += list(current_order)
	data["records_requisition"] = logged_orders

	var/list/logged_convos = list()
	var/list/active_convo = list()
	var/active_ref
	for(var/datum/ares_record/talk_log/log as anything in interface.records_talking)
		if(!istype(log))
			continue
		if(log.user == interface.last_login)
			active_convo = log.conversation
			active_ref = "\ref[log]"

		var/list/current_convo = list()
		current_convo["user"] = log.user
		current_convo["ref"] = "\ref[log]"
		current_convo["conversation"] = log.conversation
		logged_convos += list(current_convo)

	data["active_convo"] = active_convo
	data["active_ref"] = active_ref
	data["conversations"] = logged_convos

	var/list/logged_access = list()
	for(var/datum/ares_ticket/access/access_ticket as anything in tickets_access)
		var/lock_status = TICKET_OPEN
		switch(access_ticket.ticket_status)
			if(TICKET_REJECTED, TICKET_CANCELLED, TICKET_COMPLETED)
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
	data["access_tickets"] = logged_access

	return data


/datum/ares_link/ui_state(mob/user)
	return GLOB.admin_state

/datum/ares_link/ui_static_data(mob/user)
	var/list/data = list()

	data["link_id"] = interface.link_id

	return data

/datum/ares_link/ui_close(mob/user)
	. = ..()
	if(admin_interface.logged_in && (user.ckey == admin_interface.logged_in))
		admin_interface.current_menu = "login"
		admin_interface.last_menu = "login"
		admin_interface.access_list += "[admin_interface.logged_in] logged out at [worldtime2text()]."
		admin_interface.last_login = admin_interface.logged_in
		admin_interface.logged_in = null

/datum/ares_link/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = usr

	switch (action)
		if("go_back")
			if(!admin_interface.last_menu)
				return to_chat(user, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = admin_interface.current_menu
			admin_interface.current_menu = admin_interface.last_menu
			admin_interface.last_menu = temp_holder

		if("login")
			if(check_rights_for(user.client, R_MOD))
				admin_interface.logged_in = user.client.ckey
				admin_interface.access_list += "[user.client.ckey] at [worldtime2text()], Access Level '[user.client.admin_holder?.rank]'."
			else
				to_chat(user, SPAN_WARNING("You require staff identification to access this terminal!"))
				return FALSE
			admin_interface.current_menu = "main"

		// -- Page Changers -- //
		if("logout")
			admin_interface.current_menu = "login"
			admin_interface.last_menu = "login"
			admin_interface.access_list += "[admin_interface.logged_in] logged out at [worldtime2text()]. (UI Termination)"
			admin_interface.last_login = admin_interface.logged_in
			admin_interface.logged_in = null

		if("home")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "main"
		if("page_1to1")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "talking"
		if("page_announcements")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "announcements"
		if("page_bioscans")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "bioscans"
		if("page_bombardments")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "bombardments"
		if("page_apollo")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "apollo"
		if("page_access")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "access_log"
		if("page_admin_list")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "admin_access_log"
		if("page_security")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "security"
		if("page_requisitions")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "requisitions"
		if("page_flight")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "flight_log"
		if("page_emergency")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "emergency"
		if("page_deleted")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "delete_log"
		if("page_deleted_1to1")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "deleted_talks"
		if("page_access_management")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "access_management"

		// -- 1:1 Conversation -- //
		if("new_conversation")
			var/datum/ares_record/talk_log/convo = new(interface.last_login)
			convo.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], 'New 1:1 link initiated. Greetings, [interface.last_login].'"
			interface.records_talking += convo

		if("clear_conversation")
			var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
			if(!istype(conversation))
				return FALSE
			var/datum/ares_record/deleted_talk/deleted = new
			deleted.title = conversation.title
			deleted.conversation = conversation.conversation
			deleted.user = MAIN_AI_SYSTEM
			interface.records_deletion += deleted
			interface.records_talking -= conversation

		if("fake_message_ares")
			var/message = tgui_input_text(user, "What do you wish to say to ARES?", "ARES Message", encode = FALSE)
			if(message)
				interface.message_ares(message, user, params["active_convo"], TRUE)
		if("ares_reply")
			var/message = tgui_input_text(user, "What do you wish to reply with?", "ARES Response", encode = FALSE)
			if(message)
				interface.response_from_ares(message, params["active_convo"])
				var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
				var/admin_log = SPAN_STAFF_IC("<b>ADMINS/MODS: [SPAN_RED("[key_name(user)] replied to [conversation.user]'s ARES message")] [SPAN_GREEN("via Remote Interface")] with: [SPAN_BLUE(message)] </b>")
				for(var/client/admin in GLOB.admins)
					if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
						to_chat(admin, admin_log)

		if("read_record")
			var/datum/ares_record/deleted_talk/conversation = locate(params["record"])
			admin_interface.deleted_1to1 = conversation.conversation
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "read_deleted"

		if("claim_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			var/claim = TRUE
			var/assigned = ticket.ticket_assignee
			if(assigned)
				if(assigned == MAIN_AI_SYSTEM)
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
				ticket.ticket_assignee = MAIN_AI_SYSTEM
				ticket.ticket_status = TICKET_ASSIGNED
			return claim

		if("auth_access")
			var/datum/ares_ticket/access/access_ticket = locate(params["ticket"])
			if(!access_ticket)
				return FALSE
			for(var/obj/item/card/id/identification in waiting_ids)
				if(!istype(identification))
					continue
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(MAIN_AI_SYSTEM, user)
				access_ticket.ticket_status = TICKET_GRANTED
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				return TRUE
			for(var/obj/item/card/id/identification in active_ids)
				if(!istype(identification))
					continue
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(MAIN_AI_SYSTEM, user)
				access_ticket.ticket_status = TICKET_REVOKED
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				return TRUE
			return FALSE

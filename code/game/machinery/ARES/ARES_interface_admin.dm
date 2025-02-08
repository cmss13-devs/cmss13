/client/proc/cmd_admin_open_ares()
	set name = "Open ARES Interface"
	set category = "Admin.Factions"

	var/mob/user = usr
	if(!check_rights(R_MOD))
		to_chat(user, SPAN_WARNING("You do not have access to this command."))
		return FALSE

	if(!SSticker.mode)
		to_chat(user, SPAN_WARNING("The round has not started yet."))
		return FALSE

	if(!GLOB.ares_link || !GLOB.ares_link.admin_interface || !GLOB.ares_link.interface)
		to_chat(usr, SPAN_BOLDWARNING("ERROR: ARES Link or Interface not found!"))
		return FALSE
	GLOB.ares_link.tgui_interact(user)
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
	var/list/data = datacore.get_interface_data()

	data["local_admin_login"] = "[admin_interface.logged_in], [user.client.admin_holder?.rank]"
	data["admin_access_log"] = admin_interface.access_list

	data["local_current_menu"] = admin_interface.current_menu
	data["local_last_page"] = admin_interface.last_menu

	data["ares_logged_in"] = interface.last_login
	data["ares_sudo"] = interface.sudo_holder ? TRUE : FALSE

	data["ares_access_text"] = "[interface.sudo_holder ? "(SUDO)," : ""] access level [interface.authentication], [interface.ares_auth_to_text(interface.authentication)]."

	data["local_spying_conversation"] = admin_interface.deleted_1to1

	var/list/active_convo = list()
	var/active_ref
	for(var/datum/ares_record/talk_log/log as anything in datacore.records_talking)
		if(!istype(log))
			continue
		if(log.user == interface.last_login)
			active_convo = log.conversation
			active_ref = "\ref[log]"
	data["local_active_convo"] = active_convo
	data["local_active_ref"] = active_ref

	return data


/datum/ares_link/ui_state(mob/user)
	return GLOB.admin_state

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
	var/mob/user = ui.user
	if(!check_rights_for(user.client, R_MOD))
		to_chat(user, SPAN_WARNING("You require staff identification to access this terminal!"))
		return FALSE
	switch (action)
		if("go_back")
			if(!admin_interface.last_menu)
				to_chat(user, SPAN_WARNING("Error, no previous page detected."))
				return FALSE
			var/temp_holder = admin_interface.current_menu
			admin_interface.current_menu = admin_interface.last_menu
			admin_interface.last_menu = temp_holder

		if("login")
			admin_interface.logged_in = user.client.ckey
			admin_interface.access_list += "[user.client.ckey] at [worldtime2text()], Access Level '[user.client.admin_holder?.rank]'."
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
		if("page_records_1to1")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "talking_log"
		if("page_deleted_1to1")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "deleted_talks"
		if("page_tech")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "tech_log"
		if("page_core_sec")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "core_security"
		if("page_access_management")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "access_management"
		if("page_maint_management")
			admin_interface.last_menu = admin_interface.current_menu
			admin_interface.current_menu = "maintenance_management"

		// -- 1:1 Conversation -- //
		if("new_conversation")
			var/datum/ares_record/talk_log/convo = new(interface.last_login)
			convo.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], 'New 1:1 link initiated. Greetings, [interface.last_login].'"
			datacore.records_talking += convo

		if("clear_conversation")
			var/datum/ares_record/talk_log/conversation = locate(params["local_active_convo"])
			if(!istype(conversation))
				return FALSE
			var/datum/ares_record/deleted_talk/deleted = new
			deleted.title = conversation.title
			deleted.conversation = conversation.conversation
			deleted.user = MAIN_AI_SYSTEM
			datacore.records_deletion += deleted
			datacore.records_talking -= conversation

		if("fake_message_ares")
			var/message = tgui_input_text(user, "What do you wish to say to ARES?", "ARES Message", encode = FALSE)
			if(message)
				interface.message_ares(message, user, params["local_active_convo"], TRUE)
		if("ares_reply")
			var/message = tgui_input_text(user, "What do you wish to reply with?", "ARES Response", encode = FALSE)
			if(message)
				interface.response_from_ares(message, params["local_active_convo"])
				var/datum/ares_record/talk_log/conversation = locate(params["local_active_convo"])
				if(!istype(conversation))
					return FALSE
				var/admin_log = SPAN_STAFF_IC("<b>ADMINS/MODS: [SPAN_RED("[key_name(user)] replied to [conversation.user]'s ARES message")] [SPAN_GREEN("via Remote Interface")] with: [SPAN_BLUE(message)] </b>")
				for(var/client/admin in GLOB.admins)
					if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
						to_chat(admin, admin_log)

		if("read_record")
			var/datum/ares_record/deleted_talk/conversation = locate(params["record"])
			if(!istype(conversation))
				return FALSE
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
					var/prompt = tgui_alert(user, "ARES already claimed this ticket! Do you wish to drop the claim?", "Unclaim ticket", list("Yes", "No"))
					if(prompt != "Yes")
						return FALSE
					/// set ticket back to pending
					ticket.ticket_assignee = null
					ticket.ticket_status = TICKET_PENDING
					return claim
				var/choice = tgui_alert(user, "This ticket has already been claimed by [assigned]! Do you wish to override their claim?", "Claim Override", list("Yes", "No"))
				if(choice != "Yes")
					claim = FALSE
			if(claim)
				ticket.ticket_assignee = MAIN_AI_SYSTEM
				ticket.ticket_status = TICKET_ASSIGNED
			return claim

		if("auth_access")
			var/datum/ares_ticket/access/access_ticket = locate(params["ticket"])
			if(!istype(access_ticket))
				return FALSE
			for(var/obj/item/card/id/identification in waiting_ids)
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(MAIN_AI_SYSTEM, user)
				access_ticket.ticket_status = TICKET_GRANTED
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] granted core access.")
				return TRUE
			for(var/obj/item/card/id/identification in active_ids)
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(MAIN_AI_SYSTEM, user)
				access_ticket.ticket_status = TICKET_REVOKED
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: core access for [access_ticket.ticket_submitter] revoked.")
				return TRUE
			return FALSE

		if("reject_access")
			var/datum/ares_ticket/access/access_ticket = locate(params["ticket"])
			if(!istype(access_ticket))
				return FALSE
			access_ticket.ticket_status = TICKET_REJECTED
			to_chat(user, SPAN_NOTICE("[access_ticket.ticket_type] [access_ticket.ticket_id] marked as rejected."))
			ares_apollo_talk("Access Ticket [access_ticket.ticket_id] rejected.")
			return TRUE

		if("new_report")
			var/priority_report = FALSE
			var/maint_type = tgui_input_list(user, "What is the type of maintenance item you wish to report?", "Report Category", GLOB.maintenance_categories, 30 SECONDS)
			switch(maint_type)
				if("Major Structural Damage", "Fire", "Communications Failure",	"Power Generation Failure")
					priority_report = TRUE

			if(!maint_type)
				return FALSE
			var/details = tgui_input_text(user, "What are the details for this report?", "Ticket Details", encode = FALSE)
			if(!details)
				return FALSE

			if(!priority_report)
				var/is_priority = tgui_alert(user, "Is this a priority report?", "Priority designation", list("Yes", "No"))
				if(is_priority == "Yes")
					priority_report = TRUE

			var/confirm = alert(user, "Please confirm the submission of your maintenance report. \n\n Priority: [priority_report ? "Yes" : "No"]\n Category: '[maint_type]'\n Details: '[details]'\n\n Is this correct?", "Confirmation", "Yes", "No")
			if(confirm == "Yes")
				var/datum/ares_ticket/maintenance/maint_ticket = new(MAIN_AI_SYSTEM, maint_type, details, priority_report)
				tickets_maintenance += maint_ticket
				if(priority_report)
					ares_apollo_talk("Priority Maintenance Report: [maint_type] - ID [maint_ticket.ticket_id]. Seek and resolve.")
				log_game("ARES: Maintenance Ticket '\ref[maint_ticket]' created by [key_name(user)] as [MAIN_AI_SYSTEM] with Category '[maint_type]' and Details of '[details]'.")
				return TRUE
			return FALSE

		if("cancel_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			if(ticket.ticket_submitter != MAIN_AI_SYSTEM)
				to_chat(user, SPAN_WARNING("You cannot cancel a ticket that does not belong to [MAIN_AI_SYSTEM]!"))
				return FALSE
			to_chat(user, SPAN_WARNING("[ticket.ticket_type] [ticket.ticket_id] has been cancelled."))
			ticket.ticket_status = TICKET_CANCELLED
			if(ticket.ticket_priority)
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been cancelled.")
			return TRUE

		if("mark_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			var/options_list = list(TICKET_COMPLETED, TICKET_REJECTED)
			if(ticket.ticket_priority)
				options_list += TICKET_NON_PRIORITY
			else
				options_list += TICKET_PRIORITY
			var/choice = tgui_alert(user, "What do you wish to mark the ticket as?", "Mark", options_list, 20 SECONDS)
			switch(choice)
				if(TICKET_PRIORITY)
					ticket.ticket_priority = TRUE
					ares_apollo_talk("[ticket.ticket_type] [ticket.ticket_id] upgraded to Priority.")
					return TRUE
				if(TICKET_NON_PRIORITY)
					ticket.ticket_priority = FALSE
					ares_apollo_talk("[ticket.ticket_type] [ticket.ticket_id] downgraded from Priority.")
					return TRUE
				if(TICKET_COMPLETED)
					ticket.ticket_status = TICKET_COMPLETED
				if(TICKET_REJECTED)
					ticket.ticket_status = TICKET_REJECTED
				else
					return FALSE
			if(ticket.ticket_priority)
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been [choice] by [MAIN_AI_SYSTEM].")
			to_chat(user, SPAN_NOTICE("[ticket.ticket_type] [ticket.ticket_id] marked as [choice]."))
			return TRUE

		if("trigger_vent")
			var/obj/structure/pipes/vents/pump/no_boom/gas/sec_vent = locate(params["vent"])
			if(!istype(sec_vent) || sec_vent.welded)
				to_chat(user, SPAN_WARNING("ERROR: Gas release failure."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(!COOLDOWN_FINISHED(sec_vent, vent_trigger_cooldown))
				to_chat(user, SPAN_WARNING("ERROR: Insufficient gas reserve for this vent."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			to_chat(user, SPAN_WARNING("Initiating gas release from [sec_vent.vent_tag]."))
			playsound(src, 'sound/machines/chime.ogg', 15, 1)
			COOLDOWN_START(sec_vent, vent_trigger_cooldown, COOLDOWN_ARES_VENT)
			ares_apollo_talk("Nerve Gas release imminent from [sec_vent.vent_tag].")
			log_ares_security("Nerve Gas Release", "Released Nerve Gas from Vent '[sec_vent.vent_tag]'.", MAIN_AI_SYSTEM)
			sec_vent.create_gas(VENT_GAS_CN20_XENO, 6, 5 SECONDS)
			log_admin("[key_name(user)] released nerve gas from Vent '[sec_vent.vent_tag]' via ARES.")

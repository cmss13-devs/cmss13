/obj/item/device/ai_tech_pda
	icon = 'icons/obj/items/synth/ait_pda.dmi'
	name = "T411 AIDT"
	desc = "Artifical Intelligence Diagnostic Tablet model T411. Built to withstand a nuclear bomb."
	icon_state = "karnak_off"
	unacidable = TRUE
	indestructible = TRUE
	req_access = list(ACCESS_ARES_DEBUG)

	/// The ID used to link all devices.
	var/datum/ares_link/link
	/// The datacore storing all the information.
	var/datum/ares_datacore/datacore

	var/current_menu = "login"
	var/last_menu = "off"

	var/authentication = APOLLO_ACCESS_LOGOUT
	/// The last person to login.
	var/logged_in
	/// A record of who logged in and when.
	var/list/access_list = list()
	var/list/deleted_1to1 = list()

/obj/item/device/ai_tech_pda/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link)
		new_link.ticket_computers += src
		link = new_link
		new_link.linked_systems += src
	if(!datacore)
		datacore = GLOB.ares_datacore
	return TRUE

/obj/item/device/ai_tech_pda/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/item/device/ai_tech_pda/proc/delink()
	if(link)
		link.ticket_computers -= src
		link.linked_systems -= src
		link = null
	datacore = null

/obj/item/device/ai_tech_pda/Destroy()
	delink()
	return ..()

/obj/item/device/ai_tech_pda/update_icon()
	. = ..()
	if(last_menu == "off")
		icon_state = "karnak_off"
	else if(current_menu == "login")
		icon_state = "karnak_login_anim"
	else
		icon_state = "karnak_on_anim"

/obj/item/device/ai_tech_pda/attack_self(mob/living/carbon/human/user)
	if(..() || !allowed(user))
		to_chat(user, SPAN_WARNING("Access Denied!"))
		return FALSE

	if((last_menu == "off") && (current_menu == "login"))
		last_menu = "main"
		update_icon()

	tgui_interact(user)
	return TRUE

/obj/item/device/ai_tech_pda/tgui_interact(mob/user, datum/tgui/ui)
	if(!link.interface || !datacore)
		to_chat(user, SPAN_WARNING("ARES DATA LINK FAILED"))
		return FALSE
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AresAdmin", name)
		ui.open()

/obj/item/device/ai_tech_pda/ui_data(mob/user)
	if(!link.interface)
		to_chat(user, SPAN_WARNING("ARES ADMIN DATA LINK FAILED"))
		return FALSE
	var/list/data = list()

	data["is_pda"] = TRUE

	data["admin_login"] = "[logged_in], AI Service Technician"
	data["admin_access_log"] = access_list

	data["current_menu"] = current_menu
	data["last_page"] = last_menu

	data["logged_in"] = link.interface.last_login
	data["sudo"] = link.interface.sudo_holder ? TRUE : FALSE

	data["access_text"] = "[link.interface.sudo_holder ? "(SUDO)," : ""] access level [link.interface.authentication], [link.interface.ares_auth_to_text(link.interface.authentication)]."
	data["access_level"] = link.interface.authentication

	data["alert_level"] = GLOB.security_level
	data["evac_status"] = SShijack.evac_status
	data["worldtime"] = world.time

	data["access_log"] = datacore.interface_access_list
	data["apollo_log"] = datacore.apollo_log

	data["deleted_conversation"] = deleted_1to1

	data["distresstime"] = datacore.ares_distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["mission_failed"] = SSticker.mode.is_in_endgame
	data["nuketimelock"] = NUCLEAR_TIME_LOCK
	data["nuke_available"] = datacore.nuke_available

	var/list/logged_announcements = list()
	for(var/datum/ares_record/announcement/broadcast as anything in datacore.records_announcement)
		var/list/current_broadcast = list()
		current_broadcast["time"] = broadcast.time
		current_broadcast["title"] = broadcast.title
		current_broadcast["details"] = broadcast.details
		current_broadcast["ref"] = "\ref[broadcast]"
		logged_announcements += list(current_broadcast)
	data["records_announcement"] = logged_announcements

	var/list/logged_alerts = list()
	for(var/datum/ares_record/security/security_alert as anything in datacore.records_security)
		var/list/current_alert = list()
		current_alert["time"] = security_alert.time
		current_alert["title"] = security_alert.title
		current_alert["details"] = security_alert.details
		current_alert["ref"] = "\ref[security_alert]"
		logged_alerts += list(current_alert)
	data["records_security"] = logged_alerts

	var/list/logged_flights = list()
	for(var/datum/ares_record/flight/flight_log as anything in datacore.records_flight)
		var/list/current_flight = list()
		current_flight["time"] = flight_log.time
		current_flight["title"] = flight_log.title
		current_flight["details"] = flight_log.details
		current_flight["user"] = flight_log.user
		current_flight["ref"] = "\ref[flight_log]"
		logged_flights += list(current_flight)
	data["records_flight"] = logged_flights

	var/list/logged_bioscans = list()
	for(var/datum/ares_record/bioscan/scan as anything in datacore.records_bioscan)
		var/list/current_scan = list()
		current_scan["time"] = scan.time
		current_scan["title"] = scan.title
		current_scan["details"] = scan.details
		current_scan["ref"] = "\ref[scan]"
		logged_bioscans += list(current_scan)
	data["records_bioscan"] = logged_bioscans

	var/list/logged_bombs = list()
	for(var/datum/ares_record/bombardment/bomb as anything in datacore.records_bombardment)
		var/list/current_bomb = list()
		current_bomb["time"] = bomb.time
		current_bomb["title"] = bomb.title
		current_bomb["details"] = bomb.details
		current_bomb["user"] = bomb.user
		current_bomb["ref"] = "\ref[bomb]"
		logged_bombs += list(current_bomb)
	data["records_bombardment"] = logged_bombs

	var/list/logged_deletes = list()
	for(var/datum/ares_record/deletion/deleted as anything in datacore.records_deletion)
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
	for(var/datum/ares_record/deleted_talk/deleted_convo as anything in datacore.records_deletion)
		if(!istype(deleted_convo))
			continue
		var/list/deleted_disc = list()
		deleted_disc["time"] = deleted_convo.time
		deleted_disc["title"] = deleted_convo.title
		deleted_disc["ref"] = "\ref[deleted_convo]"
		logged_discussions += list(deleted_disc)
	data["deleted_discussions"] = logged_discussions

	var/list/logged_orders = list()
	for(var/datum/ares_record/requisition_log/req_order as anything in datacore.records_asrs)
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

	var/list/logged_techs = list()
	for(var/datum/ares_record/tech/tech_unlock as anything in datacore.records_tech)
		var/list/current_tech = list()
		current_tech["time"] = tech_unlock.time
		current_tech["details"] = tech_unlock.details
		current_tech["user"] = tech_unlock.user
		current_tech["tier_changer"] = tech_unlock.is_tier
		current_tech["ref"] = "\ref[tech_unlock]"
		logged_techs += list(current_tech)
	data["records_tech"] = logged_techs

	var/list/logged_convos = list()
	var/list/active_convo = list()
	var/active_ref
	for(var/datum/ares_record/talk_log/log as anything in datacore.records_talking)
		if(!istype(log))
			continue
		if(log.user == link.interface.last_login)
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
	data["access_tickets"] = logged_access

	data["security_vents"] = link.get_ares_vents()
	data["sentry_setting"] = link.faction_label
	data["faction_options"] = link.faction_options

	return data

/obj/item/device/ai_tech_pda/ui_close(mob/user)
	. = ..()
	current_menu = "login"
	last_menu = "off"
	if(logged_in)
		access_list += "[logged_in] logged out at [worldtime2text()]."
		logged_in = null
	update_icon()

/obj/item/device/ai_tech_pda/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/user = ui.user
	var/playsound = TRUE

	switch(action)
		if("go_back")
			if(!last_menu)
				return to_chat(user, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")
			var/obj/item/card/id/card = user.wear_id
			if(!card || !card.check_biometrics(user))
				to_chat(user, SPAN_WARNING("You require an authenticated ID card to access this device!"))
				playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)
				return FALSE
			logged_in = user.real_name
			access_list += "[logged_in] at [worldtime2text()]."
			current_menu = "main"

		if("sudo")
			var/new_user = tgui_input_text(user, "Enter Sudo Username", "Sudo User", encode = FALSE)
			if(new_user)
				if(new_user == link.interface.sudo_holder)
					link.interface.last_login = link.interface.sudo_holder
					link.interface.sudo_holder = null
					return FALSE
				if(new_user == link.interface.last_login)
					to_chat(user, SPAN_WARNING("Already remote logged in as this user."))
					playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
					return FALSE
				link.interface.sudo_holder = link.interface.last_login
				link.interface.last_login = new_user
				datacore.interface_access_list += "[link.interface.last_login] at [worldtime2text()], Sudo Access."
				return TRUE
		if("sudo_logout")
			datacore.interface_access_list += "[link.interface.last_login] at [worldtime2text()], Sudo Logout."
			link.interface.last_login = link.interface.sudo_holder
			link.interface.sudo_holder = null
			return

		// -- Page Changers -- //
		if("logout")
			current_menu = "login"
			last_menu = "login"
			access_list += "[logged_in] logged out at [worldtime2text()]."
			logged_in = null

		if("home")
			last_menu = current_menu
			current_menu = "main"
		if("page_1to1")
			last_menu = current_menu
			current_menu = "talking"
		if("page_announcements")
			last_menu = current_menu
			current_menu = "announcements"
		if("page_bioscans")
			last_menu = current_menu
			current_menu = "bioscans"
		if("page_bombardments")
			last_menu = current_menu
			current_menu = "bombardments"
		if("page_apollo")
			last_menu = current_menu
			current_menu = "apollo"
		if("page_access")
			last_menu = current_menu
			current_menu = "access_log"
		if("page_admin_list")
			last_menu = current_menu
			current_menu = "admin_access_log"
		if("page_security")
			last_menu = current_menu
			current_menu = "security"
		if("page_requisitions")
			last_menu = current_menu
			current_menu = "requisitions"
		if("page_flight")
			last_menu = current_menu
			current_menu = "flight_log"
		if("page_emergency")
			last_menu = current_menu
			current_menu = "emergency"
		if("page_deleted")
			last_menu = current_menu
			current_menu = "delete_log"
		if("page_deleted_1to1")
			last_menu = current_menu
			current_menu = "deleted_talks"
		if("page_tech")
			last_menu = current_menu
			current_menu = "tech_log"
		if("page_core_sec")
			last_menu = current_menu
			current_menu = "core_security"
		if("page_access_management")
			last_menu = current_menu
			current_menu = "access_management"
		if("page_maint_management")
			last_menu = current_menu
			current_menu = "maintenance_management"

		// -- 1:1 Conversation -- //
		if("new_conversation")
			if(link.interface.last_login == "No User")
				return FALSE
			var/datum/ares_record/talk_log/convo = new(link.interface.last_login)
			convo.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], 'New 1:1 link initiated. Greetings, [link.interface.last_login].'"
			datacore.records_talking += convo

		if("clear_conversation")
			var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
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
				link.interface.message_ares(message, user, params["active_convo"], TRUE)
		if("ares_reply")
			var/message = tgui_input_text(user, "What do you wish to reply with?", "ARES Response", encode = FALSE)
			if(message)
				link.interface.response_from_ares(message, params["active_convo"])
				var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
				var/admin_log = SPAN_STAFF_IC("<b>ADMINS/MODS: [SPAN_RED("[key_name(user)] replied to [conversation.user]'s ARES message")] [SPAN_GREEN("via [src]")] with: [SPAN_BLUE(message)] </b>")
				for(var/client/admin in GLOB.admins)
					if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
						to_chat(admin, admin_log)

		if("read_record")
			var/datum/ares_record/deleted_talk/conversation = locate(params["record"])
			deleted_1to1 = conversation.conversation
			last_menu = current_menu
			current_menu = "read_deleted"

		if("claim_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			var/claim = TRUE
			var/assigned = ticket.ticket_assignee
			if(assigned)
				if(assigned == logged_in)
					var/prompt = tgui_alert(user, "You already claimed this ticket! Do you wish to drop your claim?", "Unclaim ticket", list("Yes", "No"))
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
				ticket.ticket_assignee = logged_in
				ticket.ticket_status = TICKET_ASSIGNED
			return claim

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
				identification.handle_ares_access(logged_in, user)
				access_ticket.ticket_status = TICKET_GRANTED
				playsound(src, 'sound/machines/chime.ogg', 15, TRUE)
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] granted core access.")
				return TRUE
			for(var/obj/item/card/id/identification in link.active_ids)
				if(!istype(identification))
					continue
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(logged_in, user)
				access_ticket.ticket_status = TICKET_REVOKED
				playsound(src, 'sound/machines/chime.ogg', 15, TRUE)
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
				var/datum/ares_ticket/maintenance/maint_ticket = new("[logged_in] (AIST)", maint_type, details, priority_report)
				link.tickets_maintenance += maint_ticket
				if(priority_report)
					ares_apollo_talk("Priority Maintenance Report: [maint_type] - ID [maint_ticket.ticket_id]. Seek and resolve.")
				log_game("ARES: Maintenance Ticket '\ref[maint_ticket]' created by [key_name(user)] as AI-ST with Category '[maint_type]' and Details of '[details]'.")
				return TRUE
			return FALSE

		if("cancel_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
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
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been [choice] by AI-ST [logged_in].")
			to_chat(user, SPAN_NOTICE("[ticket.ticket_type] [ticket.ticket_id] marked as [choice]."))
			return TRUE

		if("delete_record")
			playsound = FALSE
			var/datum/ares_record/record = locate(params["record"])
			if(record.record_name == ARES_RECORD_DELETED)
				return FALSE
			var/datum/ares_record/deletion/new_delete = new
			var/new_details = "Error"
			var/new_title = "Error"
			switch(record.record_name)
				if(ARES_RECORD_ANNOUNCE)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					datacore.records_announcement -= record
				if(ARES_RECORD_SECURITY, ARES_RECORD_ANTIAIR)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					datacore.records_security -= record
				if(ARES_RECORD_BIOSCAN)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					datacore.records_bioscan -= record
				if(ARES_RECORD_BOMB)
					new_title = "[record.title] at [record.time]"
					new_details = "[record.details] Launched by [record.user]."
					datacore.records_bombardment -= record
				if(ARES_RECORD_TECH)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					datacore.records_tech -= record
				if(ARES_RECORD_FLIGHT)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					datacore.records_flight -= record

			new_delete.details = new_details
			new_delete.user = "[logged_in] (AIST)"
			new_delete.title = new_title

			datacore.records_deletion += new_delete
			playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)

		if("general_quarters")
			if(!COOLDOWN_FINISHED(datacore, ares_quarters_cooldown))
				to_chat(user, SPAN_WARNING("It has not been long enough since the last General Quarters call!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(GLOB.security_level < SEC_LEVEL_RED)
				set_security_level(SEC_LEVEL_RED, no_sound = TRUE, announce = FALSE)
			shipwide_ai_announcement("ATTENTION! GENERAL QUARTERS. ALL HANDS, MAN YOUR BATTLESTATIONS.", MAIN_AI_SYSTEM, 'sound/effects/GQfullcall.ogg')
			log_game("[key_name(user)] has called for general quarters via ARES.")
			message_admins("[key_name_admin(user)] has called for general quarters via ARES.")
			log_ares_security("General Quarters", "[logged_in] has called for general quarters via ARES.")
			COOLDOWN_START(datacore, ares_quarters_cooldown, 10 MINUTES)
			. = TRUE

		if("evacuation_start")
			if(GLOB.security_level < SEC_LEVEL_RED)
				to_chat(user, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			if(SShijack.evac_admin_denied)
				to_chat(user, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			if(!SShijack.initiate_evacuation())
				to_chat(user, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			log_game("[key_name(user)] has called for an emergency evacuation via ARES.")
			message_admins("[key_name_admin(user)] has called for an emergency evacuation via ARES.")
			log_ares_security("Initiate Evacuation", "[logged_in] has called for an emergency evacuation via ARES.")
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?
			if(world.time < DISTRESS_TIME_LOCK)
				to_chat(user, SPAN_WARNING("You have been here for less than six minutes... what could you possibly have done!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(!COOLDOWN_FINISHED(datacore, ares_distress_cooldown))
				to_chat(user, SPAN_WARNING("The distress launcher is cooling down!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(GLOB.security_level == SEC_LEVEL_DELTA)
				to_chat(user, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(GLOB.security_level < SEC_LEVEL_RED)
				to_chat(user, SPAN_WARNING("The ship must be under red alert to launch a distress beacon!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			for(var/client/admin in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
					playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
			SSticker.mode.request_ert(user, TRUE)
			to_chat(user, SPAN_NOTICE("A distress beacon request has been sent to USCM High Command."))
			COOLDOWN_START(datacore, ares_distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

		if("nuclearbomb")
			if(!SSticker.mode)
				return FALSE //Not a game mode?
			if(world.time < NUCLEAR_TIME_LOCK)
				to_chat(user, SPAN_WARNING("It is too soon to request Nuclear Ordnance!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(!COOLDOWN_FINISHED(datacore, ares_nuclear_cooldown))
				to_chat(user, SPAN_WARNING("The ordnance request frequency is garbled, wait for reset!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(GLOB.security_level == SEC_LEVEL_DELTA || SSticker.mode.is_in_endgame)
				to_chat(user, SPAN_WARNING("The mission has failed catastrophically, what do you want a nuke for?!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			var/reason = tgui_input_text(user, "Please enter reason nuclear ordnance is required.", "Reason for Nuclear Ordnance")
			if(!reason)
				return FALSE
			for(var/client/admin in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
					playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
			message_admins("[key_name(user)] has requested use of Nuclear Ordnance (via ARES)! Reason: <b>[reason]</b> [CC_MARK(user)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];nukeapprove=\ref[user]'>APPROVE</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];nukedeny=\ref[user]'>DENY</A>) [ADMIN_JMP_USER(user)] [CC_REPLY(user)]")
			to_chat(user, SPAN_NOTICE("A nuclear ordnance request has been sent to USCM High Command for the following reason: [reason]"))
			log_ares_security("Nuclear Ordnance Request", "[logged_in] has sent a request for nuclear ordnance for the following reason: [reason]")
			if(ares_can_interface())
				ai_silent_announcement("[logged_in] has sent a request for nuclear ordnance to USCM High Command.", ".V")
				ai_silent_announcement("Reason given: [reason].", ".V")
			COOLDOWN_START(datacore, ares_nuclear_cooldown, COOLDOWN_COMM_DESTRUCT)
			return TRUE

		if("bioscan")
			if(!SSticker.mode)
				return FALSE //Not a game mode?
			if(world.time < FORCE_SCAN_LOCK)
				to_chat(user, SPAN_WARNING("Bio sensors are not yet ready to initiate a scan!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(!(COOLDOWN_FINISHED(datacore, ares_bioscan_cooldown)) || (world.time < (GLOB.last_human_bioscan + COOLDOWN_FORCE_SCAN)))
				to_chat(user, SPAN_WARNING("It is too soon since the last scan, wait for the sensor array to reset!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			GLOB.bioscan_data.ares_bioscan(FALSE, 2)
			COOLDOWN_START(datacore, ares_bioscan_cooldown, COOLDOWN_FORCE_SCAN)
			playsound(src, 'sound/machines/terminal_processing.ogg', 15, 1)
			message_admins("BIOSCAN: [key_name(user)] triggered a Marine bioscan via ARES AIST.")
			return TRUE

		if("trigger_vent")
			playsound = FALSE
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
			log_ares_security("Nerve Gas Release", "[MAIN_AI_SYSTEM] released Nerve Gas from Vent '[sec_vent.vent_tag]'.")
			sec_vent.create_gas(VENT_GAS_CN20_XENO, 6, 5 SECONDS)
			log_admin("[key_name(user)] released nerve gas from Vent '[sec_vent.vent_tag]' via ARES.")

		if("security_lockdown")
			if(!COOLDOWN_FINISHED(datacore, aicore_lockdown))
				to_chat(user, SPAN_BOLDWARNING("AI Core Lockdown procedures are on cooldown! They will be ready in [COOLDOWN_SECONDSLEFT(datacore, aicore_lockdown)] seconds!"))
				return FALSE
			aicore_lockdown(user)
			return TRUE

		if("update_sentries")
			playsound = FALSE
			var/new_iff = params["chosen_iff"]
			if(!new_iff)
				to_chat(user, SPAN_WARNING("ERROR: Unknown setting."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(new_iff == link.faction_label)
				return FALSE
			link.change_iff(new_iff)
			playsound(src, 'sound/machines/chime.ogg', 15, 1)
			message_admins("ARES: [key_name(user)] updated ARES Sentry IFF to [new_iff].")
			to_chat(user, SPAN_WARNING("Sentry IFF settings updated!"))
			return TRUE

	if(playsound)
		var/sound = pick('sound/machines/pda_button1.ogg', 'sound/machines/pda_button2.ogg')
		playsound(src, sound, 15, TRUE)

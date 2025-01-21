/obj/item/device/ai_tech_pda
	icon = 'icons/obj/items/synth/ait_pda.dmi'
	name = "T411 AIDT"
	desc = "Artifical Intelligence Diagnostic Tablet model T411. Built to withstand a nuclear bomb."
	icon_state = "karnak_off"
	unacidable = TRUE
	explo_proof = TRUE
	req_one_access = list(ACCESS_ARES_DEBUG, ACCESS_MARINE_AI)

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

	/// Notification sound
	var/notify_sounds = TRUE
	COOLDOWN_DECLARE(printer_cooldown)
	var/access_code = 0
	var/set_ui = "AresAccessCode"

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

/obj/item/device/ai_tech_pda/verb/enter_code()
	set name = "Enter Access Code"
	set desc = "Enter an access code. Duh."
	set category = "Object.AIDT"
	set src in usr

	if(access_code)
		to_chat(usr, SPAN_WARNING("An access code has already been entered!"))
		playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)
		return FALSE
	var/mob/living/carbon/user = usr
	playsound(src, 'sound/machines/terminal_prompt.ogg', 15, TRUE)
	var/new_access_code = tgui_input_text(user, "Please enter a data access code.", "Access Code", "00000", 7, timeout = 20 SECONDS)
	if(!new_access_code)
		to_chat(usr, SPAN_WARNING("Error: No input detected!"))
		playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)
		return FALSE
	access_code = new_access_code
	playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 15, TRUE)
	to_chat(usr, SPAN_HELPFUL("New access code detected. Please reload your device."))

/obj/item/device/ai_tech_pda/verb/clear_code()
	set name = "Clear Access Code"
	set desc = "Take a guess."
	set category = "Object.AIDT"
	set src in usr

	var/mob/living/carbon/human/user
	if(ishuman(usr))
		user = usr
	else
		return FALSE

	if(!access_code)
		to_chat(user, SPAN_WARNING("You can't clear an already cleared code..."))
		return FALSE

	var/obj/item/card/id/card = user.wear_id
	if(!card || !card.check_biometrics(user))
		to_chat(user, SPAN_WARNING("You require an authenticated ID card to access this device!"))
		playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)
		return FALSE
	access_code = 0
	last_menu = "off"
	current_menu = "login"

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
	if(access_code == GLOB.ares_link.code_apollo)
		set_ui = "WorkingJoe"
	else if(access_code == GLOB.ares_link.code_interface)
		set_ui = "AresInterface"
	else if((access_code == GLOB.ares_link.code_debug) && (check_debug_login(user)))
		set_ui = "AresAdmin"
	else
		access_code = 0
		set_ui = "AresAccessCode"
	if(!ui)
		ui = new(user, src, set_ui, name)
		ui.open()

/obj/item/device/ai_tech_pda/proc/check_debug_login(mob/user)
	var/mob/living/carbon/human/human_user = user
	if(!ishuman(human_user))
		return FALSE
	var/failed = FALSE
	var/obj/item/card/id/idcard = human_user.get_active_hand()
	if(!istype(idcard))
		if(human_user.wear_id)
			idcard = human_user.wear_id
			if(!istype(idcard))
				failed = TRUE
	if(!idcard?.check_biometrics(human_user) || !(ACCESS_ARES_DEBUG in idcard?.access))
		failed = TRUE
	if(failed)
		to_chat(human_user, SPAN_WARNING("You require an authenticated ID card to access this device!"))
		playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)
		return FALSE
	return TRUE

/obj/item/device/ai_tech_pda/ui_close(mob/user)
	. = ..()
	if(set_ui == "AresAdmin")
		access_list += "[logged_in] logged out at [worldtime2text()]."
		logged_in = null
		authentication = 0
		current_menu = "login"
		last_menu = "off"
	update_icon()

/obj/item/device/ai_tech_pda/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/user = ui.user
	var/playsound = TRUE

	if(set_ui == "AresAdmin" && !check_security(user))
		return FALSE

	switch(action)
		if("go_back")
			if(!last_menu)
				return to_chat(user, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")
			var/failed = FALSE
			var/obj/item/card/id/idcard = user.get_active_hand()
			if(!istype(idcard))
				if(user.wear_id)
					idcard = user.wear_id
					if(!istype(idcard))
						failed = TRUE
			if(!idcard.check_biometrics(user))
				failed = TRUE
			if(failed)
				to_chat(user, SPAN_WARNING("You require an authenticated ID card to access this device!"))
				playsound(src, 'sound/machines/terminal_error.ogg', 15, TRUE)
				return FALSE

			switch(set_ui)
				if("AresInterface", "AresAdmin")
					authentication = get_ares_access(idcard)
				if("WorkingJoe")
					authentication = get_apollo_access(idcard)

			if(authentication)
				logged_in = idcard.registered_name
				access_list += "[logged_in] at [worldtime2text()]."
				current_menu = "main"

		if("sudo")
			if(!check_security(user) || set_ui == "AresAdmin")
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
			var/message = tgui_input_text(user, "What do you wish to say to ARES?", "ARES Message", encode = FALSE)
			if(message)
				link.interface.message_ares(message, user, params["active_convo"], TRUE)
		if("ares_reply")
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
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
			if(!check_security(user))
				return FALSE
			if(!COOLDOWN_FINISHED(datacore, aicore_lockdown))
				to_chat(user, SPAN_BOLDWARNING("AI Core Lockdown procedures are on cooldown! They will be ready in [COOLDOWN_SECONDSLEFT(datacore, aicore_lockdown)] seconds!"))
				return FALSE
			aicore_lockdown(user)
			return TRUE

		if("update_sentries")
			if(!check_security(user))
				return FALSE
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

		if("print_req")
			playsound = FALSE
			if(!COOLDOWN_FINISHED(src, printer_cooldown))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(!length(datacore.records_asrs))
				to_chat(user, SPAN_WARNING("There are no records to print!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			COOLDOWN_START(src, printer_cooldown, 20 SECONDS)
			playsound(src, 'sound/machines/fax.ogg', 15, 1)
			sleep(3.4 SECONDS)
			var/contents = {"
						<style>
							#container { width: 500px; min-height: 500px; margin: 25px auto;  \
									font-family: monospace; padding: 0; font-size: 130% }  \
							#title { font-size: 250%; letter-spacing: 8px; \
									font-weight: bolder; margin: 20px auto }   \
							.header { font-size: 130%; text-align: center; }   \
							.important { font-variant: small-caps; font-size = 130%;   \
										font-weight: bolder; }    \
							.tablelabel { width: 150px; }  \
							.field { font-style: italic; } \
							table { table-layout: fixed }  \
						</style><div id='container'>   \
						<div class='header'>   \
							<p id='title' class='important'>A.S.R.S.</p>   \
							<p class='important'>Automatic Storage Retrieval System</p>    \
							<p class='field'>Audit Log</p> \
						</div><hr>
						<u>Printed By:</u> [logged_in]<br>
						<u>Print Time:</u> [worldtime2text()]<br>
						<hr>
						<center>
						<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>
						<thead>
							<tr>
							<th scope="col">Time</th>
							<th scope="col">User</th>
							<th scope="col">Source</th>
							<th scope="col">Order</th>
							</tr>
						</thead>
						<tbody>
						"}

			for(var/datum/ares_record/requisition_log/req_order as anything in datacore.records_asrs)

				contents += {"
							<tr>
							<th scope="row">[req_order.time]</th>
							<td>[req_order.user]</td>
							<td>[req_order.title]</td>
							<td>[req_order.details]</td>
							</tr>
							"}

			contents += "</center></tbody></table>"

			var/location = get_turf(loc)
			var/obj/item/paper/log = new(location)
			log.name = "ASRS Audit Log"
			log.info += contents
			log.icon_state = "paper_uscm_words"
			visible_message(SPAN_NOTICE("[src] prints out a paper."))

		if("enter_code")
			enter_code()
			return

		if("page_logins")
			last_menu = current_menu
			current_menu = "login_records"
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
		if("page_core_gas")
			last_menu = current_menu
			current_menu = "core_security_gas"

	if(playsound)
		var/sound = pick('sound/machines/pda_button1.ogg', 'sound/machines/pda_button2.ogg')
		playsound(src, sound, 15, TRUE)

/obj/item/device/ai_tech_pda/proc/check_security(mob/living/carbon/human/user)
	if(logged_in && (user.real_name != logged_in))
		playsound(src, 'sound/machines/lockdownalarm.ogg', 15, TRUE)
		audible_message(SPAN_ALERTWARNING("[src] blares a security alarm."))

		current_menu = "login"
		last_menu = "off"
		logged_in = null
		authentication = 0
		access_code = 0

		if(set_ui == "AresAdmin")
			set_ui = "AresAccessCode"

		var/message1 = "ATTENTION! CORE SECURITY ALERT! UNAUTHORIZED USE OF DIAGNOSTIC TABLET DETECTED!"
		var/message2 = "ASSOCIATED FINGERPRINT: [user.real_name]. ASSOCIATED LOCATION: [get_area_name(user)]."

		ares_apollo_talk(message1)
		ares_apollo_talk(message2)
		ai_silent_announcement(message1, ":p")
		ai_silent_announcement(message2, ":p")
		return FALSE
	return TRUE

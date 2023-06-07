GLOBAL_DATUM_INIT(ares_link, /datum/ares_link, new)

/datum/ares_link
	var/link_id = MAIN_SHIP_DEFAULT_NAME
	/// All motion triggers for the link
	var/list/linked_alerts = list()
	/// All machinery for the link
	var/list/linked_systems = list()
	var/obj/structure/machinery/ares/processor/interface/p_interface
	var/obj/structure/machinery/ares/processor/apollo/p_apollo
	var/obj/structure/machinery/ares/processor/bioscan/p_bioscan
	var/obj/structure/machinery/computer/ares_console/interface

/datum/ares_link/Destroy()
	for(var/obj/structure/machinery/ares/link in linked_systems)
		link.delink()
	for(var/obj/structure/machinery/computer/ares_console/interface in linked_systems)
		interface.delink()
	for(var/obj/effect/step_trigger/ares_alert/alert in linked_alerts)
		alert.delink()
	..()

/obj/structure/machinery/computer/ares_console/proc/get_ares_access(obj/item/card/id/card)
	if(ACCESS_ARES_DEBUG in card.access)
		return ARES_ACCESS_DEBUG
	switch(card.assignment)
		if(JOB_WORKING_JOE)
			return ARES_ACCESS_JOE
		if(JOB_CHIEF_ENGINEER)
			return ARES_ACCESS_CE
		if(JOB_SYNTH)
			return ARES_ACCESS_SYNTH
	if(card.paygrade in GLOB.wy_paygrades)
		return ARES_ACCESS_WY_COMMAND
	if(card.paygrade in GLOB.highcom_paygrades)
		return ARES_ACCESS_HIGH
	if(card.paygrade in GLOB.co_paygrades)
		return ARES_ACCESS_CO
	if(ACCESS_MARINE_SENIOR in card.access)
		return ARES_ACCESS_SENIOR
	if(ACCESS_WY_CORPORATE in card.access)
		return ARES_ACCESS_CORPORATE
	if(ACCESS_MARINE_COMMAND in card.access)
		return ARES_ACCESS_COMMAND
	else
		return ARES_ACCESS_BASIC

/obj/structure/machinery/computer/ares_console/proc/auth_to_text(access_level)
	switch(access_level)
		if(ARES_ACCESS_BASIC)//0
			return "Authorized"
		if(ARES_ACCESS_COMMAND)//1
			return "[MAIN_SHIP_NAME] Command"
		if(ARES_ACCESS_JOE)//2
			return "Working Joe"
		if(ARES_ACCESS_CORPORATE)//3
			return "Weyland-Yutani"
		if(ARES_ACCESS_SENIOR)//4
			return "[MAIN_SHIP_NAME] Senior Command"
		if(ARES_ACCESS_CE)//5
			return "Chief Engineer"
		if(ARES_ACCESS_SYNTH)//6
			return "USCM Synthetic"
		if(ARES_ACCESS_CO)//7
			return "[MAIN_SHIP_NAME] Commanding Officer"
		if(ARES_ACCESS_HIGH)//8
			return "USCM High Command"
		if(ARES_ACCESS_WY_COMMAND)//9
			return "Weyland-Yutani Directorate"
		if(ARES_ACCESS_DEBUG)//10
			return "AI Service Technician"


// ----- ARES Logging Procs ----- //
/proc/log_ares_apollo(speaker, message)
	if(!speaker)
		speaker = "Unknown"
	var/datum/ares_link/link = GLOB.ares_link
	if(!link.p_apollo || link.p_apollo.inoperable())
		return
	if(!link.p_interface || link.p_interface.inoperable())
		return
	if(!link.interface || link.interface.inoperable())
		return
	else
		link.interface.apollo_log.Add("[worldtime2text()]: [speaker], '[message]'")

/datum/ares_link/proc/log_ares_bioscan(title, input)
	if(!p_bioscan || p_bioscan.inoperable() || !interface)
		return FALSE
	interface.records_bioscan.Add(new /datum/ares_record/bioscan(title, input))

/datum/ares_link/proc/log_ares_bombardment(mob/living/user, ob_name, coordinates)
	interface.records_bombardment.Add(new /datum/ares_record/bombardment(ob_name, "Bombardment fired at [coordinates].", user))

/datum/ares_link/proc/log_ares_announcement(title, message)
	interface.records_announcement.Add(new /datum/ares_record/announcement(title, message))

/datum/ares_link/proc/log_ares_antiair(mob/living/user, details)
	interface.records_security.Add(new /datum/ares_record/antiair(details, user))

/datum/ares_link/proc/log_ares_requisition(source, details, mob/living/user)
	interface.records_asrs.Add(new /datum/ares_record/requisition_log(source, details, user))

/datum/ares_link/proc/log_ares_security(title, details)
	interface.records_security.Add(new /datum/ares_record/security(title, details))

/obj/structure/machinery/computer/ares_console/proc/message_ares(text, mob/Sender, ref)
	var/msg = SPAN_STAFF_IC("<b><font color=orange>ARES:</font> [key_name(Sender, 1)] [ARES_MARK(Sender)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] [ADMIN_JMP_USER(Sender)] [ARES_REPLY(Sender, ref)]:</b> [text]")
	var/datum/ares_record/talk_log/conversation = locate(ref)
	conversation.conversation += "[last_login] at [worldtime2text()], '[text]'"
	for(var/client/admin in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
			to_chat(admin, msg)
			if(admin.prefs.toggles_sound & SOUND_ARES_MESSAGE)
				playsound_client(admin, 'sound/machines/chime.ogg', vol = 25)

/obj/structure/machinery/computer/ares_console/proc/response_from_ares(text, ref)
	var/datum/ares_record/talk_log/conversation = locate(ref)
	conversation.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], '[text]'"

// ------ ARES Interface UI ------ //

/obj/structure/machinery/computer/ares_console/attack_hand(mob/user as mob)
	if(..() || !allowed(usr) || inoperable())
		return FALSE

	tgui_interact(user)
	return TRUE

/obj/structure/machinery/computer/ares_console/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AresInterface", name)
		ui.open()

/obj/structure/machinery/computer/ares_console/ui_data(mob/user)
	var/list/data = list()

	data["current_menu"] = current_menu
	data["last_page"] = last_menu

	data["logged_in"] = last_login
	var/sudo_state = FALSE
	if(sudo_holder)
		sudo_state = TRUE
	data["sudo"] = sudo_state

	data["access_text"] = "[sudo_holder ? "(SUDO)," : ""] access level [authentication], [auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = security_level
	data["evac_status"] = EvacuationAuthority.evac_status
	data["worldtime"] = world.time

	data["access_log"] = list()
	data["access_log"] += access_list
	data["apollo_log"] = list()
	data["apollo_log"] += apollo_log

	data["deleted_conversation"] = list()
	data["deleted_conversation"] += deleted_1to1

	data["distresstime"] = ares_distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["mission_failed"] = SSticker.mode.is_in_endgame
	data["nuketimelock"] = NUCLEAR_TIME_LOCK
	data["nuke_available"] = nuke_available

	var/list/logged_announcements = list()
	for(var/datum/ares_record/announcement/broadcast as anything in records_announcement)
		var/list/current_broadcast = list()
		current_broadcast["time"] = broadcast.time
		current_broadcast["title"] = broadcast.title
		current_broadcast["details"] = broadcast.details
		current_broadcast["ref"] = "\ref[broadcast]"
		logged_announcements += list(current_broadcast)
	data["records_announcement"] = logged_announcements

	var/list/logged_alerts = list()
	for(var/datum/ares_record/security/security_alert as anything in records_announcement)
		if(!istype(security_alert))
			continue
		var/list/current_alert = list()
		current_alert["time"] = security_alert.time
		current_alert["title"] = security_alert.title
		current_alert["details"] = security_alert.details
		current_alert["ref"] = "\ref[security_alert]"
		logged_alerts += list(current_alert)
	data["records_security"] = logged_alerts

	var/list/logged_bioscans = list()
	for(var/datum/ares_record/bioscan/scan as anything in records_bioscan)
		var/list/current_scan = list()
		current_scan["time"] = scan.time
		current_scan["title"] = scan.title
		current_scan["details"] = scan.details
		current_scan["ref"] = "\ref[scan]"
		logged_bioscans += list(current_scan)
	data["records_bioscan"] = logged_bioscans

	var/list/logged_bombs = list()
	for(var/datum/ares_record/bombardment/bomb as anything in records_bombardment)
		var/list/current_bomb = list()
		current_bomb["time"] = bomb.time
		current_bomb["title"] = bomb.title
		current_bomb["details"] = bomb.details
		current_bomb["user"] = bomb.user
		current_bomb["ref"] = "\ref[bomb]"
		logged_bombs += list(current_bomb)
	data["records_bombardment"] = logged_bombs

	var/list/logged_deletes = list()
	for(var/datum/ares_record/deletion/deleted as anything in records_deletion)
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
	for(var/datum/ares_record/deleted_talk/deleted_convo as anything in records_deletion)
		if(!istype(deleted_convo))
			continue
		var/list/deleted_disc = list()
		deleted_disc["time"] = deleted_convo.time
		deleted_disc["title"] = deleted_convo.title
		deleted_disc["ref"] = "\ref[deleted_convo]"
		logged_discussions += list(deleted_disc)
	data["deleted_discussions"] = logged_discussions

	var/list/logged_adjustments = list()
	for(var/datum/ares_record/antiair/aa_adjustment as anything in records_security)
		if(!istype(aa_adjustment))
			continue
		var/list/current_adjustment = list()
		current_adjustment["time"] = aa_adjustment.time
		current_adjustment["details"] = aa_adjustment.details
		current_adjustment["user"] = aa_adjustment.user
		current_adjustment["ref"] = "\ref[aa_adjustment]"
		logged_adjustments += list(current_adjustment)
	data["aa_adjustments"] = logged_adjustments

	var/list/logged_orders = list()
	for(var/datum/ares_record/requisition_log/req_order as anything in records_asrs)
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
	for(var/datum/ares_record/talk_log/log as anything in records_talking)
		if(!istype(log))
			continue
		if(log.user == last_login)
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

	return data

/obj/structure/machinery/computer/ares_console/ui_static_data(mob/user)
	var/list/data = list()

	data["link_id"] = link_id

	return data

/obj/structure/machinery/computer/ares_console/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE
	if(inoperable())
		return UI_DISABLED

/obj/structure/machinery/computer/ares_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	playsound(src, "keyboard_alt", 15, 1)

	switch (action)
		if("go_back")
			if(!last_menu)
				return to_chat(usr, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")
			var/mob/living/carbon/human/operator = usr
			var/obj/item/card/id/idcard = operator.get_active_hand()
			if(istype(idcard))
				authentication = get_ares_access(idcard)
				last_login = idcard.registered_name
			else
				idcard = operator.wear_id
				if(istype(idcard))
					authentication = get_ares_access(idcard)
					last_login = idcard.registered_name
			if(authentication)
				access_list += "[last_login] at [worldtime2text()], Access Level [authentication] - [auth_to_text(authentication)]."
			current_menu = "main"

		if("sudo")
			var/new_user = tgui_input_text(usr, "Enter Sudo Username", "Sudo User", encode = FALSE)
			if(new_user)
				if(new_user == sudo_holder)
					last_login = sudo_holder
					sudo_holder = null
					return FALSE
				if(new_user == last_login)
					to_chat(usr, SPAN_WARNING("Already remote logged in as this user."))
					playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
					return FALSE
				sudo_holder = last_login
				last_login = new_user
				access_list += "[last_login] at [worldtime2text()], Sudo Access."
				return TRUE
		if("sudo_logout")
			access_list += "[last_login] at [worldtime2text()], Sudo Logout."
			last_login = sudo_holder
			sudo_holder = null
			return
		// -- Page Changers -- //
		if("logout")
			last_menu = current_menu
			current_menu = "login"
			if(sudo_holder)
				access_list += "[last_login] at [worldtime2text()], Sudo Logout."
				last_login = sudo_holder
				sudo_holder = null
			access_list += "[last_login] logged out at [worldtime2text()]."

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
		if("page_security")
			last_menu = current_menu
			current_menu = "security"
		if("page_requisitions")
			last_menu = current_menu
			current_menu = "requisitions"
		if("page_antiair")
			last_menu = current_menu
			current_menu = "antiair"
		if("page_emergency")
			last_menu = current_menu
			current_menu = "emergency"
		if("page_deleted")
			last_menu = current_menu
			current_menu = "delete_log"
		if("page_deleted_1to1")
			last_menu = current_menu
			current_menu = "deleted_talks"

		// -- Delete Button -- //
		if("delete_record")
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
					records_announcement -= record
				if(ARES_RECORD_BIOSCAN)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					records_bioscan -= record
				if(ARES_RECORD_BOMB)
					new_title = "[record.title] at [record.time]"
					new_details = "[record.details] Launched by [record.user]."
					records_bombardment -= record

			new_delete.details = new_details
			new_delete.user = last_login
			new_delete.title = new_title

			records_deletion += new_delete

		// -- 1:1 Conversation -- //
		if("new_conversation")
			var/datum/ares_record/talk_log/convo = new(last_login)
			convo.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], 'New 1:1 link initiated. Greetings, [last_login].'"
			records_talking += convo

		if("clear_conversation")
			var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
			if(!istype(conversation))
				return FALSE
			var/datum/ares_record/deleted_talk/deleted = new
			deleted.title = conversation.title
			deleted.conversation = conversation.conversation
			deleted.user = conversation.user
			records_deletion += deleted
			records_talking -= conversation

		if("message_ares")
			var/message = tgui_input_text(usr, "What do you wish to say to ARES?", "ARES Message", encode = FALSE)
			if(message)
				message_ares(message, usr, params["active_convo"])

		if("read_record")
			var/datum/ares_record/deleted_talk/conversation = locate(params["record"])
			deleted_1to1 = conversation.conversation
			last_menu = current_menu
			current_menu = "read_deleted"

		// -- Emergency Buttons -- //
		if("evacuation_start")
			if(security_level < SEC_LEVEL_RED)
				to_chat(usr, SPAN_WARNING("The ship must be under red alert in order to enact evacuation procedures."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			if(EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY)
				to_chat(usr, SPAN_WARNING("The USCM has placed a lock on deploying the evacuation pods."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			if(!EvacuationAuthority.initiate_evacuation())
				to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation procedure right now!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			log_game("[key_name(usr)] has called for an emergency evacuation via ARES.")
			message_admins("[key_name_admin(usr)] has called for an emergency evacuation via ARES.")
			var/datum/ares_link/link = GLOB.ares_link
			link.log_ares_security("Initiate Evacuation", "[last_login] has called for an emergency evacuation via ARES.")
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?
			if(world.time < DISTRESS_TIME_LOCK)
				to_chat(usr, SPAN_WARNING("You have been here for less than six minutes... what could you possibly have done!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(world.time < ares_distress_cooldown)
				to_chat(usr, SPAN_WARNING("The distress launcher is cooling down!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(security_level == SEC_LEVEL_DELTA)
				to_chat(usr, SPAN_WARNING("The ship is already undergoing self destruct procedures!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			else if(security_level < SEC_LEVEL_RED)
				to_chat(usr, SPAN_WARNING("The ship must be under red alert to launch a distress beacon!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			for(var/client/admin in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
					playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
			message_admins("[key_name(usr)] has requested a Distress Beacon (via ARES)! [CC_MARK(usr)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distress=\ref[usr]'>SEND</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];ccdeny=\ref[usr]'>DENY</A>) [ADMIN_JMP_USER(usr)] [CC_REPLY(usr)]")
			to_chat(usr, SPAN_NOTICE("A distress beacon request has been sent to USCM High Command."))
			COOLDOWN_START(src, ares_distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

		if("nuclearbomb")
			if(!SSticker.mode)
				return FALSE //Not a game mode?
			if(world.time < NUCLEAR_TIME_LOCK)
				to_chat(usr, SPAN_WARNING("It is too soon to request Nuclear Ordnance!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(world.time < ares_nuclear_cooldown)
				to_chat(usr, SPAN_WARNING("The ordnance request frequency is garbled, wait for reset!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(security_level == SEC_LEVEL_DELTA)
				to_chat(usr, SPAN_WARNING("The mission has failed catastrophically, what do you want a nuke for!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			for(var/client/admin in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
					playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
			message_admins("[key_name(usr)] has requested use of Nuclear Ordnance (via ARES)! [CC_MARK(usr)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];nukeapprove=\ref[usr]'>APPROVE</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];nukedeny=\ref[usr]'>DENY</A>) [ADMIN_JMP_USER(usr)] [CC_REPLY(usr)]")
			to_chat(usr, SPAN_NOTICE("A nuclear ordnance request has been sent to USCM High Command."))
			COOLDOWN_START(src, ares_nuclear_cooldown, COOLDOWN_COMM_DESTRUCT)
			return TRUE

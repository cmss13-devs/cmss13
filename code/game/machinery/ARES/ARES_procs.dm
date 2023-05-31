GLOBAL_DATUM_INIT(ares_link, /datum/ares_link, new)

/datum/ares_link
	var/link_id = MAIN_SHIP_DEFAULT_NAME
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
	..()

/obj/structure/machinery/computer/ares_console/proc/get_ares_access(obj/item/card/id/card)
	if(777 in card.access)
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
	interface.bioscan_records.Add(new /datum/ares_record/bioscan(title, input))

/datum/ares_link/proc/log_ares_bombardment(mob/living/user, ob_name, coordinates)
	interface.bombardment_records.Add(new /datum/ares_record/bombardment(ob_name, "Bombardment fired at [coordinates].", user))

/datum/ares_link/proc/log_ares_announcement(title, message)
	interface.announcement_records.Add(new /datum/ares_record/announcement(title, message))

/obj/structure/machinery/computer/ares_console/proc/message_ares(text, mob/Sender, ref)
	var/msg = "<b>[SPAN_NOTICE("<font color=orange>ARES:</font>")][key_name(Sender, 1)] [ARES_MARK(Sender)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] [ADMIN_JMP_USER(Sender)] [ARES_REPLY(Sender, ref)]:</b> [text]"
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
	data["access_text"] = "access level [authentication], [auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = security_level
	data["evac_status"] = EvacuationAuthority.evac_status
	data["distresstime"] = ares_distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["worldtime"] = world.time

	data["access_log"] = list()
	data["access_log"] += access_list
	data["apollo_log"] = list()
	data["apollo_log"] += apollo_log

	data["deleted_conversation"] = list()
	data["deleted_conversation"] += deleted_1to1

	var/list/logged_announcements = list()
	for(var/datum/ares_record/announcement/broadcast as anything in announcement_records)
		var/list/current_broadcast = list()
		current_broadcast["time"] = broadcast.time
		current_broadcast["title"] = broadcast.title
		current_broadcast["details"] = broadcast.details
		current_broadcast["ref"] = "\ref[broadcast]"
		logged_announcements += list(current_broadcast)
	data["announcement_records"] = logged_announcements

	var/list/logged_bioscans = list()
	for(var/datum/ares_record/bioscan/scan as anything in bioscan_records)
		var/list/current_scan = list()
		current_scan["time"] = scan.time
		current_scan["title"] = scan.title
		current_scan["details"] = scan.details
		current_scan["ref"] = "\ref[scan]"
		logged_bioscans += list(current_scan)
	data["bioscan_records"] = logged_bioscans

	var/list/logged_bombs = list()
	for(var/datum/ares_record/bombardment/bomb as anything in bombardment_records)
		var/list/current_bomb = list()
		current_bomb["time"] = bomb.time
		current_bomb["title"] = bomb.title
		current_bomb["details"] = bomb.details
		current_bomb["user"] = bomb.user
		current_bomb["ref"] = "\ref[bomb]"
		logged_bombs += list(current_bomb)
	data["bombardment_records"] = logged_bombs

	var/list/logged_deletes = list()
	for(var/datum/ares_record/deletion/deleted as anything in deletion_records)
		if(!istype(deleted))
			continue
		var/list/current_delete = list()
		current_delete["time"] = deleted.time
		current_delete["title"] = deleted.title
		current_delete["details"] = deleted.details
		current_delete["user"] = deleted.user
		current_delete["ref"] = "\ref[deleted]"
		logged_deletes += list(current_delete)
	data["deletion_records"] = logged_deletes

	var/list/logged_discussions = list()
	for(var/datum/ares_record/deleted_talk/deleted_convo as anything in deletion_records)
		if(!istype(deleted_convo))
			continue
		var/list/deleted_disc = list()
		deleted_disc["time"] = deleted_convo.time
		deleted_disc["title"] = deleted_convo.title
		deleted_disc["ref"] = "\ref[deleted_convo]"
		logged_discussions += list(deleted_disc)
	data["deleted_discussions"] = logged_discussions

	var/list/logged_convos = list()
	var/list/active_convo = list()
	var/active_ref
	for(var/datum/ares_record/talk_log/log as anything in talking_records)
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

		// -- Page Changers -- //
		if("logout")
			last_menu = current_menu
			current_menu = "login"
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
					announcement_records -= record
				if(ARES_RECORD_BIOSCAN)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					bioscan_records -= record
				if(ARES_RECORD_BOMB)
					new_title = "[record.title] at [record.time]"
					new_details = "[record.details] Launched by [record.user]."
					bombardment_records -= record

			new_delete.details = new_details
			new_delete.user = last_login
			new_delete.title = new_title

			deletion_records += new_delete

		// -- 1:1 Conversation -- //
		if("new_conversation")
			var/datum/ares_record/talk_log/convo = new(last_login)
			convo.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], 'New 1:1 link initiated. Greetings, [last_login].'"
			talking_records += convo

		if("clear_conversation")
			var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
			if(!istype(conversation))
				return FALSE
			var/datum/ares_record/deleted_talk/deleted = new
			deleted.title = conversation.title
			deleted.conversation = conversation.conversation
			deleted.user = conversation.user
			deletion_records += deleted
			talking_records -= conversation

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
			. = TRUE

		if("distress")
			if(!SSticker.mode)
				return FALSE //Not a game mode?

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
			to_chat(usr, SPAN_NOTICE("A distress beacon request has been sent to USCM Central Command."))
			COOLDOWN_START(src, ares_distress_cooldown, COOLDOWN_COMM_REQUEST)
			return TRUE

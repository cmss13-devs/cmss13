GLOBAL_DATUM_INIT(ares_link, /datum/ares_link, new)
GLOBAL_LIST_INIT(maintenance_categories, list(
	"Broken Light",
	"Shattered Glass",
	"Minor Structural Damage",
	"Major Structural Damage",
	"Janitorial",
	"Chemical Spill",
	"Fire",
	"Communications Failure",
	"Power Generation Failure",
	"Electrical Fault",
	"Support",
	"Other"
	))

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
	var/list/obj/structure/machinery/computer/working_joe/ticket_computers = list()

	/// The chat log of the apollo link. Timestamped.
	var/list/apollo_log = list()

	/// Working Joe stuff
	var/list/tickets_maintenance = list()
	var/list/tickets_access = list()

/datum/ares_link/Destroy()
	for(var/obj/structure/machinery/ares/link in linked_systems)
		link.delink()
	for(var/obj/structure/machinery/computer/ares_console/interface in linked_systems)
		interface.delink()
	for(var/obj/effect/step_trigger/ares_alert/alert in linked_alerts)
		alert.delink()
	..()


// ------ ARES Logging Procs ------ //
/proc/log_ares_apollo(speaker, message)
	if(!speaker)
		speaker = "Unknown"
	var/datum/ares_link/link = GLOB.ares_link
	if(!link.p_apollo || link.p_apollo.inoperable())
		return FALSE
	if(!link.p_interface || link.p_interface.inoperable())
		return FALSE
	link.apollo_log.Add("[worldtime2text()]: [speaker], '[message]'")

/datum/ares_link/proc/log_ares_bioscan(title, input)
	interface.records_bioscan.Add(new /datum/ares_record/bioscan(title, input))

/datum/ares_link/proc/log_ares_bombardment(user, ob_name, coordinates)
	interface.records_bombardment.Add(new /datum/ares_record/bombardment(ob_name, "Bombardment fired at [coordinates].", user))

/datum/ares_link/proc/log_ares_announcement(title, message)
	interface.records_announcement.Add(new /datum/ares_record/announcement(title, message))

/datum/ares_link/proc/log_ares_requisition(source, details, user)
	interface.records_asrs.Add(new /datum/ares_record/requisition_log(source, details, user))

/datum/ares_link/proc/log_ares_security(title, details)
	interface.records_security.Add(new /datum/ares_record/security(title, details))

/datum/ares_link/proc/log_ares_antiair(details)
	interface.records_security.Add(new /datum/ares_record/security/antiair(details))

/datum/ares_link/proc/log_ares_flight(user, details)
	interface.records_flight.Add(new /datum/ares_record/flight(details, user))
// ------ End ARES Logging Procs ------ //

/proc/ares_apollo_talk(broadcast_message)
	var/datum/language/apollo/apollo = GLOB.all_languages[LANGUAGE_APOLLO]
	for(var/mob/living/silicon/decoy/ship_ai/ai in ai_mob_list)
		if(ai.stat == DEAD)
			return FALSE
		apollo.broadcast(ai, broadcast_message)
	for(var/mob/listener in (GLOB.human_mob_list + GLOB.dead_mob_list))
		if(listener.hear_apollo())//Only plays sound to mobs and not observers, to reduce spam.
			playsound_client(listener.client, sound('sound/misc/interference.ogg'), listener, vol = 45)

/proc/ares_can_interface()
	var/obj/structure/machinery/ares/processor/interface/processor = GLOB.ares_link.p_interface
	if(!istype(GLOB.ares_link))
		return FALSE
	if(processor && !processor.inoperable())
		return TRUE
	return FALSE //interface processor not found or is broken

/proc/ares_can_log()
	var/obj/structure/machinery/computer/ares_console/interface = GLOB.ares_link.interface
	if(!istype(GLOB.ares_link))
		return FALSE
	if(interface && !interface.inoperable())
		return TRUE
	return FALSE //ares interface not found or is broken

// ------ ARES Interface Procs ------ //
/obj/structure/machinery/computer/proc/get_ares_access(obj/item/card/id/card)
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
	if(ACCESS_WY_GENERAL in card.access)
		return ARES_ACCESS_CORPORATE
	if(ACCESS_MARINE_COMMAND in card.access)
		return ARES_ACCESS_COMMAND
	else
		return ARES_ACCESS_BASIC

/obj/structure/machinery/computer/proc/ares_auth_to_text(access_level)
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


/obj/structure/machinery/computer/ares_console/proc/message_ares(text, mob/Sender, ref)
	var/msg = SPAN_STAFF_IC("<b><font color=orange>ARES:</font> [key_name(Sender, 1)] [ARES_MARK(Sender)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] [ADMIN_JMP_USER(Sender)] [ARES_REPLY(Sender, ref)]:</b> [text]")
	var/datum/ares_record/talk_log/conversation = locate(ref)
	conversation.conversation += "[last_login] at [worldtime2text()], '[text]'"
	for(var/client/admin in GLOB.admins)
		if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
			to_chat(admin, msg)
			if(admin.prefs.toggles_sound & SOUND_ARES_MESSAGE)
				playsound_client(admin, 'sound/machines/chime.ogg', vol = 25)
	log_say("[key_name(Sender)] sent '[text]' to ARES 1:1.")

/obj/structure/machinery/computer/ares_console/proc/response_from_ares(text, ref)
	var/datum/ares_record/talk_log/conversation = locate(ref)
	conversation.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], '[text]'"
// ------ End ARES Interface Procs ------ //

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
	data["sudo"] = sudo_holder ? TRUE : FALSE

	data["access_text"] = "[sudo_holder ? "(SUDO)," : ""] access level [authentication], [ares_auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = security_level
	data["evac_status"] = EvacuationAuthority.evac_status
	data["worldtime"] = world.time

	data["access_log"] = list()
	data["access_log"] += access_list
	data["apollo_log"] = list()
	data["apollo_log"] += link.apollo_log

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
	for(var/datum/ares_record/security/security_alert as anything in records_security)
		var/list/current_alert = list()
		current_alert["time"] = security_alert.time
		current_alert["title"] = security_alert.title
		current_alert["details"] = security_alert.details
		current_alert["ref"] = "\ref[security_alert]"
		logged_alerts += list(current_alert)
	data["records_security"] = logged_alerts

	var/list/logged_flights = list()
	for(var/datum/ares_record/flight/flight_log as anything in records_flight)
		var/list/current_flight = list()
		current_flight["time"] = flight_log.time
		current_flight["title"] = flight_log.title
		current_flight["details"] = flight_log.details
		current_flight["user"] = flight_log.user
		current_flight["ref"] = "\ref[flight_log]"
		logged_flights += list(current_flight)
	data["records_flight"] = logged_flights

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
			else if(operator.wear_id)
				idcard = operator.wear_id
				if(istype(idcard))
					authentication = get_ares_access(idcard)
					last_login = idcard.registered_name
			else
				to_chat(usr, SPAN_WARNING("You require an ID card to access this terminal!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(authentication)
				access_list += "[last_login] at [worldtime2text()], Access Level [authentication] - [ares_auth_to_text(authentication)]."
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
		if("page_flight")
			last_menu = current_menu
			current_menu = "flight_log"
		if("page_requisitions")
			last_menu = current_menu
			current_menu = "requisitions"
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
				if(ARES_RECORD_SECURITY, ARES_RECORD_ANTIAIR)
					new_title = "[record.title] at [record.time]"
					new_details = record.details
					records_security -= record
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
		if("general_quarters")
			if(security_level == SEC_LEVEL_RED || security_level == SEC_LEVEL_DELTA)
				to_chat(usr, SPAN_WARNING("Alert level is already red or above, General Quarters cannot be called."))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			set_security_level(2, no_sound = TRUE, announce = FALSE)
			shipwide_ai_announcement("ATTENTION! GENERAL QUARTERS. ALL HANDS, MAN YOUR BATTLESTATIONS.", MAIN_AI_SYSTEM, 'sound/effects/GQfullcall.ogg')
			log_game("[key_name(usr)] has called for general quarters via ARES.")
			message_admins("[key_name_admin(usr)] has called for general quarters via ARES.")
			var/datum/ares_link/link = GLOB.ares_link
			link.log_ares_security("General Quarters", "[last_login] has called for general quarters via ARES.")
			. = TRUE

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
			if(!COOLDOWN_FINISHED(src, ares_distress_cooldown))
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
			SSticker.mode.request_ert(usr, TRUE)
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
			if(!COOLDOWN_FINISHED(src, ares_nuclear_cooldown))
				to_chat(usr, SPAN_WARNING("The ordnance request frequency is garbled, wait for reset!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(security_level == SEC_LEVEL_DELTA || SSticker.mode.is_in_endgame)
				to_chat(usr, SPAN_WARNING("The mission has failed catastrophically, what do you want a nuke for?!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			var/reason = tgui_input_text(usr, "Please enter reason nuclear ordnance is required.", "Reason for Nuclear Ordnance")
			if(!reason)
				return FALSE
			for(var/client/admin in GLOB.admins)
				if((R_ADMIN|R_MOD) & admin.admin_holder.rights)
					playsound_client(admin,'sound/effects/sos-morse-code.ogg',10)
			message_admins("[key_name(usr)] has requested use of Nuclear Ordnance (via ARES)! Reason: <b>[reason]</b> [CC_MARK(usr)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];nukeapprove=\ref[usr]'>APPROVE</A>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];nukedeny=\ref[usr]'>DENY</A>) [ADMIN_JMP_USER(usr)] [CC_REPLY(usr)]")
			to_chat(usr, SPAN_NOTICE("A nuclear ordnance request has been sent to USCM High Command for the following reason: [reason]"))
			if(ares_can_log())
				link.log_ares_security("Nuclear Ordnance Request", "[last_login] has sent a request for nuclear ordnance for the following reason: [reason]")
			if(ares_can_interface())
				ai_silent_announcement("[last_login] has sent a request for nuclear ordnance to USCM High Command.", ".V")
				ai_silent_announcement("Reason given: [reason].", ".V")
			COOLDOWN_START(src, ares_nuclear_cooldown, COOLDOWN_COMM_DESTRUCT)
			return TRUE
// ------ End ARES Interface UI ------ //


/obj/structure/machinery/computer/working_joe/get_ares_access(obj/item/card/id/card)
	if(ACCESS_ARES_DEBUG in card.access)
		return APOLLO_ACCESS_DEBUG
	switch(card.assignment)
		if(JOB_WORKING_JOE)
			return APOLLO_ACCESS_JOE
		if(JOB_CHIEF_ENGINEER, JOB_SYNTH, JOB_CO)
			return APOLLO_ACCESS_AUTHED
	if(ACCESS_MARINE_AI in card.access)
		return APOLLO_ACCESS_AUTHED
	if(ACCESS_MARINE_AI_TEMP in card.access)
		return APOLLO_ACCESS_TEMP
	if((ACCESS_MARINE_SENIOR in card.access ) || (ACCESS_MARINE_ENGINEERING in card.access) || (ACCESS_WY_GENERAL in card.access))
		return APOLLO_ACCESS_REPORTER
	else
		return APOLLO_ACCESS_REQUEST

/obj/structure/machinery/computer/working_joe/ares_auth_to_text(access_level)
	switch(access_level)
		if(APOLLO_ACCESS_REQUEST)//0
			return "Unauthorized Personnel"
		if(APOLLO_ACCESS_REPORTER)//1
			return "Validated Incident Reporter"
		if(APOLLO_ACCESS_TEMP)//2
			return "Authorized Visitor"
		if(APOLLO_ACCESS_AUTHED)//3
			return "Certified Personnel"
		if(APOLLO_ACCESS_JOE)//4
			return "Working Joe"
		if(APOLLO_ACCESS_DEBUG)//5
			return "AI Service Technician"

// ------ Maintenance Controller UI ------ //
/obj/structure/machinery/computer/working_joe/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)
		return FALSE

	if(authenticator_id)
		authenticator_id.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(authenticator_id)
		if(operable()) // Powered. Console can response.
			visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGOUT: Session end confirmed.\"")
		else
			to_chat(usr, "You remove [authenticator_id] from [src].")
		ticket_authenticated = FALSE // No card - no access
		authenticator_id = null

	else if(target_id)
		target_id.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(target_id)
		else
			to_chat(usr, "You remove [target_id] from [src].")
		target_id = null

	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/structure/machinery/computer/working_joe/attackby(obj/object, mob/user)
	if(istype(object, /obj/item/card/id))
		if(!ticket_console)
			to_chat(user, SPAN_WARNING("This console doesn't have an ID port!"))
			return FALSE
		if(!operable())
			to_chat(user, SPAN_NOTICE("You try to insert [object] but [src] remains silent."))
			return FALSE
		var/obj/item/card/id/idcard = object
		if((idcard.assignment == JOB_WORKING_JOE) || (ACCESS_ARES_DEBUG in idcard.access))
			if(!authenticator_id)
				if(user.drop_held_item())
					object.forceMove(src)
					authenticator_id = object
				authenticate(authenticator_id)
			else if(!target_id)
				if(user.drop_held_item())
					object.forceMove(src)
					target_id = object
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
				return FALSE
		else
			if(!target_id)
				if(user.drop_held_item())
					object.forceMove(src)
					target_id = object
			else
				to_chat(user, "Both slots are full already. Remove a card first.")
				return FALSE
	else
		..()

/obj/structure/machinery/computer/working_joe/proc/authenticate(obj/item/card/id/id_card)
	if(!id_card)
		visible_message("[SPAN_BOLD("[src]")] states, \"AUTH ERROR: Authenticator card is missing!\"")
		return FALSE

	if((ACCESS_MARINE_AI in id_card.access) || (ACCESS_ARES_DEBUG in id_card.access))
		ticket_authenticated = TRUE
		visible_message("[SPAN_BOLD("[src]")] states, \"AUTH LOGIN: Welcome, [id_card.registered_name]. Access granted.\"")
		return TRUE

	visible_message("[SPAN_BOLD("[src]")] states, \"AUTH ERROR: Access denied.\"")
	return FALSE




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

	data["ticket_console"] = ticket_console
	data["current_menu"] = current_menu
	data["last_page"] = last_menu

	data["logged_in"] = last_login

	data["access_text"] = "access level [authentication], [ares_auth_to_text(authentication)]."
	data["access_level"] = authentication

	data["alert_level"] = security_level
	data["worldtime"] = world.time

	data["access_log"] = list()
	data["access_log"] += login_list

	data["apollo_log"] = list()
	data["apollo_log"] += link.apollo_log

	data["authenticated"] = ticket_authenticated


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

/obj/structure/machinery/computer/working_joe/ui_static_data(mob/user)
	var/list/data = list()

	data["link_id"] = link_id

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
				login_list += "[last_login] at [worldtime2text()], Access Level [authentication] - [ares_auth_to_text(authentication)]."
			current_menu = "main"

		if("logout")
			last_menu = current_menu
			current_menu = "login"
			login_list += "[last_login] logged out at [worldtime2text()]."

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
		if("page_returns")
			last_menu = current_menu
			current_menu = "access_returns"
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

			var/confirm = alert(operator, "Please confirm the submission of your maintenance report. \n\n Priority: [priority_report ? "Yes" : "No"] \n Category: '[maint_type]' \n Details: '[details]' \n\n Is this correct?", "Confirmation", "Yes", "No")
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
			var/priority_report = FALSE
			var/ticket_holder = tgui_input_text(operator, "Who is the ticket for?", "Ticket Holder", encode = FALSE)
			if(!ticket_holder)
				return FALSE
			var/details = tgui_input_text(operator, "What is the purpose of this access ticket?", "Ticket Details", encode = FALSE)
			if(!details)
				return FALSE

			if(authentication >= APOLLO_ACCESS_AUTHED)
				var/is_priority = tgui_alert(operator, "Is this a priority request?", "Priority designation", list("Yes", "No"))
				if(is_priority == "Yes")
					priority_report = TRUE

			var/confirm = alert(operator, "Please confirm the submission of your access ticket request. \n\n Priority: [priority_report ? "Yes" : "No"] \n Holder: '[ticket_holder]' \n Details: '[details]' \n\n Is this correct?", "Confirmation", "Yes", "No")
			if(confirm != "Yes" || !link)
				return FALSE
			var/datum/ares_ticket/access/access_ticket = new(last_login, ticket_holder, details, priority_report)
			link.tickets_access += access_ticket
			if(priority_report)
				ares_apollo_talk("Priority Access Request: [ticket_holder] - ID [access_ticket.ticket_id]. Seek and resolve.")
			log_game("ARES: Access Ticket '\ref[access_ticket]' created by [key_name(operator)] as [last_login] with Holder '[ticket_holder]' and Details of '[details]'.")
			return TRUE

	if(playsound)
		playsound(src, "keyboard_alt", 15, 1)

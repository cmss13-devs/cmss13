// #################### ARES Interface Console #####################
/obj/structure/machinery/computer/ares_console
	name = "ARES Interface"
	desc = "A console built to interface with ARES, allowing for 1:1 communication."
	icon = 'icons/obj/structures/machinery/ares.dmi'
	icon_state = "console"
	exproof = TRUE

	var/current_menu = "login"
	var/last_menu = ""

	var/authentication = ARES_ACCESS_LOGOUT

	/// The last person to login.
	var/last_login = "No User"
	/// The person pretending to be last_login
	var/sudo_holder

	/// The current deleted chat log of 1:1 conversations being read.
	var/list/deleted_1to1 = list()

	/// The ID used to link all devices.
	var/datum/ares_link/link
	/// The datacore storing all the information.
	var/datum/ares_datacore/datacore

	COOLDOWN_DECLARE(printer_cooldown)

/obj/structure/machinery/computer/ares_console/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link)
		new_link.interface = src
		link = new_link
		new_link.linked_systems += src
	if(!datacore)
		datacore = GLOB.ares_datacore
	return TRUE

/obj/structure/machinery/computer/ares_console/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/structure/machinery/computer/ares_console/proc/delink()
	if(link)
		if(link.interface == src)
			link.interface = null
		link.linked_systems -= src
		link = null
	datacore = null

/obj/structure/machinery/computer/ares_console/Destroy()
	delink()
	return ..()

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

	data["alert_level"] = GLOB.security_level
	data["evac_status"] = SShijack.evac_status
	data["worldtime"] = world.time

	data["access_log"] = datacore.interface_access_list
	data["apollo_log"] = datacore.apollo_log

	data["deleted_conversation"] = deleted_1to1

	data["distresstime"] = datacore.ares_distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["quarterstime"] = datacore.ares_quarters_cooldown
	data["mission_failed"] = SSticker.mode.is_in_endgame
	data["nuketimelock"] = NUCLEAR_TIME_LOCK
	data["nuke_available"] = datacore.nuke_available

	data["printer_cooldown"] = !COOLDOWN_FINISHED(src, printer_cooldown)

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

	data["security_vents"] = link.get_ares_vents()

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
	var/mob/user = ui.user
	var/playsound = TRUE

	switch (action)
		if("go_back")
			if(!last_menu)
				return to_chat(user, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")
			var/mob/living/carbon/human/operator = user
			var/obj/item/card/id/idcard = operator.get_active_hand()
			if(istype(idcard))
				authentication = get_ares_access(idcard)
				last_login = idcard.registered_name
			else if(operator.wear_id)
				idcard = operator.get_idcard()
				if(idcard)
					authentication = get_ares_access(idcard)
					last_login = idcard.registered_name
			else
				to_chat(user, SPAN_WARNING("You require an ID card to access this terminal!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(authentication)
				datacore.interface_access_list += "[last_login] at [worldtime2text()], Access Level [authentication] - [ares_auth_to_text(authentication)]."
			current_menu = "main"

		if("sudo")
			var/new_user = tgui_input_text(user, "Enter Sudo Username", "Sudo User", encode = FALSE)
			if(new_user)
				if(new_user == sudo_holder)
					last_login = sudo_holder
					sudo_holder = null
					return FALSE
				if(new_user == last_login)
					to_chat(user, SPAN_WARNING("Already remote logged in as this user."))
					playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
					return FALSE
				sudo_holder = last_login
				last_login = new_user
				datacore.interface_access_list += "[last_login] at [worldtime2text()], Sudo Access."
				return TRUE
		if("sudo_logout")
			datacore.interface_access_list += "[last_login] at [worldtime2text()], Sudo Logout."
			last_login = sudo_holder
			sudo_holder = null
			return
		// -- Page Changers -- //
		if("logout")
			last_menu = current_menu
			current_menu = "login"
			if(sudo_holder)
				datacore.interface_access_list += "[last_login] at [worldtime2text()], Sudo Logout."
				last_login = sudo_holder
				sudo_holder = null
			datacore.interface_access_list += "[last_login] logged out at [worldtime2text()]."
			last_login = "No User"
			authentication = ARES_ACCESS_LOGOUT

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
		if("page_tech")
			last_menu = current_menu
			current_menu = "tech_log"
		if("page_core_sec")
			last_menu = current_menu
			current_menu = "core_security"

		// -- Print ASRS Audit Log -- //
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
						<u>Printed By:</u> [last_login]<br>
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

			var/obj/item/paper/log = new(loc)
			log.name = "ASRS Audit Log"
			log.info += contents
			log.icon_state = "paper_uscm_words"
			visible_message(SPAN_NOTICE("[src] prints out a paper."))

		// -- Delete Button -- //
		if("delete_record")
			var/datum/ares_record/record = locate(params["record"])
			if(!istype(record))
				return FALSE
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
			new_delete.user = last_login
			new_delete.title = new_title

			datacore.records_deletion += new_delete

		// -- 1:1 Conversation -- //
		if("new_conversation")
			var/datum/ares_record/talk_log/convo = new(last_login)
			convo.conversation += "[MAIN_AI_SYSTEM] at [worldtime2text()], 'New 1:1 link initiated. Greetings, [last_login].'"
			datacore.records_talking += convo

		if("clear_conversation")
			var/datum/ares_record/talk_log/conversation = locate(params["active_convo"])
			if(!istype(conversation))
				return FALSE
			var/datum/ares_record/deleted_talk/deleted = new
			deleted.title = conversation.title
			deleted.conversation = conversation.conversation
			deleted.user = conversation.user
			datacore.records_deletion += deleted
			datacore.records_talking -= conversation

		if("message_ares")
			var/message = tgui_input_text(user, "What do you wish to say to ARES?", "ARES Message", encode = FALSE)
			if(message)
				message_ares(message, user, params["active_convo"])

		if("read_record")
			var/datum/ares_record/deleted_talk/conversation = locate(params["record"])
			if(!istype(conversation))
				return FALSE
			deleted_1to1 = conversation.conversation
			last_menu = current_menu
			current_menu = "read_deleted"

		// -- Emergency Buttons -- //
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
			log_ares_security("General Quarters", "Called for general quarters via ARES.", last_login)
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
			log_ares_security("Initiate Evacuation", "Called for an emergency evacuation via ARES.", last_login)
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
			log_ares_security("Nuclear Ordnance Request", "Sent a request for nuclear ordnance for the following reason: [reason]", last_login)
			if(ares_can_interface())
				ai_silent_announcement("[last_login] has sent a request for nuclear ordnance to USCM High Command.", ".V")
				ai_silent_announcement("Reason given: [reason].", ".V")
			COOLDOWN_START(datacore, ares_nuclear_cooldown, COOLDOWN_COMM_DESTRUCT)
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
			log_ares_security("Nerve Gas Release", "Released Nerve Gas from Vent '[sec_vent.vent_tag]'.", last_login)
			sec_vent.create_gas(VENT_GAS_CN20_XENO, 6, 5 SECONDS)
			log_admin("[key_name(user)] released nerve gas from Vent '[sec_vent.vent_tag]' via ARES.")

		if("security_lockdown")
			if(!COOLDOWN_FINISHED(datacore, aicore_lockdown))
				to_chat(user, SPAN_BOLDWARNING("AI Core Lockdown procedures are on cooldown! They will be ready in [COOLDOWN_SECONDSLEFT(datacore, aicore_lockdown)] seconds!"))
				return FALSE
			aicore_lockdown(user)
			return TRUE

	if(playsound)
		playsound(src, "keyboard_alt", 15, 1)

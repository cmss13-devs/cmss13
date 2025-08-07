/obj/item/device/working_joe_pda
	name = "KN5500 PDA"
	desc = "A portable interface used by Working-Joes, capable of connecting to the local command AI to relay tasking information. Built to withstand a nuclear bomb."
	icon_state = "karnak_off"
	item_state = "wj_pda"
	icon = 'icons/obj/items/synth/wj_pda.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/equipment/devices_righthand.dmi',
	)
	unacidable = TRUE
	explo_proof = TRUE
	req_one_access = list(ACCESS_MARINE_AI_TEMP, ACCESS_MARINE_AI, ACCESS_ARES_DEBUG)

	/// The ID used to link all devices.
	var/datum/ares_link/link
	/// The datacore storing all the information.
	var/datum/ares_datacore/datacore

	var/current_menu = "login"
	var/last_menu = "off"
	var/base_icon_state = "karnak"

	var/authentication = APOLLO_ACCESS_LOGOUT
	/// The last person to login.
	var/last_login

	/// Notification sound
	var/notify_sounds =  TRUE


/obj/item/device/working_joe_pda/proc/link_systems(datum/ares_link/new_link = GLOB.ares_link, override)
	if(link && !override)
		return FALSE
	if(new_link)
		new_link.ticket_computers += src
		link = new_link
		new_link.linked_systems += src
	if(!datacore)
		datacore = GLOB.ares_datacore
	return TRUE

/obj/item/device/working_joe_pda/Initialize(mapload, ...)
	link_systems(override = FALSE)
	. = ..()

/obj/item/device/working_joe_pda/proc/notify()
	if(notify_sounds)
		playsound(src, 'sound/machines/pda_ping.ogg', 25, 0)

/obj/item/device/working_joe_pda/proc/send_notifcation()
	for(var/obj/item/device/working_joe_pda/ticketer as anything in link.ticket_computers)
		if(ticketer == src)
			continue
		ticketer.notify()

/obj/item/device/working_joe_pda/proc/delink()
	if(link)
		link.ticket_computers -= src
		link.linked_systems -= src
		link = null
	datacore = null

/obj/item/device/working_joe_pda/Destroy()
	delink()
	return ..()

/obj/item/device/working_joe_pda/update_icon()
	. = ..()
	if(last_menu == "off")
		icon_state = "[base_icon_state]_off"
	else if(current_menu == "login")
		icon_state = "[base_icon_state]_login_anim"
	else
		icon_state = "[base_icon_state]_on_anim"

// ------ Maintenance Controller UI ------ //
/obj/item/device/working_joe_pda/attack_self(mob/user)
	if(..() || !allowed(usr))
		return FALSE

	if((last_menu == "off") && (current_menu == "login"))
		last_menu = "main"
		update_icon()

	tgui_interact(user)
	return TRUE

/obj/item/device/working_joe_pda/tgui_interact(mob/user, datum/tgui/ui, datum/ui_state/state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WorkingJoe", name)
		ui.open()

/obj/item/device/working_joe_pda/ui_close(mob/user)
	. = ..()

	current_menu = "login"
	last_menu = "off"
	if(last_login)
		datacore.apollo_login_list += "[last_login] logged out at [worldtime2text()]."
	last_login = null
	update_icon()

/obj/item/device/working_joe_pda/ui_data(mob/user)
	var/list/data = datacore.get_interface_data()

	data["local_current_menu"] = current_menu
	data["local_last_page"] = last_menu
	data["local_logged_in"] = last_login
	data["local_access_text"] = "access level [authentication], [ares_auth_to_text(authentication)]."
	data["local_access_level"] = authentication
	data["local_notify_sounds"] = notify_sounds

	return data

/obj/item/device/working_joe_pda/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(!allowed(user))
		return UI_UPDATE

/obj/item/device/working_joe_pda/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/playsound = TRUE
	var/mob/living/carbon/human/user = ui.user

	switch (action)
		if("go_back")
			if(!last_menu)
				return to_chat(user, SPAN_WARNING("Error, no previous page detected."))
			var/temp_holder = current_menu
			current_menu = last_menu
			last_menu = temp_holder

		if("login")

			var/obj/item/card/id/idcard = user.get_active_hand()
			if(istype(idcard))
				authentication = get_ares_access(idcard)
				last_login = idcard.registered_name
			else if(user.wear_id)
				idcard = user.get_idcard()
				if(idcard)
					authentication = get_ares_access(idcard)
					last_login = idcard.registered_name
			else
				to_chat(user, SPAN_WARNING("You require an ID card to access this terminal!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(authentication)
				datacore.apollo_login_list += "[last_login] at [worldtime2text()], Access Level [authentication] - [ares_auth_to_text(authentication)]."
			current_menu = "main"
			last_menu = "main"
			update_icon()

		if("logout")
			last_menu = current_menu
			current_menu = "login"
			datacore.apollo_login_list += "[last_login] logged out at [worldtime2text()]."
			update_icon()

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
		if("page_core_gas")
			last_menu = current_menu
			current_menu = "core_security_gas"

		if("toggle_sound")
			notify_sounds = !notify_sounds

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

			if((authentication >= APOLLO_ACCESS_REPORTER) && !priority_report)
				var/is_priority = tgui_alert(user, "Is this a priority report?", "Priority designation", list("Yes", "No"))
				if(is_priority == "Yes")
					priority_report = TRUE

			var/confirm = alert(user, "Please confirm the submission of your maintenance report. \n\n Priority: [priority_report ? "Yes" : "No"]\n Category: '[maint_type]'\n Details: '[details]'\n\n Is this correct?", "Confirmation", "Yes", "No")
			if(confirm == "Yes")
				if(link)
					var/datum/ares_ticket/maintenance/maint_ticket = new(last_login, maint_type, details, priority_report)
					link.tickets_maintenance += maint_ticket
					if(priority_report)
						ares_apollo_talk("Priority Maintenance Report: [maint_type] - ID [maint_ticket.ticket_id]. Seek and resolve.")
					else
						send_notifcation()
					log_game("ARES: Maintenance Ticket '\ref[maint_ticket]' created by [key_name(user)] as [last_login] with Category '[maint_type]' and Details of '[details]'.")
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
				ticket.ticket_assignee = last_login
				ticket.ticket_status = TICKET_ASSIGNED
			return claim

		if("cancel_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			if(ticket.ticket_submitter != last_login)
				to_chat(user, SPAN_WARNING("You cannot cancel a ticket that does not belong to you!"))
				return FALSE
			to_chat(user, SPAN_WARNING("[ticket.ticket_type] [ticket.ticket_id] has been cancelled."))
			ticket.ticket_status = TICKET_CANCELLED
			if(ticket.ticket_priority)
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been cancelled.")
			else
				send_notifcation()
			return TRUE

		if("mark_ticket")
			var/datum/ares_ticket/ticket = locate(params["ticket"])
			if(!istype(ticket))
				return FALSE
			if(ticket.ticket_assignee != last_login && ticket.ticket_assignee) //must be claimed by you or unclaimed.)
				to_chat(user, SPAN_WARNING("You cannot update a ticket that is not assigned to you!"))
				return FALSE
			var/choice = tgui_alert(user, "What do you wish to mark the ticket as?", "Mark", list(TICKET_COMPLETED, TICKET_REJECTED), 20 SECONDS)
			switch(choice)
				if(TICKET_COMPLETED)
					ticket.ticket_status = TICKET_COMPLETED
				if(TICKET_REJECTED)
					ticket.ticket_status = TICKET_REJECTED
				else
					return FALSE
			if(ticket.ticket_priority)
				ares_apollo_talk("Priority [ticket.ticket_type] [ticket.ticket_id] has been [choice] by [last_login].")
			else
				send_notifcation()
			to_chat(user, SPAN_NOTICE("[ticket.ticket_type] [ticket.ticket_id] marked as [choice]."))
			return TRUE

		if("new_access")
			var/obj/item/card/id/idcard = user.get_active_hand()
			var/has_id = FALSE
			if(istype(idcard))
				has_id = TRUE
			else if(user.wear_id)
				idcard = user.get_idcard()
				if(idcard)
					has_id = TRUE
			if(!has_id)
				to_chat(user, SPAN_WARNING("You require an ID card to request an access ticket!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE
			if(idcard.registered_name != last_login)
				to_chat(user, SPAN_WARNING("This ID card does not match the active login!"))
				playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
				return FALSE

			var/details = tgui_input_text(user, "What is the purpose of this access ticket?", "Ticket Details", encode = FALSE)
			if(!details)
				return FALSE

			var/confirm = alert(user, "Please confirm the submission of your access ticket request.\n\nHolder: '[last_login]'\nDetails: '[details]'\n\nIs this correct?", "Confirmation", "Yes", "No")
			if(confirm != "Yes" || !link)
				return FALSE
			var/datum/ares_ticket/access/access_ticket = new(last_login, details, FALSE, idcard.registered_gid)
			link.waiting_ids += idcard
			link.tickets_access += access_ticket
			log_game("ARES: Access Ticket '\ref[access_ticket]' created by [key_name(user)] as [last_login] with Details of '[details]'.")
			message_admins(SPAN_STAFF_IC("[key_name_admin(user)] created a new ARES Access Ticket."), 1)
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
				if(identification.registered_gid != access_ticket.user_id_num)
					continue

				access_ticket.ticket_status = TICKET_RETURNED
				identification.access -= ACCESS_MARINE_AI_TEMP
				identification.modification_log += "Temporary AI Access self-returned by [key_name(user)]."

				to_chat(user, SPAN_NOTICE("Temporary Access Ticket surrendered."))
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] surrendered their access.")

				authentication = get_ares_access(identification)
				if(authentication)
					datacore.apollo_login_list += "[last_login] at [worldtime2text()], Surrendered Temporary Access Ticket."
				return TRUE

			to_chat(user, SPAN_WARNING("This ID card does not have an access ticket!"))
			playsound(src, 'sound/machines/buzz-two.ogg', 15, 1)
			return FALSE

		if("auth_access")
			playsound = FALSE
			var/datum/ares_ticket/access/access_ticket = locate(params["ticket"])
			if(!access_ticket)
				return FALSE
			for(var/obj/item/card/id/identification in link.waiting_ids)
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(last_login, user)
				access_ticket.ticket_status = TICKET_GRANTED
				playsound(src, 'sound/machines/chime.ogg', 15, 1)
				ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] was granted access by [last_login].")
				return TRUE
			for(var/obj/item/card/id/identification in link.active_ids)
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				identification.handle_ares_access(last_login, user)
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
				to_chat(user, SPAN_WARNING("You cannot update a ticket that is not assigned to you!"))
				return FALSE
			access_ticket.ticket_status = TICKET_REJECTED
			to_chat(user, SPAN_NOTICE("[access_ticket.ticket_type] [access_ticket.ticket_id] marked as rejected."))
			ares_apollo_talk("Access Ticket [access_ticket.ticket_id]: [access_ticket.ticket_submitter] was rejected access by [last_login].")
			for(var/obj/item/card/id/identification in link.waiting_ids)
				if(identification.registered_gid != access_ticket.user_id_num)
					continue
				var/mob/living/carbon/human/id_owner = identification.registered_ref?.resolve()
				if(id_owner)
					to_chat(id_owner, SPAN_WARNING("AI visitation access rejected."))
					playsound_client(id_owner?.client, 'sound/machines/pda_ping.ogg', src, 25, 0)
			return TRUE

		if("trigger_vent")
			playsound = FALSE
			var/obj/structure/pipes/vents/pump/no_boom/gas/ares/sec_vent = locate(params["vent"])
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

		if("update_sentries")
			var/new_iff = params["chosen_iff"]
			if(!new_iff)
				to_chat(user, SPAN_WARNING("ERROR: Unknown setting."))
				return FALSE
			if(new_iff == link.faction_label)
				return FALSE
			link.change_iff(new_iff)
			message_admins("ARES: [key_name(user)] updated ARES Sentry IFF to [new_iff].")
			to_chat(user, SPAN_WARNING("Sentry IFF settings updated!"))
			return TRUE

	if(playsound)
		var/sound = pick('sound/machines/pda_button1.ogg', 'sound/machines/pda_button2.ogg')
		playsound(src, sound, 15, TRUE)

/obj/item/device/working_joe_pda/uscm
	name = "KN5500/2 PDA"
	desc = "A portable interface used by AI technicians, capable of connecting to the local command AI to relay tasking information. Built to withstand a nuclear bomb."
	icon_state = "karnak_uscm_off"
	base_icon_state = "karnak_uscm"

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

	data["logged_in"] = logged_in
	data["access_level"] = authentication
	data["sudo"] = FALSE

	var/admin_remote_access_text = "[link.interface.sudo_holder ? "(SUDO)," : ""] access level [link.interface.authentication], [link.interface.ares_auth_to_text(link.interface.authentication)]."
	if(set_ui == "AresAdmin")
		data["access_text"] = admin_remote_access_text
		data["logged_in"] = link.interface.last_login
		data["access_level"] = link.interface.authentication
		data["sudo"] = link.interface.sudo_holder ? TRUE : FALSE
	else if(set_ui == "WorkingJoe")
		data["access_text"] = " access level [authentication], [apollo_auth_to_text(authentication)]."
	else if(set_ui == "AresInterface")
		data["access_text"] = " access level [authentication], [ares_auth_to_text(authentication)]."

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

	data["notify_sounds"] = notify_sounds
	data["security_vents"] = link.get_ares_vents()
	data["sentry_setting"] = link.faction_label
	data["faction_options"] = link.faction_options

	return data



/obj/item/device/ai_tech_pda/proc/get_apollo_access(obj/item/card/id/card)
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

/obj/item/device/ai_tech_pda/proc/apollo_auth_to_text(access_level)
	switch(access_level)
		if(APOLLO_ACCESS_LOGOUT)//0
			return "Logged Out"
		if(APOLLO_ACCESS_REQUEST)//1
			return "Unauthorized Personnel"
		if(APOLLO_ACCESS_REPORTER)//2
			return "Validated Incident Reporter"
		if(APOLLO_ACCESS_TEMP)//3
			return "Authorized Visitor"
		if(APOLLO_ACCESS_AUTHED)//4
			return "Certified Personnel"
		if(APOLLO_ACCESS_JOE)//5
			return "Working Joe"
		if(APOLLO_ACCESS_DEBUG)//6
			return "AI Service Technician"

/obj/item/device/ai_tech_pda/proc/get_ares_access(obj/item/card/id/card)
	if(ACCESS_ARES_DEBUG in card.access)
		return ARES_ACCESS_DEBUG
	switch(card.assignment)
		if(JOB_WORKING_JOE)
			return ARES_ACCESS_JOE
		if(JOB_CHIEF_ENGINEER)
			return ARES_ACCESS_CE
		if(JOB_SYNTH)
			return ARES_ACCESS_SYNTH
	if(card.paygrade in GLOB.wy_highcom_paygrades)
		return ARES_ACCESS_WY_COMMAND
	if(card.paygrade in GLOB.uscm_highcom_paygrades)
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

/obj/item/device/ai_tech_pda/proc/ares_auth_to_text(access_level)
	switch(access_level)
		if(ARES_ACCESS_LOGOUT)
			return "Logged Out"
		if(ARES_ACCESS_BASIC)
			return "Authorized"
		if(ARES_ACCESS_COMMAND)
			return "[MAIN_SHIP_NAME] Command"
		if(ARES_ACCESS_JOE)
			return "Working Joe"
		if(ARES_ACCESS_CORPORATE)
			return "Weyland-Yutani"
		if(ARES_ACCESS_SENIOR)
			return "[MAIN_SHIP_NAME] Senior Command"
		if(ARES_ACCESS_CE)
			return "Chief Engineer"
		if(ARES_ACCESS_SYNTH)
			return "USCM Synthetic"
		if(ARES_ACCESS_CO)
			return "[MAIN_SHIP_NAME] Commanding Officer"
		if(ARES_ACCESS_HIGH)
			return "USCM High Command"
		if(ARES_ACCESS_WY_COMMAND)
			return "Weyland-Yutani Directorate"
		if(ARES_ACCESS_DEBUG)
			return "AI Service Technician"

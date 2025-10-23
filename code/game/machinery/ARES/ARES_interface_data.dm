/datum/ares_datacore/proc/get_interface_data()
	var/datum/ares_link/link = GLOB.ares_link
	var/list/data = list()

	data["alert_level"] = GLOB.security_level
	data["evac_status"] = SShijack.evac_status
	data["worldtime"] = world.time

	data["ares_access_log"] = interface_access_list
	data["apollo_access_log"] = apollo_login_list
	data["apollo_log"] = apollo_log


	data["distresstime"] = ares_distress_cooldown
	data["distresstimelock"] = DISTRESS_TIME_LOCK
	data["quarterstime"] = ares_quarters_cooldown
	data["mission_failed"] = SSticker.mode.is_in_endgame
	data["nuketimelock"] = NUCLEAR_TIME_LOCK
	data["nuke_available"] = nuke_available

	data["sentry_setting"] = link.faction_label
	data["faction_options"] = list("USCM Only", "Wey-Yu Only", "USCM & Wey-Yu", "ARES Only")


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

	var/list/logged_techs = list()
	for(var/datum/ares_record/tech/tech_unlock as anything in records_tech)
		var/list/current_tech = list()
		current_tech["time"] = tech_unlock.time
		current_tech["details"] = tech_unlock.details
		current_tech["user"] = tech_unlock.user
		current_tech["tier_changer"] = tech_unlock.is_tier
		current_tech["ref"] = "\ref[tech_unlock]"
		logged_techs += list(current_tech)
	data["records_tech"] = logged_techs

	var/list/logged_convos = list()
	for(var/datum/ares_record/talk_log/log as anything in records_talking)
		if(!istype(log))
			continue

		var/list/current_convo = list()
		current_convo["user"] = log.user
		current_convo["time"] = log.time
		current_convo["title"] = log.title
		current_convo["ref"] = "\ref[log]"
		current_convo["conversation"] = log.conversation
		logged_convos += list(current_convo)

	data["records_discussions"] = logged_convos

	var/list/security_vents = list()
	for(var/obj/structure/pipes/vents/pump/no_boom/gas/ares/vent in link.linked_vents)
		if(!vent.vent_tag)
			vent.vent_tag = "Security Vent #[link.tag_num]"
			link.tag_num++

		var/list/current_vent = list()
		var/is_available = COOLDOWN_FINISHED(vent, vent_trigger_cooldown)
		current_vent["vent_tag"] = vent.vent_tag
		current_vent["ref"] = "\ref[vent]"
		current_vent["available"] = is_available
		security_vents += list(current_vent)
	data["security_vents"] = security_vents

	var/list/logged_maintenance = list()
	for(var/datum/ares_ticket/maintenance/maint_ticket as anything in link.tickets_maintenance)
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

	return data

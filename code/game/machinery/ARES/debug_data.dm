/obj/item/device/ai_tech_pda/ui_data(mob/user)
	if(!link.interface)
		to_chat(user, SPAN_WARNING("ARES ADMIN DATA LINK FAILED"))
		return FALSE
	var/list/data = datacore.get_interface_data()

	data["local_admin_login"] = "[logged_in], AI Service Technician"
	data["admin_access_log"] = access_list

	data["local_current_menu"] = current_menu
	data["local_last_page"] = last_menu

	data["local_logged_in"] = logged_in
	data["local_access_level"] = authentication
	data["local_is_pda"] = TRUE
	data["local_sudo"] = FALSE
	data["local_printer_cooldown"] = !COOLDOWN_FINISHED(src, printer_cooldown)
	data["local_notify_sounds"] = notify_sounds

	var/admin_remote_access_text = "[link.interface.sudo_holder ? "(SUDO)," : ""] access level [link.interface.authentication], [link.interface.ares_auth_to_text(link.interface.authentication)]."
	if(set_ui == "AresAdmin")
		data["local_access_text"] = admin_remote_access_text
		data["local_logged_in"] = link.interface.last_login
		data["local_access_level"] = link.interface.authentication
		data["ares_sudo"] = link.interface.sudo_holder ? TRUE : FALSE
	else if(set_ui == "WorkingJoe")
		data["local_access_text"] = " access level [authentication], [apollo_auth_to_text(authentication)]."
	else if(set_ui == "AresInterface")
		data["local_access_text"] = " access level [authentication], [ares_auth_to_text(authentication)]."

	data["local_spying_conversation"] = deleted_1to1

	var/list/active_convo = list()
	var/active_ref
	for(var/datum/ares_record/talk_log/log as anything in datacore.records_talking)
		if(!istype(log))
			continue
		if(log.user == link.interface.last_login)
			active_convo = log.conversation
			active_ref = "\ref[log]"
	data["local_active_convo"] = active_convo
	data["local_active_ref"] = active_ref

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

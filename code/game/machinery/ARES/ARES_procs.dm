GLOBAL_DATUM_INIT(ares_link, /datum/ares_link, new)
GLOBAL_DATUM_INIT(ares_datacore, /datum/ares_datacore, new)
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
	/// All motion triggers for the link
	var/list/linked_alerts = list()
	/// All machinery for the link
	var/list/linked_systems = list()
	var/obj/structure/machinery/ares/cpu/central_processor
	var/obj/structure/machinery/ares/processor/interface/processor_interface
	var/obj/structure/machinery/ares/processor/apollo/processor_apollo
	var/obj/structure/machinery/ares/processor/bioscan/processor_bioscan
	var/obj/structure/machinery/computer/ares_console/interface
	var/list/obj/structure/machinery/computer/working_joe/ticket_computers = list()

	/// Working Joe stuff
	var/list/tickets_maintenance = list()
	var/list/tickets_access = list()
	var/list/waiting_ids = list()
	var/list/active_ids = list()

/datum/ares_datacore
	/// A record of who logged in and when.
	var/list/interface_access_list = list()
	/// Access list for Apollo Maintenance Console
	var/list/apollo_login_list = list()

	/// The chat log of the apollo link. Timestamped.
	var/list/apollo_log = list()

	/// Holds all (/datum/ares_record/announcement)s
	var/list/records_announcement = list()
	/// Holds all (/datum/ares_record/bioscan)s
	var/list/records_bioscan = list()
	/// Holds all (/datum/ares_record/bombardment)s
	var/list/records_bombardment = list()
	/// Holds all (/datum/ares_record/deletion)s
	var/list/records_deletion = list()
	/// Holds all (/datum/ares_record/talk_log)s
	var/list/records_talking = list()
	/// Holds all (/datum/ares_record/requisition_log)s
	var/list/records_asrs = list()
	/// Holds all (/datum/ares_record/security)s (including AA)
	var/list/records_security = list()
	/// Holds all (/datum/ares_record/flight)s
	var/list/records_flight = list()
	/// Is nuke request usable or not?
	var/nuke_available = TRUE


	COOLDOWN_DECLARE(ares_distress_cooldown)
	COOLDOWN_DECLARE(ares_nuclear_cooldown)
	COOLDOWN_DECLARE(ares_quarters_cooldown)

/datum/ares_link/Destroy()
	for(var/obj/structure/machinery/ares/link in linked_systems)
		link.delink()
	for(var/obj/structure/machinery/computer/ares_console/interface in linked_systems)
		interface.delink()
	for(var/obj/effect/step_trigger/ares_alert/alert in linked_alerts)
		alert.delink()
	..()


// ------ ARES Logging Procs ------ //
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
	var/obj/structure/machinery/ares/processor/interface/processor = GLOB.ares_link.processor_interface
	if(!istype(GLOB.ares_link))
		return FALSE
	if(processor && !processor.inoperable())
		return TRUE
	return FALSE //interface processor not found or is broken

/proc/ares_can_log()
	if(!istype(GLOB.ares_link) || !istype(GLOB.ares_datacore))
		return FALSE
	var/obj/structure/machinery/ares/cpu/central_processor = GLOB.ares_link.central_processor
	if(central_processor && !central_processor.inoperable())
		return TRUE
	return FALSE //CPU not found or is broken

/proc/log_ares_apollo(speaker, message)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_link/link = GLOB.ares_link
	if(!link.processor_apollo || link.processor_apollo.inoperable())
		return FALSE
	if(!speaker)
		speaker = "Unknown"
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.apollo_log.Add("[worldtime2text()]: [speaker], '[message]'")

/proc/log_ares_bioscan(title, input)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_bioscan.Add(new /datum/ares_record/bioscan(title, input))

/proc/log_ares_bombardment(user_name, ob_name, coordinates)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_bombardment.Add(new /datum/ares_record/bombardment(ob_name, "Bombardment fired at [coordinates].", user_name))

/proc/log_ares_announcement(title, message)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_announcement.Add(new /datum/ares_record/announcement(title, message))

/proc/log_ares_requisition(source, details, user_name)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_asrs.Add(new /datum/ares_record/requisition_log(source, details, user_name))

/proc/log_ares_security(title, details)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_security.Add(new /datum/ares_record/security(title, details))

/proc/log_ares_antiair(details)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_security.Add(new /datum/ares_record/security/antiair(details))

/proc/log_ares_flight(user_name, details)
	if(!ares_can_log())
		return FALSE
	var/datum/ares_datacore/datacore = GLOB.ares_datacore
	datacore.records_flight.Add(new /datum/ares_record/flight(details, user_name))
// ------ End ARES Logging Procs ------ //

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

/obj/item/device/working_joe_pda/proc/get_ares_access(obj/item/card/id/card)
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

/obj/item/device/working_joe_pda/proc/ares_auth_to_text(access_level)
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

/datum/ares_record
	var/record_name = "ARES Data Core"
	/// World time in text format.
	var/time
	/// The title of the record, usually announcement title.
	var/title
	/// The content of the record, announcement text/bioscan info etc.
	var/details
	/// The name of the initiator of certain records. Who fired an OB, or who deleted something etc.
	var/user

/datum/ares_record/New(title, details)
	time = worldtime2text()
	src.title = title
	src.details = details

/datum/ares_record/announcement
	record_name = ARES_RECORD_ANNOUNCE

/datum/ares_record/bioscan
	record_name = ARES_RECORD_BIOSCAN

/datum/ares_record/requisition_log
	record_name = ARES_RECORD_ASRS

/datum/ares_record/requisition_log/New(title, details, user)
	time = worldtime2text()
	src.title = title
	src.details = details
	src.user = user

/datum/ares_record/security
	record_name = ARES_RECORD_SECURITY

/datum/ares_record/security/antiair
	record_name = ARES_RECORD_ANTIAIR

/datum/ares_record/security/antiair/New(details)
	time = worldtime2text()
	src.title = "AntiAir Adjustment"
	src.details = details

/datum/ares_record/flight
	record_name = ARES_RECORD_FLIGHT

/datum/ares_record/flight/New(details, user)
	time = worldtime2text()
	title = "Flight Log"
	src.details = details
	src.user = user

/datum/ares_record/bombardment
	record_name = ARES_RECORD_BOMB

/datum/ares_record/bombardment/New(title, details, user)
	time = worldtime2text()
	src.title = title
	src.details = details
	src.user = user

/datum/ares_record/tech
	record_name = ARES_RECORD_TECH
	/// If this tech unlock changed the tier.
	var/is_tier = FALSE

/datum/ares_record/tech/New(title, details, user, tier_tech)
	time = worldtime2text()
	src.title = title
	src.details = details
	src.user = user
	is_tier = tier_tech

/datum/ares_record/deletion
	record_name = ARES_RECORD_DELETED

/datum/ares_record/deletion/New()
	time = worldtime2text()

/datum/ares_record/talk_log
	record_name = "1:1 Data Log"
	var/conversation = list()

/datum/ares_record/talk_log/New(user)
	src.user = user
	src.title = "1:1 Log ([user])"

/datum/ares_record/deleted_talk
	record_name = ARES_RECORD_DELETED
	var/conversation = list()

/datum/ares_record/deleted_talk/New()
	time = worldtime2text()


/datum/ares_ticket
	var/ticket_type = "Root Ticket"
	var/ticket_status = TICKET_PENDING
	/// Name of who is handling the ticket. Derived from last login.
	var/ticket_assignee
	/// Numerical designation of the ticket.
	var/ticket_id = "1111"
	/// World time in text format.
	var/ticket_time
	/// Who submitted the ticket. Derived from last login.
	var/ticket_submitter
	/// The name of the ticket.
	var/ticket_name
	/// The content of the ticket, usually an explanation of what it is for.
	var/ticket_details
	/// Whether or not the tickey is a priority.
	var/ticket_priority = FALSE

/datum/ares_ticket/New(user, name, details, priority)
	var/ref_holder = "\ref[src]"
	var/pos = length(ref_holder)
	var/new_id = "#[copytext("\ref[src]", pos - 4, pos)]"
	new_id = uppertext(new_id)

	ticket_time = worldtime2text()
	ticket_submitter = user
	ticket_details = details
	ticket_name = name
	ticket_priority = priority
	ticket_id = new_id

/datum/ares_ticket/maintenance
	ticket_type = ARES_RECORD_MAINTENANCE

/datum/ares_ticket/access
	ticket_type = ARES_RECORD_ACCESS
	ticket_name = ARES_RECORD_ACCESS
	var/user_id_num

/datum/ares_ticket/access/New(user, details, priority, global_id_num)
	var/ref_holder = "\ref[src]"
	var/pos = length(ref_holder)
	var/new_id = "#[copytext("\ref[src]", pos - 4, pos)]"
	new_id = uppertext(new_id)

	ticket_time = worldtime2text()
	ticket_submitter = user
	ticket_details = details
	ticket_priority = priority
	ticket_id = new_id
	user_id_num = global_id_num

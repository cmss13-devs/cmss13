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

/datum/ares_record/antiair
	record_name = ARES_RECORD_ANTIAIR
/datum/ares_record/antiair/New(details, user)
	time = worldtime2text()
	src.title = "AntiAir Adjustment"
	src.details = details
	src.user = user

/datum/ares_record/bombardment
	record_name = ARES_RECORD_BOMB

/datum/ares_record/bombardment/New(title, details, user)
	time = worldtime2text()
	src.title = title
	src.details = details
	src.user = user

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

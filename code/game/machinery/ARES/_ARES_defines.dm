/// Generic access for 1:1 conversations with ARES and unrestricted commands.
#define ARES_ACCESS_BASIC 0
/// Secure Access, can read ARES Announcements and Bioscans.
#define ARES_ACCESS_COMMAND 1
#define ARES_ACCESS_JOE 2
/// CL, can read Apollo Log and also Delete Announcements.
#define ARES_ACCESS_CORPORATE 3
/// Senior Command, can Delete Bioscans.
#define ARES_ACCESS_SENIOR 4
/// Synth, CE & Commanding Officer, can read the access log.
#define ARES_ACCESS_CE 5
#define ARES_ACCESS_SYNTH 6
#define ARES_ACCESS_CO 7
/// High Command, can read the deletion log.
#define ARES_ACCESS_HIGH 8
#define ARES_ACCESS_WY_COMMAND 9
/// Debugging. Allows me to view everything without using a high command rank. Unlikely to stay in a full merge.
#define ARES_ACCESS_DEBUG 10

#define ARES_RECORD_ANNOUNCE "Announcement Record"
#define ARES_RECORD_ANTIAIR "AntiAir Control Log"
#define ARES_RECORD_ASRS "Requisition Record"
#define ARES_RECORD_BIOSCAN "Bioscan Record"
#define ARES_RECORD_BOMB "Orbital Bombardment Record"
#define ARES_RECORD_DELETED "Deleted Record"
#define ARES_RECORD_SECURITY "Security Update"

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

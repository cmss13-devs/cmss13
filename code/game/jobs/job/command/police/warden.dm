// Warden
/datum/job/command/warden
	title = JOB_WARDEN
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Military Warden (MW)"
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='"+URL_WIKI_LAW+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the mainting security records and overwatching any prisoners in Brig."

AddTimelock(/datum/job/command/warden, list(
	JOB_POLICE_ROLES = 5 HOURS
))

/obj/effect/landmark/start/warden
	name = JOB_WARDEN
	job = /datum/job/command/warden
/datum/job/civilian/corp_sec
	title = JOB_CORPORATE_BODYGUARD
	total_positions = 1
	spawn_positions = 1
	supervisors = "the ONI Specialist"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/corp_sec
	entry_message_body = "As a <a href='"+WIKI_PLACEHOLDER+"'>ONI Personnel Security Officer</a> from the Office of Naval Intelligence, your job requires you to stay in character at all times. On ship, you are subject to orders only by the Command and Security departments, after the onboard ONI Specialist. You are not required to follow any orders from the ship's crew but you can be arrested if you do not. Your primary job is to protect the ONI office, and its Specialist."

/obj/effect/landmark/start/corp_sec
	name = JOB_CORPORATE_BODYGUARD
	icon_state = "cs_spawn"
	job = /datum/job/civilian/corp_sec

AddTimelock(/datum/job/civilian/corp_sec, list(
	JOB_CORPORATE_ROLES = 25 HOURS,
	JOB_POLICE_ROLES = 5 HOURS,
))

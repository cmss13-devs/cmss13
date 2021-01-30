/datum/job/logistics/engineering
	title = JOB_CHIEF_ENGINEER
	selection_class = "job_ce"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief Engineer (CE)"
	entry_message_body = "Your job is to maintain the ship's engine and keep everything running. If you have no idea how to set up the engine, or it's your first time, mentorhelp so that a mentor can assist you. You are also next in the chain of command, should the bridge crew fall in the line of duty."

AddTimelock(/datum/job/logistics/engineering, list(
	JOB_ENGINEER_ROLES = 10 HOURS
))

/obj/effect/landmark/start/engineering
	name = JOB_CHIEF_ENGINEER
	job = /datum/job/logistics/engineering
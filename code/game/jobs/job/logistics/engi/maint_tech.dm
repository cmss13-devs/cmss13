/datum/job/logistics/maint
	title = JOB_MAINT_TECH
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief engineer"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Maintenance Technician (MT)"
	entry_message_body = "Your job is to maintain the integrity of the ship, including the orbital cannon. You remain one of the more flexible roles on the ship and as such may receive other menial tasks from your superiors."

/obj/effect/landmark/start/maint
	name = JOB_MAINT_TECH
	job = /datum/job/logistics/maint

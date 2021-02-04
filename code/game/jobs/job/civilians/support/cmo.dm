/datum/job/civilian/professor
	title = JOB_CMO
	total_positions = 1
	spawn_positions = 1
	supervisors = "the acting commanding officer"
	selection_class = "job_cmo"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief Medical Officer (CMO)"
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You have final authority over the medical department, medications, and treatments. Make sure that the doctors and nurses are doing their jobs and keeping the marines healthy and strong."

AddTimelock(/datum/job/civilian/professor, list(
	JOB_MEDIC_ROLES = 10 HOURS
))

/obj/effect/landmark/start/professor
	name = JOB_CMO
	job = /datum/job/civilian/professor
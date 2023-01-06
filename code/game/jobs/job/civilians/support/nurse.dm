/datum/job/civilian/nurse
	title = JOB_NURSE
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/nurse
	entry_message_body = "<a href='"+URL_WIKI_NURSE_GUIDE+"'>You are tasked with keeping the Marines healthy and strong.</a> You are also an expert when it comes to medication and treatment, but you do not know anything about surgery. Focus on assisting doctors and triaging wounded marines."

/obj/effect/landmark/start/nurse
	name = JOB_NURSE
	job = /datum/job/civilian/nurse

AddTimelock(/datum/job/civilian/nurse, list(
	JOB_HUMAN_ROLES = 1 HOURS
))

/datum/job/civilian/nurse
	title = JOB_NURSE
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/nurse
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You are tasked with keeping the Marines healthy and strong.</a> You are also an expert when it comes to medication and treatment, and can do minor surgical procedures. Focus on assisting doctors and triaging wounded marines."
	minimal_open_positions = 3
	maximal_open_positions = 3

/obj/effect/landmark/start/nurse
	name = JOB_NURSE
	icon_state = "nur_spawn"
	job = /datum/job/civilian/nurse

AddTimelock(/datum/job/civilian/nurse, list(
	JOB_HUMAN_ROLES = 1 HOURS
))

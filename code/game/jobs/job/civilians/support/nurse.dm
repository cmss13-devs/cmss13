/datum/job/civilian/nurse
	title = JOB_NURSE
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief medical officer, and doctors you work under"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/nurse
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You are tasked with keeping the Marines healthy and strong.</a> You are also an expert when it comes to medication and treatment, and can do minor surgical procedures. Focus on assisting doctors and triaging wounded marines. You are not expected to be sufficient in medical knowledge gameplay yet, as this is a learning role. Your superiors can help you if you are lost, or if you do not know what you are doing, you can mentorhelp so a mentor can assist you."

/obj/effect/landmark/start/nurse
	name = JOB_NURSE
	icon_state = "nur_spawn"
	job = /datum/job/civilian/nurse

AddTimelock(/datum/job/civilian/nurse, list(
	JOB_HUMAN_ROLES = 1 HOURS
))

/datum/job/civilian/nurse
	title = JOB_NURSE
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Nurse"

/datum/job/civilian/nurse/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are a civilian, and are not subject to follow military chain of command, but you do work for the USCM. You are tasked with keeping the marines healthy and strong. You are also an expert when it comes to medication and treatment, but you do not know anything about surgery. Focus on assisting doctors and triaging wounded marines."
	return ..()

/obj/effect/landmark/start/nurse
	name = JOB_NURSE
	job = /datum/job/civilian/nurse

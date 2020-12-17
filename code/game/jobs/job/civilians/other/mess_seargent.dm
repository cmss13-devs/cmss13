/datum/job/civilian/chef
	title = JOB_MESS_SERGEANT
	total_positions = 1
	spawn_positions = 1
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	supervisors = "the acting commanding officer"
	gear_preset = "USCM Mess Sergeant (MS)"

/datum/job/logistics/chef/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "Your job is to service the marines with excellent food, drinks and entertaining the shipside crew when needed. You have a lot of freedom and it is up to you, to decide what to do with it. Good luck!"
	return ..()

/obj/effect/landmark/start/chef
	name = JOB_MESS_SERGEANT
	job = /datum/job/civilian/chef

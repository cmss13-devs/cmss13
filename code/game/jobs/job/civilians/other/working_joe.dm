/datum/job/civilian/working_joe
	title = JOB_WORKING_JOE
	total_positions = 2
	spawn_positions = 2
	supervisors = "the acting commanding officer"
	selection_class = "job_working_joe"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_SYNTHETIC
	gear_preset = /datum/equipment_preset/synth/working_joe
	entry_message_body = "You are a Working Joe! You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules. Failure to do so may result in your White-list Removal. Your primary job is to support and assist all USCM Departments and Personnel on-board. In addition, being a Synthetic gives you knowledge in every field and specialization possible on-board the ship. As a Synthetic you answer to the acting commanding officer. Special circumstances may change this!"

/obj/effect/landmark/start/working_joe
	name = JOB_WORKING_JOE
	job = /datum/job/civilian/working_joe

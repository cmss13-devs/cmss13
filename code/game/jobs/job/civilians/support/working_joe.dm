/datum/job/civilian/working_joe
	title = JOB_WORKING_JOE
	total_positions = 8
	spawn_positions = 8
	allow_additional = 1
	supervisors = "ARES and the acting commanding officer"
	selection_class = "job_working_joe"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_WHITELISTED|ROLE_CUSTOM_SPAWN
	flags_whitelist = WHITELIST_JOE
	gear_preset = /datum/equipment_preset/synth/working_joe
	entry_message_body = "You are a Working Joe!  You are held to a higher standard and are required to obey not only the Server Rules but Marine Law and Synthetic Rules.  Failure to do so may result in your White-list Removal.  Your primary job is to maintain the cleanliness of the ship, putting things in their proper place.  Your capacities are limited, but you have all the equipment you need, and the central AI has a plan!"

/datum/job/civilian/working_joe/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ai_announcement), "[H.real_name] has been deployed to help with operations."), 1.5 SECONDS)
	return ..()

/obj/effect/landmark/start/working_joe
	name = JOB_WORKING_JOE
	job = /datum/job/civilian/working_joe

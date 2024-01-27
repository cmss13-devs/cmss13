/datum/job/special/uscm/colonel
	title = JOB_COLONEL
/datum/job/special/uscm/general
	title = JOB_GENERAL
/datum/job/special/uscm/acmc
	title = JOB_ACMC
/datum/job/special/uscm/cmc
	title = JOB_CMC
/datum/job/special/uscm/sof
	title = JOB_MARINE_RAIDER
/datum/job/special/uscm/riot
	title = JOB_RIOT
/datum/job/special/uscm/riot/chief
	title = JOB_RIOT_CHIEF

/datum/job/special/uscm/ai_tech
	title = JOB_AI_TECH
	selection_class = "job_ce"
	supervisors = "the acting commanding officer"
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_WHITELISTED|ROLE_HIDDEN
	gear_preset = /datum/equipment_preset/uscm_event/ai_tech

/datum/job/special/uscm/ai_tech/check_whitelist_status(mob/user)
	if(check_rights(R_PERMISSIONS, show_msg = FALSE))
		return TRUE
	return FALSE

/datum/job/special/uscm/ai_tech/generate_entry_message()
	entry_message_body = "You are a visiting AI Service Technician aboard the [MAIN_SHIP_NAME]. Your goal is to ensure the onboard AI, [MAIN_AI_SYSTEM], is operating effectively. Your job involves heavy roleplay and requires you to behave like a high-ranking officer and to stay in character at all times. You are required to adhere to and obey <a href='"+LAW_PLACEHOLDER+"'>Marine Law</a>. Failure to do so may result in punitive action against you. Godspeed."
	return ..()

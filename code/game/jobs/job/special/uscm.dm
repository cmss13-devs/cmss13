/datum/job/special/uscm/colonel
	title = JOB_COLONEL
/datum/job/special/uscm/observer
	title = JOB_USCM_OBSV
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

#define USCM_TECH "USCM"
#define WY_TECH "Wey-Yu"

/datum/job/special/uscm/ai_tech
	title = JOB_AI_TECH
	selection_class = "job_ce"
	supervisors = "the acting commanding officer"
	total_positions = 1
	spawn_positions = 1
	flags_startup_parameters = ROLE_WHITELISTED
	gear_preset = /datum/equipment_preset/uscm_event/ai_tech

	// job option
	job_options = list(USCM_TECH = "USCM", WY_TECH = "WY")
	var/corporate = FALSE

//check the job option. and change the gear preset
/datum/job/special/uscm/ai_tech/handle_job_options(option)
	if(option != USCM_TECH)
		corporate = TRUE
		supervisors = "Weyland Yutani"
		gear_preset = /datum/equipment_preset/uscm_event/ai_tech/corporate
	else
		corporate = FALSE
		gear_preset = /datum/equipment_preset/uscm_event/ai_tech

/datum/job/special/uscm/ai_tech/check_whitelist_status(mob/user)
	if(check_rights(R_PERMISSIONS, show_msg = FALSE))
		return TRUE
	return FALSE

/datum/job/special/uscm/ai_tech/generate_entry_message()
	entry_message_body = "You are a [corporate ? FACTION_WY : FACTION_MARINE] AI Service Technician temporarily assigned to the [MAIN_SHIP_NAME]. Your goal is to ensure the onboard AI, [MAIN_AI_SYSTEM], is operating effectively. Your job involves heavy roleplay and requires you to behave like [corporate ? "a senior corporate representative, remaining in character at all times.<br>As a Weyland Yutani Technician you have access to the Corporate Office aboard the USS Almayer. Although you should cooperate with the onboard Liaison, you are not their subordinate nor they yours. You should help The Company interests where applicable but do not abuse your access to the AI Systems." : "an officer and to stay in character at all times. You are required to adhere to and obey <a href='"+LAW_PLACEHOLDER+"'>Marine Law</a>. Failure to do so may result in punitive action against you. Godspeed.\n\nThe access code for APOLLO Interface is [GLOB.ares_link.code_apollo].\nThe access code for ARES Interface is [GLOB.ares_link.code_interface]."]"
	return ..()

/obj/effect/landmark/start/aist
	name = JOB_AI_TECH
	icon_state = "aist_spawn"
	job = /datum/job/special/uscm/ai_tech

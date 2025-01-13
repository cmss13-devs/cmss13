/datum/job/command/senior
	title = JOB_SEA
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_MENTOR
	gear_preset = /datum/equipment_preset/uscm_ship/sea

	job_options = list("Gunnery Sergeant" = "GySGT", "Master Sergeant" = "MSgt", "First Sergeant" = "1Sgt", "Master Gunnery Sergeant" = "MGySgt", "Sergeant Major" = "SgtMaj")

/datum/job/command/senior/on_config_load()
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You are</a> held to a higher standard and are required to obey not only the Server Rules but <a href='"+LAW_PLACEHOLDER+"'>Marine Law</a> and <a href='[CONFIG_GET(string/wikiarticleurl)]/[URL_WIKI_SOP]'>Standard Operating Procedure</a>. Failure to do so may result in your Mentorship Removal. Your primary job is to teach others the game and its mechanics, and offer advice to all USCM Departments and Personnel on-board."
	return ..()

/datum/job/command/senior/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(all_hands_on_deck), "Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!", MAIN_AI_SYSTEM, sound('sound/misc/attention_jingle.ogg')), 1.5 SECONDS)
	return ..()

/datum/job/command/senior/filter_job_option(mob/job_applicant)
	. = ..()

	var/list/filtered_job_options = list(job_options[1])

	if(job_applicant?.client?.prefs)
		if(get_job_playtime(job_applicant.client, JOB_SEA) >= JOB_PLAYTIME_TIER_1)
			filtered_job_options += list(job_options[2]) + list(job_options[3])
		if(get_job_playtime(job_applicant.client, JOB_SEA) >= JOB_PLAYTIME_TIER_3)
			filtered_job_options += list(job_options[4]) + list(job_options[5])

	return filtered_job_options

AddTimelock(/datum/job/command/senior, list(
	JOB_SQUAD_ROLES = 15 HOURS,

	JOB_ENGINEER_ROLES = 10 HOURS,
	JOB_POLICE_ROLES = 10 HOURS,
	JOB_MEDIC_ROLES = 10 HOURS,

	JOB_COMMAND_ROLES = 5 HOURS,
))

/obj/effect/landmark/start/senior
	name = JOB_SEA
	icon_state = "sea_spawn"
	job = /datum/job/command/senior

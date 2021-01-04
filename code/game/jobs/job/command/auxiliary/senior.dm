/datum/job/command/senior
	title = JOB_SEA
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_MENTOR
	gear_preset = "USCM Senior Enlisted Advisor (SEA)"

/datum/job/command/senior/generate_entry_message()
	entry_message_body = "You are held to a higher standard and are required to obey not only the Server Rules but <a href='[URL_WIKI_LAW]'>Marine Law</a> and <a href='[URL_WIKI_SOP]'>Standard Operating Procedure</a>. Failure to do so may result in your Mentorship Removal. Your primary job is to teach others the game and its mechanics, and offer advice to all USCM Departments and Personnel on-board."
	return ..()

/datum/job/command/senior/announce_entry_message(mob/living/carbon/human/H)
	if(flags_startup_parameters & ROLE_ADD_TO_MODE && SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/ai_announcement, "Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!"), 1.5 SECONDS)
	..()

AddTimelock(/datum/job/command/senior, list(
	JOB_SQUAD_ROLES = 15 HOURS,

	JOB_ENGINEER_ROLES = 10 HOURS,
	JOB_POLICE_ROLES = 10 HOURS,
	JOB_MEDIC_ROLES = 10 HOURS,

	JOB_COMMAND_ROLES = 5 HOURS,
))

/obj/effect/landmark/start/senior
	name = JOB_SEA
	job = /datum/job/command/senior

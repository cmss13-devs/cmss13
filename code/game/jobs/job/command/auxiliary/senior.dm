/datum/job/command/senior
	title = JOB_SEA
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADMIN_NOTIFY|ROLE_WHITELISTED
	flags_whitelist = WHITELIST_MENTOR
	gear_preset = /datum/equipment_preset/uscm_ship/sea
	entry_message_body = "<a href='"+URL_WIKI_SEA_GUIDE+"'>You are</a> held to a higher standard and are required to obey not only the Server Rules but <a href='"+URL_WIKI_LAW+"'>Marine Law</a> and <a href='"+URL_WIKI_SOP+"'>Standard Operating Procedure</a>. Failure to do so may result in your Mentorship Removal. Your primary job is to teach others the game and its mechanics, and offer advice to all USCM Departments and Personnel on-board."

/datum/job/command/senior/announce_entry_message(mob/living/carbon/human/H)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(all_hands_on_deck), "Attention all hands, [H.get_paygrade(0)] [H.real_name] on deck!"), 1.5 SECONDS)
	return ..()


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

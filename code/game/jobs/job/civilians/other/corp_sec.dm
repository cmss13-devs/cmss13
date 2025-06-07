/datum/job/civilian/corp_sec
	title = JOB_CORPORATE_BODYGUARD
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Wey-Yu corporate liaison"
	selection_class = "job_cl"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/corp_sec
	entry_message_body = "As a <a href='"+WIKI_PLACEHOLDER+"'>corporate security officer</a> from Weyland-Yutani, your job requires you to stay in character at all times. While in the AO (Area of Operation), you are subject to orders given by military personnel. On ship, you are subject to orders only by the Command and Security departments, after the onboard Corporate Liaison. You are not required to follow any orders from the ship's crew but you can be arrested if you do not. Your primary job is to protect the Weyland-Yutani office, and its liaison."

/obj/effect/landmark/start/corp_sec
	name = JOB_CORPORATE_BODYGUARD
	icon_state = "cs_spawn"
	job = /datum/job/civilian/corp_sec

AddTimelock(/datum/job/civilian/corp_sec, list(
	JOB_CORPORATE_ROLES = 30 HOURS,
))

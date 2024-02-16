/datum/job/logistics/engineering
	title = JOB_CHIEF_ENGINEER
	selection_class = "job_ce"
	supervisors = "the auxiliary support officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/chief_engineer
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to maintain your department and keep your technicians in check. You are responsible for engineering, power, ordnance, and the orbital cannon. You are seventh in line for Acting Commander, behind any staff officers."

AddTimelock(/datum/job/logistics/engineering, list(
	JOB_ENGINEER_ROLES = 12 HOURS,
	JOB_JOB_MAINT_TECH = 3 HOURS,
	JOB_ORDNANCE_TECH = 6 HOURS
))

/obj/effect/landmark/start/engineering
	name = JOB_CHIEF_ENGINEER
	icon_state = "ce_spawn"
	job = /datum/job/logistics/engineering

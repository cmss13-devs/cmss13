/datum/job/command/field
	title = JOB_FO
	total_positions = 1
	spawn_positions = 1
	allow_additional = 0
	scaled = FALSE
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/fo
	entry_message_body = "<a href='"+URL_WIKI_SO_GUIDE+"'>Your job is to lead the marines from the frontline and offer combat support. You are also in line to take command after other eligible superior commissioned officers."

AddTimelock(/datum/job/command/field, list(
	JOB_SQUAD_LEADER = 5 HOURS,
	JOB_COMMAND_ROLES = 1 HOURS,
	JOB_HUMAN_ROLES = 15 HOURS
))

/obj/effect/landmark/start/field
	name = JOB_FO
	job = /datum/job/command/field

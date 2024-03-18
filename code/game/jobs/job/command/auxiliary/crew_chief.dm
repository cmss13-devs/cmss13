/datum/job/command/crew_chief
	title = JOB_DROPSHIP_CREW_CHIEF
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "your assigned dropship pilot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/dcc
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to assist</a> your pilot officer maintain the ship's dropship. You have authority over your assigned dropship and personnel within its walls, as long as it does not conflict with Standard Operating Procedure, or Marine Law. You are expected to maintain order and assist with maintaining the dropship, as not to disrupt the pilot and increase efficiency."

AddTimelock(/datum/job/command/crew_chief, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/crew_chief
	name = JOB_DROPSHIP_CREW_CHIEF
	icon_state = "dcc_spawn"
	job = /datum/job/command/crew_chief

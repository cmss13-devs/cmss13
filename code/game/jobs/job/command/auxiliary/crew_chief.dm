/datum/job/command/crew_chief
	title = JOB_DROPSHIP_PILOT
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the gunship officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/dcc
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to prepare</a> and pilot the crew tranport dropship. You have authority only on the dropship, but you are expected to maintain order, as not to disrupt the transport. If you are not piloting, there is an autopilot fallback for command, but don't leave the dropship without reason."

AddTimelock(/datum/job/command/crew_chief, list(
	JOB_SQUAD_ROLES = 5 HOURS
))

/obj/effect/landmark/start/crew_chief
	name = JOB_DROPSHIP_PILOT
	icon_state = "dcc_spawn"
	job = /datum/job/command/crew_chief

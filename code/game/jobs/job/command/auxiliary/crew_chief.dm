/datum/job/command/crew_chief
	title = JOB_DROPSHIP_CREW_CHIEF
	spawn_positions = 2
	supervisors = "the pilot officers"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/dcc
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to assist</a> the pilot officer maintain the ship's dropship. You have authority only on the dropship, but you are expected to maintain order, as not to disrupt the pilot."
	minimal_open_positions = 2
	maximal_open_positions = 2

AddTimelock(/datum/job/command/crew_chief, list(
	JOB_SQUAD_ROLES = 5 HOURS,
	JOB_MEDIC_ROLES = 1 HOURS
))

/obj/effect/landmark/start/crew_chief
	name = JOB_DROPSHIP_CREW_CHIEF
	icon_state = "dcc_spawn"
	job = /datum/job/command/crew_chief

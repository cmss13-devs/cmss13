/datum/job/command/ops_crew_chief
	title = JOB_OPERATIONS_CREW_CHIEF
	total_positions = 1
	spawn_positions = 1
	supervisors = "the pilot officers"
	flags_startup_parameters = ROLE_HIDDEN
	late_joinable = FALSE
	gear_preset = /datum/equipment_preset/uscm_ship/occ
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job is to assist</a> the pilot officer maintain the ship's AD-71E Blackfoot VTOL. You have authority only on the VTOL, but you are expected to maintain order, as not to disrupt the pilot."

AddTimelock(/datum/job/command/ops_crew_chief, list(
	JOB_SQUAD_ROLES = 5 HOURS,
	JOB_MEDIC_ROLES = 1 HOURS
))

/obj/effect/landmark/start/ops_crew_chief
	name = JOB_DROPSHIP_CREW_CHIEF
	icon_state = "occ_spawn"
	job = /datum/job/command/ops_crew_chief

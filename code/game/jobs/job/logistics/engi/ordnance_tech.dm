//Ordnance Technician
/datum/job/logistics/otech
	title = JOB_ORDNANCE_TECH
	supervisors = "the chief engineer"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ordn
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>Your job</a> is to maintain the integrity of the USCM weapons, munitions and equipment, including the orbital cannon. You can use the workshop in the portside hangar to construct new armaments for the marines. However you remain one of the more flexible roles on the ship and as such may receive other menial tasks from your superiors."
	players_per_position = 60
	minimal_open_positions = 2
	maximal_open_positions = 3

AddTimelock(/datum/job/logistics/otech, list(
	JOB_ENGINEER_ROLES = 1 HOURS
))

/obj/effect/landmark/start/otech
	name = JOB_ORDNANCE_TECH
	icon_state = "ot_spawn"
	job = /datum/job/logistics/otech

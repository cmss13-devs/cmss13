//Ordnance Technician
/datum/job/logistics/tech
	title = JOB_ORDNANCE_TECH
	total_positions = 3
	spawn_positions = 3
	supervisors = "the chief engineer"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ordn
	entry_message_body = "<a href='"+URL_WIKI_OT_GUIDE+"'>Your job</a> is to maintain the integrity of the USCM weapons, munitions and equipment, including the orbital cannon. You can use the workshop in the portside hangar to construct new armaments for the marines. However you remain one of the more flexible roles on the ship and as such may receive other menial tasks from your superiors."

AddTimelock(/datum/job/logistics/tech, list(
	JOB_ENGINEER_ROLES = 1 HOURS
))

/obj/effect/landmark/start/tech
	name = JOB_ORDNANCE_TECH
	job = /datum/job/logistics/tech

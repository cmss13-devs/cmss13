//Ordnance Technician
/datum/job/logistics/tech
	title = JOB_ORDNANCE_TECH
	total_positions = 3
	spawn_positions = 3
	allow_additional = 1
	scaled = 1
	supervisors = "the chief engineer"
	selection_class = "job_ot"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Ordnance Technician (OT)"
	entry_message_body = "Your job is to maintain the integrity of the USCM weapons, munitions and equipment, including the orbital cannon. You can use the workshop in the portside hangar to construct new armaments for the marines. However you remain one of the more flexible roles on the ship and as such may receive other menial tasks from your superiors."

/datum/job/logistics/tech/set_spawn_positions(var/count)
	spawn_positions = ot_slot_formula(count)

/datum/job/logistics/tech/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = ot_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/logistics/tech, list(
	JOB_ENGINEER_ROLES = 1 HOURS
))

/obj/effect/landmark/start/tech
	name = JOB_ORDNANCE_TECH
	job = /datum/job/logistics/tech
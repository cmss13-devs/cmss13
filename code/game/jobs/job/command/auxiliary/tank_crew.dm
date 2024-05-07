/datum/job/command/tank_crew
	title = JOB_CREWMAN
	total_positions = 2
	spawn_positions = 2
	allow_additional = 1
	scaled = 0
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/tank
	entry_message_body = "<a href='"+URL_WIKI_VC_GUIDE+"'>Your job is to operate and maintain the ship's armored vehicles.</a> You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."

AddTimelock(/datum/job/command/tank_crew, list(
	JOB_SQUAD_ROLES = 10 HOURS,
	JOB_ENGINEER_ROLES = 5 HOURS
))


/datum/job/logistics/tanktech/set_spawn_positions(count)
	spawn_positions = tank_crew_slot_formula(count)

/datum/job/logistics/tanktech/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = tank_crew_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/tank_crew
	name = JOB_CREWMAN
	job = /datum/job/command/tank_crew

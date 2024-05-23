/datum/job/command/vehicle_crewmen
	title = JOB_TANKCREW
	total_positions = 2
	spawn_positions = 2
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the acting commanding officer"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm/tank
	entry_message_body = "Your job is to operate and maintain the ship's armored vehicles. </a> You are in charge of representing the armored presence amongst the marines during the operation, as well as maintaining and repairing your own vehicles."

/datum/job/command/vehicle_crewmen/set_spawn_positions(count)
	spawn_positions = tank_crew_slot_formula(length(GLOB.clients))

/datum/job/command/vehicle_crewmen/get_total_positions(latejoin = FALSE)
	var/positions = spawn_positions
	if(!latejoin)
		total_positions_so_far = positions
		return positions

	positions = tank_crew_slot_formula(length(GLOB.clients))
	if(positions > total_positions_so_far)
		total_positions_so_far = positions
		return positions
		positions = total_positions_so_far
		return positions

/obj/effect/landmark/start/vehicle_crewmen
	name = JOB_TANKCREW
	job = /datum/job/command/vehicle_crewmen

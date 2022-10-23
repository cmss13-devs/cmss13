/datum/job/command/ship_marine
	title = JOB_SHIP_MARINE
	total_positions = 5
	spawn_positions = 5
	allow_additional = TRUE
	scaled = TRUE
	selection_class = "job_shp_m"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ship_marine/standard
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='"+URL_WIKI_LAW+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. You are a ship marine, just another set of hands for the corps. Your duty is to protect and maintain the security of your assigned vessel, keep order via marine law, repel boarders, put down mutinies, and defend the landing zone during operations. Ooh-rah-to-ashes marine."

/datum/job/command/ship_marine/set_spawn_positions(var/count)
	spawn_positions = ship_marine_slot_formula(count)

/datum/job/command/ship_marine/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = ship_marine_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/ship_marine
	name = JOB_SHIP_MARINE
	job = /datum/job/command/ship_marine

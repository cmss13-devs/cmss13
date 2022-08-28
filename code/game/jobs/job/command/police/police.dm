/datum/job/command/ship_marine
	title = JOB_SHIP_MARINE
	total_positions = 5
	spawn_positions = 5
	allow_additional = TRUE
	scaled = TRUE
	selection_class = "job_shp_m"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ship_marine/standard
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='"+URL_WIKI_LAW+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"

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

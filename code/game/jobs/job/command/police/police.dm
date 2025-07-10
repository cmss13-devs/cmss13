//Military Police
/datum/job/command/police
	title = JOB_POLICE
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_police/mp
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You</a> are held by a higher standard and are required to obey not only the server rules but the <a href='"+LAW_PLACEHOLDER+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"

/datum/job/command/police/set_spawn_positions(count)
	spawn_positions = mp_slot_formula(count)

/datum/job/command/police/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = mp_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

/obj/effect/landmark/start/police
	name = JOB_POLICE
	icon_state = "mp_spawn"
	job = /datum/job/command/police

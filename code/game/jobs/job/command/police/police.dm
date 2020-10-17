//Military Police
/datum/job/command/police
	title = JOB_POLICE
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Military Police (MP)"

/datum/job/command/police/set_spawn_positions(var/count)
	spawn_positions = mp_slot_formula(count)

/datum/job/command/police/get_total_positions(var/latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = mp_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	return positions


/datum/job/command/police/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='[URL_WIKI_LAW]'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"
	return ..()

AddTimelock(/datum/job/command/police, list(
	JOB_SQUAD_ROLES = 10 HOURS
))
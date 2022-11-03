/datum/job/command/cadet_police
	title = JOB_POLICE_CADET
	total_positions = 2
	spawn_positions = 2
	allow_additional = 0
	scaled = 0
	selection_class = "job_mp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_police/mp_cadet
	entry_message_body = "<a href='"+URL_WIKI_MPC_GUIDE+"'>You</a> are held by a higher standard and are required to obey not only the server rules but the <a href='"+URL_WIKI_LAW+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. Your primary job is to maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep!"



AddTimelock(/datum/job/command/cadet_police, list(
	JOB_SQUAD_ROLES = 10 HOURS
))

/obj/effect/landmark/start/cadet_police
	name = JOB_POLICE_CADET
	job = /datum/job/command/cadet_police

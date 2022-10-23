/datum/job/command/master_at_arms
	title = JOB_SHIP_MASTER_AT_ARMS
	selection_class = "job_shp_mat"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/ship_marine/master_at_arms
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='"+URL_WIKI_LAW+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. You lead the Ship Marines, ensure they keep the peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"

AddTimelock(/datum/job/command/master_at_arms, list(
	JOB_SHIP_MARINE_ROLES = 15 HOURS,
	JOB_COMMAND_ROLES = 5 HOURS
))

/obj/effect/landmark/start/warrant
	name = JOB_SHIP_MASTER_AT_ARMS
	job = /datum/job/command/master_at_arms

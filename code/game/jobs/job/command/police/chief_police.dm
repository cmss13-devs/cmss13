//Chief MP
/datum/job/command/warrant
	title = JOB_CHIEF_POLICE
	selection_class = "job_cmp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT|ROLE_ADD_TO_MODE
	gear_preset = "USCM Chief MP (CMP)"

/datum/job/command/warrant/generate_entry_message(mob/living/carbon/human/H)
	entry_message_body = "You are held by a higher standard and are required to obey not only the server rules but the <a href='[URL_WIKI_LAW]'>Marine Law</a>. Failure to do so may result in a job ban or server ban. You lead the Military Police, ensure your officers maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"
	return ..()

AddTimelock(/datum/job/command/warrant, list(
	JOB_POLICE_ROLES = 10 HOURS,
	JOB_COMMAND_ROLES = 5 HOURS
))
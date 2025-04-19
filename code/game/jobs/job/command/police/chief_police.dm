//Chief MP
/datum/job/command/warrant
	title = JOB_CHIEF_POLICE
	selection_class = "job_cmp"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_police/cmp
	entry_message_body = "<a href='"+WIKI_PLACEHOLDER+"'>You</a> are held by a higher standard and are required to obey not only the server rules but the <a href='"+LAW_PLACEHOLDER+"'>Marine Law</a>. Failure to do so may result in a job ban or server ban. You lead the Military Police, ensure your officers maintain peace and stability aboard the ship. Marines can get rowdy after a few weeks of cryosleep! In addition, you are tasked with the security of high-ranking personnel, including the command staff. Keep them safe!"
	var/mob/living/carbon/human/active_cmp = null;

/datum/job/command/warrant/generate_entry_conditions(mob/living/cmp, whitelist_status)
	. = ..()
	active_cmp = cmp
	RegisterSignal(cmp, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_cmp))

/datum/job/command/warrant/proc/cleanup_active_cmp(mob/cmp)
	SIGNAL_HANDLER
	active_cmp = null

/datum/job/command/warrant/get_active_player_on_job()
	return active_cmp

AddTimelock(/datum/job/command/warrant, list(
	JOB_POLICE_ROLES = 15 HOURS,
	JOB_COMMAND_ROLES = 5 HOURS
))

/obj/effect/landmark/start/warrant
	name = JOB_CHIEF_POLICE
	icon_state = "cmp_spawn"
	job = /datum/job/command/warrant

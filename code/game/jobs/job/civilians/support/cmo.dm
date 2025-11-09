//CMO
/datum/job/civilian/professor
	title = JOB_CMO
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Commander and the Unites States Colonial Marines High Command"
	selection_class = "job_cmo"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/cmo
	entry_message_body = "As the primary representative of the medical knowledge and practice onboard this vessel, your job is to <a href='"+WIKI_PLACEHOLDER+"'>supervise the medical and research teams and ensure that they are well behaved and coordinated</a>. Your authority is ample, even though your real knowledge is not necessarily so, and you should have this in mind when supervising your subordinates. You answer to the Commander and, if necessity call you to take the ship's lead, High Command. You are also encouraged to fill the gaps where your teams are innefective or understaffed."
	var/mob/living/carbon/human/active_cmo

/datum/job/civilian/professor/generate_entry_conditions(mob/living/cmo, whitelist_status)
	. = ..()
	active_cmo = cmo
	RegisterSignal(cmo, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_cmo))

/datum/job/civilian/professor/proc/cleanup_active_cmo(mob/cmo)
	SIGNAL_HANDLER
	active_cmo = null

/datum/job/civilian/professor/get_active_player_on_job()
	return active_cmo

AddTimelock(/datum/job/civilian/professor, list(
	JOB_DOCTOR_ROLES = 10 HOURS,
	JOB_MEDIC_ROLES = 10 HOURS,
	JOB_RESEARCH_ROLES = 5 HOURS,
))

/obj/effect/landmark/start/professor
	name = JOB_CMO
	icon_state = "cmo_spawn"
	job = /datum/job/civilian/professor

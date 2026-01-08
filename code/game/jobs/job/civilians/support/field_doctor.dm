
/datum/job/civilian/field_doctor
	title = JOB_FIELD_DOCTOR
	total_positions = 1
	spawn_positions = 1
	allow_additional = TRUE
	scaled = TRUE
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/field_doctor
	entry_message_body = "You're a commissioned officer of the USCM. <a href='"+WIKI_PLACEHOLDER+"'>You are a doctor specialized in field medicine and surgery.</a> Your primary job is to deploy with your fellow marines, medicate, and operate on the wounded within the safety of your FOB tent. You must stay onboard the Almayer until your superior says it is safe to deploy, after the FOB is secured, and there is least one other doctor on the ship. You are still a doctor, so if you are waiting for deployment, it is your responsibility to assist other doctors in surgery and chembay prep."
	var/mob/living/carbon/human/active_field_doctor

/datum/job/civilian/field_doctor/generate_entry_conditions(mob/living/field_doctor, whitelist_status)
	. = ..()
	active_field_doctor = field_doctor
	RegisterSignal(field_doctor, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_active_field_doctor))

/datum/job/civilian/field_doctor/proc/cleanup_active_field_doctor(mob/field_doctor)
	SIGNAL_HANDLER
	active_field_doctor = null

/datum/job/civilian/field_doctor/get_active_player_on_job()
	return active_field_doctor

AddTimelock(/datum/job/civilian/field_doctor, list(
	JOB_DOCTOR_ROLES = 5 HOURS
))

/obj/effect/landmark/start/field_doctor
	name = JOB_FIELD_DOCTOR
	icon_state = "field_doc_spawn"
	job = /datum/job/civilian/field_doctor

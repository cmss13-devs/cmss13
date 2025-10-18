
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
	entry_message_body = "You're a commissioned officer of the USCM. <a href='"+WIKI_PLACEHOLDER+"'>You are a doctor specialized in field medicine and surgery.</a> Your primary job is to deploy with the marines and keep them healthy and strong by assessing and treating patients with medications and surgery based on case severity in the safety of your FOB tent. You must stay onboard the Almayer medical bay until the FOB is secured, and you also must remain there if there are no other medical personnel on board. Your superiors may delay your deployment to the field. In the meantime, grab your tent, stash everything you can in your personal crate, and assist other doctors in meeting chemical quotas and setting up the surgery bay. If you do not know what you are doing, mentorhelp so a mentor can assist you."
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

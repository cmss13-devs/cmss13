
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
	entry_message_body = "You are a <a href='"+WIKI_PLACEHOLDER+"'>Field Doctor</a> tasked with keeping the marines healthy and strong in the field, usually in the form of surgery. You must stay onboard the Almayer medical bay if there are no other doctors present and until the FOB is secured. Your superiors may also delay your deployment to the field."

AddTimelock(/datum/job/civilian/field_doctor, list(
	JOB_MEDIC_ROLES = 5 HOURS
))

/obj/effect/landmark/start/field_doctor
	name = JOB_FIELD_DOCTOR
	icon_state = "field_doc_spawn"
	job = /datum/job/civilian/field_doctor

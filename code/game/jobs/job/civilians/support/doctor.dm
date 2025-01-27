//job options for doctors surgeon pharmacy technician(preparation of medecine and distribution)

#define DOCTOR_VARIANT "Doctor"
#define SURGEON_VARIANT "Surgeon"

// Doctor
/datum/job/civilian/doctor
	title = JOB_DOCTOR
	spawn_positions = 5
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor

	// job option
	job_options = list(DOCTOR_VARIANT = "Doc", SURGEON_VARIANT = "Sur")
	/// If this job is a doctor variant of the doctor role

	players_per_position = 25
	minimal_open_positions = 4
	maximal_open_positions = 6
	var/doctor = TRUE

//check the job option. and change the gear preset
/datum/job/civilian/doctor/handle_job_options(option)
	if(option != SURGEON_VARIANT)
		doctor = TRUE
		gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor
	else
		doctor = FALSE
		gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor/surgeon

//check what job option you took and generate the corresponding the good texte.
/datum/job/civilian/doctor/generate_entry_message(mob/living/carbon/human/H)
	if(doctor)
		. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor and tasked with keeping the marines healthy and strong, usually in the form of surgery.</a> You are a jack of all trades in medicine: you can medicate, perform surgery and produce pharmaceuticals. If you do not know what you are doing, mentorhelp so a mentor can assist you."}
	else
		. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a surgeon and tasked with keeping the marines healthy and strong, usually in the form of surgery.</a> You are a doctor that specializes in surgery, but you are also very capable in pharmacy and triage. If you do not know what you are doing, mentorhelp so a mentor can assist you."}

AddTimelock(/datum/job/civilian/doctor, list(
	JOB_MEDIC_ROLES = 1 HOURS
))

/obj/effect/landmark/start/doctor
	name = JOB_DOCTOR
	icon_state = "doc_spawn"
	job = /datum/job/civilian/doctor

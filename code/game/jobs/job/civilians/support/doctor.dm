//job options for doctors surgeon pharmacy technician(preparation of medecine and distribution)

#define DOCTOR_VARIANT JOB_DOCTOR_RU	// SS220 EDIT TRANSLATE
#define SURGEON_VARIANT JOB_SURGEON_RU	// SS220 EDIT TRANSLATE

// Doctor
/datum/job/civilian/doctor
	title = JOB_DOCTOR
	total_positions = 5
	spawn_positions = 5
	allow_additional = 1
	scaled = 1
	supervisors = "the chief medical officer"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor

	// job option
	job_options = list(DOCTOR_VARIANT = "Док", SURGEON_VARIANT = "Хир")
	/// If this job is a doctor variant of the doctor role
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

/datum/job/civilian/doctor/set_spawn_positions(count)
	spawn_positions = doc_slot_formula(count)

/datum/job/civilian/doctor/get_total_positions(latejoin = 0)
	var/positions = spawn_positions
	if(latejoin)
		positions = doc_slot_formula(get_total_marines())
		if(positions <= total_positions_so_far)
			positions = total_positions_so_far
		else
			total_positions_so_far = positions
	else
		total_positions_so_far = positions
	return positions

AddTimelock(/datum/job/civilian/doctor, list(
	JOB_MEDIC_ROLES = 1 HOURS
))

/obj/effect/landmark/start/doctor
	name = JOB_DOCTOR
	icon_state = "doc_spawn"
	job = /datum/job/civilian/doctor

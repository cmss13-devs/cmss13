//job options for doctors surgeon pharmacy technician(preparation of medecine and distribution)

#define DOCTOR_VARIANT "Doctor"
#define SURGEON_VARIANT "Surgeon"
#define PHARMACIST_VARIANT "Pharmaceutical Chemist"
#define MORTICIAN_VARIANT "Mortician"

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
	job_options = list(DOCTOR_VARIANT = "Doc", SURGEON_VARIANT = "Sur", PHARMACIST_VARIANT = "Phm", MORTICIAN_VARIANT = "Mor")
	/// The doctor variant of the doctor role that was selected in handle_job_options
	var/doctor_variant

//check the job option. and change the gear preset
/datum/job/civilian/doctor/handle_job_options(option)
	doctor_variant = option
	switch(option)
		if(SURGEON_VARIANT)
			gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor/surgeon
		if(PHARMACIST_VARIANT)
			gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor/pharmacist
		if(MORTICIAN_VARIANT)
			gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor/mortician
		else
			gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor

//check what job option you took and generate the corresponding the good texte.
/datum/job/civilian/doctor/generate_entry_message(mob/living/carbon/human/target)
	switch(doctor_variant)
		if(SURGEON_VARIANT)
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor specialized in surgery and tasked with keeping the marines healthy and strong, usually in the form of manual and instrumental operations.</a>Aside from surgery, you are very capable in pharmacy, triage, and performing autopsies, if the medical bay is understaffed in other departments. If you do not know what you are doing, mentorhelp so a mentor can assist you."}
		if(PHARMACIST_VARIANT)
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor with a specialty in pharmaceutical chemistry and tasked with providing groundside marines and the medical bay with medicine and chemicals </a>You can also medicate, perform surgery, and perform autopsies, if the medical bay is understaffed in other departments. If you do not know what you are doing, mentorhelp so a mentor can assist you."}
		if(MORTICIAN_VARIANT)
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor with a specialty in mortuary science and tasked with transporting, bagging, tagging, and identifying the cause of death of the deceased.</a>You can also medicate, perform surgery, and produce pharmaceuticals, if the medical bay is understaffed in other departments. If you do not know what you are doing, mentorhelp so a mentor can assist you."}
		else
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor and tasked with keeping the marines healthy and strong. </a> You are a jack of all trades in medicine: you can medicate, perform surgery, make autopsies, and produce pharmaceuticals. If the medical bay is understaffed in other departments, it is your job to fill those roles as you needed. If you do not know what you are doing, mentorhelp so a mentor can assist you."}

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

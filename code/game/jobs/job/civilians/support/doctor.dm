//Job options for doctors based on their specialty. They can all manufacture chemicals, administer medication, and operate on patients, but the variants have specialities that they prioritize in.

#define DOCTOR_VARIANT "Doctor" // "I do not have a specialty; I go where I am needed most."
#define PHARMACIST_VARIANT "Pharmaceutical Physician" // "I specialize in chemistry and medicine."
#define SURGEON_VARIANT "Surgeon" // "I specialize in surgery and triage."

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
	job_options = list(DOCTOR_VARIANT = "Doc", PHARMACIST_VARIANT = "Phm", SURGEON_VARIANT = "Sur")
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
		else
			gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor

//check what job option you took and generate the corresponding the good texte.
/datum/job/civilian/doctor/generate_entry_message(mob/living/carbon/human/target)
	switch(doctor_variant)
		if(SURGEON_VARIANT)
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor with a special interest in surgery.</a> Your primary job is keeping marines healthy and strong by fixing broken bones, blood vessels, and organs and performing foreign object extractions based on case severity. You are also very capable in medicine and pharmacology; if the pharmacy and triage bays are understaffed, and you have nobody left to operate on, it is also your job to develop chemicals and medicate patients. If you do not know what you are doing, mentorhelp so a mentor can assist you."}
		if(PHARMACIST_VARIANT)
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor with a special interest in chemistry and medicine.</a> Your primary job is providing the medical bay and marines with medicine and chemicals, and your secondary job is administering these medications to patients based on case severity. You are also very capable in surgery; if there are not enough doctors to operate on patients after you have met your quota, you must head to the surgery bay. If you do not know what you are doing, mentorhelp so a mentor can assist you."}
		else
			. = {"You're a commissioned officer of the USCM. <a href='[generate_wiki_link()]'>You are a doctor.</a> You are not specialized in any department, but you are nonetheless a jack of all trades with extensive knowledge in pharmacology, medicine, triage, and surgery. Your primary job is to assess and treat patients with medicine based on case severity, but you are also responsible for manufacturing chemicals and operating on patients if the pharmacy and surgery bays are understaffed. If you do not know what you are doing, mentorhelp so a mentor can assist you."}

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

/datum/job/civilian/doctor/generate_entry_conditions(mob/living/M, whitelist_status)
	. = ..()
	if(!islist(GLOB.marine_officers[JOB_DOCTOR]))
		GLOB.marine_officers[JOB_DOCTOR] = list()
	GLOB.marine_officers[JOB_DOCTOR] += M
	RegisterSignal(M, COMSIG_PARENT_QDELETING, PROC_REF(cleanup_leader_candidate))

/datum/job/civilian/doctor/proc/cleanup_leader_candidate(mob/M)
	SIGNAL_HANDLER
	GLOB.marine_officers[JOB_DOCTOR] -= M

/obj/effect/landmark/start/doctor
	name = JOB_DOCTOR
	icon_state = "doc_spawn"
	job = /datum/job/civilian/doctor

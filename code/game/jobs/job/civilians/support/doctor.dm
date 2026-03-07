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
	supervisors = "the Chief Medical Officer and the Commander"
	selection_class = "job_doctor"
	flags_startup_parameters = ROLE_ADD_TO_DEFAULT
	gear_preset = /datum/equipment_preset/uscm_ship/uscm_medical/doctor

	// job option
	job_options = list(DOCTOR_VARIANT = "Doc", PHARMACIST_VARIANT = "Pharm", SURGEON_VARIANT = "Surg")
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
			. = {"As a surgeon, your job inclines much more to <a href='[generate_wiki_link()]'>surgically operating patients</a> than any other task inside your workspace. Fix broken bones, blood vessels, organs and perform all kinds of extractions based on case severity. Remember to coordinate with your peers inside and outside of surgery, nothing is more helpful than a well coordinated extra pair of hands. You still, though, have the same skills as a doctor, and you should be using that to fill the gaps within your team where needed. If you need help regarding what you should be doing, be sure to ask the Chief Medical Officer."}
		if(PHARMACIST_VARIANT)
			. = {"You are a pharmacist, and your job is to <a href='[generate_wiki_link()]'>provide to medical personnel the drugs they need to do their work proper</a>. Coordinate with the research team and make sure their newly developed chemicals are not being wasted. You still, though, have the same skills as a doctor, and you should be using that to fill the gaps within your team where needed. If you need help regarding what you should be doing, be sure to ask the Chief Medical Officer."}
		else
			. = {"As a doctor, you should consider yourself a <a href='[generate_wiki_link()]'>jack of all trades within the medical department, with knowledge in medicine, triage, surgery and pharmacology</a>. Your responsabilities are vast and you should be making sure that you are coordinating well with your peers. If you need help regarding what you should be doing, be sure to ask the Chief Medical Officer."}

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

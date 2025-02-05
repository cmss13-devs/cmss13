//job options for doctors surgeon pharmacy technician(preparation of medecine and distribution)

#define DOCTOR_VARIANT "Доктор"	// SS220 EDIT TRANSLATE
#define SURGEON_VARIANT "Хирург"	// SS220 EDIT TRANSLATE

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
	job_options = list(DOCTOR_VARIANT = "Док", SURGEON_VARIANT = "Хир")	// SS220 EDIT TRANSLATE
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
		. = {"Вы уполномоченный офицер ККМП. <a href='[generate_wiki_link()]'>Вы врач и ваша задача — поддерживать здоровье и силу морпехов, обычно в качестве хирурга.</a> Вы мастер на все руки в медицине: вы можете лечить, делать операции и производить фармацевтические препараты. Если вы не знаете, что делаете, запросите наставника или mentorhelp, чтобы вам могли помочь."}
	else
		. = {"Вы уполномоченный офицер ККМП. <a href='[generate_wiki_link()]'>Вы хирург и ваша задача — поддерживать здоровье и силу морпехов, обычно в качестве хирурга.</a> Вы врач, специализирующийся на хирургии, но вы также очень способны в фармацевтике и сортировке. Если вы не знаете, что делаете, запросите наставника или mentorhelp, чтобы вам могли помочь."}

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

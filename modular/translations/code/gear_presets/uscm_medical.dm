/datum/equipment_preset/uscm_ship/uscm_medical/cmo
	//name = "USCM Chief Medical Officer (CMO)"
	assignment = JOB_CMO_RU

/datum/equipment_preset/uscm_ship/uscm_medical/doctor
	//name = "USCM Doctor"
	assignment = JOB_DOCTOR_RU

/datum/equipment_preset/uscm_ship/uscm_medical/doctor/surgeon
	//name = "USCM Surgeon"
	assignment = JOB_SURGEON_RU

/datum/equipment_preset/uscm_ship/uscm_medical/field_doctor
	// name = "USCM Field Doctor"
	assignment = JOB_FIELD_DOCTOR_RU
	role_comm_title = "Пол. Врач"

/datum/equipment_preset/uscm_ship/uscm_medical/nurse
	//name = "USCM Nurse"
	assignment = JOB_NURSE_RU

/datum/equipment_preset/uscm_ship/uscm_medical/nurse/load_id(mob/living/carbon/human/new_human, client/mob_client)
	if (new_human.gender == MALE)
		assignment = JOB_NURSE_RU_MALE
	else if(new_human.gender == FEMALE)
		assignment = JOB_NURSE_RU_FEMALE
	else
		assignment = initial(assignment)
	. = ..()

/datum/equipment_preset/uscm_ship/uscm_medical/researcher
	//name = "USCM Researcher"
	assignment = JOB_RESEARCHER_RU

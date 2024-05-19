// mob ref is a failsafe, ideally we just access through the id.
/proc/retrieve_record(record_id_ref = null, mob_name = null, mob_ref = null, record_type = RECORD_TYPE_GENERAL)
	if(!record_id_ref && !mob_name && !mob_ref)
		return

	var/datum/datacore/database = GLOB.data_core
	if(!database)
		return // should never happen but who knows.

	var/datum/data/record/retrieved_record = null
	var/list/selected_record_type = null

	switch(record_type)
		if(RECORD_TYPE_GENERAL)
			selected_record_type = database.general
		if(RECORD_TYPE_SECURITY)
			selected_record_type = database.security
		if(RECORD_TYPE_MEDICAL)
			selected_record_type = database.medical
		if(RECORD_TYPE_STATIC)
			selected_record_type = database.locked
		else
			return
	if(record_id_ref)
		retrieved_record = selected_record_type[record_id_ref]
	else
		for(var/record_id_query in selected_record_type)
			var/datum/data/record/record = selected_record_type[record_id_query]
			if(record.fields[MOB_NAME] == mob_name || record.fields[MOB_WEAKREF] == mob_ref)
				retrieved_record = record
				break

	return retrieved_record

/proc/insert_record_stat(record_id_ref = null, mob_name = null, mob_ref = null, record_type = RECORD_TYPE_GENERAL, stat_type = null, new_stat = null)
	if(!stat_type || !new_stat)
		return FALSE

	var/datum/data/record/retrieved_record = retrieve_record(record_id_ref, mob_name, mob_ref, record_type)
	if(!retrieved_record)
		return FALSE
	retrieved_record.fields[stat_type] = new_stat

	return TRUE

/proc/create_general_record(mob/living/carbon/human/person)
	var/datum/data/record/general_record = new()
	general_record.fields[MOB_NAME] = person.real_name ?  person.real_name : "Unassigned"
	general_record.name = person.real_name ? person.real_name : "New Record"
	general_record.fields[MOB_SHOWN_RANK] = person.job ? person.job : "Unassigned"  // yes they are the same at the start, but this can change depending on an alt title.
	general_record.fields[MOB_REAL_RANK] = person.job ? person.job : "Unassigned"
	general_record.fields[MOB_SEX] = person.gender ? person.gender : "Unknown"
	general_record.fields[MOB_SQUAD] = person.assigned_squad ? person.assigned_squad.name : null
	general_record.fields[MOB_AGE] = person.age ? person.age : "Unknown"
	general_record.fields[MOB_HEALTH_STATUS] = MOB_STAT_HEALTH_ACTIVE // always starts as active
	general_record.fields[MOB_MENTAL_STATUS] = MOB_STAT_MENTAL_STATUS_STABLE // debatable, haha.
	general_record.fields[MOB_SPECIES] = person?.get_species()
	general_record.fields[MOB_ORIGIN] = person.origin ? person.origin :"Unknown"
	general_record.fields[MOB_SHOWN_FACTION] = person.personal_faction ? person.personal_faction : "Unknown"
	general_record.fields[MOB_REAL_FACTION] = person.faction ? person.faction : "Unknown"
	general_record.fields[MOB_RELIGION] = person.religion ? person.religion : "Unknown"
	general_record.fields[MOB_WEAKREF] = WEAKREF(person)
	general_record.fields[MOB_GENERAL_NOTES] = person.gen_record && !jobban_isbanned(person, "Records") ? person.gen_record : "No notes found."
	GLOB.data_core.general[person.record_id_ref] = general_record

/proc/create_security_record(mob/living/carbon/human/person)
	var/datum/data/record/security_record = new()
	security_record.fields[MOB_NAME] = person.name ? person.name : "Unknown"
	security_record.name = text("Security Record")
	security_record.fields[MOB_CRIMINAL_STATUS] = MOB_STAT_CRIME_NONE
	security_record.fields[MOB_INCIDENTS] = list()
	security_record.fields[MOB_WEAKREF] = WEAKREF(person)
	security_record.fields[MOB_SECURITY_NOTES] = person.sec_record  && !jobban_isbanned(person, "Records") ? person.sec_record : "No notes found."
	GLOB.data_core.security[person.record_id_ref] = security_record

/proc/create_medical_record(mob/living/carbon/human/person)
	var/datum/data/record/medical_record = new()
	medical_record.fields[MOB_NAME] = person.real_name ? person.real_name : "Unknown"
	medical_record.name = person.real_name ? person.real_name : "New Medical Record"
	medical_record.fields[MOB_BLOOD_TYPE] = person.b_type ? person.b_type : "Unknown"
	medical_record.fields[MOB_DISABILITIES] = "None"
	medical_record.fields[MOB_AUTOPSY_NOTES] = null
	medical_record.fields[MOB_MEDICAL_NOTES] = person.med_record && !jobban_isbanned(person, "Records") ? person.med_record : "No notes found."
	medical_record.fields[MOB_DISEASES] = "None"
	medical_record.fields[MOB_CAUSE_OF_DEATH] = "None"
	medical_record.fields[MOB_AUTOPSY_SUBMISSION] = FALSE
	medical_record.fields[MOB_LAST_SCAN_TIME] = null
	medical_record.fields[MOB_LAST_SCAN_RESULT] = "No scan data on record"
	medical_record.fields[MOB_AUTODOC_DATA] = list()
	medical_record.fields[MOB_AUTODOC_MANUAL] = list()
	medical_record.fields[MOB_WEAKREF] = WEAKREF(person)
	GLOB.data_core.medical[person.record_id_ref] = medical_record

/proc/create_static_character_record(mob/living/carbon/human/person)
	var/datum/data/record/record_locked = new()
	record_locked.fields[RECORD_UNIQUE_ID] = md5("[person.real_name][person.job]")
	record_locked.fields[MOB_NAME] = person.real_name
	record_locked.name = person.real_name
	record_locked.fields[MOB_REAL_RANK] = person.job
	record_locked.fields[MOB_AGE] = person.age
	record_locked.fields[MOB_SEX] = person.gender
	record_locked.fields[MOB_BLOOD_TYPE] = person.b_type
	record_locked.fields[MOB_SPECIES] = person.get_species()
	record_locked.fields[MOB_ORIGIN] = person.origin
	record_locked.fields[MOB_SHOWN_FACTION] = person.personal_faction
	record_locked.fields[MOB_RELIGION] = person.religion
	record_locked.fields[MOB_WEAKREF] = WEAKREF(person)
	record_locked.fields[MOB_EXPLOIT_RECORD] = !jobban_isbanned(person, "Records") ? person.exploit_record : "No additional information acquired"
	GLOB.data_core.locked[person.record_id_ref] = record_locked

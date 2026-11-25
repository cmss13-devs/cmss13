/proc/get_all_jobs_titles()
	var/all_jobs_titles[] = new
	var/all_datums[] = typesof(/datum/job) - list(/datum/job)
	var/datum/job/jobdatum
	for(var/jobtype in all_datums)
		jobdatum = new jobtype
		all_jobs_titles += jobdatum.title
	return all_jobs_titles

/proc/get_all_jobs()
	var/list/all_jobs = list()
	var/list/all_jobtypes = typesof(/datum/job) - list(/datum/job)
	for(var/jobtype in all_jobtypes)
		all_jobs += new jobtype
	return all_jobs

/proc/get_all_centcom_jobs() return list()

/proc/get_all_job_icons() return GLOB.joblist + list("Prisoner")//For all existing HUD icons

/proc/get_actual_job_name(mob/M)
	if(!M)
		return null

	var/job_name = M.job
	return job_name

//Same order as on the crew manifest
/proc/get_manifest_ordered_jobs(list/job_names)
	var/list/ordered_jobs = GLOB.ROLES_CIC + GLOB.ROLES_CIC_ANTAG
	ordered_jobs += GLOB.ROLES_AUXIL_SUPPORT + GLOB.ROLES_AUXIL_SUPPORT_ANTAG
	ordered_jobs += GLOB.ROLES_MARINES + GLOB.ROLES_MARINES_ANTAG
	ordered_jobs += GLOB.ROLES_POLICE + GLOB.ROLES_POLICE_ANTAG
	ordered_jobs += GLOB.ROLES_ENGINEERING + GLOB.ROLES_ENGINEERING_ANTAG
	ordered_jobs += GLOB.ROLES_REQUISITION + GLOB.ROLES_REQUISITION_ANTAG
	ordered_jobs += GLOB.ROLES_MEDICAL + GLOB.ROLES_MEDICAL_ANTAG
	ordered_jobs += GLOB.ROLES_MISC + GLOB.ROLES_MISC_ANTAG
	ordered_jobs &= job_names
	ordered_jobs |= job_names
	return ordered_jobs
//Antag being the UPP
/proc/get_job_department(job_title)
	if((job_title in GLOB.ROLES_CIC) || (job_title in GLOB.ROLES_CIC_ANTAG))
		return "command"
	if((job_title in GLOB.ROLES_AUXIL_SUPPORT) || (job_title in GLOB.ROLES_AUXIL_SUPPORT_ANTAG))
		return "auxiliary"
	if((job_title in GLOB.ROLES_MARINES) || (job_title in GLOB.ROLES_MARINES_ANTAG))
		return "marines"
	if((job_title in GLOB.ROLES_POLICE) || (job_title in GLOB.ROLES_POLICE_ANTAG))
		return "security"
	if((job_title in GLOB.ROLES_ENGINEERING) || (job_title in GLOB.ROLES_ENGINEERING_ANTAG))
		return "engineering"
	if((job_title in GLOB.ROLES_REQUISITION) || (job_title in GLOB.ROLES_REQUISITION_ANTAG))
		return "requisitions"
	if((job_title in GLOB.ROLES_MEDICAL) || (job_title in GLOB.ROLES_MEDICAL_ANTAG))
		return "medical"
	if((job_title in GLOB.ROLES_MISC) || (job_title in GLOB.ROLES_MISC_ANTAG))
		return "miscellaneous"

/proc/is_job_leader(job_title)
	switch(job_title)
		if(JOB_CO, JOB_AUXILIARY_OFFICER, JOB_CHIEF_POLICE, JOB_CHIEF_ENGINEER, JOB_CHIEF_REQUISITION, JOB_CMO, JOB_WO_CO, JOB_WO_CHIEF_POLICE, JOB_WO_CHIEF_ENGINEER, JOB_WO_CHIEF_REQUISITION, JOB_WO_CMO, JOB_UPP_CO_OFFICER)
			return TRUE
		if(JOB_SQUAD_LEADER, JOB_WO_SQUAD_LEADER, JOB_UPP_LEADER)
			return TRUE
		if(JOB_SYNTH, JOB_WO_SYNTH, JOB_UPP_SUPPORT_SYNTH, JOB_UPP_COMBAT_SYNTH)
			return TRUE
	return FALSE

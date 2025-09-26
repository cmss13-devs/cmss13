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

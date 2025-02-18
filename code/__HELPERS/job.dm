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

/proc/get_marine_jobs()
	return list(
			JOB_CO,
			JOB_XO,
			JOB_SO,
			JOB_INTEL,
			JOB_CAS_PILOT,
			JOB_DROPSHIP_PILOT,
			JOB_DROPSHIP_CREW_CHIEF,
			JOB_TANK_CREW,
			JOB_CORPORATE_LIAISON,
			JOB_COMBAT_REPORTER,
			JOB_CHIEF_ENGINEER,
			JOB_ORDNANCE_TECH,
			JOB_MAINT_TECH,
			JOB_CHIEF_REQUISITION,
			JOB_CARGO_TECH,
			JOB_SQUAD_LEADER,
			JOB_SQUAD_ENGI,
			JOB_SQUAD_MEDIC,
			JOB_SQUAD_SPECIALIST,
			JOB_SQUAD_TEAM_LEADER,
			JOB_SQUAD_SMARTGUN,
			JOB_SQUAD_MARINE,
			JOB_CMO,
			JOB_RESEARCHER,
			JOB_DOCTOR,
			JOB_FIELD_DOCTOR,
			JOB_NURSE,
			JOB_POLICE,
			JOB_WARDEN,
			JOB_CHIEF_POLICE,
			JOB_WARDEN,
			JOB_SEA,
			JOB_MARINE
			)

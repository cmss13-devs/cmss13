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

//gets the actual job rank (ignoring alt titles)
//this is used solely for sechuds
/obj/proc/GetJobRealName()
	if (!istype(src,/obj/item/card/id)) return
	var/obj/item/card/id/I = src
	if(I.rank in GLOB.joblist) return I.rank
	if(I.assignment in GLOB.joblist) return I.assignment
	return "Unknown"

/proc/FindNameFromID(mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/card/id/I = H.wear_id
	if(istype(I)) return I.registered_name
	I = H.get_active_hand()
	if(istype(I)) return I.registered_name

/proc/get_all_job_icons() return GLOB.joblist + list("Prisoner")//For all existing HUD icons

/obj/proc/GetJobName() //Used in secHUD icon generation
	var/obj/item/card/id/I = src
	if(istype(I))
		var/job_icons = get_all_job_icons()
		var/centcom = get_all_centcom_jobs()

		if(I.assignment	in job_icons) 	return I.assignment//Check if the job has a hud icon
		if(I.rank in job_icons) 		return I.rank
		if(I.assignment	in centcom) 	return "Centcom"//Return with the NT logo if it is a Centcom job
		if(I.rank in centcom) 			return "Centcom"
	return "Unknown" //Return unknown if none of the above apply

/proc/get_actual_job_name(var/mob/M)
	if(!M)
		return null

	var/job_name = M.job
	return job_name

/proc/get_marine_jobs()
	return list(
			JOB_CO,
			JOB_XO,
			JOB_SO,
			JOB_PILOT,
			JOB_CREWMAN,
			JOB_CORPORATE_LIAISON,
			JOB_CHIEF_ENGINEER,
			JOB_ORDNANCE_TECH,
			JOB_CHIEF_REQUISITION,
			JOB_CARGO_TECH,
			JOB_SQUAD_LEADER,
			JOB_SQUAD_ENGI,
			JOB_SQUAD_MEDIC,
			JOB_SQUAD_SPECIALIST,
			JOB_SQUAD_RTO,
			JOB_SQUAD_SMARTGUN,
			JOB_SQUAD_MARINE,
			JOB_CMO,
			JOB_DOCTOR,
			JOB_RESEARCHER,
			JOB_POLICE,
			JOB_CHIEF_POLICE,
			JOB_SEA
			)

/proc/get_role_uniforms(rank)
	for(var/job_name in GLOB.gear_presets_list)
		var/datum/equipment_preset/job = GLOB.gear_presets_list[job_name]
		if(job.rank == rank)
			return job.uniform_sets

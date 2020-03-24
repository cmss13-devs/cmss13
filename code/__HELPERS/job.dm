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
	if(I.rank in joblist) return I.rank
	if(I.assignment in joblist) return I.assignment
	return "Unknown"

/proc/FindNameFromID(mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/card/id/I = H.wear_id
	if(istype(I)) return I.registered_name
	I = H.get_active_hand()
	if(istype(I)) return I.registered_name

/proc/get_all_job_icons() return joblist + list("Prisoner")//For all existing HUD icons

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
			JOB_INTEL,
			JOB_CORPORATE_LIAISON,
			JOB_CHIEF_ENGINEER,
			JOB_ORDNANCE_TECH,
			JOB_CHIEF_REQUISITION,
			JOB_REQUISITION,
			JOB_SQUAD_LEADER,
			JOB_SQUAD_ENGI,
			JOB_SQUAD_MEDIC,
			JOB_SQUAD_SPECIALIST,
			JOB_SQUAD_SMARTGUN,
			JOB_SQUAD_MARINE,
			JOB_CMO,
			JOB_DOCTOR,
			JOB_RESEARCHER,
			JOB_POLICE,
			JOB_CHIEF_POLICE,
			JOB_SEA
			)

/proc/get_paygrades(paygrade, size, gender)
	if(!paygrade) return
	switch(paygrade)
		if("C") . = size ? "" : "Civilian"
		if("CD") . = size ? "Dr. " : "Doctor"
		if("CCMO") . = size ? "Prof. " : "Professor"
		if("PMC1") . = size ? "SCE " : "Security Expert"
		if("PMC2S") . = size ? "SPS " : "Support Specialist"
		if("PMC2M") . = size ? "SPM " : "Medical Specialist"
		if("PMC3") . = size ? "ELR " : "Elite Responder"
		if("PMC4") . = size ? "TML " : "Team Leader"
		if("WY1") . = size ? (gender == "female" ? "Ms. " : "Mr. ") : "Junior Executive"
		if("E1") . = size ? "PVT " : "Private"
		if("E2") . = size ? "PFC " : "Private First Class"
		if("E3") . = size ? "LCPL " : "Lance Corporal"
		if("E4") . = size ? "CPL " : "Corporal"
		if("E5") . = size ? "SGT " : "Sergeant"
		if("E6") . = size ? "SSGT " : "Staff Sergeant"
		if("E7") . = size ? "SFC " : "Sergeant First Class"
		if("E8") . = size ? "GySGT " : "Gunnery Sergeant"
		if("E9") . = size ? "SGM " : "Sergeant Major"
		if("E9E") . = size ? "CSGM " : "Command Sergeant Major"
		if("O1") . = size ? "ENS " : "Ensign"
		if("O2") . = size ? "LT " : "Lieutenant"
		if("O3") . = size ? "LCDR " : "Lieutenant Commander"
		if("O4") . = size ? "CDR " : "Commander"
		if("O5") . = size ? "CPT " : "Captain"
		if("O5E") . = size ? "CDRE " : "Commodore"
		if("O6") . = size ? "RDML " : "Rear Admiral (Lower Half)"
		if("O7") . = size ? "RADM " : "Rear Admiral (Upper Half)"
		if("O8") . = size ? "VADM " : "Vice Admiral"
		if("O9") . = size ? "ADM " : "Admiral"
		if("O9E") . = size ? "SMR " : "Sky Marshal"
		else . = paygrade + " " //custom paygrade

/proc/get_rank_pins(paygrade)
	if(!paygrade) return null
	switch(paygrade)
		if("E1") . = /obj/item/clothing/accessory/ranks
		if("E2") . = /obj/item/clothing/accessory/ranks/e2
		if("E3") . = /obj/item/clothing/accessory/ranks/e3
		if("E4") . = /obj/item/clothing/accessory/ranks/e4
		if("E5") . = /obj/item/clothing/accessory/ranks/e5
		if("E6") . = /obj/item/clothing/accessory/ranks/e6
		if("E7") . = /obj/item/clothing/accessory/ranks/e7
		if("E8") . = /obj/item/clothing/accessory/ranks/e8
		if("E9") . = /obj/item/clothing/accessory/ranks/e9
		if("E9E") . = /obj/item/clothing/accessory/ranks/e9e
		if("O1") . = /obj/item/clothing/accessory/ranks/o1
		if("O2") . = /obj/item/clothing/accessory/ranks/o2
		if("O3") . = /obj/item/clothing/accessory/ranks/o3
		if("O4") . = /obj/item/clothing/accessory/ranks/o4
		if("O5") . = /obj/item/clothing/accessory/ranks/o5
		if("O5E") . = /obj/item/clothing/accessory/ranks/o5e
		if("O6") . = /obj/item/clothing/accessory/ranks/o6
		if("O7") . = /obj/item/clothing/accessory/ranks/o7
		if("O8") . = /obj/item/clothing/accessory/ranks/o8
		if("O9") . = /obj/item/clothing/accessory/ranks/o9
		if("O9E") . = /obj/item/clothing/accessory/ranks/o9e
		else . = null

/proc/get_role_uniforms(rank)
	for(var/job_name in gear_presets_list)
		var/datum/equipment_preset/job = gear_presets_list[job_name]
		if(job.rank == rank)
			return job.uniform_sets

/datum/entity/weapon_stats
	var/datum/entity/player
	var/list/niche_stats = list() //! Indexed list of /datum/entity/statistic, "Total Reloads" = number
	var/list/humans_killed = list() //! Indexed list of /datum/entity/statistic, "jobname2" = number
	var/list/xenos_killed = list() //! Indexed list of /datum/entity/statistic, "caste" = number
	var/name
	var/total_kills = 0
	var/total_hits
	var/total_shots
	var/total_shots_hit
	var/total_friendly_fire
	var/display_stat = TRUE

/datum/entity/weapon_stats/Destroy(force)
	player = null
	QDEL_LIST_ASSOC_VAL(niche_stats)
	QDEL_LIST_ASSOC_VAL(humans_killed)
	QDEL_LIST_ASSOC_VAL(xenos_killed)
	return ..()

/datum/entity/weapon_stats/proc/count_human_kill(job_name)
	if(!job_name)
		return
	if(!humans_killed["[job_name]"])
		var/datum/entity/statistic/N = new()
		N.name = job_name
		humans_killed["[job_name]"] = N
	var/datum/entity/statistic/S = humans_killed["[job_name]"]
	S.value++

/datum/entity/weapon_stats/proc/count_xeno_kill(caste)
	if(!caste)
		return
	if(!xenos_killed["[caste]"])
		var/datum/entity/statistic/N = new()
		N.name = caste
		xenos_killed["[caste]"] = N
	var/datum/entity/statistic/S = xenos_killed["[caste]"]
	S.value++

/datum/entity/weapon_stats/proc/count_niche_stat(niche_name, amount = 1)
	if(!niche_name)
		return
	if(!niche_stats["[niche_name]"])
		var/datum/entity/statistic/N = new()
		N.name = niche_name
		niche_stats["[niche_name]"] = N
	var/datum/entity/statistic/S = niche_stats["[niche_name]"]
	S.value += amount

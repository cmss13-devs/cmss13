/datum/entity/weapon_stats
	var/datum/entity/player = null // "deanthelis"
	var/list/niche_stats = list() // list of type /datum/entity/statistic, "Total Reloads" = number
	var/list/humans_killed = list() // list of type /datum/entity/statistic, "jobname2" = number
	var/list/xenos_killed = list() // list of type /datum/entity/statistic, "caste" = number
	var/name = null
	var/total_kills = 0
	var/total_hits = null
	var/total_shots = null
	var/total_shots_hit = null
	var/total_friendly_fire = null
	var/display_stat = TRUE

/datum/entity/weapon_stats/proc/count_human_kill(job_name)
	if(!job_name)
		return
	if(!humans_killed["[job_name]"])
		var/datum/entity/statistic/new_stat = new()
		new_stat.name = job_name
		humans_killed["[job_name]"] = new_stat
	var/datum/entity/statistic/stat = humans_killed["[job_name]"]
	stat.value++

/datum/entity/weapon_stats/proc/count_xeno_kill(caste)
	if(!caste)
		return
	if(!xenos_killed["[caste]"])
		var/datum/entity/statistic/new_stat = new()
		new_stat.name = caste
		xenos_killed["[caste]"] = new_stat
	var/datum/entity/statistic/stat = xenos_killed["[caste]"]
	stat.value++

/datum/entity/weapon_stats/proc/count_niche_stat(niche_name, amount = 1)
	if(!niche_name)
		return
	if(!niche_stats["[niche_name]"])
		var/datum/entity/statistic/new_stat = new()
		new_stat.name = niche_name
		niche_stats["[niche_name]"] = new_stat
	var/datum/entity/statistic/stat = niche_stats["[niche_name]"]
	stat.value += amount

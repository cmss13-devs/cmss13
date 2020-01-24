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

/datum/entity/weapon_stats/proc/count_human_kill(var/job_name)
	if(!job_name)
		return
	if(!humans_killed["[job_name]"])
		var/datum/entity/statistic/N = new()
		N.name = job_name
		humans_killed["[job_name]"] = N
	var/datum/entity/statistic/S = humans_killed["[job_name]"]
	S.value += 1

/datum/entity/weapon_stats/proc/count_xeno_kill(var/caste)
	if(!caste)
		return
	if(!xenos_killed["[caste]"])
		var/datum/entity/statistic/N = new()
		N.name = caste
		xenos_killed["[caste]"] = N
	var/datum/entity/statistic/S = xenos_killed["[caste]"]
	S.value += 1

/datum/entity/weapon_stats/proc/count_niche_stat(var/niche_name, var/amount = 1)
	if(!niche_name)
		return
	if(!niche_stats["[niche_name]"])
		var/datum/entity/statistic/N = new()
		N.name = niche_name
		niche_stats["[niche_name]"] = N
	var/datum/entity/statistic/S = niche_stats["[niche_name]"]
	S.value += amount

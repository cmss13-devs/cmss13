/datum/entity/player_stats
	var/datum/entity/player_entity/player = null // "mattatlas"
	var/total_kills = 0
	var/total_deaths = 0
	var/total_playtime = 0
	var/total_rounds_played = 0
	var/steps_walked = 0
	var/round_played = FALSE
	var/datum/entity/statistic/nemesis = null // "runner" = 3
	var/list/niche_stats = list() // list of type /datum/entity/statistic, "Total Executions" = number
	var/list/humans_killed = list() // list of type /datum/entity/statistic, "jobname2" = number
	var/list/xenos_killed = list() // list of type /datum/entity/statistic, "caste" = number
	var/list/death_list = list() // list of type /datum/entity/death_stats
	var/display_stat = TRUE

/datum/entity/player_stats/proc/get_playtime()
	return total_playtime

/datum/entity/player_stats/proc/count_personal_human_kill(var/job_name, var/cause, var/job)
	return

/datum/entity/player_stats/proc/count_personal_xeno_kill(var/job_name, var/cause, var/job)
	return

/datum/entity/player_stats/proc/count_human_kill(var/job_name, var/cause, var/job)
	if(!job_name)
		return
	if(!humans_killed["[job_name]"])
		var/datum/entity/statistic/N = new()
		N.name = job_name
		humans_killed["[job_name]"] = N
	var/datum/entity/statistic/S = humans_killed["[job_name]"]
	S.value += 1
	if(job)
		count_personal_human_kill(job_name, cause, job)
	total_kills += 1

/datum/entity/player_stats/proc/count_xeno_kill(var/caste, var/cause, var/job)
	if(!caste)
		return
	if(!xenos_killed["[caste]"])
		var/datum/entity/statistic/N = new()
		N.name = caste
		xenos_killed["[caste]"] = N
	var/datum/entity/statistic/S = xenos_killed["[caste]"]
	S.value += 1
	if(job)
		count_personal_xeno_kill(caste, cause, job)
	total_kills += 1

//*****************
//Mob Procs - death
//*****************

/datum/entity/player_stats/proc/recalculate_nemesis()
	var/list/causes = list()
	for(var/datum/entity/death_stats/stat_entity in death_list)
		if(!stat_entity.cause_name)
			continue
		causes["[stat_entity.cause_name]"] += 1
		if(!nemesis)
			nemesis = new()
			nemesis.name = stat_entity.cause_name
			nemesis.value = 1
			continue
		if(causes["[stat_entity.cause_name]"] > nemesis.value)
			nemesis.name = stat_entity.cause_name
			nemesis.value = causes["[stat_entity.cause_name]"]

/datum/entity/player_stats/proc/count_personal_death(var/job)
	return

/mob/proc/track_death_calculations()
	if(statistic_exempt || statistic_tracked)
		return
	if(round_statistics)
		round_statistics.recalculate_nemesis()
	if(mind && mind.player_entity)
		mind.player_entity.update_panel_data(round_statistics)
	statistic_tracked = TRUE

//*****************
//Mob Procs - kills
//*****************

/mob/proc/count_human_kill(var/job_name, var/cause)
	return

/mob/proc/count_xeno_kill(var/killed_caste, var/cause)
	return

/mob/proc/count_niche_stat(var/niche_name, var/amount = 1)
	return

//Human
/mob/living/carbon/human/count_human_kill(var/job_name, var/cause)
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/human/human_stats = mind.setup_human_stats()
	var/job_actual = get_actual_job_name(src)
	human_stats.count_human_kill(job_name, cause, job_actual)

/mob/living/carbon/human/count_xeno_kill(var/killed_caste, var/cause)
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/human/human_stats = mind.setup_human_stats()
	var/job_actual = get_actual_job_name(src)
	human_stats.count_xeno_kill(killed_caste, cause, job_actual)

/mob/living/carbon/human/count_niche_stat(var/niche_name, var/amount = 1, var/weapon_name)
	if(statistic_exempt || !mind)
		return
	var/job_actual = get_actual_job_name(src)
	var/datum/entity/player_stats/human/human_stats = mind.setup_human_stats()
	human_stats.count_niche_stat(niche_name, amount, job_actual, weapon_name)

//Xeno
/mob/living/carbon/Xenomorph/count_human_kill(var/job_name, var/cause)
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.count_human_kill(job_name, cause, caste_name)

/mob/living/carbon/Xenomorph/count_xeno_kill(var/killed_caste, var/cause)
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.count_xeno_kill(killed_caste, cause, caste_name)

/mob/living/carbon/Xenomorph/count_niche_stat(var/niche_name, var/amount = 1)
	if(statistic_exempt || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.count_niche_stat(niche_name, amount, caste_name)

//*****************
//Mob Procs - minor
//*****************

/datum/entity/player_stats/proc/count_personal_niche_stat(var/niche_name, var/amount = 1, var/job)
	return

/datum/entity/player_stats/proc/count_niche_stat(var/niche_name, var/amount = 1, var/job)
	if(!niche_name)
		return
	if(!niche_stats["[niche_name]"])
		var/datum/entity/statistic/N = new()
		N.name = niche_name
		niche_stats["[niche_name]"] = N
	var/datum/entity/statistic/S = niche_stats["[niche_name]"]
	S.value += amount
	if(job)
		count_personal_niche_stat(niche_name, amount, job)

/datum/entity/player_stats/proc/count_personal_steps_walked(var/job)
	return

/mob/proc/track_steps_walked()
	return

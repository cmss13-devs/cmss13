/datum/entity/player_stats/xeno
	var/total_hits = 0
	var/datum/entity/player_stats/caste/top_caste = null // reference to /datum/entity/player_stats/caste (i.e. ravager)
	var/list/caste_stats_list = list() // list of types /datum/entity/player_stats/caste

/datum/entity/player_stats/xeno/get_playtime(var/type)
	if(!type || type == FACTION_XENOMORPH)
		return ..()
	if(!caste_stats_list["[type]"])
		return 0
	var/datum/entity/player_stats/caste/S = caste_stats_list["[type]"]
	return S.get_playtime()

//******************
//Stat Procs - setup
//******************

/datum/entity/player_stats/xeno/proc/setup_caste_stats(var/caste, var/noteworthy = TRUE)
	if(!caste)
		return
	var/caste_key = strip_improper(caste)
	if(caste_stats_list["[caste_key]"])
		var/datum/entity/player_stats/caste/S = caste_stats_list["[caste_key]"]
		if(!S.display_stat && noteworthy)
			S.display_stat = noteworthy
		return S
	var/datum/entity/player_stats/caste/new_stat = new()
	new_stat.display_stat = noteworthy
	new_stat.player = player
	new_stat.name = caste_key
	caste_stats_list["[caste_key]"] = new_stat
	return new_stat

//******************
//Stat Procs - death
//******************

/mob/living/carbon/Xenomorph/track_death_calculations()
	if(statistic_exempt || statistic_tracked || !mind || !mind.player_entity)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	if(!xeno_stats.round_played)
		xeno_stats.total_rounds_played += 1
		xeno_stats.round_played = TRUE
	xeno_stats.total_playtime += life_time_total
	xeno_stats.track_caste_playtime(caste_name, life_time_total)
	xeno_stats.recalculate_top_caste()
	xeno_stats.recalculate_nemesis()
	..()

/datum/entity/player_stats/xeno/recalculate_nemesis()
	for(var/caste_statistic in caste_stats_list)
		var/datum/entity/player_stats/caste/caste_entity = caste_stats_list[caste_statistic]
		caste_entity.recalculate_nemesis()
	..()

/datum/entity/player_stats/xeno/proc/recalculate_top_caste()
	for(var/statistics in caste_stats_list)
		var/datum/entity/player_stats/caste/stat_entity = caste_stats_list[statistics]
		if(!top_caste)
			top_caste = stat_entity
			continue
		if(stat_entity.total_kills > top_caste.total_kills)
			top_caste = stat_entity

/datum/entity/player_stats/xeno/proc/track_caste_playtime(var/caste, var/time = 0)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	if(!S.round_played)
		S.total_rounds_played += 1
		S.round_played = TRUE
	S.total_playtime += time
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.total_playtime += time

/datum/entity/player_stats/xeno/count_personal_death(var/caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.total_deaths += 1
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.total_deaths += 1

//******************
//Stat Procs - kills
//******************

/datum/entity/player_stats/xeno/count_personal_human_kill(var/job_name, var/cause, var/caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.count_human_kill(job_name, cause)
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.count_human_kill(job_name, cause)
	recalculate_top_caste()

/datum/entity/player_stats/xeno/count_personal_xeno_kill(var/caste_name, var/cause, var/caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.count_xeno_kill(caste_name, cause)
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.count_xeno_kill(caste_name, cause)
	recalculate_top_caste()

//*****************
//Mob Procs - minor
//*****************

/datum/entity/player_stats/xeno/count_personal_niche_stat(var/niche_name, var/amount = 1, var/caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.count_niche_stat(niche_name, amount)
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.count_niche_stat(niche_name, amount)

/datum/entity/player_stats/xeno/proc/track_personal_abilities_used(var/caste, var/ability, var/amount = 1)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.track_personal_abilities_used(ability, amount)
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.track_personal_abilities_used(ability, amount)

/mob/living/carbon/Xenomorph/proc/track_ability_usage(var/ability, var/caste, var/amount = 1)
	if(statistic_exempt || !client || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(caste_name && !isnull(xeno_stats))
		xeno_stats.track_personal_abilities_used(caste_name, ability, amount)

/datum/entity/player_stats/xeno/count_personal_steps_walked(var/caste, var/amount = 1)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.steps_walked += amount
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.steps_walked += amount

/mob/living/carbon/Xenomorph/track_steps_walked(var/amount = 1)
	if(statistic_exempt || !client || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.steps_walked += amount
	if(caste_name)
		xeno_stats.count_personal_steps_walked(caste_name, amount)

/datum/entity/player_stats/xeno/proc/count_personal_slashes(var/caste, var/amount = 1)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.total_hits += amount
	if(round_statistics)
		var/datum/entity/player_stats/caste/R = round_statistics.setup_caste_stats(caste)
		R.total_hits += amount

/mob/living/carbon/Xenomorph/proc/track_slashes(var/caste, var/amount = 1)
	if(statistic_exempt || !client || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.total_hits += amount
	if(caste_name)
		xeno_stats.count_personal_slashes(caste_name, amount)
	if(round_statistics)
		round_statistics.total_slashes += amount

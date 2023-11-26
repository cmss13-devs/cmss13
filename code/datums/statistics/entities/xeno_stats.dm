/datum/entity/player_stats/xeno
	var/total_hits = 0
	var/datum/entity/player_stats/caste/top_caste = null // reference to /datum/entity/player_stats/caste (i.e. ravager)
	var/list/caste_stats_list = list() // list of types /datum/entity/player_stats/caste
	var/list/datum/entity/statistic/medal/medal_list = list() // list of all royal jelly earned

/datum/entity/player_stats/xeno/Destroy(force)
	. = ..()
	QDEL_NULL(top_caste)
	QDEL_LIST_ASSOC_VAL(caste_stats_list)
	QDEL_LIST(medal_list)

/datum/entity/player_stats/xeno/get_playtime(type)
	if(!type || type == FACTION_XENOMORPH)
		return ..()
	if(!caste_stats_list["[type]"])
		return 0
	var/datum/entity/player_stats/caste/S = caste_stats_list["[type]"]
	return S.get_playtime()

//******************
//Stat Procs - setup
//******************

/datum/entity/player_stats/xeno/proc/setup_caste_stats(caste, noteworthy = TRUE)
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

/mob/living/carbon/xenomorph/track_death_calculations()
	if(statistic_exempt || statistic_tracked || !mind || !mind.player_entity)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	if(!xeno_stats.round_played)
		xeno_stats.total_rounds_played++
		xeno_stats.round_played = TRUE
	xeno_stats.total_playtime += life_time_total
	xeno_stats.track_caste_playtime(caste_type, life_time_total)
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

/datum/entity/player_stats/xeno/proc/track_caste_playtime(caste, time = 0)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	if(!S.round_played)
		S.total_rounds_played++
		S.round_played = TRUE
	S.total_playtime += time
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.total_playtime += time

/datum/entity/player_stats/xeno/count_personal_death(caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.total_deaths++
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.total_deaths++

//******************
//Stat Procs - kills
//******************

/datum/entity/player_stats/xeno/count_personal_human_kill(job_name, cause, caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.count_human_kill(job_name, cause)
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.count_human_kill(job_name, cause)
	recalculate_top_caste()

/datum/entity/player_stats/xeno/count_personal_xeno_kill(caste_type, cause, caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.count_xeno_kill(caste_type, cause)
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.count_xeno_kill(caste_type, cause)
	recalculate_top_caste()

//*****************
//Mob Procs - minor
//*****************

/datum/entity/player_stats/xeno/count_personal_niche_stat(niche_name, amount = 1, caste)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.count_niche_stat(niche_name, amount)
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.count_niche_stat(niche_name, amount)

/datum/entity/player_stats/xeno/proc/track_personal_abilities_used(caste, ability, amount = 1)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.track_personal_abilities_used(ability, amount)
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.track_personal_abilities_used(ability, amount)

/mob/living/carbon/xenomorph/proc/track_ability_usage(ability, caste, amount = 1)
	if(statistic_exempt || !client || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(caste_type && !isnull(xeno_stats))
		xeno_stats.track_personal_abilities_used(caste_type, ability, amount)

/datum/entity/player_stats/xeno/count_personal_steps_walked(caste, amount = 1)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.steps_walked += amount
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.steps_walked += amount

/mob/living/carbon/xenomorph/track_steps_walked(amount = 1)
	if(statistic_exempt || !client || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.steps_walked += amount
	if(caste_type)
		xeno_stats.count_personal_steps_walked(caste_type, amount)

/datum/entity/player_stats/xeno/proc/count_personal_slashes(caste, amount = 1)
	var/datum/entity/player_stats/caste/S = setup_caste_stats(caste)
	S.total_hits += amount
	if(GLOB.round_statistics)
		var/datum/entity/player_stats/caste/R = GLOB.round_statistics.setup_caste_stats(caste)
		R.total_hits += amount

/mob/living/carbon/xenomorph/proc/track_slashes(caste, amount = 1)
	if(statistic_exempt || !client || !mind)
		return
	var/datum/entity/player_stats/xeno/xeno_stats = mind.setup_xeno_stats()
	if(isnull(xeno_stats))
		return
	xeno_stats.total_hits += amount
	if(caste_type)
		xeno_stats.count_personal_slashes(caste_type, amount)
	if(GLOB.round_statistics)
		GLOB.round_statistics.total_slashes += amount

/datum/random_fact/kills
	statistic_name = "kills"
	statistic_verb = "earned"
	role_filter = list(XENO_CASTE_FACEHUGGER, XENO_CASTE_LESSER_DRONE, XENO_CASTE_LARVA, XENO_CASTE_PREDALIEN_LARVA)
	role_filter_blacklist = TRUE

/datum/random_fact/kills/life_grab_stat(mob/fact_mob)
	return fact_mob.life_kills_total

/datum/random_fact/kills/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_kills

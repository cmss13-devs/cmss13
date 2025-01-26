/datum/random_fact/kills
	statistic_name = "kills"
	statistic_verb = "earned"

/datum/random_fact/kills/life_grab_stat(mob/fact_mob)
	return fact_mob.life_kills_total

/*
/datum/random_fact/kills/death_grab_stat(datum/entity/statistic/death/fact_death)
*/
//RUCM START
/datum/random_fact/kills/death_grab_stat(datum/entity/statistic_death/fact_death)
//RUCM END
	return fact_death.total_kills

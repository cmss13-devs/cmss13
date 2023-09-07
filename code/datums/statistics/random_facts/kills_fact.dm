/datum/random_fact/kills
	statistic_name = "убийств"
	statistic_verb = "совершил(а)"

/datum/random_fact/kills/life_grab_stat(mob/fact_mob)
	return fact_mob.life_kills_total

/datum/random_fact/kills/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_kills

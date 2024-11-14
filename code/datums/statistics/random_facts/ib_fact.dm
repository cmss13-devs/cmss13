/datum/random_fact/ib
	statistic_name = "people"
	statistic_verb = "fixed internal bleeding for"

/datum/random_fact/ib/life_grab_stat(mob/fact_mob)
	return fact_mob.life_ib_total

/datum/random_fact/ib/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_ib_fixed

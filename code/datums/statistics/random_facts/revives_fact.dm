/datum/random_fact/revives
	statistic_name = "people"
	statistic_verb = "revived"
	min_required = 5

/datum/random_fact/revives/life_grab_stat(mob/fact_mob)
	return fact_mob.life_revives_total

/datum/random_fact/revives/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_revives_done

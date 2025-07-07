/datum/random_fact/steps
	statistic_name = "steps"
	statistic_verb = "took"
	min_required = 1000

/datum/random_fact/steps/life_grab_stat(mob/fact_mob)
	return fact_mob.life_steps_total

/datum/random_fact/steps/death_grab_stat(datum/entity/statistic/death/fact_death)
	return fact_death.total_steps_done

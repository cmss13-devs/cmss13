/datum/random_fact/steps
	statistic_name = "calories"
	statistic_verb = "burned"
	min_required = 10

/datum/random_fact/steps/life_grab_stat(mob/fact_mob)
	return (fact_mob.life_steps_total * 0.05)

/datum/random_fact/steps/death_grab_stat(datum/entity/statistic/death/fact_death)
	return (fact_death.total_steps * 0.05)

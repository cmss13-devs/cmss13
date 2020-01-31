/datum/xeno_mutator/shatterglob
	name = "STRAIN: Boiler - Shatter Glob"
	description = "Instead of leaving a lasting cloud of gas, your two bombard types will now detonate upon hitting the ground, spraying the area with splashes and drops of acid or neurotoxin."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Boiler")
	mutator_actions_to_remove = null
	mutator_actions_to_add = null
	keystone = TRUE

/datum/xeno_mutator/shatterglob/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/Xenomorph/Boiler/B = MS.xeno
	B.bomb_delay = 250 // 25s flat, doesn't decrease with maturity anymore
	B.mutation_type = BOILER_SHATTER
	MS.recalculate_actions(description)

/datum/ammo/xeno/toxin/shatter // Used by boiler shatter glob strain
	name = "neurotoxin spatter"

/datum/ammo/xeno/toxin/shatter/New()
	..()
	accuracy = config.med_hit_accuracy
	accurate_range = config.max_shell_range
	max_range = config.close_shell_range
	shell_speed = config.slow_shell_speed
	scatter = config.med_scatter_value

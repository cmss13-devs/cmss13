/datum/xeno_strain/neuro_spitter
	name = SENTINEL_NEURO_SPITTER
	description = "At the cost of your abilities, your tackles are improved and your gain neurotoxic spit, which will slow down, stun, and eventually knock out hosts with consecutive spits."
	flavor_description = "Anyone else wanna take a nap?" // REM
	actions_to_remove = list(
		/datum/action/xeno_action/activable/slowing_spit,
		/datum/action/xeno_action/activable/scattered_spit,
		/datum/action/xeno_action/onclick/paralyzing_slash,
	)
	actions_to_add = list(
		/datum/action/xeno_action/activable/neuro_spit
	)

/datum/xeno_strain/neuro_spitter/apply_strain(mob/living/carbon/xenomorph/sentinel/sentinel)
	sentinel.tackle_min = 2
	sentinel.tacklestrength_max = 5
	sentinel.recalculate_everything()

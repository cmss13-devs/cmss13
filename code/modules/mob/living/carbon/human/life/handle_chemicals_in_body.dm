//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_chemicals_in_body()

	reagent_move_delay_modifier = 0

	recalculate_move_delay = TRUE

	if(chem_effect_flags)
		chem_effect_reset_time--
		if(!chem_effect_reset_time)
			chem_effect_reset_time = 8
			if(chem_effect_flags & CHEM_EFFECT_HYPER_THROTTLE)
				universal_understand = FALSE
			chem_effect_flags = 0

	if(reagents && !(species.flags & NO_CHEM_METABOLIZATION))
		var/alien = 0
		if(species && species.reagent_tag)
			alien = species.reagent_tag
		reagents.metabolize(src,alien)

	if(status_flags & GODMODE)
		return 0 //Godmode

	if(!(species.flags & IS_SYNTHETIC))
		//Nutrition decrease
		if(nutrition > 0 && stat != 2)
			nutrition = max (0, nutrition - HUNGER_FACTOR)


		handle_trace_chems()

	else nutrition = NUTRITION_NORMAL //synthetics are never hungry

	//updatehealth() moved to Life()

	return //TODO: DEFERRED

/mob/living/carbon/human/proc/handle_necro_chemicals_in_body()
	SHOULD_NOT_SLEEP(TRUE)
	if(!reagents || undefibbable)
		return // Double checking due to Life() funny background=1
	for(var/datum/reagent/generated/R in reagents.reagent_list)
		var/list/mods = list(	REAGENT_EFFECT		= TRUE,
								REAGENT_BOOST 		= FALSE,
								REAGENT_PURGE 		= FALSE,
								REAGENT_FORCE 		= FALSE,
								REAGENT_CANCEL		= FALSE)

		for(var/datum/chem_property/P in R.properties)
			var/list/A = P.pre_process(src)
			if(!A)
				continue
			for(var/mod in A)
				mods[mod] |= A[mod]

		if(mods[REAGENT_CANCEL])
			return

		if(mods[REAGENT_FORCE])
			R.handle_processing(src, mods)
			R.holder.remove_reagent(R.id, R.custom_metabolism)

		R.handle_dead_processing(src, mods)

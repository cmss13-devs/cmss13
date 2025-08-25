//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_chemicals_in_body(delta_time)

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
		reagents.metabolize(src, alien, delta_time)

	if(status_flags & GODMODE)
		return 0 //Godmode

	if(!(species.flags & IS_SYNTHETIC))
		//Nutrition decrease
		if(stat != DEAD)
			nutrition = max(0, nutrition - HUNGER_FACTOR)


		handle_trace_chems()

	else
		nutrition = NUTRITION_NORMAL //synthetics are never hungry

	return //TODO: DEFERRED

/mob/living/carbon/human/proc/handle_necro_chemicals_in_body(delta_time)
	SHOULD_NOT_SLEEP(TRUE)
	if(!reagents || undefibbable)
		return // Double checking due to Life() funny background=1

	var/has_cryo_medicine = reagents.get_reagent_amount("cryoxadone") >= 1 || reagents.get_reagent_amount("clonexadone") >= 1
	if(has_cryo_medicine)
		var/obj/structure/machinery/cryo_cell/cryo = loc
		if(!istype(cryo) || !cryo.on || cryo.inoperable())
			has_cryo_medicine = FALSE

	for(var/datum/reagent/cur_reagent in reagents.reagent_list)
		if(!has_cryo_medicine && !istype(cur_reagent, /datum/reagent/generated))
			continue

		var/list/mods = list( REAGENT_EFFECT = TRUE,
								REAGENT_BOOST = FALSE,
								REAGENT_PURGE = FALSE,
								REAGENT_FORCE = has_cryo_medicine,
								REAGENT_CANCEL = FALSE)

		for(var/datum/chem_property/cur_prop in cur_reagent.properties)
			var/list/results = cur_prop.pre_process(src)
			if(!results)
				continue
			for(var/mod in results)
				mods[mod] |= results[mod]

		if(mods[REAGENT_CANCEL])
			return

		if(mods[REAGENT_FORCE])
			cur_reagent.handle_processing(src, mods, delta_time)
			cur_reagent.holder.remove_reagent(cur_reagent.id, cur_reagent.custom_metabolism * delta_time)

		cur_reagent.handle_dead_processing(src, mods, delta_time)

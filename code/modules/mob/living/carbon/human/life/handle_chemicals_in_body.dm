//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_chemicals_in_body()

	reagent_move_delay_modifier = 0
	reagent_shock_modifier = 0
	reagent_pain_modifier = 0

	recalculate_move_delay = TRUE

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

		if(nutrition > NUTRITION_MAX)
			if(overeatduration < 600) //Capped so people don't take forever to unfat
				overeatduration++
		else
			if(overeatduration > 1)
				overeatduration -= 2 //Doubled the unfat rate

		handle_trace_chems()

	else nutrition = NUTRITION_NORMAL //synthetics are never hungry

	//updatehealth() moved to Life()

	return //TODO: DEFERRED

/mob/living/carbon/human/proc/handle_necro_chemicals_in_body()
	for(var/datum/reagent/generated/R in reagents.reagent_list)
		var/is_OD
		var/is_COD
		if(R.overdose && R.volume >= R.overdose)
			is_OD = 1
			if(R.overdose_critical && R.volume > R.overdose_critical)
				is_COD = 1
		for(var/P in R.properties)
			var/potency = R.properties[P]
			if(!potency) continue
			switch(P)
				if(PROPERTY_NEUROCRYOGENIC)
					R.holder.remove_reagent(R.id, R.custom_metabolism)
					if(is_OD)
						bodytemperature = max(bodytemperature-5*potency,0)
						if(is_COD)
							adjustBrainLoss(5 * potency)
					else
						revive_grace_period += SECONDS_5 * potency
				if(PROPERTY_DEFIBRILLATING)
					R.holder.remove_reagent(R.id, R.custom_metabolism)
					adjustOxyLoss(-getOxyLoss())
					if(check_tod() && is_revivable() && health > config.health_threshold_dead)
						to_chat(src, SPAN_NOTICE("You feel your heart struggling as you suddenly feel a spark, making it desperately try to continue pumping."))
						playsound_client(src.client, 'sound/effects/Heart Beat Short.ogg', 35)
						add_timer(CALLBACK(src, .proc/handle_revive), 50, TIMER_UNIQUE)
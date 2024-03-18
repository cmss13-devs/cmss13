
//*****************************************************************************************************/
//***********************************Randomly Generated Chemicals**************************************/
//*****************************************************************************************************/

/datum/chemical_reaction/generated
	result_amount = 1 //Makes it a bit harder to mass produce

/datum/reagent/generated
	reagent_state = LIQUID //why isn't this default, seriously
	chemclass = CHEM_CLASS_ULTRA
	objective_value = OBJECTIVE_HIGH_VALUE
	flags = REAGENT_SCANNABLE

/datum/reagent/generated/New()
	//Generate stats
	if(!id) //So we can initiate a new datum without generating it
		return
	if(!GLOB.chemical_reagents_list[id])
		generate_name()
		generate_stats()
		GLOB.chemical_reagents_list[id] = src
	make_alike(GLOB.chemical_reagents_list[id])
	recalculate_variables()

/datum/chemical_reaction/generated/New()
	//Generate recipe
	if(!id) //So we can initiate a new datum without generating it
		return
	if(!GLOB.chemical_reactions_list[id])
		generate_recipe()
		GLOB.chemical_reactions_list[id] = src
	make_alike(GLOB.chemical_reactions_list[id])

/////////Tier 1


/datum/chemical_reaction/generated/on_reaction(datum/reagents/holder, created_volume)
	var/datum/reagent/R = holder.has_reagent(id)
	if(!R || !R.properties)
		return
	if(created_volume > R.overdose)
		if(R.chemfiresupp)
			holder.trigger_volatiles = TRUE
		else
			for(var/datum/chem_property/P in R.properties)
				if(P.volatile)
					holder.trigger_volatiles = TRUE
					break

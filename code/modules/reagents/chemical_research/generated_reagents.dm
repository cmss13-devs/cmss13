
//*****************************************************************************************************/
//***********************************Randomly Generated Chemicals**************************************/
//*****************************************************************************************************/

/datum/chemical_reaction/generated
	result_amount = 1 //Makes it a bit harder to mass produce

/datum/reagent/generated
	reagent_state = LIQUID //why isn't this default, seriously
	chemclass = CHEM_CLASS_ULTRA
	objective_value = OBJECTIVE_NO_VALUE
	flags = REAGENT_SCANNABLE
	/// One reagent for the recipe picked at the creation of chem without creating recipe datum but is guranteed to be a part of recipe when recipe datum is created. Used as a hint for research contracts.
	var/reagent_recipe_hint = null
	/// one consistent property hint picked from itself. Set when creating itself
	var/property_hint = null

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

/datum/chemical_reaction/generated/on_reaction(datum/reagents/holder, created_volume)
	. = ..()
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

/datum/reagent/generated/make_alike(datum/reagent/generated/chemical_to_copy)
	. = ..()
	reagent_recipe_hint = chemical_to_copy.reagent_recipe_hint
	property_hint = chemical_to_copy.property_hint

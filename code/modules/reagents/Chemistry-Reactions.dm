///////////////////////////////////////////////////////////////////////////////////

/datum/chemical_reaction
	var/name = null
	var/id = null
	var/result = null
	var/gen_tier = 0 //used for generation purposes
	var/list/required_reagents = new/list()
	var/list/required_catalysts = new/list()

	var/mob_react = TRUE //Determines if a chemical reaction can occur inside a mob

	// both vars below are currently unused
	var/atom/required_container = null // the container required for the reaction to happen
	var/required_other = 0 // an integer required for the reaction to happen

	var/result_amount = 0 //I recommend you set the result amount to the total volume of all components.
	var/secondary = 0 // set to nonzero if secondary reaction
	var/list/secondary_results = list()		//additional reagents produced by the reaction
	var/requires_heating = 0

/datum/chemical_reaction/proc/on_reaction(var/datum/reagents/holder, var/created_volume)
	return

/datum/chemical_reaction/proc/get_filter()
	var/list/reaction_ids = list()
	if(required_reagents && required_reagents.len)
		for(var/reaction in required_reagents)
			reaction_ids += reaction
	// Create filters based on each reagent id in the required reagents list
	for(var/id in reaction_ids)
		if(!chemical_reactions_filtered_list[id])
			chemical_reactions_filtered_list[id] = list()
		return id // We don't have to bother adding ourselves to other reagent ids, it is redundant.

/datum/chemical_reaction/proc/check_duplicate()
	var/matches = 0
	for(var/R in required_reagents)
		if(chemical_reactions_filtered_list[R])
			for(var/reaction in chemical_reactions_filtered_list[R])//We filter the chemical_reactions_filtered_list so we don't have to search through as much
				var/datum/chemical_reaction/C = reaction
				for(var/B in C.required_reagents)
					if(required_reagents.Find(B))
						matches++
	if(matches >= required_reagents.len)
		return TRUE

// As funny as it may sound, spawning a chemical which's recipe is Bicaridine, Tramadol and Kelotane that instantly kills or cripple marine is not nice.
// To prevent such a situation, if ALL reagent inside a reaction are medical chemicals, the recipe is considered flawed.
/datum/chemical_reaction/proc/check_reaction_uses_all_default_medical()
	for(var/R in required_reagents)
		var/datum/reagent/M = chemical_reagents_list[R]
		if(!(initial(M.flags) & REAGENT_TYPE_MEDICAL))
			return FALSE
	return TRUE

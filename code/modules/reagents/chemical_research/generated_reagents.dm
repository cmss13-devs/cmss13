/////////////////////////RANDOMLY GENERATED CHEMICALS/////////////////////////
/datum/chemical_reaction/generated
	result_amount = 1 //Makes it a bit harder to mass produce

/datum/reagent/generated
	reagent_state = LIQUID //why isn't this default, seriously
	chemclass = CHEM_CLASS_ULTRA
	objective_value = 20
	flags = REAGENT_SCANNABLE

/datum/reagent/generated/New()
	//Generate stats
	if(!id) //So we can initiate a new datum without generating it
		return
	if(!chemical_reagents_list[id])
		generate_name()
		generate_stats()
		chemical_reagents_list[id] = src
	make_alike(chemical_reagents_list[id])
	recalculate_variables()

/datum/chemical_reaction/generated/New()
	//Generate recipe
	if(!id) //So we can initiate a new datum without generating it
		return
	if(!chemical_reactions_list[id])
		generate_recipe()
		chemical_reactions_list[id] = src
	make_alike(chemical_reactions_list[id])

/////////Tier 1
/datum/chemical_reaction/generated/alpha
	id = "alpha"
	result = "alpha"
	gen_tier = 1

/datum/reagent/generated/alpha
	id = "alpha"
	gen_tier = 1

/datum/chemical_reaction/generated/beta
	id = "beta"
	result = "beta"
	gen_tier = 1

/datum/reagent/generated/beta
	id = "beta"
	gen_tier = 1

/datum/chemical_reaction/generated/gamma
	id = "gamma"
	result = "gamma"
	gen_tier = 1

/datum/reagent/generated/gamma
	id = "gamma"
	gen_tier = 1

/datum/chemical_reaction/generated/delta
	id = "delta"
	result = "delta"
	gen_tier = 1

/datum/reagent/generated/delta
	id = "delta"
	gen_tier = 1

/datum/chemical_reaction/generated/epsilon
	id = "epsilon"
	result = "epsilon"
	gen_tier = 1

/datum/reagent/generated/epsilon
	id = "epsilon"
	gen_tier = 1

/////////Tier 2
/datum/chemical_reaction/generated/zeta
	id = "zeta"
	result = "zeta"
	gen_tier = 2

/datum/reagent/generated/zeta
	id = "zeta"
	gen_tier = 2

/datum/chemical_reaction/generated/eta
	id = "eta"
	result = "eta"
	gen_tier = 2

/datum/reagent/generated/eta
	id = "eta"
	gen_tier = 2

/datum/chemical_reaction/generated/theta
	id = "theta"
	result = "theta"
	gen_tier = 2

/datum/reagent/generated/theta
	id = "theta"
	gen_tier = 2

/////////Tier 3
/datum/chemical_reaction/generated/iota
	id = "iota"
	result = "iota"
	gen_tier = 3

/datum/reagent/generated/iota
	id = "iota"
	gen_tier = 3

/datum/chemical_reaction/generated/kappa
	id = "kappa"
	result = "kappa"
	gen_tier = 3

/datum/reagent/generated/kappa
	id = "kappa"
	gen_tier = 3

/////////Tier 4
/datum/chemical_reaction/generated/lambda
	id = "lambda"
	result = "lambda"
	gen_tier = 4

/datum/reagent/generated/lambda
	id = "lambda"
	gen_tier = 4

/datum/chemical_reaction/generated/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/reagent/R = holder.reagent_list[id]
	if(!R || !R.properties)
		return
	for(var/datum/chem_property/P in R.properties)
		switch(P.name)
			if(PROPERTY_HYPERTHERMIC)
				if(created_volume > R.overdose)
					holder.trigger_volatiles = TRUE
			if(PROPERTY_EXPLOSIVE)
				if(created_volume > R.overdose)
					holder.trigger_volatiles = TRUE

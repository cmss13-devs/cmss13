SUBSYSTEM_DEF(reagents)
	name = "Reagents"
	init_order = SS_INIT_REAGENTS
	flags = SS_NO_FIRE

/datum/controller/subsystem/reagents/Initialize()
	// Initalize to create the global chemistry lists:
	// Must be before SSatoms.InitializeAtoms and SSmapping
	prepare_properties()
	prepare_reagents()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/reagents/Recover()
	initialized = SSreagents.initialized

/datum/controller/subsystem/reagents/proc/prepare_properties()
	//Chemical Properties - Initialises all /datum/chem_property into a list indexed by property name
	var/paths = typesof(/datum/chem_property)
	chemical_properties_list = list()
	//Some filters
	chemical_properties_list["negative"] = list()
	chemical_properties_list["neutral"] = list()
	chemical_properties_list["positive"] = list()
	chemical_properties_list["rare"] = list()
	//Save
	for(var/path in paths)
		var/datum/chem_property/P = new path()
		if(!P.name)
			continue
		chemical_properties_list[P.name] = P
		if(P.starter)
			//Add a separate instance to the chemical property database
			var/datum/chem_property/D = new path()
			D.level = 0
			chemical_data.research_property_data += D
		if(P.rarity > PROPERTY_DISABLED)
			//Filters for the generator picking properties
			if(P.rarity == PROPERTY_RARE || P.rarity == PROPERTY_LEGENDARY)
				chemical_properties_list["rare"][P.name] = P
			else if(isNegativeProperty(P))
				chemical_properties_list["negative"][P.name] = P
			else if(isNeutralProperty(P))
				chemical_properties_list["neutral"][P.name] = P
			else if(isPositiveProperty(P))
				chemical_properties_list["positive"][P.name] = P

/datum/controller/subsystem/reagents/proc/prepare_reagents()
	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	set waitfor = 0
	//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
	//Generated chemicals should be initialized last, hence the substract then readd.
	var/list/paths = subtypesof(/datum/reagent) - typesof(/datum/reagent/generated) -  subtypesof(/datum/reagent/generated) + subtypesof(/datum/reagent/generated)
	chemical_reagents_list = list()
	for(var/path in paths)
		var/datum/reagent/D = new path()
		D.save_chemclass()
		chemical_reagents_list[D.id] = D

	//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
	var/list/regular_paths = subtypesof(/datum/chemical_reaction) - typesof(/datum/chemical_reaction/generated)
	var/list/generated_paths = subtypesof(/datum/chemical_reaction/generated) //Generated chemicals should be initialized last
	chemical_reactions_filtered_list = list()
	chemical_reactions_list = list()

	for(paths in list(regular_paths, generated_paths))
		for(var/path in paths)
			var/datum/chemical_reaction/D = new path()
			chemical_reactions_list[D.id] = D
			D.add_to_filtered_list()

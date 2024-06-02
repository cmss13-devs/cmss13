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
	GLOB.chemical_properties_list = list()
	//Some filters
	GLOB.chemical_properties_list["negative"] = list()
	GLOB.chemical_properties_list["neutral"] = list()
	GLOB.chemical_properties_list["positive"] = list()
	GLOB.chemical_properties_list["rare"] = list()
	//Save
	for(var/path in paths)
		var/datum/chem_property/prop = new path()
		if(!prop.name)
			continue
		GLOB.chemical_properties_list[prop.name] = prop
		if(prop.starter)
			//Add a separate instance to the chemical property database
			var/datum/chem_property/chem = new path()
			chem.level = 0
			GLOB.chemical_data.research_property_data += chem
		if(prop.rarity > PROPERTY_DISABLED)
			//Filters for the generator picking properties
			if(prop.rarity == PROPERTY_RARE || prop.rarity == PROPERTY_LEGENDARY)
				GLOB.chemical_properties_list["rare"][prop.name] = prop
			else if(isNegativeProperty(prop))
				GLOB.chemical_properties_list["negative"][prop.name] = prop
			else if(isNeutralProperty(prop))
				GLOB.chemical_properties_list["neutral"][prop.name] = prop
			else if(isPositiveProperty(prop))
				GLOB.chemical_properties_list["positive"][prop.name] = prop

/datum/controller/subsystem/reagents/proc/prepare_reagents()
	//I dislike having these here but map-objects are initialised before world/New() is called. >_>
	set waitfor = FALSE
	//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
	//Generated chemicals should be initialized last, hence the substract then readd.
	var/list/paths = subtypesof(/datum/reagent) - typesof(/datum/reagent/generated) - subtypesof(/datum/reagent/generated) + subtypesof(/datum/reagent/generated)
	GLOB.chemical_reagents_list = list()
	for(var/path in paths)
		var/datum/reagent/chem = new path()
		chem.save_chemclass()
		GLOB.chemical_reagents_list[chem.id] = chem

	//Chemical Reactions - Initialises all /datum/chemical_reaction into a list
	// It is filtered into multiple lists within a list.
	// For example:
	// chemical_reaction_list["phoron"] is a list of all reactions relating to phoron
	var/list/regular_paths = subtypesof(/datum/chemical_reaction) - typesof(/datum/chemical_reaction/generated)
	var/list/generated_paths = subtypesof(/datum/chemical_reaction/generated) //Generated chemicals should be initialized last
	GLOB.chemical_reactions_filtered_list = list()
	GLOB.chemical_reactions_list = list()

	for(paths in list(regular_paths, generated_paths))
		for(var/path in paths)
			var/datum/chemical_reaction/react = new path()
			GLOB.chemical_reactions_list[react.id] = react
			react.add_to_filtered_list()

SUBSYSTEM_DEF(reagents)
	name = "Reagents"
	init_order = SS_INIT_REAGENTS
	flags = SS_NO_FIRE

/datum/controller/subsystem/reagents/Initialize()
	// Initalize to create the global chemistry lists:
	// Must be before SSatoms.InitializeAtoms and SSmapping
	global_prepare_properties()
	global_prepare_reagents()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/reagents/Recover()
	initialized = SSreagents.initialized

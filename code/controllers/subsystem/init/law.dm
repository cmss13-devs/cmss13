SUBSYSTEM_DEF(law_init)
	name       = "Law Init"
	init_order = SS_INIT_LAW
	flags      = SS_NO_FIRE
	
	var/list/laws = list() // All laws
	var/list/optional_law = list()
	var/list/minor_law = list()
	var/list/major_law = list()
	var/list/capital_law = list()

/datum/controller/subsystem/law_init/Initialize()
	for(var/L in subtypesof(/datum/law/optional_law))
		optional_law += new L

	for(var/L in subtypesof(/datum/law/minor_law))
		minor_law += new L

	for(var/L in subtypesof(/datum/law/major_law))
		major_law += new L

	for(var/L in subtypesof(/datum/law/capital_law))
		capital_law += new L

	laws = optional_law + minor_law + major_law + capital_law
	
	return ..()

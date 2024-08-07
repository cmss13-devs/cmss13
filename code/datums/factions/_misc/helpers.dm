GLOBAL_LIST_INIT_TYPED(faction_datums, /datum/faction, setup_factions_list())

/proc/setup_factions_list()
	. = list()
	for(var/path in typesof(/datum/faction))
		var/datum/faction/faction = new path
		.[faction.faction_name] = faction

GLOBAL_LIST_INIT_TYPED(custom_event_info_list, /datum/custom_event_info, setup_custom_event_info())

/proc/setup_custom_event_info()
	. = list()
	var/datum/custom_event_info/CEI = new()
	CEI.faction_name = "Global"
	.[CEI.faction_name] = CEI
	for(var/faction_to_get in FACTION_LIST_ALL)
		var/datum/faction/faction = GLOB.faction_datums[faction_to_get]
		CEI = new()
		CEI.faction_name = faction.name
		CEI.faction = faction
		.[CEI.faction_name] = CEI

GLOBAL_LIST_INIT_TYPED(faction_modules, /datum/faction_module, setup_faction_modules_list())

/proc/setup_faction_modules_list()
	. = list()
	for(var/path in typesof(/datum/faction_module))
		var/datum/faction_module/module = new path
		.[module.module_name] = module

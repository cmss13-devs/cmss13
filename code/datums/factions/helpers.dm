GLOBAL_LIST_INIT_TYPED(custom_event_info_list, /datum/custom_event_info, setup_custom_event_info())

GLOBAL_LIST_INIT_TYPED(faction_datums, /datum/faction, setup_faction_list())

/proc/setup_faction_list()
	. = list()
	for(var/path in typesof(/datum/faction))
		var/datum/faction/faction = new path()
		.[faction.code_identificator] = faction
		faction.relations_datum.generate_relations_helper()

/proc/setup_custom_event_info()
	. = list()
	.["glob"] = new /datum/custom_event_info(null, "Global", "glob")

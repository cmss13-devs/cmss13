GLOBAL_LIST_INIT_TYPED(faction_datums, /datum/faction, setup_faction_list())

/proc/setup_faction_list()
	var/list/faction_datums_list = list()
	for(var/T in typesof(/datum/faction))
		var/datum/faction/current_faction = new T
		faction_datums_list[current_faction.faction_tag] = current_faction
	return faction_datums_list

/proc/get_faction(faction = FACTION_MARINE)
	var/datum/faction/current_faction = GLOB.faction_datums[faction]
	if(current_faction)
		return current_faction
	return GLOB.faction_datums[FACTION_NEUTRAL]

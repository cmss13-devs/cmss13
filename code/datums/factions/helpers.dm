GLOBAL_LIST_INIT_TYPED(faction_datums, /datum/faction, setup_faction_list())

/proc/setup_faction_list()
	var/list/faction_datums_list = list()
	for(var/T in typesof(/datum/faction))
		var/datum/faction/F = new T
		faction_datums_list[F.faction_tag] = F
	return faction_datums_list

/proc/get_faction(faction = FACTION_MARINE)
	var/datum/faction/F = GLOB.faction_datums[faction]
	if(F)
		return F
	return GLOB.faction_datums[FACTION_NEUTRAL]

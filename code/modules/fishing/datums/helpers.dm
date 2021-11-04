/proc/get_fishing_loot_datum(var/table_type)
	if(!length(GLOB.fishing_loot_tables))
		for(var/new_type in typesof(/datum/fish_loot_table))
			GLOB.fishing_loot_tables[new_type] = new new_type
	if(!table_type || !(table_type in GLOB.fishing_loot_tables))
		return GLOB.fishing_loot_tables[/datum/fish_loot_table] // return generic datum
	return GLOB.fishing_loot_tables[table_type]

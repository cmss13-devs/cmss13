/proc/get_fishing_loot_datum(table_type)
	if(!length(GLOB.fishing_loot_tables))
		for(var/new_type in typesof(/datum/fish_loot_table))
			GLOB.fishing_loot_tables[new_type] = new new_type
	if(!table_type || !(table_type in GLOB.fishing_loot_tables))
		return GLOB.fishing_loot_tables[/datum/fish_loot_table] // return generic datum
	return GLOB.fishing_loot_tables[table_type]

/proc/get_fishing_loot(turf/T, area/A, common_weight, uncommon_weight, rare_weight, ultra_rare_weight)
	var/datum/fish_loot_table/area_loot_table = get_fishing_loot_datum(A.fishing_loot)
	var/type_to_spawn = area_loot_table.return_caught_fish(common_weight, uncommon_weight, rare_weight, ultra_rare_weight)
	var/obj/item/caught_item = new type_to_spawn(T)
	return caught_item

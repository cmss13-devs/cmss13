GLOBAL_LIST_EMPTY(fishing_loot_tables)

/datum/fish_loot_table
	var/list/common_fishable_atoms = list(
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/marine,
	)
	var/list/uncommon_fishable_atoms = list(
		/obj/item/cell/high,
		/obj/item/device/multitool
	)
	var/list/rare_fishable_atoms = list(
		/obj/item/reagent_container/food/snacks/packaged_burrito
	)
	var/list/ultra_rare_fishable_atoms = list(
		/obj/item/card/data/clown,
		/obj/item/reagent_container/food/snacks/clownburger,
		/obj/item/reagent_container/pill/ultrazine/unmarked
	)

/datum/fish_loot_table/proc/return_caught_fish(common_weight, uncommon_weight, rare_weight, ultra_rare_weight)
	if(prob(common_weight))
		return pick(common_fishable_atoms)
	else if (prob(uncommon_weight))
		return pick(uncommon_fishable_atoms)
	else if (prob(rare_weight))
		return pick(rare_fishable_atoms)
	else if (prob(ultra_rare_weight))
		return pick(ultra_rare_fishable_atoms)
	return pick(common_fishable_atoms)

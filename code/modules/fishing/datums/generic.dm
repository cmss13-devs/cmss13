GLOBAL_LIST_EMPTY(fishing_loot_tables)

/datum/fish_loot_table
	var/list/common_fishable_atoms = list(
		/obj/item/clothing/shoes/leather,
		/obj/item/reagent_container/food/snacks/fishable/crab,
		/obj/item/reagent_container/food/snacks/fishable/worm,
		/obj/item/reagent_container/food/snacks/fishable/shell/clam,
		/obj/item/reagent_container/food/snacks/fishable/squid/sock,
		/obj/item/ore/coal,
		/obj/item/ore/slag,
		/obj/item/reagent_container/food/snacks/fishable/urchin/purple,
		/obj/item/reagent_container/food/snacks/fishable/fish/bluegill
	)
	var/list/uncommon_fishable_atoms = list(
		/obj/item/cell/high,
		/obj/item/device/multitool,
		/obj/item/reagent_container/food/snacks/fishable/quadtopus,
		/obj/item/reagent_container/food/snacks/fishable/squid/whorl,
		/obj/item/reagent_container/food/snacks/fishable/fish/bass,
		/obj/item/reagent_container/food/snacks/fishable/fish/catfish,
		/obj/item/ore/iron,
		/obj/item/fish_bait,
		/obj/item/storage/beer_pack,
		/obj/item/stack/sheet/metal
	)
	var/list/rare_fishable_atoms = list(
		/obj/item/reagent_container/food/snacks/packaged_burrito,
		/obj/item/ore/silver,
		/obj/item/ore/gold,
		/obj/item/ore/diamond,
		/obj/item/reagent_container/food/snacks/fishable/urchin/red
	)
	var/list/ultra_rare_fishable_atoms = list(
		/obj/item/card/data/clown,
		/obj/item/reagent_container/food/snacks/clownburger,
		/obj/item/reagent_container/pill/ultrazine/unmarked,
		/obj/item/ore/osmium,
		/obj/item/ore/uranium,
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

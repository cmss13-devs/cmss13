/datum/research_upgrades
	var/name = "Upgrade." //unique to every upgrade. not the name of the item. name of the upgrade
	var/desc = "something is broken. yippee!!" // same as above. name of upgrades, not items. Items are at research_upgrades.dm somewhere in item folder.
	var/behavior = UPGRADE_EXCLUDE_BUY // should this be on the list? whatever.
	var/list/value_upgrade = list(1000) //prices for autodoc. in accordance with amount of upgrades.
	var/item_reference // actual path to the item.
	var/upgrade_type //which tab

/datum/research_upgrades/proc/get_upgrade_desc(value) // get value-specific upgrade defines, only needed when you're planning to add more than one of simular upgrades. like one below
	return

/datum/research_upgrades/machinery
	name = "Machinery"
	desc = "todo"
	behavior = UPGRADE_CATEGORY // one on the dropdown choices you get

/datum/research_upgrades/machinery/autodoc
	name = "AutoDoc Upgrade"
	desc = "Research upgrade for AutoDoc, Technology on this disk is used for" // added when we call get_upgrade_desc at final shop-list assembly at xeno analyzer.
	behavior = UPGRADE_TIER_4 // ok so, this is tricky. basically you put in how many VARIATIONS of upgrades you need. in this example its internal bleeding repair, 2 for bone repair, 3 for organ repair/etc, and 4 for larva removal. They are not exclusive, that means if you get level 4, you still dont have level 2 and 3 & 1.
	value_upgrade = list(3000, 5000, 8000, 10000)
	item_reference = /obj/item/research_upgrades/autodoc
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/machinery/autodoc/get_upgrade_desc(value)
	switch(value)
		if(UPGRADE_TIER_1)
			return " (Internal Bleedings)"
		if(UPGRADE_TIER_2)
			return " (Fractures Repair)"
		if(UPGRADE_TIER_3)
			return " (Treating Organs)"
		if(UPGRADE_TIER_4)
			return " (Extracting Parasites)"

/datum/research_upgrades/machinery/sleeper
	name = "Sleeper Upgrade"
	desc = "Research upgrade for Sleeper system, Technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered, as well as upgrading diaslisys software."
	behavior = UPGRADE_TIER_1
	value_upgrade = list(1000)
	item_reference = /obj/item/research_upgrades/sleeper
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/item
	name = "Items"
	behavior = UPGRADE_CATEGORY








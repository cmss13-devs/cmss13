/datum/research_upgrades
	var/name = "Upgrade." //unique to every upgrade. not the name of the item. name of the upgrade
	var/desc = "something is broken. yippee!!" // same as above. name of upgrades, not items. Items are at research_upgrades.dm somewhere in item folder.
	var/behavior = UPGRADE_EXCLUDE_BUY // should this be on the list? whatever.
	var/value_upgrade = 1000 // the price of the upgrade, refer to this : 1
	var/item_reference // actual path to the item.
	var/upgrade_type //which tab

/datum/research_upgrades/machinery
	name = "Machinery"
	desc = "todo"
	behavior = UPGRADE_CATEGORY // one on the dropdown choices you get

/datum/research_upgrades/machinery/autodoc
	name = "AutoDoc Upgrade"
	behavior = UPGRADE_EXCLUDE_BUY
	item_reference = /obj/item/research_upgrades/autodoc

/datum/research_upgrades/machinery/autodoc/internal_bleed
	name = "AutoDoc Internal Bleeding Repair"
	desc = "Data and instruction set for AutoDoc making it capable to fix internal bleedings extremely quick by injecting powerfull coagulant alongside physically fixing it."
	behavior = UPGRADE_TIER_1
	value_upgrade = 1000

/datum/research_upgrades/machinery/autodoc/broken_bone
	name = "AutoDoc Broken Bone Fixation"
	desc = "Data and instruction set for AutoDoc making it capable to set the fracture and inject bonegel without a single cut."
	behavior = UPGRADE_TIER_2
	value_upgrade = 5000

/datum/research_upgrades/machinery/autodoc/organ_damage
	name = "AutoDoc Broken Organ Repair"
	desc = "Data and instruction set for AutoDoc making it capable to fix organ damage."
	behavior = UPGRADE_TIER_3
	value_upgrade = 4500

/datum/research_upgrades/machinery/autodoc/larva_removal
	name = "AutoDoc Broken Embryo Removal"
	desc = "Data and instruction set for AutoDoc making it mildy proficient in removing parasites left by unknown organism."
	behavior = UPGRADE_TIER_4
	value_upgrade = 8000

/datum/research_upgrades/machinery/sleeper
	name = "Sleeper Upgrade"
	desc = "Research upgrade for Sleeper system, Technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered, as well as upgrading diaslisys software."
	behavior = UPGRADE_TIER_1
	value_upgrade = 1000
	item_reference = /obj/item/research_upgrades/sleeper
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/item
	name = "Items"
	behavior = UPGRADE_CATEGORY

/datum/research_upgrades/item/research_credits
	name = "Research Credits"
	desc = "Sell the data acquired to the nearest Weyland-Yutani Science devision team for two points."
	value_upgrade = 2000
	item_reference = /obj/item/research_upgrades/credits
	behavior = UPGRADE_TIER_1








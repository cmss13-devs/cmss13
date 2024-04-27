/datum/research_upgrades
	var/name = "Upgrade." //unique to every upgrade. not the name of the item. name of the upgrade
	var/desc = "something is broken. yippee!!" // same as above. name of upgrades, not items. Items are at research_upgrades.dm somewhere in item folder.
	var/behavior = UPGRADE_EXCLUDE_BUY // should this be on the list? whatever.
	var/value_upgrade = 1000 // the price of the upgrade, refer to this : 1
	var/item_reference // actual path to the item.
	var/upgrade_type //which tab
	var/clearance_req = 5 //5x is level 6. Why is it not that way? no one knows.

/datum/research_upgrades/machinery
	name = "Machinery"
	behavior = UPGRADE_CATEGORY // one on the dropdown choices you get

/datum/research_upgrades/machinery/autodoc
	name = "AutoDoc Upgrade"
	behavior = UPGRADE_EXCLUDE_BUY
	item_reference = /obj/item/research_upgrades/autodoc
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/machinery/autodoc/internal_bleed
	name = "AutoDoc Internal Bleeding Repair"
	desc = "Data and instruction set for AutoDoc making it capable to fix internal bleedings extremely quick by injecting powerfull coagulant alongside physically fixing it."
	behavior = UPGRADE_TIER_1
	value_upgrade = 1000
	clearance_req = 1

/datum/research_upgrades/machinery/autodoc/broken_bone
	name = "AutoDoc Broken Bone Fixation"
	desc = "Data and instruction set for AutoDoc making it capable to set the fracture and inject bonegel without a single cut."
	behavior = UPGRADE_TIER_2
	value_upgrade = 5000
	clearance_req = 3

/datum/research_upgrades/machinery/autodoc/organ_damage
	name = "AutoDoc Broken Organ Repair"
	desc = "Data and instruction set for AutoDoc making it capable to fix organ damage."
	behavior = UPGRADE_TIER_3
	value_upgrade = 4500
	clearance_req = 2

/datum/research_upgrades/machinery/autodoc/larva_removal
	name = "AutoDoc Broken Embryo Removal"
	desc = "Data and instruction set for AutoDoc making it mildy proficient in removing parasites left by unknown organism."
	behavior = UPGRADE_TIER_4
	value_upgrade = 8000
	clearance_req = 6


/datum/research_upgrades/machinery/sleeper
	name = "Sleeper Upgrade"
	desc = "Research upgrade for Sleeper system, Technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered, as well as upgrading diaslisys software."
	behavior = UPGRADE_TIER_1
	value_upgrade = 1000
	item_reference = /obj/item/research_upgrades/sleeper
	upgrade_type = ITEM_MACHINERY_UPGRADE
	clearance_req = 2

/datum/research_upgrades/item
	name = "Items"
	behavior = UPGRADE_CATEGORY

/datum/research_upgrades/item/research_credits
	name = "Research Credits"
	desc = "Sell the data acquired to the nearest Weyland-Yutani Science devision team for two points."
	value_upgrade = 2000
	item_reference = /obj/item/research_upgrades/credits
	behavior = UPGRADE_TIER_1
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 3

/datum/research_upgrades/item/laser_scalpel
	name = "Lazer Scalpel"
	desc = "A more advanced and robust version of the normal scalpel, allowing it to pierce through thick skin and chitin alike with extreme ease"
	value_upgrade = 5000
	item_reference = /obj/item/tool/surgery/scalpel/laser/advanced
	behavior = UPGRADE_TIER_1
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 3

/datum/research_upgrades/armor
	name = "Armor"
	behavior = UPGRADE_CATEGORY

/datum/research_upgrades/armor/translator
	name = "Universal Translator Plate"
	desc = "A plate which, when attached to uniform, is able to translate any word heard by user without data about that language, effectively allowing to translate new and old languages alike."
	value_upgrade = 2000
	behavior = UPGRADE_TIER_1
	clearance_req = 4
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/translator


/datum/research_upgrades/armor/coagulator
	name = "Active Blood Coagulator Plate"
	desc = "Stops bleedings by coordinated effort of multiple sensors and radioation emmiters. FDA requires us to disclose the dangers and potential results of continuious exposure to radiation"
	value_upgrade = 3000
	behavior = UPGRADE_TIER_1
	clearance_req = 2
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/coagulator

/datum/research_upgrades/armor/emergency_injector
	name = "Medical Emergency Injector"
	desc = "A medical plate with two buttons on the sides with hefty chemical tank. Attached to uniform and on simultanious press injects emergency dose of medical chemicals much larger than a normal emergency autoinjector. Single time use and is recycled in biomass printer. Features overdose protection"
	value_upgrade = 1000
	clearance_req = 3
	behavior = UPGRADE_TIER_1
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/emergency_injector






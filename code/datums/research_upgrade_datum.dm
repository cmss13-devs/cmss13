/datum/research_upgrades
	///unique to every upgrade. not the name of the item. name of the upgrade
	var/name = "Upgrade."
	///name of upgrades, not items. Items are at research_upgrades.dm somewhere in item folder.
	var/desc = "something is broken. yippee!!"
	///which behavior should this type follow. Should this be completely excluded from the buy menu? should it be one of the dropdown options?
	var/behavior = RESEARCH_UPGRADE_EXCLUDE_BUY // should this be on the list? whatever.
	/// the price of the upgrade, refer to this: 500 is a runner, 8k is queen. T3 is usually 3k.
	var/value_upgrade = 1000
	/// actual path to the item.(upgrade)
	var/item_reference
	///In which tab the upgrade should be.
	var/upgrade_type
	///Clearance requirment to buy this upgrade. 5x is level 6. Why is it not that way? no one knows.
	var/clearance_req = 5

/datum/research_upgrades/machinery
	name = "Machinery"
	behavior = RESEARCH_UPGRADE_CATEGORY // one on the dropdown choices you get

/datum/research_upgrades/machinery/autodoc
	name = "AutoDoc Upgrade"
	behavior = RESEARCH_UPGRADE_EXCLUDE_BUY
	item_reference = /obj/item/research_upgrades/autodoc
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/machinery/autodoc/internal_bleed
	name = "AutoDoc Internal Bleeding Repair"
	desc = "A data and instruction set for the Autodoc, making it capable of rapidly fixing internal bleeding."
	behavior = RESEARCH_UPGRADE_TIER_1
	value_upgrade = 1000
	clearance_req = 1

/datum/research_upgrades/machinery/autodoc/broken_bone
	name = "AutoDoc Bone Fracture Repair"
	desc = "A data instruction set for the Autodoc, making it capable of setting fractures and applying bonegel."
	behavior = RESEARCH_UPGRADE_TIER_2
	value_upgrade = 3000
	clearance_req = 3

/datum/research_upgrades/machinery/autodoc/organ_damage
	name = "AutoDoc Broken Organ Repair"
	desc = "A data and instruction set for the Autodoc, making it capable of fixing organ damage."
	behavior = RESEARCH_UPGRADE_TIER_3
	value_upgrade = 2500
	clearance_req = 2

/datum/research_upgrades/machinery/autodoc/larva_removal
	name = "AutoDoc Embryo Removal"
	desc = "Data and instruction set for AutoDoc making it mildly proficient in removing parasites left by unknown organism."
	behavior = RESEARCH_UPGRADE_TIER_4
	value_upgrade = 7000
	clearance_req = 6


/datum/research_upgrades/machinery/sleeper
	name = "Sleeper Upgrade"
	desc = "Research upgrade for Sleeper system, technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered, as well as upgrading dialysis software."
	behavior = RESEARCH_UPGRADE_TIER_1
	value_upgrade = 1000
	item_reference = /obj/item/research_upgrades/sleeper
	upgrade_type = ITEM_MACHINERY_UPGRADE
	clearance_req = 2

/datum/research_upgrades/item
	name = "Items"
	behavior = RESEARCH_UPGRADE_CATEGORY

/datum/research_upgrades/item/research_credits
	name = "Research Credits"
	desc = "Sell the data acquired to the nearest Weyland-Yutani Science division team for two or three points."
	value_upgrade = 1500
	item_reference = /obj/item/research_upgrades/credits
	behavior = RESEARCH_UPGRADE_TIER_1
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 4

/datum/research_upgrades/item/laser_scalpel
	name = "Laser Scalpel"
	desc = "An advanced, robust version of the normal scalpel, allowing it to pierce through thick skin and chitin alike with extreme ease."
	value_upgrade = 3000
	item_reference = /obj/item/tool/surgery/scalpel/laser/advanced
	behavior = RESEARCH_UPGRADE_TIER_1
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 3

/datum/research_upgrades/item/incision_management
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	value_upgrade = 3500
	item_reference = /obj/item/tool/surgery/scalpel/manager
	behavior = RESEARCH_UPGRADE_TIER_1
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 5

/datum/research_upgrades/armor
	name = "Armor"
	behavior = RESEARCH_UPGRADE_CATEGORY

/datum/research_upgrades/armor/translator
	name = "Universal Translator Plate"
	desc = "A uniform-attachable plate capable of translating any unknown language heard by the wearer."
	value_upgrade = 2000
	behavior = RESEARCH_UPGRADE_TIER_1
	clearance_req = 5
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/translator


/datum/research_upgrades/armor/coagulator
	name = "Active Blood Coagulator Plate"
	desc = "A uniform-attachable plate capable of coagulating any bleeding wounds the user possesses."
	value_upgrade = 1250
	behavior = RESEARCH_UPGRADE_TIER_1
	clearance_req = 2
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/coagulator

/datum/research_upgrades/armor/emergency_injector
	name = "Medical Emergency Injector"
	desc = "A medical plate with two buttons on the sides with hefty chemical tank. Attached to uniform and on simultanious press injects emergency dose of medical chemicals much larger than a normal emergency autoinjector. Single time use and is recycled in biomass printer. Features overdose protection"
	value_upgrade = 750
	clearance_req = 1
	behavior = RESEARCH_UPGRADE_TIER_1
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/emergency_injector

/datum/research_upgrades/armor/ceramic
	name = "Ceramic Armor Plate"
	desc = "A strong trauma plate, able to protect the user from a large amount of bullets. completely useless against sharp objects."
	value_upgrade = 500
	clearance_req = 4
	behavior = RESEARCH_UPGRADE_TIER_1
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/ceramic_plate





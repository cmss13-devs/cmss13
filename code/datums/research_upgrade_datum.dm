/datum/research_upgrades
	///unique to every upgrade. not the name of the item. name of the upgrade
	var/name = "Upgrade."
	///name of upgrades, not items. Items are at research_upgrades.dm somewhere in item folder.
	var/desc = "something is broken. yippee!!"
	///which behavior should this type follow. Should this be completely excluded from the buy menu? should it be one of the dropdown options? or a normal item?
	var/behavior = RESEARCH_UPGRADE_EXCLUDE_BUY // should this be on the list?
	/// the price of the upgrade, refer to this: 500 is a runner, 8k is queen. T3 is usually 3k, woyer is 2k.
	var/value_upgrade = 1000
	///In which tab the upgrade should be.
	var/upgrade_type
	///Path to the item, upgrade, if any.
	var/item_reference
	///Clearance requirment to buy this upgrade. 5x is level 6. Why is it not that way? no one knows.
	var/clearance_req = 5
	///The change of price for item per purchase, recommended for mass producing stuff or limited upgrade.
	var/change_purchase = 0
	///the minimum price which we cant go any cheaper usually dont need to set this if change price is 0 or positive
	var/minimum_price = 0
	///the maximum price which we cant go any more expensive, usually dont need to set this if change price is 0 or negative
	var/maximum_price = INFINITY

///gets called once the product is purchased, override if you need to pass any special arguments or have special behavior on purchase.
/datum/research_upgrades/proc/on_purchase(turf/machine_loc)
	if(isnull(item_reference))
		return
	new item_reference(machine_loc)

/datum/research_upgrades/machinery
	name = "Machinery"
	behavior = RESEARCH_UPGRADE_CATEGORY // one on the dropdown choices you get

/datum/research_upgrades/machinery/autodoc
	name = "AutoDoc Upgrade"
	behavior = RESEARCH_UPGRADE_EXCLUDE_BUY
	upgrade_type = ITEM_MACHINERY_UPGRADE

/datum/research_upgrades/machinery/autodoc/internal_bleed
	name = "AutoDoc Internal Bleeding Repair"
	desc = "A data and instruction set for the AutoDoc, making it capable of rapidly fixing internal bleeding."
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 200
	clearance_req = 1

/datum/research_upgrades/machinery/autodoc/internal_bleed/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc(machine_loc, RESEARCH_UPGRADE_TIER_1)

/datum/research_upgrades/machinery/autodoc/broken_bone
	name = "AutoDoc Bone Fracture Repair"
	desc = "A data instruction set for the AutoDoc, making it capable of setting fractures and applying bonegel."
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 2000
	clearance_req = 3

/datum/research_upgrades/machinery/autodoc/broken_bone/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc(machine_loc, RESEARCH_UPGRADE_TIER_2)

/datum/research_upgrades/machinery/autodoc/organ_damage
	name = "AutoDoc Broken Organ Repair"
	desc = "A data and instruction set for the AutoDoc, making it capable of fixing organ damage."
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 1500
	clearance_req = 2

/datum/research_upgrades/machinery/autodoc/organ_damage/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc(machine_loc, RESEARCH_UPGRADE_TIER_3)

/datum/research_upgrades/machinery/autodoc/larva_removal
	name = "AutoDoc Embryo Removal"
	desc = "Data and instruction set for AutoDoc making it mildly proficient in removing parasites left by unknown organism."
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 4000
	clearance_req = 6

/datum/research_upgrades/machinery/autodoc/larva_removal/on_purchase(turf/machine_loc)
	new /obj/item/research_upgrades/autodoc(machine_loc, RESEARCH_UPGRADE_TIER_4)


/datum/research_upgrades/machinery/sleeper
	name = "Sleeper Upgrade"
	desc = "Research upgrade for Sleeper system, technology on this disk is used on a sleeper to allow wider spectrum of chemicals to be administered, as well as upgrading dialysis software."
	behavior = RESEARCH_UPGRADE_ITEM
	value_upgrade = 500
	item_reference = /obj/item/research_upgrades/sleeper
	upgrade_type = ITEM_MACHINERY_UPGRADE
	clearance_req = 1

/datum/research_upgrades/item
	name = "Items"
	behavior = RESEARCH_UPGRADE_CATEGORY

/datum/research_upgrades/item/research_credits
	name = "Research Credits"
	desc = "Sell the data acquired to the nearest Weyland-Yutani Science division team for 8 or 9 points."
	value_upgrade = 2000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	item_reference = /obj/item/research_upgrades/credits
	change_purchase = 500
	maximum_price = 5000
	clearance_req = 5

/datum/research_upgrades/item/laser_scalpel
	name = "Laser Scalpel"
	desc = "An advanced, robust version of the normal scalpel, allowing it to pierce through thick skin and chitin alike with extreme ease."
	value_upgrade = 3000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	item_reference = /obj/item/tool/surgery/scalpel/laser/advanced
	clearance_req = 3

/datum/research_upgrades/item/incision_management
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision, allowing for the immediate commencement of therapeutic steps."
	value_upgrade = 3000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	clearance_req = 4
	item_reference = /obj/item/tool/surgery/scalpel/manager


/datum/research_upgrades/item/nanosplints
	name = "Reinforced Fiber Splints"
	desc = "A set of splints made from durable carbon fiber sheets reinforced with flexible titanium lattice, comes in a stack of five."
	value_upgrade = 800
	clearance_req = 3
	change_purchase = -200
	minimum_price = 200
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE

/datum/research_upgrades/item/nanosplints/on_purchase(turf/machine_loc)
	new /obj/item/stack/medical/splint/nano/research(machine_loc, 5)//adjust this to change amount of nanosplints in a stack, cant be higher than five, go change max_amount in the nanosplint itself, then change it.

/datum/research_upgrades/item/flamer_tank
	name = "Upgraded Incinerator Tank"
	desc = "An upgraded incinerator tank, with larger capacity and able to handle stronger fuels."
	value_upgrade = 300
	clearance_req = 1
	change_purchase = 100
	minimum_price = 100
	maximum_price = 1000
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ACCESSORY_UPGRADE
	item_reference = /obj/item/ammo_magazine/flamer_tank/custom/upgraded

/datum/research_upgrades/item/flamer_tank/smoke
	name = "Upgraded Incinerator Smoke Tank"
	desc = "An upgraded incinerator smoke tank with a larger capacity."
	value_upgrade = 100 //not useful enough to be expensive
	clearance_req = 1
	change_purchase = 50
	minimum_price = 100
	maximum_price = 500
	item_reference = /obj/item/ammo_magazine/flamer_tank/smoke/upgraded

/datum/research_upgrades/armor
	name = "Armor"
	behavior = RESEARCH_UPGRADE_CATEGORY

/datum/research_upgrades/armor/translator
	name = "Universal Translator Plate"
	desc = "A uniform-attachable plate capable of translating any unknown language heard by the wearer."
	value_upgrade = 2000
	behavior = RESEARCH_UPGRADE_ITEM
	clearance_req = 6
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/translator

/datum/research_upgrades/armor/coagulator
	name = "Active Blood Coagulator Plate"
	desc = "A uniform-attachable plate capable of coagulating any bleeding wounds the user possesses."
	value_upgrade = 1200
	behavior = RESEARCH_UPGRADE_ITEM
	clearance_req = 2
	change_purchase = -200
	minimum_price = 200
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/coagulator


/datum/research_upgrades/armor/emergency_injector
	name = "Medical Emergency Injector"
	desc = "A medical plate with two buttons on the sides and a hefty chemical tank. Attached to a uniform and on a simultaneous press, it injects an emergency dose of medical chemicals much larger than a normal emergency autoinjector. Single time use and is recycled in biomass printer. Features overdose protection."
	value_upgrade = 250
	clearance_req = 1
	behavior = RESEARCH_UPGRADE_ITEM
	change_purchase = -100
	minimum_price = 100
	upgrade_type = ITEM_ARMOR_UPGRADE
	item_reference = /obj/item/clothing/accessory/health/research_plate/emergency_injector

/datum/research_upgrades/armor/ceramic
	name = "Ceramic Armor Plate"
	desc = "A strong trauma plate, able to protect the user from a large amount of bullets. Completely useless against sharp objects."
	value_upgrade = 500
	clearance_req = 4
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ARMOR_UPGRADE
	change_purchase = -50
	minimum_price = 200
	item_reference = /obj/item/clothing/accessory/health/ceramic_plate

/datum/research_upgrades/armor/preservation
	name = "Death Preservation Plate"
	desc = "Preservation plate which activates once the user is dead, uses variety of different substances and sensors to slow down the decay and increase the time before the user is permanently dead, due to small tank of preservatives, it needs to be replaced on each death. Extends time to permadeath by around four minutes."
	value_upgrade = 500
	clearance_req = 4
	behavior = RESEARCH_UPGRADE_ITEM
	upgrade_type = ITEM_ARMOR_UPGRADE
	change_purchase = -100
	minimum_price = 100
	item_reference = /obj/item/clothing/accessory/health/research_plate/anti_decay

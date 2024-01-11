GLOBAL_LIST_INIT(cm_vending_clothing_tutorial, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/clothing/head/helmet/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Medium Armor", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("POUCHES (CHOOSE 1)", 0, null, null, null),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),

	)) // The pouch uses a different category so they only get one

/obj/structure/machinery/cm_vending/clothing/tutorial
	name = "\improper ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/tutorial/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial

// Med Standard Vendor Tutorial

GLOBAL_LIST_INIT(cm_vending_clothing_tutorialstandard, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/clothing/head/helmet/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Medium Armor", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

	))

/obj/structure/machinery/cm_vending/clothing/tutorialmed
	name = "\improper ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/tutorialmed/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorialstandard

//Standard Med Vendor 1
GLOBAL_LIST_INIT(cm_vending_clothing_tutorial_medic, list(
		list("POUCHES (CHOOSE 1)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/tutorial_medic_equip
	name = "\improper ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/tutorial_medic_equip/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_medic

//Standard Med Vendor 2
GLOBAL_LIST_INIT(cm_vending_clothing_tutorial_medic_bravo, list(
		list("POUCHES (CHOOSE 1)", 0, null, null, null),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	))
/obj/structure/machinery/cm_vending/clothing/tutorial_medic_equip_bravo
	name = "\improper ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/tutorial_medic_equip_bravo/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_medic_bravo

//Standard Med Vendor 3
GLOBAL_LIST_INIT(cm_vending_clothing_tutorial_medic_charlie, list(
		list("POUCHES (CHOOSE 1)", 0, null, null, null),
		list("First-Aid Pouch (Pill Packets)", 1, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/sorted/uniform_supply/tutorial_medic_equip_charlie
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a small storage of standard marine uniforms."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)
	req_one_access = list()

	vendor_role = list()

/obj/structure/machinery/cm_vending/sorted/uniform_supply/tutorial_medic_equip_charlie/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_medic_charlie

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep_tutorial
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a small storage of standard marine uniforms."
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)
	req_one_access = list()

	vendor_role = list()

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep_tutorial/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_prep

GLOBAL_LIST_INIT(cm_vending_clothing_tutorial_prep, list(
		list("STANDARD EQUIPMENT", 0, null, null, null),
		list("Marine Combat Boots", 1, /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Boots", 1, /obj/item/clothing/shoes/marine/brown, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", 1, /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 1, /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Gloves", 1, /obj/item/clothing/gloves/marine/brown, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", 1, /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Radio Headset", 1, /obj/item/device/radio/headset/almayer, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Marine Helmet", 1, /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),

		list("WEBBINGS", 0, null, null),
		list("Brown Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Webbing", 1, /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 1, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 1, /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("ARMOR", 0, null, null),
		list("M3 Pattern Carrier Marine Armor", 1, /obj/item/clothing/suit/storage/marine/medium/carrier, VENDOR_ITEM_REGULAR),
		list("M3-EOD Pattern Heavy Armor", 1, /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", 1, /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),

		list("BACKPACK", 0, null, null, null),
		list("Lightweight IMP Backpack", 1, /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Technician Backpack", 1, /obj/item/storage/backpack/marine/tech, VENDOR_ITEM_REGULAR),
		list("Medical Backpack", 1, /obj/item/storage/backpack/marine/medic, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", 1, /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Technical Satchel", 1, /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),
		list("USCM Technical Chestrig", 1, /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, VENDOR_ITEM_REGULAR),
		list("Medical Satchel", 1, /obj/item/storage/backpack/marine/satchel/medic, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", 1, /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),

		list("RESTRICTED BACKPACKS", 0, null, null),
		list("USCM Technician Welderpack", 1, /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", 1, /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("Radio Telephone Backpack", 1, /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("BELTS", 0, null, null),
		list("M276 Pattern Ammo Load Rig", 1, /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M40 Grenade Rig", 1, /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", 1, /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", 1, /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", 1, /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig And Pouch", 1, /obj/item/storage/belt/gun/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", 1, /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M82F Holster Rig", 1, /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", 1, /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 1, /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("POUCHES", 0, null, null, null),
		list("Bayonet Sheath (Full)",1, /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 1, /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 1, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 1, /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Small Document Pouch", 1, /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 1, /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 1, /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 1, /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", 1, /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 1, /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("RESTRICTED POUCHES", 0, null, null, null),
		list("Construction Pouch", 1, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 1, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch (Empty)", 1, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 1, /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Tools Pouch", 1, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 1, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		))

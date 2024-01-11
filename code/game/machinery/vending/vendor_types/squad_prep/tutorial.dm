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

/obj/structure/machinery/cm_vending/clothing/medic_equip
	name = "\improper ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/medic_equip/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_medic

//Standard Med Vendor 2
GLOBAL_LIST_INIT(cm_vending_clothing_tutorial_medic_bravo, list(
		list("POUCHES (CHOOSE 1)", 0, null, null, null),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	))
/obj/structure/machinery/cm_vending/clothing/medic_equip_bravo
	name = "\improper ColMarTech Automated Marine Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Marine Rifleman standard-issue equipment."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)

	vendor_role = list()

/obj/structure/machinery/cm_vending/clothing/medic_equip_bravo/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_medic_bravo

//Standard Med Vendor 3
GLOBAL_LIST_INIT(cm_vending_clothing_tutorial_medic_charlie, list(
		list("POUCHES (CHOOSE 1)", 0, null, null, null),
		list("First-Aid Pouch (Pill Packets)", 1, /obj/item/storage/pouch/firstaid/full/pills, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/sorted/uniform_supply/medic_equip_charlie
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a small storage of standard marine uniforms."
	icon_state = "mar_rack"
	show_points = TRUE
	vendor_theme = VENDOR_THEME_USCM
	req_access = list(ACCESS_TUTORIAL_LOCKED)
	req_one_access = list()

	vendor_role = list()

/obj/structure/machinery/cm_vending/sorted/uniform_supply/medic_equip_charlie/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_tutorial_medic_charlie

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

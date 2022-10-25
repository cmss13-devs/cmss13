//------------ MP CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_mp, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine/mp, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mp, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Military Police M2 Pattern Armor", 0, /obj/item/clothing/suit/storage/marine/mp, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Military Police M2 Pattern Padless Armor", 0, /obj/item/clothing/suit/storage/marine/mp/padless, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Military Police M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/mp, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (TAKE ALL)", 0, null, null, null),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR)

	))

/obj/structure/machinery/cm_vending/clothing/mp
	name = "\improper ColMarTech Military Police Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Military Police standard-issue equipment."
	req_access = list(ACCESS_MARINE_BRIG)
	vendor_role = list(JOB_POLICE)

/obj/structure/machinery/cm_vending/clothing/mp/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_mp

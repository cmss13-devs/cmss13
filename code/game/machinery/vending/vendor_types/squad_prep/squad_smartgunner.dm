//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_smartgun, list(
		list("SMARTGUN SET (MANDATORY)", 0, null, null, null),
		list("Essential Smartgunner Set", 0, /obj/item/storage/box/m56_system, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("SMARTGUN AMMUNITION", 0, null, null, null),
		list("M56 Smartgun Drum", 15, /obj/item/ammo_magazine/smartgun, null, VENDOR_ITEM_MANDATORY),

		list("SMARTGUN EXTRA UTILITIES (CHOOSE 1)", 0, null, null, null),
		list("Burst Fire Assembly", 0, /obj/item/attachable/burstfire_assembly, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 0, /obj/item/cell/high, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("GUN ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Quickfire Adapter", 0, /obj/item/attachable/quickfire, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/smartgun
	name = "\improper ColMarTech Squad Smartgunner Gear Rack"
	desc = "An automated gear rack for Squad Smartgunners."
	icon_state = "sg_gear"
	vendor_role = list(JOB_SQUAD_SMARTGUN)
	req_access = list(ACCESS_MARINE_SMARTPREP)

/obj/structure/machinery/cm_vending/gear/smartgun/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_gear_smartgun

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_smartgun, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("BELT", 0, null, null, null),
		list("M802 Smartgunner Ammo Belt", 0, /obj/item/storage/belt/gun/smartgunner/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Firstaid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/clothing/smartgun
	name = "\improper ColMarTech Squad Smartgun Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Squad Smartgun standard-issue equipment."
	req_access = list(ACCESS_MARINE_SMARTPREP)
	vendor_role = list(JOB_SQUAD_SMARTGUN)

/obj/structure/machinery/cm_vending/clothing/smartgun/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_smartgun

/obj/structure/machinery/cm_vending/clothing/smartgun/alpha
	squad_tag = SQUAD_NAME_1
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/alpha
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/smartgun/bravo
	squad_tag = SQUAD_NAME_2
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/bravo
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/smartgun/charlie
	squad_tag = SQUAD_NAME_3
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/charlie
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/smartgun/delta
	squad_tag = SQUAD_NAME_4
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/delta
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

//------------ESSENTIAL SETS---------------

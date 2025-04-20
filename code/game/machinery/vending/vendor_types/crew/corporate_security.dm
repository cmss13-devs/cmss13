//------------ CL CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_corporate_security, list(
	list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
	list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
	list("Uniform", 0, /obj/item/clothing/under/marine/veteran/pmc/corporate, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Headset", 0, /obj/item/device/radio/headset/almayer/mcl/sec, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
	list("Corporate Boots", 0, /obj/item/clothing/shoes/marine/corporate/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

	list("ARMOR (TAKE ALL)", 0, null, null, null),
	list("Corporate Security Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light/corporate, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
	list("Corporate Security Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

	list("FIREARM CASE (CHOOSE 1)", 0, null, null, null),
	list("M41A Pulse Rifle MK2", 0, /obj/effect/essentials_set/wy_m41a, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
	list("M39 Submachine Gun", 0, /obj/effect/essentials_set/wy_m39, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

	list("HANDGUN CASE (CHOOSE 1)", 0, null, null, null),
	list("88 mod 4 Combat Pistol Case", 0, /obj/item/storage/box/guncase/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
	list("M44 Combat Revolver Case", 0, /obj/item/storage/box/guncase/m44, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
	list("M4A3 Service Pistol Case", 0, /obj/item/storage/box/guncase/m4a3, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

	list("BACKPACK (CHOOSE 1)", 0, null, null, null),
	list("Black Leather Satchel", 0, /obj/item/storage/backpack/satchel/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

	list("BELT (CHOOSE 1)", 0, null, null, null),
	list("WY-TM892 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3/wy/mod88, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

	list("POUCHES (CHOOSE 2)", 0, null, null, null),
	list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
	list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
	list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
	list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

	list("MASK (CHOOSE 1)", 0, null, null, null),
	list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

	list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
	list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
	list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/clothing/corporate_security
	name = "\improper Corporate Security Equipment Rack"
	desc = "A wardrobe containing all the clothes an executive would ever need."
	vendor_theme = VENDOR_THEME_COMPANY
	show_points = FALSE
	req_access = list(ACCESS_WY_GENERAL)
	vendor_role = list(JOB_CORPORATE_SECURITY)
	desc = "An automated rack hooked up to a colossal storage of Corporate Security standard-issue equipment."

/obj/structure/machinery/cm_vending/clothing/corporate_security/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_corporate_security


/obj/effect/essentials_set/wy_m41a
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/m41a/corporate,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle,
		/obj/item/ammo_magazine/rifle,
	)

/obj/effect/essentials_set/wy_m39
	spawned_gear_list = list(
		/obj/item/weapon/gun/smg/m39/corporate,
		/obj/item/ammo_magazine/smg/m39,
		/obj/item/ammo_magazine/smg/m39,
		/obj/item/ammo_magazine/smg/m39,
	)

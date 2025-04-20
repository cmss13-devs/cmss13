//------------ CL CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_corporate_security, list(
	list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
	list("Gloves", 0, /obj/item/clothing/gloves/marine/veteran/pmc, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
	list("Uniform", 0, /obj/item/clothing/under/marine/veteran/pmc/guard, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
	list("Headset", 0, /obj/item/device/radio/headset/almayer/mcl/sec, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
	list("Corporate Boots", 0, /obj/item/clothing/shoes/veteran/pmc/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
	list("Tactical SWAT HUD", 0, /obj/item/clothing/glasses/sunglasses/sechud/tactical, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),

	list("ARMOR (CHOOSE 1)", 0, null, null, null),
	list("Security Guard Light Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/light/bulletproof/guard, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
	list("Security Guard Medium Armor", 0, /obj/item/clothing/suit/storage/marine/veteran/pmc/guard, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

	list("HEADGEAR (CHOOSE 1)", 0, null, null, null),
	list("Security Guard Armored Cap", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/guard, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
	list("Corporate Security Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/pmc/corporate, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

	list("BACKPACK (CHOOSE 1)", 0, null, null, null),
	list("Black Leather Satchel", 0, /obj/item/storage/backpack/satchel/black, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
	list("PMC Combat Pack", 0, /obj/item/storage/backpack/pmc, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

	list("POUCHES (CHOOSE 2)", 0, null, null, null),
	list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
	list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine/wy, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

	list("MASK (CHOOSE 1)", 0, null, null, null),
	list("Armored Balaclava", 0, /obj/item/clothing/mask/gas/pmc, MARINE_CAN_BUY_MASK, VENDOR_ITEM_RECOMMENDED),
	list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

	list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
	list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
	list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

	list("PRIMARY WEAPON (CHOOSE 1)", 0, null, null, null),
	list("M41A Pulse Rifle MK2", 0, /obj/effect/essentials_set/wy_m41a, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
	list("M39 Submachine Gun", 0, /obj/effect/essentials_set/wy_m39, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),
	list("NSG23 Assault Rifle", 0, /obj/effect/essentials_set/wy_nsg23, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

	list("SIDEARM (CHOOSE 1)", 0, null, null, null),
	list("ES-4 Electrostatic Pistol", 0, /obj/item/storage/belt/gun/m4a3/wy/es4, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
	list("88 Mod 4 Combat Pistol", 0, /obj/item/storage/belt/gun/m4a3/wy/mod88, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
	list("VP78 Pistol", 8, /obj/item/storage/belt/gun/m4a3/wy/vp78, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

	list("PRIMARY AMMUNITION", 0, null, null, null),
	list("M39 Magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39 , null, VENDOR_ITEM_REGULAR),
	list("M39 Extended Magazine (10x20mm)", 8, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
	list("M39 AP Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
	list("M41A Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle , null, VENDOR_ITEM_REGULAR),
	list("M41A Extended Magazine (10x24mm)", 8, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),
	list("M41A AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
	list("NSG 23 magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/nsg23, null, VENDOR_ITEM_REGULAR),
	list("NSG 23 extended magazine (10x24mm)", 8, /obj/item/ammo_magazine/rifle/nsg23/extended, null, VENDOR_ITEM_REGULAR),
	list("NSG 23 armor-piercing magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/nsg23/ap, null, VENDOR_ITEM_REGULAR),

	list("SIDEARM AMMUNITION", 0, null, null, null),
	list("ES-4 Stun Magazine (9mm)", 4, /obj/item/ammo_magazine/pistol/es4, null, VENDOR_ITEM_REGULAR),
	list("88M4 AP Magazine (9mm)", 4, /obj/item/ammo_magazine/pistol/mod88, null, VENDOR_ITEM_REGULAR),
	list("VP78 Magazine (9mm)", 6, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),

	list("SPARE EQUIPMENT", 0, null, null, null),
	list("Handheld Flash", 2, /obj/item/device/flash, null, VENDOR_ITEM_REGULAR),
	list("Pepper Spray", 4, /obj/item/reagent_container/spray/pepper, null, VENDOR_ITEM_REGULAR),
	list("Stun Baton", 4, /obj/item/weapon/baton, null, VENDOR_ITEM_REGULAR),
	list("Box of Zipties", 4, /obj/item/storage/box/zipcuffs/small, null, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/clothing/corporate_security
	name = "\improper Corporate Security Equipment Rack"
	desc = "A wardrobe containing all the clothes an executive would ever need."
	vendor_theme = VENDOR_THEME_COMPANY
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

/obj/effect/essentials_set/wy_nsg23
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/nsg23/stripped,
		/obj/item/ammo_magazine/rifle/nsg23,
		/obj/item/ammo_magazine/rifle/nsg23,
		/obj/item/ammo_magazine/rifle/nsg23,
	)

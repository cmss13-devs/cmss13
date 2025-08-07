//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_sea, list(
		list("PERSONAL PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("M41A MK1 Pulse Rifle", 0, /obj/item/weapon/gun/rifle/m41aMK1, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_REGULAR),

		list("SPARE AMMUNITION", 0, null, null, null),
		list("M41A MK1 Magazine", 9, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_REGULAR),

		list("GUN ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 0, /obj/item/attachable/flashlight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/sea
	name = "ColMarTech SEA Weapon Rack"
	desc = "An automated gear rack for the Senior Enlisted Advisor."
	req_access = list(ACCESS_MARINE_SEA)
	vendor_role = list(JOB_SEA)
	icon_state = "guns"

/obj/structure/machinery/cm_vending/gear/sea/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_sea

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_sea, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Drill Hat", 0, /obj/item/clothing/head/drillhat, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Officer Uniform", 0, /obj/item/clothing/under/marine/dress, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("USCM Service Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/sea, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/lockable, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("GLOVES (CHOOSE 1)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Combat Toolbelt Rig (Full)", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("COMBAT GEAR", 0, null, null, null),
		list("M10 Helmet", 0, /obj/item/clothing/head/helmet/marine, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_REGULAR),
		list("M3-VL Pattern Ballistics Vest", 0, /obj/item/clothing/suit/storage/marine/light/vest, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", 0, /obj/item/clothing/suit/storage/marine/light, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("M3 Pattern Padded Armor", 0, /obj/item/clothing/suit/storage/marine/medium/padded, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_REGULAR),
		list("Bulletproof Vest", 0, /obj/item/clothing/suit/armor/bulletproof, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_REGULAR),

		list("EYEWEAR (CHOOSE 1)", 0, null, null, null),
		list("Welding Goggles", 0, /obj/item/clothing/glasses/welding, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Prescription Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health/prescription, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Sunglasses", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/sea
	name = "ColMarTech SEA Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Senior Enlisted Advisor standard-issue equipment."
	req_access = list(ACCESS_MARINE_SEA)
	vendor_role = list(JOB_SEA)

/obj/structure/machinery/cm_vending/clothing/sea/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_sea

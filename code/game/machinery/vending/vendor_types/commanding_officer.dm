//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_commanding_officer, list(
		list("PERSONAL PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("M46C pulse rifle", 0, /obj/item/weapon/gun/rifle/m46c, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("FN FP9000", 0, /obj/item/weapon/gun/smg/fp9000, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),
		list("M16 rifle", 0, /obj/item/weapon/gun/rifle/m16, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41aMK1 Magazine", 40, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A Extended Magazine", 30, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine", 20, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("FN FP9000 Magazine", 20, /obj/item/ammo_magazine/smg/fp9000, null, VENDOR_ITEM_REGULAR),
		list("M16 Magazine", 20, /obj/item/ammo_magazine/rifle/m16, null, VENDOR_ITEM_REGULAR),
		list("M16 AP Magazine", 20, /obj/item/ammo_magazine/rifle/m16/ap, null, VENDOR_ITEM_REGULAR),

		list("SHOTGUN AMMUNITION", 0, null, null, null),
		list("Buckshot Shells", 20, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("Shotgun Slugs", 20, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("Flechette Shells", 25, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("M41A Incendiary Magazine", 65, /obj/item/ammo_magazine/rifle/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M41A Rubber Shot Magazine", 10, /obj/item/ammo_magazine/rifle/rubber, null, VENDOR_ITEM_REGULAR),
		list("Beanbag Slugs", 10, /obj/item/ammo_magazine/shotgun/beanbag, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("High Impact Mateba Speedloader (.454)", 20, /obj/item/ammo_magazine/revolver/mateba/highimpact, null, VENDOR_ITEM_REGULAR),
		list("Mateba Speedloader (.454)", 10, /obj/item/ammo_magazine/revolver/mateba, null, VENDOR_ITEM_REGULAR),
		list("High Impact Desert Eagle Magazine (.50)", 25, /obj/item/ammo_magazine/pistol/heavy/highimpact, null, VENDOR_ITEM_REGULAR),
		list("Desert Eagle Magazine (.50)", 10, /obj/item/ammo_magazine/pistol/heavy, null, VENDOR_ITEM_REGULAR),
		list("M1911 Magazine (.45)", 10, /obj/item/ammo_magazine/pistol/m1911, null, VENDOR_ITEM_REGULAR),

		list("GUN ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/commanding_officer
	name = "\improper ColMarTech Commanding Officer Weapon Rack"
	desc = "An automated gear rack for the Commanding Officer."
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = list(JOB_CO)
	icon_state = "guns"
	use_snowflake_points = TRUE

/obj/structure/machinery/cm_vending/gear/commanding_officer/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_gear_commanding_officer


//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_commanding_officer, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/techofficer/commander, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/lockable, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("Mateba autorevolver custom", 0, /obj/effect/essentials_set/cmateba, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Desert Eagle", 0, /obj/item/storage/belt/gun/m4a3/heavy/co, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M1911 pistol", 0, /obj/item/storage/belt/gun/m4a3/m1911, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("Combat Equipment (TAKE ALL)", 0, null, null, null),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/MP/CO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/CO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

/obj/structure/machinery/cm_vending/clothing/commanding_officer
	name = "\improper ColMarTech Commanding Officer Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Commanding Officer standard-issue equipment."
	req_access = list(ACCESS_MARINE_COMMANDER)
	vendor_role = list(JOB_CO)

/obj/structure/machinery/cm_vending/clothing/commanding_officer/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_commanding_officer


/obj/effect/essentials_set/cmateba
	spawned_gear_list = list(
		/obj/item/storage/belt/gun/mateba/cmateba/full,
		/obj/item/storage/mateba_case/captain
	)
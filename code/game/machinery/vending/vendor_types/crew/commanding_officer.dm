//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_commanding_officer, list(
		list("COMMANDER'S PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("M46C Pulse Rifle", 0, /obj/effect/essentials_set/co/riflepreset, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M56C Smartgun", 0, /obj/item/storage/box/m56c_system, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("M41A MK1 Magazine", 30, /obj/item/ammo_magazine/rifle/m41aMK1, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A MK1 AP Magazine", 40, /obj/item/ammo_magazine/rifle/m41aMK1/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A Extended Magazine", 20, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine", 20, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M56B Smartgun Drum", 20, /obj/item/ammo_magazine/smartgun, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("High Impact Mateba Speedloader (.454)", 15, /obj/item/ammo_magazine/revolver/mateba/highimpact, null, VENDOR_ITEM_RECOMMENDED),
		list("High Impact AP Mateba Speedloader (.454)", 20, /obj/item/ammo_magazine/revolver/mateba/highimpact/ap, null, VENDOR_ITEM_REGULAR),
		list("High Impact Desert Eagle Magazine (.50)", 15, /obj/item/ammo_magazine/pistol/heavy/super/highimpact, null, VENDOR_ITEM_RECOMMENDED),
		list("High Impact AP Desert Eagle Magazine (.50)", 20, /obj/item/ammo_magazine/pistol/heavy/super/highimpact/ap, null, VENDOR_ITEM_REGULAR),

		list("SHOTGUN AMMUNITION", 0, null, null, null),
		list("Buckshot Shells", 20, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("Shotgun Slugs", 20, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("Flechette Shells", 20, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", 0, null, null, null),
		list("M41A Incendiary Magazine", 65, /obj/item/ammo_magazine/rifle/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M41A Rubber Shot Magazine", 10, /obj/item/ammo_magazine/rifle/rubber, null, VENDOR_ITEM_REGULAR),
		list("Beanbag Slugs", 10, /obj/item/ammo_magazine/shotgun/beanbag, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("HEDP Grenade Pack", 15, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("HEFA Grenade Pack", 15, /obj/item/storage/box/packet/hefa, null, VENDOR_ITEM_REGULAR),
		list("WP Grenade Pack", 15, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("G2 Electroshock Grenade Packet (x3 grenades)",  15, /obj/item/storage/box/packet/sebb, null, VENDOR_ITEM_REGULAR),

		list("RAIL ATTACHMENTS", 0, null, null, null),
		list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 15, /obj/item/attachable/scope/mini, null, VENDOR_ITEM_REGULAR),

		list("Helmet Visors", 0, null, null, null),
		list("Night Vision Visor", 10, /obj/item/device/helmet_visor/night_vision, null, VENDOR_ITEM_RECOMMENDED),
		list("Medical Visor", 5, /obj/item/device/helmet_visor/medical/advanced, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL ATTACHMENTS", 0, null, null, null),
		list("Laser Sight", 15, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Angled Grip", 15, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 15, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Shotgun", 15, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", 15, /obj/item/attachable/attached_gun/extinguisher, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flamethrower", 15, /obj/item/attachable/attached_gun/flamer, null, VENDOR_ITEM_REGULAR),
		list("Underbarrel Grenade Launcher", 5, /obj/item/attachable/attached_gun/grenade, null, VENDOR_ITEM_REGULAR),

		list("BARREL ATTACHMENTS", 0, null, null, null),
		list("Extended Barrel", 15, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 15, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 15, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/gear/commanding_officer
	name = "\improper ColMarTech Commanding Officer Weapon Rack"
	desc = "An automated weapons rack for the Commanding Officer. It features a robust selection of weaponry meant only for the USCM's top officers."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CO, JOB_WO_CO)
	icon_state = "guns"
	use_snowflake_points = TRUE

/obj/structure/machinery/cm_vending/gear/commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_commanding_officer

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_commanding_officer, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom/cdrcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("COMMANDING OFFICER ESSENTIALS KIT (TAKE ALL)", 0, null, null, null),
		list("Commanding Officer Essentials Kit", 0, /obj/effect/essentials_set/commanding_officer, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("BAGS (CHOOSE 1)", 0, null, null, null),
		list("Commanding Officer Backpack", 0, /obj/item/storage/backpack/mcommander, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Secure Satchel", 0, /obj/item/storage/backpack/satchel/lockable, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("RTO Telephone Pack", 0, /obj/item/storage/backpack/marine/satchel/rto, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Intel Expedition Pack", 0, /obj/item/storage/backpack/marine/satchel/intel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Commanding Officer's M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/CO, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("M11C Helmet", 0, /obj/item/clothing/head/helmet/marine/leader/CO, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Insulated Combat Gloves", 0, /obj/item/clothing/gloves/marine/insulated/black, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HUDS (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("BELTS (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Military Police Belt", 0, /obj/item/storage/belt/security/MP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Rig", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Lifesaver Rig", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Holster Toolrig", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("PATCHES (DISCRETIONARY)", 0, null, null, null),
		list("Falling Falcons Shoulder Patch", 0, /obj/item/clothing/accessory/patch/falcon, null, VENDOR_ITEM_REGULAR),
		list("Falling Falcons UA Shoulder Patch", 0, /obj/item/clothing/accessory/patch/falconalt, null, VENDOR_ITEM_REGULAR),
		list("USCM Large Chest Patch", 0, /obj/item/clothing/accessory/patch/uscmlarge, null, VENDOR_ITEM_REGULAR),
		list("USCM Shoulder Patch", 0, /obj/item/clothing/accessory/patch, null, VENDOR_ITEM_REGULAR),
		list("United Americas Shoulder patch", 0, /obj/item/clothing/accessory/patch/ua, null, VENDOR_ITEM_REGULAR),
		list("United Americas Flag Shoulder patch", 0, /obj/item/clothing/accessory/patch/uasquare, null, VENDOR_ITEM_REGULAR),
		list("Falling Falcons Challenge Coin", 0, /obj/item/coin/silver/falcon, null, VENDOR_ITEM_REGULAR)
))

/obj/structure/machinery/cm_vending/clothing/commanding_officer
	name = "\improper ColMarTech Commanding Officer Equipment Rack"
	desc = "An automated equipment vendor for the Commanding Officer. Contains a prime selection of equipment for only the USCM's top officers."
	req_access = list(ACCESS_MARINE_SENIOR)
	vendor_role = list(JOB_CO, JOB_WO_CO)

/obj/structure/machinery/cm_vending/clothing/commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_commanding_officer

/obj/effect/essentials_set/commanding_officer
	spawned_gear_list = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/map/current_map,
		/obj/item/device/whistle,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/device/megaphone,
	)

// This gets around the COs' weapon not spawning without incendiary mag.
/obj/effect/essentials_set/co/riflepreset
	spawned_gear_list = list(
		/obj/item/weapon/gun/rifle/m46c,
	)

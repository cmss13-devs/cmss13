//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_upp_commanding_officer, list(
		list("COMMANDER'S PRIMARY (CHOOSE 1)", 0, null, null, null),
		list("Type 71 Pulse Rifle", 0, /obj/item/weapon/gun/rifle/type71, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("Type 71 Pulse Rifle Carbine", 0, /obj/item/weapon/gun/rifle/type71/carbine, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("Type 64 Submachinegun", 0, /obj/item/weapon/gun/smg/bizon/upp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("PRIMARY AMMUNITION", 0, null, null, null),
		list("Type 71 Magazine", 10, /obj/item/ammo_magazine/rifle/type71, null, VENDOR_ITEM_RECOMMENDED),
		list("Type 71 AP Magazine", 20, /obj/item/ammo_magazine/rifle/type71/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("Type 64 Helical Magazine", 20, /obj/item/ammo_magazine/smg/bizon, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("Type 73 Magazine (7.62x25mm)", 5, /obj/item/ammo_magazine/pistol/t73, null, VENDOR_ITEM_RECOMMENDED),
		list("High Impact Type 73 Magazine (7.62x25mm)", 15, /obj/item/ammo_magazine/pistol/t73_impact , null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("Type 6 Shrapnel Grenade", 5, /obj/item/explosive/grenade/high_explosive/upp, null, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", 5, /obj/item/explosive/grenade/phosphorus/upp, null, VENDOR_ITEM_REGULAR),

		list("RAIL ATTACHMENTS", 0, null, null, null),
		list("Red-Dot Sight", 15, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 15, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 15, /obj/item/attachable/scope/mini, null, VENDOR_ITEM_REGULAR),

		list("Helmet Visors", 0, null, null, null),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_RECOMMENDED),

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

/obj/structure/machinery/cm_vending/gear/upp_commanding_officer
	name = "\improper UnionAraratCorp Commanding Officer Weapon Rack"
	desc = "An automated weapons rack for the Commanding Officer. It features a robust selection of weaponry meant only for the UPP's top officers."
	req_access = list(ACCESS_UPP_LEADERSHIP)
	vendor_role = list(JOB_UPP_CO_OFFICER, JOB_UPP_MAY_OFFICER, JOB_UPP_LTKOL_OFFICER, JOB_UPP_KOL_OFFICER)
	icon_state = "guns"
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/gear/upp_commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_upp_commanding_officer

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_upp_commanding_officer, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Headset", 0, /obj/item/device/radio/headset/distress/UPP/command, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("IRP", 0, /obj/item/storage/box/mre/upp, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("COMMANDING OFFICER ESSENTIALS KIT (TAKE ALL)", 0, null, null, null),
		list("Commanding Officer Essentials Kit", 0, /obj/effect/essentials_set/upp_commanding_officer, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("BAGS (CHOOSE 1)", 0, null, null, null),
		list("Commanding Officer Combat Pack", 0, /obj/item/storage/backpack/lightpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Secure Satchel", 0, /obj/item/storage/backpack/satchel/lockable, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("UL6 Personal Armor", 0, /obj/item/clothing/suit/storage/marine/faction/UPP/support, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("UM4 Helmet", 0, /obj/item/clothing/head/helmet/marine/veteran/UPP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Combat Gloves", 0, /obj/item/clothing/gloves/marine/veteran/upp, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Soldier Combat Boots", 0, /obj/item/clothing/shoes/marine/upp/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Tactical Waistcoat", 0, /obj/item/clothing/accessory/storage/black_vest/waistcoat, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HUDS (CHOOSE 1)", 0, null, null, null),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("BELTS (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Military Police Belt", 0, /obj/item/storage/belt/security/MP/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Medical Storage Rig", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Type 41 Ammo Load Rig", 0, /obj/item/storage/belt/marine/upp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Sapper Toolrig", 0, /obj/item/storage/belt/gun/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/upp_commanding_officer
	name = "\improper UnionAraratCorp Commanding Officer Equipment Rack"
	desc = "An automated equipment vendor for the Commanding Officer. Contains a prime selection of equipment for only the UPP's top officers."
	req_access = list(ACCESS_UPP_LEADERSHIP)
	vendor_role = list(JOB_UPP_CO_OFFICER, JOB_UPP_MAY_OFFICER, JOB_UPP_LTKOL_OFFICER, JOB_UPP_KOL_OFFICER)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/clothing/upp_commanding_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_upp_commanding_officer

/obj/effect/essentials_set/upp_commanding_officer
	spawned_gear_list = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/map/current_map,
		/obj/item/device/whistle,
		/obj/item/weapon/gun/energy/taser,
		/obj/item/device/megaphone,
	)

//------------PILOT OFFICER REQUIPMENT RACK---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pilot_officer
	name = "\improper ColMarTech Pilot Officer Weapons Rack"
	desc = "An automated weapon rack hooked up to a small storage of standard-issue weapons. Can be accessed only by the Pilot Officers."
	icon_state = "guns"
	req_access = list(ACCESS_MARINE_PILOT)
	vendor_role = list(JOB_PILOT)

	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("L42A Battle Rifle", 4, /obj/item/weapon/gun/rifle/l42a, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", 4, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", 4, /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 4, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("Box Of Buckshot Shells (12g)", 12, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box Of Flechette Shells (12g)", 12, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box Of Shotgun Slugs (12g)", 12, /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("L42A Magazine (10x24mm)", 24, /obj/item/ammo_magazine/rifle/l42a, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", 24, /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Magazine (10x24mm)", 24, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", 4, /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", 4, /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", 4, /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("88M4 AP Magazine (9mm)", 20, /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Speedloader (.44)", 20, /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", 20, /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine (9mm)", 12, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine (9mm)", 12, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine (9mm)", 16, /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("Rail Flashlight", 8, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", 4, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("Combat Flashlight", 4, /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", 4, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", 1, /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare pack", 10, /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/pilot_officer/populate_product_list(var/scale)
	return

//------------CLOTHING VENDOR---------------

//MARINE_CAN_BUY_SHOES MARINE_CAN_BUY_UNIFORM currently not used
obj/structure/machinery/cm_vending/clothing/pilot_officer
	name = "\improper ColMarTech Pilot Officer Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Pilot Officer standard-issue equipment."
	req_access = list(ACCESS_MARINE_PILOT)
	vendor_role = list(JOB_PILOT)

	listed_products = list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("M70 Flak Jacket", 0, /obj/item/clothing/suit/armor/vest/pilot, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("M30 Tactical Helmet", 0, /obj/item/clothing/head/helmet/marine/pilot, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Leather Satchel", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M4A3 Custom Pistol", 0, /obj/item/weapon/gun/pistol/m4a3/custom, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("VP78 Pistol", 0, /obj/item/weapon/gun/pistol/vp78, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/sparepouch, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("GLASSES (CHOOSE 1)", 0, null, null, null),
		list("Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Medical HUD Glasses", 0, /obj/item/clothing/glasses/hud/health, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_RECOMMENDED),
		list("Sunglasses", 0, /obj/item/clothing/glasses/sunglasses, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 10, /obj/item/attachable/gyro, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Masterkey Shotgun", 10, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M37 Wooden Stock", 10, /obj/item/attachable/stock/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M39 Stock", 10, /obj/item/attachable/stock/smg, null, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", 10, /obj/item/attachable/stock/rifle, null, VENDOR_ITEM_REGULAR),
		list("Quickfire Adapter", 10, /obj/item/attachable/quickfire, null, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 10, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("AMMUNITION", 0, null, null, null),
		list("L42A AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/l42a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended, null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended, null, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 15, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 2, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED)
	)
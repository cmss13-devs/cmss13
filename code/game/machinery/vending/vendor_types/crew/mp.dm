//------------ MP CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_military_police, list(
		list("POLICE SET (MANDATORY)", 0, null, null, null),
		list("Essential Police Set", 0, /obj/effect/essentials_set/police, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine/mp, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mmpo, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (TAKE ALL)", 0, null, null, null),
		list("Military Police M2 Armor", 0, /obj/item/clothing/suit/storage/marine/MP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("MP Beret", 0, /obj/item/clothing/head/beret/marine/mp, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("HANDGUN CASE (CHOOSE 1)", 0, null, null, null),
		list("88 mod 4 Combat Pistol Case", 0, /obj/item/storage/box/guncase/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M44 Combat Revolver Case", 0, /obj/item/storage/box/guncase/m44, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M4A4 Service Pistol Case", 0, /obj/item/storage/box/guncase/m4a4, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Military Police Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Revolver Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Leg Pouch", 0, /obj/item/clothing/accessory/storage/black_vest/leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Leg Pouch (Black)", 0, /obj/item/clothing/accessory/storage/black_vest/black_leg_pouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/military_police
	name = "\improper ColMarTech Military Police Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Military Police standard-issue equipment."
	req_access = list(ACCESS_MARINE_BRIG)
	vendor_role = list(JOB_POLICE,JOB_POLICE_HG)

/obj/structure/machinery/cm_vending/clothing/military_police/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_military_police

//------------ Warden CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_military_police_warden, list(
		list("POLICE SET (MANDATORY)", 0, null, null, null),
		list("Essential Police Set", 0, /obj/effect/essentials_set/police, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Warden Uniform", 0, /obj/item/clothing/under/marine/warden, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mwcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("ARMOR (TAKE ALL)", 0, null, null, null),
		list("Military Warden M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/warden, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Warden Peaked Cap", 0, /obj/item/clothing/head/beret/marine/mp/warden, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),

		list("HANDGUN CASE (CHOOSE 1)", 0, null, null, null),
		list("88 mod 4 Combat Pistol Case", 0, /obj/item/storage/box/guncase/mod88, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M44 Combat Revolver Case", 0, /obj/item/storage/box/guncase/m44, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),
		list("M4A4 Service Pistol Case", 0, /obj/item/storage/box/guncase/m4a4, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_MANDATORY),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Military Police Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Revolver Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Autoinjectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/military_police_warden
	name = "\improper ColMarTech Military Warden Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Military Police standard-issue equipment."
	req_access = list(ACCESS_MARINE_BRIG)
	vendor_role = list(JOB_WARDEN)

/obj/structure/machinery/cm_vending/clothing/military_police_warden/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_military_police_warden

/obj/effect/essentials_set/police
	spawned_gear_list = list(
		/obj/item/clothing/glasses/sunglasses/sechud,
		/obj/item/storage/belt/security/MP/full,
		/obj/item/clothing/head/helmet/marine/MP,
	)

//------------ Honorguard ARMORY ---------------

/obj/structure/machinery/cm_vending/gear/honor_guard
	name = "\improper ColMarTech Honor Guard Armory Equipment Rack"
	desc = "An automated combat equipment vendor for Honorguards, usually chosen from Military Police."
	req_access = list(ACCESS_MARINE_BRIG)
	icon_state = "mar_rack"
	vendor_role = list(JOB_POLICE,JOB_POLICE_HG)

/obj/structure/machinery/cm_vending/gear/honor_guard/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_honor_guard

GLOBAL_LIST_INIT(cm_vending_gear_honor_guard, list(
		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Honor Guard Pamphlet", 0, /obj/item/pamphlet/skill/honorguard, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("Honor Guard Headset", 0, /obj/item/device/radio/headset/almayer/marine/mp_honor, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Military Police M2 Armor", 0, /obj/item/clothing/suit/storage/marine/MP, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Military Police M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_COMBAT_SHOES, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("WEAPONS KIT (CHOOSE 1)", 0, null, null, null),
		list("M41A Standard Kit", 0, /obj/item/storage/box/kit/honor_m41a, MARINE_CAN_BUY_KIT, VENDOR_ITEM_RECOMMENDED),
		list("M39 Standard Kit", 0, /obj/item/storage/box/kit/honor_m39, MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),
		list("M4RA Standard Kit", 0, /obj/item/storage/box/kit/honor_m4ra, MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),
		list("MK221 Standard Kit", 0, /obj/item/storage/box/kit/honor_mk221, MARINE_CAN_BUY_KIT, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("EXTRA AMMO", 0, null, null, null),
		list("M41A Mk2 Magazine (10x24)", 5, /obj/item/ammo_magazine/rifle, null, VENDOR_ITEM_RECOMMENDED),
		list("M41A Mk2 AP Magazine (10x24)", 20, /obj/item/ammo_magazine/rifle/ap, null, VENDOR_ITEM_RECOMMENDED),
		list("M39 HV Magazine (10x20)", 5, /obj/item/ammo_magazine/smg/m39, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20)", 20, /obj/item/ammo_magazine/smg/m39/ap, null, VENDOR_ITEM_REGULAR),
		list("M4RA Magazine (10x24)", 5, /obj/item/ammo_magazine/rifle/m4ra, null, VENDOR_ITEM_REGULAR),
		list("M4RA AP Magazine (10x24)", 20, /obj/item/ammo_magazine/rifle/m4ra/ap, null, VENDOR_ITEM_REGULAR),
		list("Box of Buckshot Shells (12g)", 5, /obj/item/ammo_magazine/shotgun/buckshot, null, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", 5, /obj/item/ammo_magazine/shotgun/slugs, null, VENDOR_ITEM_REGULAR),
		list("Box of Flechette Shells (12g)", 5, /obj/item/ammo_magazine/shotgun/flechette, null, VENDOR_ITEM_REGULAR),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Magnetic Harness", 12, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_RECOMMENDED),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("Machete Scabbard (Full)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	))

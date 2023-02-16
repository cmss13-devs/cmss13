//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_rto, list(

		list("AMMUNITION", 0, null, null, null),
		list("L42A AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/l42a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Packet (x3 grenades)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 20, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 20, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Packet (x3 airburst grenades)", 10, /obj/item/storage/box/packet/airburst_smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Airburst Packet (x3 airburst grenades", 20, /obj/item/storage/box/packet/hornet, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x4 mines)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", 5, /obj/item/explosive/grenade/metal_foam, null, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 10, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("M41AE2 Heavy Pulse Rifle", 30, /obj/item/storage/box/guncase/lmg, null, VENDOR_ITEM_REGULAR),
		list("M79 Grenade Launcher", 30, /obj/item/storage/box/guncase/m79, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 10, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("SensorMate Medical HUD", 15, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_REGULAR),
		list("M2 Night Vision Goggles", 30, /obj/item/prop/helmetgarb/helmet_nvg, null, VENDOR_ITEM_RECOMMENDED),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 15, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 15, /obj/item/clothing/accessory/storage/holster, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 15, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_REGULAR),
		list("Powerloader Certification", 45, /obj/item/pamphlet/skill/powerloader, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 10, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_RECOMMENDED),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/rto
	name = "ColMarTech Radio Telephone Operator Gear Rack"
	desc = "An automated gear rack for RTOs."
	icon_state = "intel_gear"
	show_points = TRUE
	req_access = list(ACCESS_MARINE_RTO_PREP)
	vendor_role = list(JOB_SQUAD_RTO)

/obj/structure/machinery/cm_vending/gear/rto/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_rto

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_rto, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine/rto, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine/insulated, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Armor", 0, /obj/item/clothing/suit/storage/marine/rto, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/rto, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Radio Telephone Pack", 0, /obj/item/storage/backpack/marine/satchel/rto, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Essential RTO Utilities", 0, /obj/effect/essentials_set/rto/utilities, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medkit Pouch", 0, /obj/item/storage/pouch/medkit, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR)
	))

//MARINE_CAN_BUY_SHOES MARINE_CAN_BUY_UNIFORM currently not used
/obj/structure/machinery/cm_vending/clothing/rto
	name = "ColMarTech Radio Telephone Operator Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of RTO standard-issue equipment."
	req_access = list(ACCESS_MARINE_RTO_PREP)
	vendor_role = list(JOB_SQUAD_RTO)

/obj/structure/machinery/cm_vending/clothing/rto/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_rto

/obj/structure/machinery/cm_vending/clothing/rto/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_RTO_PREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/rto

/obj/structure/machinery/cm_vending/clothing/rto/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_RTO_PREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/rto

/obj/structure/machinery/cm_vending/clothing/rto/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_RTO_PREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/rto

/obj/structure/machinery/cm_vending/clothing/rto/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_RTO_PREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/rto

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/rto/vp78
	spawned_gear_list = list(
		/obj/item/weapon/gun/pistol/vp78,
		/obj/item/device/binoculars/range/designator,
		/obj/item/storage/box/m94/signal,
		/obj/item/storage/box/m94/signal,
		/obj/item/ammo_magazine/pistol/vp78,
		/obj/item/ammo_magazine/pistol/vp78,
		/obj/item/ammo_magazine/pistol/vp78,
		/obj/item/ammo_magazine/pistol/vp78,
		/obj/item/storage/belt/gun/m4a3,
	)

/obj/effect/essentials_set/rto/mod
	spawned_gear_list = list(
		/obj/item/weapon/gun/pistol/mod88,
		/obj/item/device/binoculars/range/designator,
		/obj/item/storage/box/m94/signal,
		/obj/item/storage/box/m94/signal,
		/obj/item/ammo_magazine/pistol/mod88,
		/obj/item/ammo_magazine/pistol/mod88,
		/obj/item/ammo_magazine/pistol/mod88,
		/obj/item/ammo_magazine/pistol/mod88,
		/obj/item/storage/belt/gun/m4a3,
	)

/obj/effect/essentials_set/rto/utilities
	spawned_gear_list = list(
		/obj/item/device/binoculars/range/designator,
		/obj/item/storage/box/m94/signal,
		/obj/item/storage/box/m94/signal,
	)

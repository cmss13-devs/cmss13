//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_engi, list(
		list("ENGINEER SET (MANDATORY)", 0, null, null, null),
		list("Essential Engineer Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("HANDHELD DEFENSE (CHOOSE 1)", 0, null, null, null),
		list("21S Tesla Coil", 0, /obj/item/defenses/handheld/tesla_coil, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("JIMA Planted Flag", 0, /obj/item/defenses/handheld/planted_flag, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UA 42-F Sentry Flamer", 0, /obj/item/defenses/handheld/sentry/flamer, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("UA 571-C Sentry Gun", 0, /obj/item/defenses/handheld/sentry, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_MANDATORY),
		list("Sentry Upgrade kit", 15, /obj/item/engi_upgrade_kit, null, VENDOR_ITEM_REGULAR),

		list("ENGINEERING SUPPLIES", 0, null, null, null),
		list("Airlock Circuit Board", 2, /obj/item/circuitboard/airlock, null, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", 2, /obj/item/circuitboard/apc, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool (ET)", 2, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 3, /obj/item/cell/high, null, VENDOR_ITEM_REGULAR),
		list("Metal x10", 5, /obj/item/stack/sheet/metal/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plasteel x10", 7, /obj/item/stack/sheet/plasteel/small_stack, null, VENDOR_ITEM_RECOMMENDED),
		list("Plastic Explosive", 3, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", 5, /obj/item/explosive/plastic/breaching_charge, null, VENDOR_ITEM_RECOMMENDED),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),
		list("Sandbags x25", 10, /obj/item/stack/sandbags_empty/half, null, VENDOR_ITEM_RECOMMENDED),
		list("Super-Capacity Power Cell", 10, /obj/item/cell/super, null, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", 5, /obj/item/clothing/glasses/welding, null, VENDOR_ITEM_MANDATORY),
		list("ES-11 Mobile Fuel Canister", 4, /obj/item/tool/weldpack/minitank, null, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 18, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 18, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Packet (x3 grenades)", 18, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 9, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 18, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 18, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Packet (x3 airburst grenades)", 10, /obj/item/storage/box/packet/airburst_smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Airburst Packet (x3 airburst grenades", 20, /obj/item/storage/box/packet/hornet, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x4 mines)", 18, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),
		list("M40 MFHS Metal Foam Grenade", 5, /obj/item/explosive/grenade/metal_foam, null, VENDOR_ITEM_REGULAR),

		list("AMMUNITION", 0, null, null, null),
		list("L42A AP Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/l42a/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 6, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", 6, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 8, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 12, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Unit", 12, /obj/item/storage/box/guncase/flamer, null, VENDOR_ITEM_REGULAR),
		list("M41AE2 Heavy Pulse Rifle", 18, /obj/item/storage/box/guncase/lmg, null, VENDOR_ITEM_REGULAR),
		list("M79 Grenade Launcher", 24, /obj/item/storage/box/guncase/m79, null, VENDOR_ITEM_REGULAR),
		list("M56D Heavy Machine Gun", 24, /obj/item/storage/box/guncase/m56d, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("SensorMate Medical HUD", 12, /obj/item/clothing/glasses/hud/sensor, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("M3 B12 Pattern Armor", 24, /obj/item/clothing/suit/storage/marine/leader, null, VENDOR_ITEM_REGULAR),
		list("M4 Pattern Armor", 30, /obj/item/clothing/suit/storage/marine/rto, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 6, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 6, /obj/item/storage/pouch/sling, null, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 6, /obj/item/storage/pouch/magazine/large, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 4, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 8, /obj/item/storage/pouch/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 3, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 8, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 3, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Powerloader Certification", 45, /obj/item/pamphlet/skill/powerloader, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 10, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_RECOMMENDED),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 3, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 3, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 3, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 3, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/engi
	name = "\improper ColMarTech Squad ComTech Gear Rack"
	desc = "An automated gear rack for combat technicians."
	icon_state = "eng_gear"
	vendor_role = list(JOB_SQUAD_ENGI)
	req_access = list(ACCESS_MARINE_ENGPREP)

/obj/structure/machinery/cm_vending/gear/engi/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_engi

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_engi, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine/engineer, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/marine, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Helmet", 0, /obj/item/clothing/head/helmet/marine/tech, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Light Armor", 0, /obj/item/clothing/suit/storage/marine/light, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Medium Armor", 0, /obj/item/clothing/suit/storage/marine/medium, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Heavy Armor", 0, /obj/item/clothing/suit/storage/marine/heavy, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Machete Scabbard (Full)", 0, /obj/item/storage/large_holster/machete/full, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Backpack", 0, /obj/item/storage/backpack/marine/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("Technician Welder-Satchel", 0, /obj/item/storage/backpack/marine/engineerpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Mortar Operator Belt", 0, /obj/item/storage/belt/gun/mortarbelt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 0, /obj/item/storage/pouch/explosive, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/engi
	name = "\improper ColMarTech Squad ComTech Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of combat technician standard-issue equipment."
	req_access = list(ACCESS_MARINE_ENGPREP)
	vendor_role = list(JOB_SQUAD_ENGI)

/obj/structure/machinery/cm_vending/clothing/engi/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_engi

/obj/structure/machinery/cm_vending/clothing/engi/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_ALPHA)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha/engi

/obj/structure/machinery/cm_vending/clothing/engi/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_BRAVO)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo/engi

/obj/structure/machinery/cm_vending/clothing/engi/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_CHARLIE)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie/engi

/obj/structure/machinery/cm_vending/clothing/engi/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_ENGPREP, ACCESS_MARINE_DELTA)
	gloves_type = /obj/item/clothing/gloves/marine/insulated
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta/engi

//------------ESSENTIAL SETS---------------

/obj/effect/essentials_set/engi
	spawned_gear_list = list(
		/obj/item/explosive/plastic,
		/obj/item/stack/sandbags_empty = 25,
		/obj/item/stack/sheet/metal/large_stack,
		/obj/item/stack/sheet/plasteel/medium_stack,
		/obj/item/cell/high,
		/obj/item/tool/shovel/etool/folded,
		/obj/item/device/lightreplacer,
	)

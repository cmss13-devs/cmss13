//------------UPP REQ VENDORS---------------

//------------ARMAMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/upp_cargo_guns
	name = "\improper UnionAraratCorp Automated Armaments Vendor"
	desc = "An automated supply rack hooked up to a big storage of various firearms, explosives, load carrying equipment and other miscellaneous items. Can be accessed by Logistic Technicians."
	icon_state = "upp_guns"
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/sorted/cargo_guns/upp_cargo_guns/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("Type 71 Pulse Rifle", floor(scale * 60), /obj/item/weapon/gun/rifle/type71, VENDOR_ITEM_REGULAR),
		list("Type 71 Pulse Rifle Carbine", floor(scale * 20), /obj/item/weapon/gun/rifle/type71/carbine, VENDOR_ITEM_REGULAR),
		list("Type 64 Submachinegun", floor(scale * 60), /obj/item/weapon/gun/smg/bizon/upp, VENDOR_ITEM_REGULAR),
		list("Type 23 Riot Shotgun", floor(scale * 20), /obj/item/weapon/gun/shotgun/type23, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("Type 73 Pistol", floor(scale * 50), /obj/item/weapon/gun/pistol/t73, VENDOR_ITEM_REGULAR),
		list("NP92 Pistol", floor(scale * 50), /obj/item/weapon/gun/pistol/np92, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Revolver", floor(scale * 50), /obj/item/weapon/gun/revolver/upp, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", floor(scale * 20), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", -1, null, null),
		list("Type-19 Submachinegun", floor(scale * 3), /obj/item/storage/box/guncase/type19, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Unit", floor(scale * 2), /obj/item/storage/box/guncase/flamer, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", -1, null, null),
		list("Type 6 Shrapnel Grenade", floor(scale * 25), /obj/item/explosive/grenade/high_explosive/upp, VENDOR_ITEM_REGULAR),
		list("Type 8 WP Grenade", floor(scale * 4), /obj/item/explosive/grenade/phosphorus/upp, VENDOR_ITEM_REGULAR),
		list("Smoke Grenade", floor(scale * 5), /obj/item/explosive/grenade/smokebomb, VENDOR_ITEM_REGULAR),
		list("Plastic Explosives", floor(scale * 4), /obj/item/explosive/plastic, VENDOR_ITEM_REGULAR),
		list("Breaching Charge", floor(scale * 4), /obj/item/explosive/plastic/breaching_charge, VENDOR_ITEM_REGULAR),

		list("WEBBINGS", -1, null, null),
		list("Black Webbing Vest", floor(scale * 2), /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", floor(scale * 2), /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", floor(scale * 1.5), /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),
		list("Webbing", floor(scale * 5), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Knife Webbing", floor(scale * 1), /obj/item/clothing/accessory/storage/knifeharness, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", floor(scale * 2), /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("Black Drop Pouch", floor(scale * 2), /obj/item/clothing/accessory/storage/droppouch/black, VENDOR_ITEM_REGULAR),
		list("External Webbing", floor(scale * 5), /obj/item/clothing/suit/storage/webbing, VENDOR_ITEM_REGULAR),

		list("BACKPACKS", -1, null, null),
		list("Combat Pack", floor(scale * 15), /obj/item/storage/backpack/lightpack/upp, VENDOR_ITEM_REGULAR),
		list("Pyrotechnician G4-1 Fueltank", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack/flamethrower/kit, VENDOR_ITEM_REGULAR),
		list("UPP Sapper Welderpack", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack/upp, VENDOR_ITEM_REGULAR),
		list("Mortar Shell Backpack", floor(scale * 1), /obj/item/storage/backpack/marine/mortarpack, VENDOR_ITEM_REGULAR),
		list("IMP Ammo Rack", floor(scale * 2), /obj/item/storage/backpack/marine/ammo_rack, VENDOR_ITEM_REGULAR),
		list("Parachute", floor(scale * 20), /obj/item/parachute, VENDOR_ITEM_REGULAR),
		list("Grenade Satchel", floor(scale * 2), /obj/item/storage/backpack/marine/grenadepack, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("Type 41 Ammo Load Rig", floor(scale * 15), /obj/item/storage/belt/marine/upp, VENDOR_ITEM_REGULAR),
		list("NPZ92 Pistol Holster Rig", floor(scale * 15), /obj/item/storage/belt/gun/type47, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", floor(scale * 2), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig", floor(scale * 5), /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", floor(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", floor(scale * 10), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Mortar Operator Belt", floor(scale * 2), /obj/item/storage/belt/gun/mortarbelt, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null),
		list("Autoinjector Pouch", floor(scale * 1), /obj/item/storage/pouch/autoinjector, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", floor(scale * 2), /obj/item/storage/pouch/medkit, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Full)", floor(scale * 5), /obj/item/storage/pouch/firstaid/full, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", floor(scale * 2), /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Syringe Pouch", floor(scale * 2), /obj/item/storage/pouch/syringe, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", floor(scale * 2), /obj/item/storage/pouch/tools/full, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", floor(scale * 2), /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch", floor(scale * 2), /obj/item/storage/pouch/electronics, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", floor(scale * 2), /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", floor(scale * 5), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Document Pouch", floor(scale * 2), /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", floor(scale * 2), /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 1, /obj/item/storage/pouch/machete/full, VENDOR_ITEM_REGULAR),
		list("Bayonet Pouch", floor(scale * 2), /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", floor(scale * 2), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", floor(scale * 5), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", floor(scale * 5), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", floor(scale * 5), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", floor(scale * 5), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", floor(scale * 4), /obj/item/storage/pouch/flamertank, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", floor(scale * 1), /obj/item/storage/pouch/general/large, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", floor(scale * 1), /obj/item/storage/pouch/magazine/large, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", floor(scale * 1), /obj/item/storage/pouch/shotgun/large, VENDOR_ITEM_REGULAR),

		list("REPAIR TOOLS", -1, null, null),
		list("Multi-Purpose Combat Lubricant", floor(scale * 20), /obj/item/stack/repairable/gunlube, VENDOR_ITEM_REGULAR),
		list("Firearms Repair Kit", floor(scale * 10), /obj/item/stack/repairable/gunkit, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Combat Flashlight", floor(scale * 8), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", floor(scale * 4), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("Gas Mask", floor(scale * 10), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", floor(scale * 2), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", floor(scale * 10), /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", floor(scale * 6), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("Binoculars", floor(scale * 2), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("Rangefinder", floor(scale * 1), /obj/item/device/binoculars/range, VENDOR_ITEM_REGULAR),
		list("Laser Designator", floor(scale * 1), /obj/item/device/binoculars/range/designator, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", floor(scale * 3), /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", floor(scale * 3), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", floor(scale * 1), /obj/item/cell/high, VENDOR_ITEM_REGULAR),
		list("Sentry Gun Network Laptop", 4, /obj/item/device/sentry_computer, VENDOR_ITEM_REGULAR),
		list("JTAC Pamphlet", floor(scale * 1), /obj/item/pamphlet/skill/jtac, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", floor(scale * 1), /obj/item/pamphlet/skill/engineer, VENDOR_ITEM_REGULAR),
		list("Powerloader Certification", 0.75, /obj/item/pamphlet/skill/powerloader, VENDOR_ITEM_REGULAR),
		list("Spare PDT/L Battle Buddy Kit", floor(scale * 4), /obj/item/storage/box/pdt_kit, VENDOR_ITEM_REGULAR),
		list("W-Y brand rechargeable mini-battery", floor(scale * 3), /obj/item/cell/crap, VENDOR_ITEM_REGULAR),
		list("Nailgun Magazine (7x45mm)", floor(scale * 4), /obj/item/ammo_magazine/smg/nailgun, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES BOXES", -1, null, null),
		list("M15 Fragmentation Grenade Packet", 0, /obj/item/storage/box/packet/m15, VENDOR_ITEM_REGULAR),
		list("Type 8 WP grenade packet", 0, /obj/item/storage/box/packet/phosphorus/upp, VENDOR_ITEM_REGULAR),
		list("HSDP grenade packet", 0, /obj/item/storage/box/packet/smoke, VENDOR_ITEM_REGULAR),
		list("M40 HEDP Grenade Packet", 0, /obj/item/storage/box/packet/high_explosive, VENDOR_ITEM_REGULAR),
		list("M40 HEDP Grenade Box", 0, /obj/item/storage/box/nade_box, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Grenade Packet", 0, /obj/item/storage/box/packet/incendiary, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Grenade Box", 0, /obj/item/storage/box/nade_box/incen, VENDOR_ITEM_REGULAR),

		list("OTHER BOXES", -1, null, null),
		list("Box of Combat Flashlights", 0, /obj/item/ammo_box/magazine/misc/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Box of M94 Marking Flare Packs", 0, /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("Box of M89 Signal Flare Packs", 0, /obj/item/ammo_box/magazine/misc/flares/signal, VENDOR_ITEM_REGULAR),
		list("Box of High-Capacity Power Cells", 0, /obj/item/ammo_box/magazine/misc/power_cell, VENDOR_ITEM_REGULAR),
		list("Nailgun Magazine Box (7x45mm)", floor(scale * 2), /obj/item/ammo_box/magazine/nailgun, VENDOR_ITEM_REGULAR),
		)

//------------UPP AMMUNITION VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/upp_cargo_ammo
	name = "\improper UnionAraratCorp Automated Munition Vendor"
	desc = "An automated supply rack hooked up to a big storage of various ammunition types. Can be accessed by the Logistic Technicians."
	icon_state = "req_ammo"
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/upp_cargo_ammo/populate_product_list(scale)
	listed_products = list(
		list("REGULAR AMMUNITION", -1, null, null),
		list("Type 71 Magazine (5.45x39mm)", floor(scale * 100), /obj/item/ammo_magazine/rifle/type71, VENDOR_ITEM_REGULAR),
		list("Type 64 Helical Magazine (7.62x19mm)", floor(scale * 100), /obj/item/ammo_magazine/smg/bizon, VENDOR_ITEM_REGULAR),
		list("Box of Heavy Buckshot Shells (8g)", floor(scale * 56), /obj/item/ammo_magazine/shotgun/heavy/buckshot, VENDOR_ITEM_REGULAR),
		list("Box of Heavy Slugs (8g)", floor(scale * 56), /obj/item/ammo_magazine/shotgun/heavy/slug, VENDOR_ITEM_REGULAR),
		list("Box of Heavy Flechette Shells (8g)", floor(scale * 56), /obj/item/ammo_magazine/shotgun/heavy/flechette, VENDOR_ITEM_REGULAR),
		list("Type 73 Magazine (7.62x25mm Tokarev)", floor(scale * 40), /obj/item/ammo_magazine/pistol/t73, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Speed Loader (7.62x38mmR)", floor(scale * 40), /obj/item/ammo_magazine/revolver/upp, VENDOR_ITEM_REGULAR),
		list("NP92 Magazine (9x18mm Makarov)", floor(scale * 40), /obj/item/ammo_magazine/pistol/np92, VENDOR_ITEM_REGULAR),

		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", floor(scale * 10), /obj/item/ammo_magazine/rifle/type71/ap, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("Type-19 stick magazine (7.62x25mm)", floor(scale * 12), /obj/item/ammo_magazine/smg/pps43, VENDOR_ITEM_REGULAR),
		list("Type-19 drum magazine (7.62x25mm)", floor(scale * 1), /obj/item/ammo_magazine/smg/pps43/extended, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", floor(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),

		list("MAGAZINE BOXES", -1, null, null),
		list("Magazine box (Type 71 Rifle x 10)", 0, /obj/item/ammo_box/magazine/type71, VENDOR_ITEM_REGULAR),
		list("Magazine box (AP Type 71 Rifle x 10)", 0, /obj/item/ammo_box/magazine/type71/ap, VENDOR_ITEM_REGULAR),
		list("Magazine box (Type 64 Bizon x 10)", 0, /obj/item/ammo_box/magazine/type64, VENDOR_ITEM_REGULAR),
		list("Magazine box (Type 73 Pistol x 16)", 0, /obj/item/ammo_box/magazine/type73, VENDOR_ITEM_REGULAR),
		list("Speed loaders box (ZhNK-72 x 12)", 0, /obj/item/ammo_box/magazine/zhnk, VENDOR_ITEM_REGULAR),
		list("Magazine box (Type19 x 12)", 0, /obj/item/ammo_box/magazine/type19, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Slugs 8g x 100)", 0, /obj/item/ammo_box/magazine/shotgun/upp, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Buckshot 8g x 100)", 0, /obj/item/ammo_box/magazine/shotgun/upp/buckshot, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Box (Flechette 8g x 100)", 0, /obj/item/ammo_box/magazine/shotgun/upp/flechette, VENDOR_ITEM_REGULAR),
		list("Flamer Tank Box (UT-Napthal Fuel x 8)", 0, /obj/item/ammo_box/magazine/flamer, VENDOR_ITEM_REGULAR),
		)

//------------ATTACHMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/attachments/upp_attachments
	name = "\improper UnionAraratCorp Attachments Vendor"
	desc = "An automated supply rack hooked up to a big storage of weapons attachments. Can be accessed by the Logistics Technicians."
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/sorted/attachments/upp_attachments/populate_product_list(scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Extended Barrel", 6.5, /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", 10.5, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 6.5, /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", 6.5, /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("B8 Smart-Scope", 3.5, /obj/item/attachable/alt_iff_scope, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", 8.5, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 10.5, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 4.5, /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 Red-Dot Sight", 9.5, /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 Reflex Sight", 9.5, /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x Telescopic Scope", 4.5, /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL", -1, null, null),
		list("Angled Grip", 6.5, /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("Bipod", 6.5, /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", 4.5, /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 4.5, /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 9.5, /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("Mini Flamethrower", 4.5, /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 Flamer Nozzle", 4.5, /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 Underbarrel Shotgun", 4.5, /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", 4.5, /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", 9.5, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 9.5, /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),
		)

//------------UNIFORM VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/uniform_supply/upp_uniform
	name = "\improper UnionAraratCorp Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a big storage of standard marine uniforms. Can be accessed by the Logistic Technicians."
	icon_state = "upp_clothing"
	req_access = list()
	req_one_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP

/obj/structure/machinery/cm_vending/sorted/uniform_supply/upp_uniform/populate_product_list(scale)
	listed_products = list(
		list("UNIFORM", -1, null, null),
		list("UPP Fatigues", floor(scale * 20), /obj/item/clothing/under/marine/veteran/UPP, VENDOR_ITEM_REGULAR),
		list("UPP Medic Fatigues", 5, /obj/item/clothing/under/marine/veteran/UPP/medic, VENDOR_ITEM_REGULAR),
		list("UPP Sapper Fatigues", 5, /obj/item/clothing/under/marine/veteran/UPP/engi, VENDOR_ITEM_REGULAR),

		list("BOOTS", -1, null, null),
		list("Soldier Combat Boots", 20, /obj/item/clothing/shoes/marine/upp/knife, VENDOR_ITEM_REGULAR),

		list("BACKPACKS", -1, null, null),
		list("Combat Pack", 20, /obj/item/storage/backpack/lightpack/upp, VENDOR_ITEM_REGULAR),
		list("UPP Sapper Welderpack", 10, /obj/item/storage/backpack/marine/engineerpack/upp, VENDOR_ITEM_REGULAR),

		list("ARMOR", -1, null, null),
		list("UM5 Medium Personal Armor", 20, /obj/item/clothing/suit/storage/marine/faction/UPP, VENDOR_ITEM_REGULAR),
		list("UL6 Light Personal Armor", 20, /obj/item/clothing/suit/storage/marine/faction/UPP/support, VENDOR_ITEM_REGULAR),

		list("GLOVES", -1, null, null),
		list("Soldier Combat Gloves", 40, /obj/item/clothing/gloves/marine/veteran/upp, VENDOR_ITEM_REGULAR),

		list("RADIO", -1, null, null),
		list("Engineering/JTAC Encryption Key", 5, /obj/item/device/encryptionkey/upp/engi, VENDOR_ITEM_REGULAR),
		list("Medical Encryption Key", 5, /obj/item/device/encryptionkey/upp/medic, VENDOR_ITEM_REGULAR),

		list("MASKS", -1, null, null, null),
		list("Gas Mask", 20, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 10, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Bedroll", 30, /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		)

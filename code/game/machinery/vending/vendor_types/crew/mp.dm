//------------ MP CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_military_police, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Uniform", 0, /obj/item/clothing/under/marine/mp, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mmpo, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Pistol", 0, /obj/item/storage/belt/gun/m4a3/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Military Police M2 Armor", 0, /obj/item/clothing/suit/storage/marine/MP, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Military Police M2 Padless Armor", 0, /obj/item/clothing/suit/storage/marine/MP/padless, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Military Police M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (TAKE ALL)", 0, null, null, null),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HAT (CHOOSE 1)", 0, null, null, null),
		list("MP Beret", 0, /obj/item/clothing/head/helmet/beret/marine/mp, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),

	))

/obj/structure/machinery/cm_vending/clothing/military_police
	name = "\improper ColMarTech Military Police Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Military Police standard-issue equipment."
	req_access = list(ACCESS_MARINE_BRIG)
	vendor_role = list(JOB_POLICE, JOB_POLICE_CADET)

/obj/structure/machinery/cm_vending/clothing/military_police/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_military_police

//------------ Warden CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_military_police_warden, list(

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Warden Uniform", 0, /obj/item/clothing/under/marine/warden, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/cmpcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("Satchel", 0, /obj/item/storage/backpack/satchel/sec, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (Take ALL)", 0, null, null, null),
		list("M4A3 Custom Pistol ", 0, /obj/item/storage/belt/gun/m4a3/commander, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("Mod 88 Pistol", 0, /obj/item/storage/belt/gun/m4a3/mod88, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Military Warden M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/warden, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Military Warden M3 Padless Armor", 0, /obj/item/clothing/suit/storage/marine/MP/warden/padless, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),

		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Military Police M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),

		list("EYEWEAR (TAKE ALL)", 0, null, null, null),
		list("Security HUD Glasses", 0, /obj/item/clothing/glasses/sunglasses/sechud, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Full)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("HAT (CHOOSE 1)", 0, null, null, null),
		list("Warden Peaked Cap", 0, /obj/item/clothing/head/helmet/beret/marine/mp/warden, MARINE_CAN_BUY_MASK, VENDOR_ITEM_MANDATORY),
	))

/obj/structure/machinery/cm_vending/clothing/military_police_warden
	name = "\improper ColMarTech Military Warden Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Military Police standard-issue equipment."
	req_access = list(ACCESS_MARINE_BRIG)
	vendor_role = list(JOB_WARDEN)

/obj/structure/machinery/cm_vending/clothing/military_police_warden/Initialize(mapload, ...)
	. = ..()
	listed_products = GLOB.cm_vending_clothing_military_police_warden

/obj/structure/machinery/cm_vending/sorted/cargo_guns/mp
	name = "\improper ColMarTech Military Police Armory Rack"
	desc = "An automated rack that stores various military police weapons and equipment for use in emergencies."

/obj/structure/machinery/cm_vending/sorted/cargo_guns/mp/populate_product_list(var/scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("L42A Battle Rifle", 1, /obj/item/weapon/gun/rifle/l42a, VENDOR_ITEM_REGULAR),
		list("MK221 Tactical Shotgun", 3, /obj/item/weapon/gun/shotgun/combat, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", 1, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 1, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("Box of Flechette Shells (12g)", round(scale * 4), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box of Buckshot Shells (12g)", round(scale * 5), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", round(scale * 5), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("L42A Magazine (10x24mm)", round(scale * 5), /obj/item/ammo_magazine/rifle/l42a, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", round(scale * 5), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Magazine (10x24mm)", round(scale * 5), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("M39 Folding Stock", round(scale * 2), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("L42 Synthetic Stock", round(scale * 2), /obj/item/attachable/stock/carbine, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", round(scale * 5), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("Underbarrel Flashlight Grip", round(scale * 2), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("Underslung Grenade Launcher", round(scale * 2), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("UTILITIES", -1, null, null),
		list("M5 Bayonet", round(scale * 5), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", round(scale * 2), /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/riot
	name = "\improper ColMarTech Military Police Riot Vendor"
	desc = "An automated rack that stores riot equipment."
	req_access = list(ACCESS_MARINE_BRIG)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/mp/populate_product_list(var/scale)
	listed_products = list(
		list("LESS THAN LETHAL", -1, null, null),
		list("MK221 Riot Shotgun (20g)", 1, /obj/item/weapon/gun/shotgun/combat/riot, VENDOR_ITEM_REGULAR),
		list("M81 Grenade Launcher", 1, /obj/item/weapon/gun/launcher/grenade/m81/riot, VENDOR_ITEM_REGULAR),

		list("LESS LETHAL AMMO", -1, null, null),
		list("Box of Beanbag shells (20g)", round(scale * 5), /obj/item/ammo_magazine/shotgun/beanbag/riot, VENDOR_ITEM_REGULAR),
		list("Baton Slug Packet", 2, /obj/item/storage/box/packet/baton_slug, VENDOR_ITEM_REGULAR),

		list("RIOT ARMOR", -1, null, null),
		list("Riot armor", 1, /obj/item/clothing/suit/armor/riot/marine, VENDOR_ITEM_RECOMMENDED),
		list("Riot helmet", 1, /obj/item/clothing/suit/armor/riot/marine, VENDOR_ITEM_RECOMMENDED),
		list("Gas Mask", 2, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),

		list("RIOT EQUIPMENT", -1, null, null),
		list("Riot Shield", 3, /obj/item/weapon/shield/riot, VENDOR_ITEM_RECOMMENDED),
		list("Teargas canister box", 1, /obj/item/storage/box/nade_box/tear_gas, VENDOR_ITEM_MANDATORY),
		list("Flashbang box", 1, /obj/item/storage/box/flashbangs, VENDOR_ITEM_REGULAR),
	)

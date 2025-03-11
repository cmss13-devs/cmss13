//------------SQUAD PREP VENDORS -------------------

//------------SQUAD PREP WEAPON RACKS---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep
	name = "\improper ColMarTech Automated Weapons Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "guns"
	req_access = list()
	req_one_access = list(ACCESS_MARINE_DATABASE, ACCESS_MARINE_PREP)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", floor(scale * 5), /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", floor(scale * 10), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", floor(scale * 10), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", floor(scale * 15), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("Box of Flechette Shells (12g)", floor(scale * 3), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box of Buckshot Shells (12g)", floor(scale * 5), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", floor(scale * 5), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M4RA Magazine (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", floor(scale * 15), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Magazine (10x24mm)", floor(scale * 15), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("M10 Auto Pistol", floor(scale * 10), /obj/item/weapon/gun/pistol/m10, VENDOR_ITEM_REGULAR),
		list("88 Mod 4 Combat Pistol", floor(scale * 10), /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", floor(scale * 10), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", floor(scale * 10), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", floor(scale * 5), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("M10 HV magazine (10x20mm)", floor(scale * 10), /obj/item/ammo_magazine/pistol/m10, VENDOR_ITEM_REGULAR),
		list("88M4 AP Magazine (9mm)", floor(scale * 10), /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Speedloader (.44)", floor(scale * 10), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", floor(scale * 10), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("M39 Folding Stock", floor(scale * 5), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("M41A Folding Stock", floor(scale * 5), /obj/item/attachable/stock/rifle/collapsible, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", floor(scale * 10), /obj/item/attachable/flashlight, VENDOR_ITEM_RECOMMENDED),
		list("Underbarrel Flashlight Grip", floor(scale * 5), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_RECOMMENDED),
		list("Underslung Grenade Launcher", floor(scale * 10), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("UTILITIES", -1, null, null),
		list("M5 Bayonet", floor(scale * 10), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", floor(scale * 5), /obj/item/storage/box/m94, VENDOR_ITEM_RECOMMENDED)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial
	name = "\improper ColMarTech Automated Weapons Rack"
	desc = "An automated weapon rack hooked up to a big storage of standard-issue weapons."
	icon_state = "guns"
	req_access = list(ACCESS_TUTORIAL_LOCKED)
	req_one_access = list()
	hackable = FALSE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M41A Pulse Rifle MK2", 1, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("M41A Magazine (10x24mm)", 1, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_RECOMMENDED),
	)

/// Called if the tutorial mob somehow uses an entire magazine without the xeno dying
/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/tutorial/proc/load_ammo()
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M41A Pulse Rifle MK2", 0, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_RECOMMENDED),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("M41A Magazine (10x24mm)", 99, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_RECOMMENDED),
	)

//------------SQUAD PREP UNIFORM VENDOR---------------


/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep
	name = "\improper ColMarTech Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a small storage of standard marine uniforms."
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list()
	listed_products = list()
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/populate_product_list(scale)
	listed_products = list(
		list("STANDARD EQUIPMENT", -1, null, null, null),
		list("Marine Combat Boots", floor(scale * 15), /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Boots", floor(scale * 15), /obj/item/clothing/shoes/marine/brown, VENDOR_ITEM_REGULAR),
		list("Marine Grey Combat Boots", floor(scale * 15), /obj/item/clothing/shoes/marine/grey, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", floor(scale * 15), /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", floor(scale * 15), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Gloves", floor(scale * 15), /obj/item/clothing/gloves/marine/brown, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", floor(scale * 15), /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Grey Combat Gloves", floor(scale * 15), /obj/item/clothing/gloves/marine/grey, VENDOR_ITEM_REGULAR),
		list("Marine Radio Headset", floor(scale * 15), /obj/item/device/radio/headset/almayer, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Marine Helmet", floor(scale * 15), /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),

		list("WEBBINGS", -1, null, null),
		list("Brown Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Webbing", floor(scale * 2), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Black Webbing", floor(scale * 2), /obj/item/clothing/accessory/storage/webbing/black, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0.75, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0.75, /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("ARMOR", -1, null, null),
		list("M3 Pattern Carrier Marine Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/medium/carrier, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padded Marine Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/medium/padded, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padless Marine Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/medium/padless, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Ridged Marine Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/medium/padless_lines, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Skull Marine Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/medium/skull, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Smooth Marine Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/medium/smooth, VENDOR_ITEM_REGULAR),
		list("M3-EOD Pattern Heavy Armor", floor(scale * 10), /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", floor(scale * 10), /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),

		list("BACKPACK", -1, null, null, null),
		list("Lightweight IMP Backpack", floor(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Technician Backpack", floor(scale * 15), /obj/item/storage/backpack/marine/tech, VENDOR_ITEM_REGULAR),
		list("Medical Backpack", floor(scale * 15), /obj/item/storage/backpack/marine/medic, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", floor(scale * 15), /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Chestrig", floor(scale * 15), /obj/item/storage/backpack/marine/satchel/chestrig, VENDOR_ITEM_REGULAR),
		list("USCM Technical Satchel", floor(scale * 15), /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),
		list("USCM Technical Chestrig", floor(scale * 15), /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, VENDOR_ITEM_REGULAR),
		list("Medical Satchel", floor(scale * 15), /obj/item/storage/backpack/marine/satchel/medic, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", floor(scale * 5), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),

		list("RESTRICTED BACKPACKS", -1, null, null),
		list("USCM Technician Welderpack", 1.25, /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("Radio Telephone Backpack", 0.75, /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("M276 Pattern Ammo Load Rig", floor(scale * 15), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M40 Grenade Rig", floor(scale * 10), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", floor(scale * 15), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", floor(scale * 15), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", floor(scale * 15), /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig And Pouch", floor(scale * 10), /obj/item/storage/belt/gun/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M10 holster Rig And Pouch", floor(scale * 10), /obj/item/storage/belt/gun/m10, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Revolver Holster Rig", floor(scale * 15), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M82F Holster Rig", floor(scale * 5), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", floor(scale * 15), /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", floor(scale * 15), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null, null),
		list("Bayonet Sheath (Full)",floor(scale * 15), /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", floor(scale * 15), /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", floor(scale * 15), /obj/item/storage/pouch/firstaid/full/pills, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", floor(scale * 15), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Small Document Pouch", floor(scale * 15), /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", floor(scale * 15), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", floor(scale * 15), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", floor(scale * 15), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", floor(scale * 15), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", floor(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("RESTRICTED POUCHES", -1, null, null, null),
		list("Construction Pouch", 1.25, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 1.25, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch (Empty)", 2.5, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", floor(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Tools Pouch", 1.25, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 1.25, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("MASK", -1, null, null, null),
		list("Gas Mask", floor(scale * 15), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", floor(scale * 10), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("Rebreather", floor(scale * 10), /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null, null),
		list("Ballistic goggles", floor(scale * 10), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("M1A1 Ballistic goggles", floor(scale * 10), /obj/item/clothing/glasses/mgoggles/v2, VENDOR_ITEM_REGULAR),
		list("Prescription ballistic goggles", floor(scale * 10), /obj/item/clothing/glasses/mgoggles/prescription, VENDOR_ITEM_REGULAR),
		list("Marine RPG glasses", floor(scale * 10), /obj/item/clothing/glasses/regular, VENDOR_ITEM_REGULAR),
		list("M5 Integrated Gas Mask", floor(scale * 10), /obj/item/prop/helmetgarb/helmet_gasmask, VENDOR_ITEM_REGULAR),
		list("M10 Helmet Netting", floor(scale * 10), /obj/item/prop/helmetgarb/netting, VENDOR_ITEM_REGULAR),
		list("M10 Helmet Rain Cover", floor(scale * 10), /obj/item/prop/helmetgarb/raincover, VENDOR_ITEM_REGULAR),
		list("Firearm Lubricant", floor(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("Attachable Dogtags", floor(scale * 15), /obj/item/clothing/accessory/dogtags, VENDOR_ITEM_REGULAR),
		list("USCM Flair", floor(scale * 15), /obj/item/prop/helmetgarb/flair_uscm, VENDOR_ITEM_REGULAR),
		list("Falling Falcons Shoulder Patch", floor(scale * 15), /obj/item/clothing/accessory/patch/falcon, VENDOR_ITEM_REGULAR),
		list("Falling Falcons UA Shoulder Patch", floor(scale * 15), /obj/item/clothing/accessory/patch/falconalt, VENDOR_ITEM_REGULAR),
		list("USCM Large Chest Patch", floor(scale * 15), /obj/item/clothing/accessory/patch/uscmlarge, VENDOR_ITEM_REGULAR),
		list("USCM Shoulder Patch", floor(scale * 15), /obj/item/clothing/accessory/patch, VENDOR_ITEM_REGULAR),
		list("United Americas Shoulder patch", floor(scale * 10), /obj/item/clothing/accessory/patch/ua, VENDOR_ITEM_REGULAR),
		list("United Americas Flag Shoulder patch", floor(scale * 10), /obj/item/clothing/accessory/patch/uasquare, VENDOR_ITEM_REGULAR),
		list("Bedroll", floor(scale * 20), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),
		list("M5 Camera Gear", floor(scale *0.5), /obj/item/device/overwatch_camera, VENDOR_ITEM_REGULAR),

		list("OPTICS", -1, null, null, null),
		list("Advanced Medical Optic (CORPSMAN ONLY)", floor(scale * 4), /obj/item/device/helmet_visor/medical/advanced, VENDOR_ITEM_REGULAR),
		list("Squad Optic", floor(scale * 15), /obj/item/device/helmet_visor, VENDOR_ITEM_REGULAR),

		)

//--------------SQUAD SPECIFIC VERSIONS--------------
//Those vendors aren't being used i will make them us the main vendor a parent to avoid having four different
// list with just the headset changed.

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_ALPHA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/alpha/populate_product_list(scale)
	..()
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Alpha Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/alpha, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_BRAVO, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/bravo/populate_product_list(scale)
	..()
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Bravo Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/bravo, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_CHARLIE, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/charlie/populate_product_list(scale)
	..()
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Charlie Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/charlie, VENDOR_ITEM_REGULAR),
		)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta
	req_access = list(ACCESS_MARINE_PREP)
	req_one_access = list(ACCESS_MARINE_DELTA, ACCESS_MARINE_DATABASE, ACCESS_MARINE_CARGO)

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/delta/populate_product_list(scale)
	..()
	listed_products += list(
		list("HEADSET", -1, null, null),
		list("Marine Delta Radio Headset", 10, /obj/item/device/radio/headset/almayer/marine/delta, VENDOR_ITEM_REGULAR),
		)

//--------------SQUAD MUNITION VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad
	name = "\improper ColMarTech Automated Munition Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various ammunition types. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

	vend_x_offset = 2

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state


/obj/structure/machinery/cm_vending/sorted/cargo_ammo/squad/populate_product_list(scale)
	listed_products = list(
		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("M4RA AP Magazine (10x24mm)", 3.5, /obj/item/ammo_magazine/rifle/m4ra/ap, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", floor(scale * 3), /obj/item/ammo_magazine/smg/m39/ap, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", floor(scale * 3), /obj/item/ammo_magazine/rifle/ap, VENDOR_ITEM_REGULAR),

		list("EXTENDED AMMUNITION", -1, null, null),
		list("M10 HV extended magazine (10x20mm)", floor(scale * 5), /obj/item/ammo_magazine/pistol/m10/extended , VENDOR_ITEM_REGULAR),
		list("M10 HV drum magazine (10x20mm)", floor(scale * 5), /obj/item/ammo_magazine/pistol/m10/drum , VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 1.8, /obj/item/ammo_magazine/smg/m39/extended, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", 1.9, /obj/item/ammo_magazine/rifle/extended, VENDOR_ITEM_REGULAR),

		list("SPECIAL AMMUNITION", -1, null, null),
		list("M56 Smartgun Drum", 1, /obj/item/ammo_magazine/smartgun, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", floor(scale * 2), /obj/item/ammo_magazine/revolver/heavy, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", floor(scale * 2), /obj/item/ammo_magazine/revolver/marksman, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", floor(scale * 2), /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("VP78 Magazine", floor(scale * 5), /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", floor(scale * 5), /obj/item/ammo_magazine/pistol/smart, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", floor(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		list("M56D Drum Magazine", floor(scale * 2), /obj/item/ammo_magazine/m56d, VENDOR_ITEM_REGULAR),
		list("M2C Box Magazine", floor(scale * 2), /obj/item/ammo_magazine/m2c, VENDOR_ITEM_REGULAR),
		list("Box of Breaching Shells (16g)", floor(scale * 2), /obj/item/ammo_magazine/shotgun/light/breaching, VENDOR_ITEM_REGULAR),
		list("HIRR Baton Slugs", floor(scale * 6), /obj/item/explosive/grenade/slug/baton, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Star Shell", floor(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst/starshell, VENDOR_ITEM_REGULAR),
		list("M74 AGM-S Hornet Shell", floor(scale * 4), /obj/item/explosive/grenade/high_explosive/airburst/hornet_shell, VENDOR_ITEM_REGULAR),
		)

//--------------SQUAD ARMAMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad
	name = "\improper ColMarTech Automated Utilities Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various utilities and tools. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE

	vend_x_offset = 2
	vend_y_offset = 1
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad/populate_product_list(scale)
	listed_products = list(
		list("FOOD", -1, null, null),
		list("MRE", floor(scale * 5), /obj/item/storage/box/mre, VENDOR_ITEM_REGULAR),
		list("MRE Box", floor(scale * 1), /obj/item/ammo_box/magazine/misc/mre, VENDOR_ITEM_REGULAR),

		list("TOOLS", -1, null, null),
		list("Entrenching Tool (ET)", floor(scale * 2), /obj/item/tool/shovel/etool/folded, VENDOR_ITEM_REGULAR),
		list("Screwdriver", floor(scale * 5), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("Wirecutters", floor(scale * 5), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("Crowbar", floor(scale * 5), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("Wrench", floor(scale * 5), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR),
		list("Multitool", floor(scale * 1), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),
		list("ME3 hand welder", floor(scale * 1), /obj/item/tool/weldingtool/simple, VENDOR_ITEM_REGULAR),

		list("FLARE AND LIGHT", -1, null, null),
		list("Combat Flashlight", floor(scale * 5), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Box of Flashlight", floor(scale * 1), /obj/item/ammo_box/magazine/misc/flashlight, VENDOR_ITEM_REGULAR),
		list("Box of Flares", floor(scale * 1), /obj/item/ammo_box/magazine/misc/flares, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", floor(scale * 10), /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", floor(scale * 1), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Engineer Kit", floor(scale * 1), /obj/item/storage/toolkit/empty, VENDOR_ITEM_REGULAR),
		list("Map", floor(scale * 5), /obj/item/map/current_map, VENDOR_ITEM_REGULAR),
		list("Extinguisher", floor(scale * 5), /obj/item/tool/extinguisher, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", floor(scale * 1), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("Roller Bed", floor(scale * 1), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", floor(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("Binoculars", floor(scale * 1), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("MB-6 Folding Barricades (x3)", floor(scale * 2), /obj/item/stack/folding_barricade/three, VENDOR_ITEM_REGULAR),
		list("Spare PDT/L Battle Buddy Kit", floor(scale * 3), /obj/item/storage/box/pdt_kit, VENDOR_ITEM_REGULAR),
		list("W-Y brand rechargeable mini-battery", floor(scale * 2.5), /obj/item/cell/crap, VENDOR_ITEM_REGULAR),
		list("Nailgun Magazine (7x45mm)", floor(scale * 4), /obj/item/ammo_magazine/smg/nailgun, VENDOR_ITEM_REGULAR)
		)

//--------------SQUAD ATTACHMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/attachments/squad
	name = "\improper Armat Systems Squad Attachments Vendor"
	desc = "An automated supply rack hooked up to a small storage of weapons attachments. Can be accessed by any Marine Rifleman."
	req_access = list(ACCESS_MARINE_ALPHA)
	req_one_access = list(ACCESS_MARINE_LEADER, ACCESS_MARINE_SPECPREP, ACCESS_MARINE_RO)
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

	vend_y_offset = 1

/obj/structure/machinery/cm_vending/sorted/attachments/squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/attachments/squad/populate_product_list(scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Extended Barrel", 2.5, /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 2.5, /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", 2.5, /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),
		list("Shotgun Choke", 1.5, /obj/item/attachable/shotgun_choke, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("B8 Smart-Scope", 1.5, /obj/item/attachable/alt_iff_scope, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", 4, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("S4 2x Telescopic Mini-Scope", 2, /obj/item/attachable/scope/mini, VENDOR_ITEM_REGULAR),
		list("S5 Red-Dot Sight", 3, /obj/item/attachable/reddot, VENDOR_ITEM_REGULAR),
		list("S6 Reflex Sight", 3, /obj/item/attachable/reflex, VENDOR_ITEM_REGULAR),
		list("S8 4x Telescopic Scope", 2, /obj/item/attachable/scope, VENDOR_ITEM_REGULAR),

		list("UNDERBARREL", -1, null, null),
		list("Angled Grip", 2.5, /obj/item/attachable/angledgrip, VENDOR_ITEM_REGULAR),
		list("Bipod", 2.5, /obj/item/attachable/bipod, VENDOR_ITEM_REGULAR),
		list("Burst Fire Assembly", 1.5, /obj/item/attachable/burstfire_assembly, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 1.5, /obj/item/attachable/gyro, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 3, /obj/item/attachable/lasersight, VENDOR_ITEM_REGULAR),
		list("Mini Flamethrower", 1.5, /obj/item/attachable/attached_gun/flamer, VENDOR_ITEM_REGULAR),
		list("XM-VESG-1 Flamer Nozzle", 1.5, /obj/item/attachable/attached_gun/flamer_nozzle, VENDOR_ITEM_REGULAR),
		list("U7 Underbarrel Shotgun", 1.5, /obj/item/attachable/attached_gun/shotgun, VENDOR_ITEM_REGULAR),
		list("Underbarrel Extinguisher", 1.5, /obj/item/attachable/attached_gun/extinguisher, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 3, /obj/item/attachable/verticalgrip, VENDOR_ITEM_REGULAR),

		list("STOCK", -1, null, null),
		list("M37 Wooden Stock", 1.5, /obj/item/attachable/stock/shotgun, VENDOR_ITEM_REGULAR),
		list("M39 Arm Brace", 1.5, /obj/item/attachable/stock/smg/collapsible/brace, VENDOR_ITEM_REGULAR),
		list("M39 Stock", 1.5, /obj/item/attachable/stock/smg, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", 1.5, /obj/item/attachable/stock/rifle, VENDOR_ITEM_REGULAR),
		list("M44 Magnum Sharpshooter Stock", 1.5, /obj/item/attachable/stock/revolver, VENDOR_ITEM_REGULAR)
		)

//------------ESSENTIAL SETS---------------
/obj/effect/essentials_set/random/uscm_light_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/storage/marine/light/padded,
		/obj/item/clothing/suit/storage/marine/light/padless,
		/obj/item/clothing/suit/storage/marine/light/padless_lines,
		/obj/item/clothing/suit/storage/marine/light/carrier,
		/obj/item/clothing/suit/storage/marine/light/skull,
		/obj/item/clothing/suit/storage/marine/light/smooth,
	)

/obj/effect/essentials_set/random/uscm_heavy_armor
	spawned_gear_list = list(
		/obj/item/clothing/suit/storage/marine/heavy/padded,
		/obj/item/clothing/suit/storage/marine/heavy/padless,
		/obj/item/clothing/suit/storage/marine/heavy/padless_lines,
		/obj/item/clothing/suit/storage/marine/heavy/carrier,
		/obj/item/clothing/suit/storage/marine/heavy/skull,
		/obj/item/clothing/suit/storage/marine/heavy/smooth,
	)

//------------MARINE CIVILIAN CLOTHING---------------

GLOBAL_LIST_INIT(cm_vending_clothing_marine_snowflake, list(
	list("SHIRTS AND UNIFORMS", 0, null, null, null),
	list("White T-Shirt and Brown Jeans", 12, /obj/item/clothing/under/tshirt/w_br, null, VENDOR_ITEM_REGULAR),
	list("Gray T-Shirt and Blue Jeans", 12, /obj/item/clothing/under/tshirt/gray_blu, null, VENDOR_ITEM_REGULAR),
	list("Red T-Shirt and Black Jeans", 12, /obj/item/clothing/under/tshirt/r_bla, null, VENDOR_ITEM_REGULAR),
	list("Frontier Jumpsuit", 12, /obj/item/clothing/under/rank/frontier, null, VENDOR_ITEM_REGULAR),
	list("UA Grey Jumpsuit", 12, /obj/item/clothing/under/rank/utility/gray, null, VENDOR_ITEM_REGULAR),
	list("UA Brown Jumpsuit", 12, /obj/item/clothing/under/rank/utility/brown, null, VENDOR_ITEM_REGULAR),
	list("UA Green Utility Uniform", 12, /obj/item/clothing/under/rank/utility, null, VENDOR_ITEM_REGULAR),
	list("Grey Utilities", 12, /obj/item/clothing/under/rank/utility/yellow, null, VENDOR_ITEM_REGULAR),
	list("Grey Utilities and Blue Jeans", 12, /obj/item/clothing/under/rank/utility/red, null, VENDOR_ITEM_REGULAR),
	list("Blue Utilities and Brown Jeans", 12, /obj/item/clothing/under/rank/utility/blue, null, VENDOR_ITEM_REGULAR),
	list("White Service Uniform", 12, /obj/item/clothing/under/colonist/white_service, null, VENDOR_ITEM_REGULAR),
	list("Steward Clothes", 12, /obj/item/clothing/under/colonist/steward, null, VENDOR_ITEM_REGULAR),
	list("Red Dress Skirt", 12, /obj/item/clothing/under/blackskirt, null, VENDOR_ITEM_REGULAR),
	list("Blue Suit Pants", 12, /obj/item/clothing/under/liaison_suit/blue, null, VENDOR_ITEM_REGULAR),
	list("Brown Suit Pants", 12, /obj/item/clothing/under/liaison_suit/brown, null, VENDOR_ITEM_REGULAR),
	list("White Suit Pants", 12, /obj/item/clothing/under/liaison_suit/corporate_formal, null, VENDOR_ITEM_REGULAR),
	list("Working Joe Uniform", 36, /obj/item/clothing/under/rank/synthetic/joe, null, VENDOR_ITEM_REGULAR),

	list("GLASSES", 0, null, null, null),
	list("Marine RPG Glasses", 12, /obj/item/clothing/glasses/regular, null, VENDOR_ITEM_REGULAR),
	list("Sunglasses", 12, /obj/item/clothing/glasses/sunglasses, null, VENDOR_ITEM_REGULAR),

	list("SHOES", 0, null, null, null),
	list("Boots", 12, /obj/item/clothing/shoes/marine, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Black", 12, /obj/item/clothing/shoes/black, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Blue", 12, /obj/item/clothing/shoes/blue, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Brown", 12, /obj/item/clothing/shoes/brown, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Green", 12, /obj/item/clothing/shoes/green, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Purple", 12, /obj/item/clothing/shoes/purple, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Red", 12, /obj/item/clothing/shoes/red, null, VENDOR_ITEM_REGULAR),
	list("Shoes, White", 12, /obj/item/clothing/shoes/white, null, VENDOR_ITEM_REGULAR),
	list("Shoes, Yellow", 12, /obj/item/clothing/shoes/yellow, null, VENDOR_ITEM_REGULAR),

	list("HEADWEAR", 0, null, null, null),
	list("Beanie", 12, /obj/item/clothing/head/beanie, null, VENDOR_ITEM_REGULAR),
	list("Beret, Engineering", 12, /obj/item/clothing/head/beret/eng, null, VENDOR_ITEM_REGULAR),
	list("Beret, Purple", 12, /obj/item/clothing/head/beret/jan, null, VENDOR_ITEM_REGULAR),
	list("Beret, Red", 12, /obj/item/clothing/head/beret/cm/red, null, VENDOR_ITEM_REGULAR),
	list("Beret, Standard", 12, /obj/item/clothing/head/beret/cm, null, VENDOR_ITEM_REGULAR),
	list("Beret, Tan", 12, /obj/item/clothing/head/beret/cm/tan, null, VENDOR_ITEM_REGULAR),
	list("Beret, Green", 12, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
	list("Beret, Black", 12, /obj/item/clothing/head/beret/cm/black, null, VENDOR_ITEM_REGULAR),
	list("Beret, White", 12, /obj/item/clothing/head/beret/cm/white, null, VENDOR_ITEM_REGULAR),
	list("Ushanka", 12, /obj/item/clothing/head/ushanka, null, VENDOR_ITEM_REGULAR),
	list("Cap", 12, /obj/item/clothing/head/cmcap, null, VENDOR_ITEM_REGULAR),

	list("SUIT", 0, null, null, null),
	list("Bomber Jacket, Brown", 12, /obj/item/clothing/suit/storage/bomber, null, VENDOR_ITEM_REGULAR),
	list("Bomber Jacket, Black", 12, /obj/item/clothing/suit/storage/bomber/alt, null, VENDOR_ITEM_REGULAR),
	list("External Webbing", 12, /obj/item/clothing/suit/storage/webbing, null, VENDOR_ITEM_REGULAR),
	list("Utility Vest", 12, /obj/item/clothing/suit/storage/utility_vest, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Orange)", 12, /obj/item/clothing/suit/storage/hazardvest, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Blue)", 12, /obj/item/clothing/suit/storage/hazardvest/blue, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Yellow)", 12, /obj/item/clothing/suit/storage/hazardvest/yellow, null, VENDOR_ITEM_REGULAR),
	list("Hazard Vest(Black)", 12, /obj/item/clothing/suit/storage/hazardvest/black, null, VENDOR_ITEM_REGULAR),
	list("USCM Service Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/service, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Brown", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_brown, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Grey", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_gray, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Green", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_green, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, First Responder", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_fr, null, VENDOR_ITEM_REGULAR),
	list("Windbreaker, Exploration", 12, /obj/item/clothing/suit/storage/windbreaker/windbreaker_covenant, null, VENDOR_ITEM_REGULAR),
	list("Black Suit Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/black, null, VENDOR_ITEM_REGULAR),
	list("Brown Suit Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/brown, null, VENDOR_ITEM_REGULAR),
	list("Blue Suit Jacket", 12, /obj/item/clothing/suit/storage/jacket/marine/corporate/blue, null, VENDOR_ITEM_REGULAR),
	list("Brown Vest", 12, /obj/item/clothing/suit/storage/jacket/marine/vest, null, VENDOR_ITEM_REGULAR),
	list("Tan Vest", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/tan, null, VENDOR_ITEM_REGULAR),
	list("Grey Vest", 12, /obj/item/clothing/suit/storage/jacket/marine/vest/grey, null, VENDOR_ITEM_REGULAR),

	list("BACKPACK", 0, null, null, null),
	list("Backpack, Industrial", 12, /obj/item/storage/backpack/industrial, null, VENDOR_ITEM_REGULAR),
	list("Satchel, Leather", 12, /obj/item/storage/backpack/satchel, null, VENDOR_ITEM_REGULAR),
	list("Satchel, Medical", 12, /obj/item/storage/backpack/satchel/med, null, VENDOR_ITEM_REGULAR),

	list("OTHER", 0, null, null, null),
	list("Red Armband", 6, /obj/item/clothing/accessory/armband, null, VENDOR_ITEM_REGULAR),
	list("Purple Armband", 6, /obj/item/clothing/accessory/armband/science, null, VENDOR_ITEM_REGULAR),
	list("Yellow Armband", 6, /obj/item/clothing/accessory/armband/engine, null, VENDOR_ITEM_REGULAR),
	list("Green Armband", 6, /obj/item/clothing/accessory/armband/medgreen, null, VENDOR_ITEM_REGULAR),
	list("Dress Gloves", 6, /obj/item/clothing/gloves/marine/dress, null, VENDOR_ITEM_REGULAR),

))

/obj/structure/machinery/cm_vending/clothing/marine/snowflake
	name = "\improper Personal Civilian Clothing Storage Unit"
	desc = "The vendor where all of your personal civilian clothing is stored while you are on-duty."
	icon_state = "snowflake"
	show_points = TRUE
	use_snowflake_points = TRUE
	vendor_theme = VENDOR_THEME_COMPANY
	req_access = list()
	vendor_role = list()

	vend_delay = 1 SECONDS

/obj/structure/machinery/cm_vending/clothing/marine/snowflake/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_marine_snowflake

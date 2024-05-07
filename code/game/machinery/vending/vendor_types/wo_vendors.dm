//------------WHISKEY OUTPOST VENDOR VEERSIONS---------------

//------------UNIFORM VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/wo
	req_access = list()
	req_one_access = list()

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/wo/populate_product_list(scale)
	listed_products = list(
		list("STANDARD EQUIPMENT", -1, null, null, null),
		list("Marine Combat Boots", round(scale * 15), /obj/item/clothing/shoes/marine, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Boots", round(scale * 15), /obj/item/clothing/shoes/marine/brown, VENDOR_ITEM_REGULAR),
		list("USCM Uniform", round(scale * 15), /obj/item/clothing/under/marine, VENDOR_ITEM_REGULAR),
		list("Marine Combat Gloves", round(scale * 15), /obj/item/clothing/gloves/marine, VENDOR_ITEM_REGULAR),
		list("Marine Brown Combat Gloves", round(scale * 15), /obj/item/clothing/gloves/marine/brown, VENDOR_ITEM_REGULAR),
		list("Marine Black Combat Gloves", round(scale * 15), /obj/item/clothing/gloves/marine/black, VENDOR_ITEM_REGULAR),
		list("Marine Radio Headset", round(scale * 15), /obj/item/device/radio/headset/almayer, VENDOR_ITEM_REGULAR),
		list("M10 Pattern Marine Helmet", round(scale * 15), /obj/item/clothing/head/helmet/marine, VENDOR_ITEM_REGULAR),

		list("WEBBINGS", -1, null, null),
		list("Brown Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Webbing", round(scale * 2), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 1, /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("ARMOR", -1, null, null),
		list("M3 Pattern Carrier Marine Armor", round(scale * 15), /obj/item/clothing/suit/storage/marine/medium/carrier, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padded Marine Armor", round(scale * 15), /obj/item/clothing/suit/storage/marine/medium/padded, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Padless Marine Armor", round(scale * 15), /obj/item/clothing/suit/storage/marine/medium/padless, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Ridged Marine Armor", round(scale * 15), /obj/item/clothing/suit/storage/marine/medium/padless_lines, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Skull Marine Armor", round(scale * 15), /obj/item/clothing/suit/storage/marine/medium/skull, VENDOR_ITEM_REGULAR),
		list("M3 Pattern Smooth Marine Armor", round(scale * 15), /obj/item/clothing/suit/storage/marine/medium/smooth, VENDOR_ITEM_REGULAR),
		list("M3-EOD Pattern Heavy Armor", round(scale * 10), /obj/item/clothing/suit/storage/marine/heavy, VENDOR_ITEM_REGULAR),
		list("M3-L Pattern Light Armor", round(scale * 10), /obj/item/clothing/suit/storage/marine/light, VENDOR_ITEM_REGULAR),

		list("BACKPACK", -1, null, null, null),
		list("Lightweight IMP Backpack", round(scale * 15), /obj/item/storage/backpack/marine, VENDOR_ITEM_REGULAR),
		list("Technician Backpack", round(scale * 15), /obj/item/storage/backpack/marine/tech, VENDOR_ITEM_REGULAR),
		list("Medical Backpack", round(scale * 15), /obj/item/storage/backpack/marine/medic, VENDOR_ITEM_REGULAR),
		list("USCM Satchel", round(scale * 15), /obj/item/storage/backpack/marine/satchel, VENDOR_ITEM_REGULAR),
		list("USCM Chestrig", round(scale * 15), /obj/item/storage/backpack/marine/satchel/chestrig, VENDOR_ITEM_REGULAR),
		list("USCM Technical Satchel", round(scale * 15), /obj/item/storage/backpack/marine/satchel/tech, VENDOR_ITEM_REGULAR),
		list("USCM Technical Chestrig", round(scale * 15), /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, VENDOR_ITEM_REGULAR),
		list("Medical Satchel", round(scale * 15), /obj/item/storage/backpack/marine/satchel/medic, VENDOR_ITEM_REGULAR),
		list("Shotgun Scabbard", round(scale * 5), /obj/item/storage/large_holster/m37, VENDOR_ITEM_REGULAR),

		list("RESTRICTED BACKPACKS", -1, null, null),
		list("USCM Technician Welderpack", 1.25, /obj/item/storage/backpack/marine/engineerpack, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", round(scale * 2), /obj/item/storage/backpack/marine/engineerpack/satchel, VENDOR_ITEM_REGULAR),
		list("Radio Telephone Backpack", 0.75, /obj/item/storage/backpack/marine/satchel/rto, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("M276 Pattern Ammo Load Rig", round(scale * 15), /obj/item/storage/belt/marine, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M40 Grenade Rig", round(scale * 10), /obj/item/storage/belt/grenade, VENDOR_ITEM_REGULAR),
		list("M276 Pattern Shotgun Shell Loading Rig", round(scale * 15), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("M276 Pattern General Pistol Holster Rig", round(scale * 15), /obj/item/storage/belt/gun/m4a3, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig", round(scale * 15), /obj/item/storage/large_holster/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M39 Holster Rig And Pouch", round(scale * 10), /obj/item/storage/belt/gun/m39, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M44 Holster Rig", round(scale * 15), /obj/item/storage/belt/gun/m44, VENDOR_ITEM_REGULAR),
		list("M276 Pattern M82F Holster Rig", round(scale * 5), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("M276 Knife Rig (Full)", round(scale * 15), /obj/item/storage/belt/knifepouch, VENDOR_ITEM_REGULAR),
		list("M276 G8-A General Utility Pouch", round(scale * 15), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null, null),
		list("Bayonet Sheath (Full)",round(scale * 15), /obj/item/storage/pouch/bayonet, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", round(scale * 15), /obj/item/storage/pouch/firstaid/full/alternate, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", round(scale * 15), /obj/item/storage/pouch/firstaid/full/pills, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", round(scale * 15), /obj/item/storage/pouch/flare/full, VENDOR_ITEM_REGULAR),
		list("Small Document Pouch", round(scale * 15), /obj/item/storage/pouch/document/small, VENDOR_ITEM_REGULAR),
		list("Magazine Pouch", round(scale * 15), /obj/item/storage/pouch/magazine, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", round(scale * 15), /obj/item/storage/pouch/shotgun, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", round(scale * 15), /obj/item/storage/pouch/general/medium, VENDOR_ITEM_REGULAR),
		list("Pistol Magazine Pouch", round(scale * 15), /obj/item/storage/pouch/magazine/pistol, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", round(scale * 15), /obj/item/storage/pouch/pistol, VENDOR_ITEM_REGULAR),

		list("RESTRICTED POUCHES", -1, null, null, null),
		list("Construction Pouch", 1.25, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 1.25, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch (Empty)", 2.5, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", round(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Tools Pouch", 1.25, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 1.25, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("MASK", -1, null, null, null),
		list("Gas Mask", round(scale * 15), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", round(scale * 10), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("Rebreather", round(scale * 10), /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null, null),
		list("Ballistic goggles", round(scale * 10), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("M1A1 Ballistic goggles", round(scale * 10), /obj/item/clothing/glasses/mgoggles/v2, VENDOR_ITEM_REGULAR),
		list("Prescription ballistic goggles", round(scale * 10), /obj/item/clothing/glasses/mgoggles/prescription, VENDOR_ITEM_REGULAR),
		list("Marine RPG glasses", round(scale * 10), /obj/item/clothing/glasses/regular, VENDOR_ITEM_REGULAR),
		list("M5 Integrated Gas Mask", round(scale * 10), /obj/item/prop/helmetgarb/helmet_gasmask, VENDOR_ITEM_REGULAR),
		list("M10 Helmet Netting", round(scale * 10), /obj/item/prop/helmetgarb/netting, VENDOR_ITEM_REGULAR),
		list("M10 Helmet Rain Cover", round(scale * 10), /obj/item/prop/helmetgarb/raincover, VENDOR_ITEM_REGULAR),
		list("Firearm Lubricant", round(scale * 15), /obj/item/prop/helmetgarb/gunoil, VENDOR_ITEM_REGULAR),
		list("USCM Flair", round(scale * 15), /obj/item/prop/helmetgarb/flair_uscm, VENDOR_ITEM_REGULAR),
		list("Falling Falcons Shoulder Patch", round(scale * 15), /obj/item/clothing/accessory/patch/falcon, VENDOR_ITEM_REGULAR),
		list("USCM Shoulder Patch", round(scale * 15), /obj/item/clothing/accessory/patch, VENDOR_ITEM_REGULAR),
		list("Bedroll", round(scale * 20), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),

		list("OPTICS", -1, null, null, null),
		list("Advanced Medical Optic (CORPSMAN ONLY)", round(scale * 4), /obj/item/device/helmet_visor/medical/advanced, VENDOR_ITEM_REGULAR),
		list("Squad Optic", round(scale * 15), /obj/item/device/helmet_visor, VENDOR_ITEM_REGULAR),

		)

//------------WEAPON RACKS---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/wo
	req_access = list()
	req_one_access = list()
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_LOAD_AMMO_BOXES | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/cargo_guns/squad_prep/wo/populate_product_list(scale)
	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", round(scale * 10), /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", round(scale * 15), /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", round(scale * 30), /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK1", round(scale * 30), /obj/item/weapon/gun/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", round(scale * 30), /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("Box of Buckshot Shells (12g)", round(scale * 10), /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box of Flechette Shells (12g)", round(scale * 4), /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", round(scale * 10), /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M4RA Magazine (10x24mm)", round(scale * 15), /obj/item/ammo_magazine/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", round(scale * 25), /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A MK1 Magazine (10x24mm)", round(scale * 25), /obj/item/ammo_magazine/rifle/m41aMK1, VENDOR_ITEM_REGULAR),
		list("M41A MK2 Magazine (10x24mm)", round(scale * 25), /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", round(scale * 25), /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", round(scale * 25), /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", round(scale * 5), /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("88M4 AP Magazine (9mm)", round(scale * 25), /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Speedloader (.44)", round(scale * 20), /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", round(scale * 25), /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("M39 Folding Stock", round(scale * 10), /obj/item/attachable/stock/smg/collapsible, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", round(scale * 25), /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", round(scale * 10), /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),
		list("Underslung Grenade Launcher", round(scale * 25), /obj/item/attachable/attached_gun/grenade, VENDOR_ITEM_REGULAR), //They already get these as on-spawns, might as well formalize some spares.

		list("UTILITIES", -1, null, null),
		list("M5 Bayonet", round(scale * 25), /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M11 Throwing Knife", round(scale * 10), /obj/item/weapon/throwing_knife, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare Pack", round(scale * 10), /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR)
	)

//------------REQ AMMUNITION VENDOR---------------
/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/wo
	req_access = list(ACCESS_MARINE_CARGO)
	req_one_access = list()

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/cargo/wo/populate_product_list(scale)
	..()
	listed_products += list(
		list("EXTRA SCOUT AMMUNITION", -1, null, null, null),
		list("A19 High Velocity Impact Magazine (10x24mm)", round(scale * 1), /obj/item/ammo_magazine/rifle/m4ra/custom/impact, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Incendiary Magazine (10x24mm)", round(scale * 1), /obj/item/ammo_magazine/rifle/m4ra/custom/incendiary, VENDOR_ITEM_REGULAR),
		list("A19 High Velocity Magazine (10x24mm)", round(scale * 1.5), /obj/item/ammo_magazine/rifle/m4ra/custom, VENDOR_ITEM_REGULAR),

		list("EXTRA SNIPER AMMUNITION", -1, null, null, null),
		list("M42A Flak Magazine (10x28mm)", round(scale * 1), /obj/item/ammo_magazine/sniper/flak, VENDOR_ITEM_REGULAR),
		list("M42A Incendiary Magazine (10x28mm)", round(scale * 1), /obj/item/ammo_magazine/sniper/incendiary, VENDOR_ITEM_REGULAR),
		list("M42A Marksman Magazine (10x28mm Caseless)", round(scale * 1.5), /obj/item/ammo_magazine/sniper, VENDOR_ITEM_REGULAR),

		list("EXTRA DEMOLITIONIST AMMUNITION", -1, null, null, null),
		list("84mm Anti-Armor Rocket", round(scale * 1), /obj/item/ammo_magazine/rocket/ap, VENDOR_ITEM_REGULAR),
		list("84mm High-Explosive Rocket", round(scale * 1), /obj/item/ammo_magazine/rocket, VENDOR_ITEM_REGULAR),
		list("84mm White-Phosphorus Rocket", round(scale * 1), /obj/item/ammo_magazine/rocket/wp, VENDOR_ITEM_REGULAR),

		list("EXTRA GRENADES", -1, null, null, null),
		list("M40 HEDP Grenade Pack (x6)", round(scale * 1.5), /obj/effect/essentials_set/hedp_6_pack, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Grenade Pack (x6)", round(scale * 1.5), /obj/effect/essentials_set/hidp_6_pack, VENDOR_ITEM_REGULAR),
		list("M74 AGM-F Grenade Pack (x6)", round(scale * 1.5), /obj/effect/essentials_set/agmf_6_pack, VENDOR_ITEM_REGULAR),
		list("M74 AGM-I Grenade Pack (x6)", round(scale * 1.5), /obj/effect/essentials_set/agmi_6_pack, VENDOR_ITEM_REGULAR),

		list("EXTRA FLAMETHROWER TANKS", -1, null, null, null),
		list("Large Incinerator Tank", round(scale * 1), /obj/item/ammo_magazine/flamer_tank/large, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (B) (Green Flame)", round(scale * 1), /obj/item/ammo_magazine/flamer_tank/large/B, VENDOR_ITEM_REGULAR),
		list("Large Incinerator Tank (X) (Blue Flame)", round(scale * 1), /obj/item/ammo_magazine/flamer_tank/large/X, VENDOR_ITEM_REGULAR),
		)

//------------ARMAMENTS VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/cargo/wo
	req_access = list(ACCESS_MARINE_CARGO)
	vend_dir = NORTH
	vend_dir_whitelist = list(EAST, WEST)

//---- ATTACHIES
/obj/structure/machinery/cm_vending/sorted/attachments/wo
	req_access = list(ACCESS_MARINE_CARGO)
	vend_dir = NORTH
	vend_dir_whitelist = list(SOUTHWEST, SOUTHEAST)

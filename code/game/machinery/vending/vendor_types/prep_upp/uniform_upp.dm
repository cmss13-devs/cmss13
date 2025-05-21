/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/upp_squad_prep
	name = "\improper UnionAraratCorp Surplus Uniform Vendor"
	desc = "An automated supply rack hooked up to a small storage of standard soldier uniforms."
	icon_state = "upp_clothing"
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP
	req_one_access = list()
	listed_products = list()
	hackable = TRUE

/obj/structure/machinery/cm_vending/sorted/uniform_supply/squad_prep/upp_squad_prep/populate_product_list(scale)
	listed_products = list(
		list("STANDARD EQUIPMENT", -1, null, null),
		list("Soldier Combat Boots", floor(scale * 15), /obj/item/clothing/shoes/marine/upp/knife, VENDOR_ITEM_REGULAR),
		list("UPP Uniform", floor(scale * 15), /obj/item/clothing/under/marine/veteran/UPP, VENDOR_ITEM_REGULAR),
		list("Soldier Combat Gloves", floor(scale * 15), /obj/item/clothing/gloves/marine/veteran/upp, VENDOR_ITEM_REGULAR),
		list("Soldier Radio Headset", floor(scale * 15), /obj/item/device/radio/headset/distress/UPP, VENDOR_ITEM_REGULAR),
		list("UM4 Helmet", floor(scale * 15), /obj/item/clothing/head/helmet/marine/veteran/UPP, VENDOR_ITEM_REGULAR),

		list("HEADWEAR", -1, null, null),
		list("UL3 armored beret", 15, /obj/item/clothing/head/uppcap/beret, VENDOR_ITEM_REGULAR),
		list("UL8 armored ushanka", 15, /obj/item/clothing/head/uppcap/ushanka, VENDOR_ITEM_REGULAR),

		list("WEBBINGS", -1, null, null),
		list("Brown Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest/brown_vest, VENDOR_ITEM_REGULAR),
		list("Black Webbing Vest", 1, /obj/item/clothing/accessory/storage/black_vest, VENDOR_ITEM_REGULAR),
		list("Webbing", floor(scale * 2), /obj/item/clothing/accessory/storage/webbing, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0.75, /obj/item/clothing/accessory/storage/droppouch, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0.75, /obj/item/clothing/accessory/storage/holster, VENDOR_ITEM_REGULAR),

		list("ARMOR", -1, null, null),
		list("UM5 Medium Personal Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/faction/UPP, VENDOR_ITEM_REGULAR),
		list("UL6 Light Personal Armor", floor(scale * 15), /obj/item/clothing/suit/storage/marine/faction/UPP/support, VENDOR_ITEM_REGULAR),

		list("BACKPACK", -1, null, null),
		list("Combat Pack", floor(scale * 15), /obj/item/storage/backpack/lightpack/upp, VENDOR_ITEM_REGULAR),

		list("RESTRICTED BACKPACKS", -1, null, null),
		list("UPP Sapper Welderpack", floor(scale * 2), /obj/item/storage/backpack/marine/engineerpack/upp, VENDOR_ITEM_REGULAR),

		list("BELTS", -1, null, null),
		list("Type 41 Ammo Load Rig", floor(scale * 15), /obj/item/storage/belt/marine/upp, VENDOR_ITEM_REGULAR),
		list("NPZ92 Pistol Holster Rig", floor(scale * 15), /obj/item/storage/belt/gun/type47, VENDOR_ITEM_REGULAR),
		list("Flaregun Holster Rig", floor(scale * 2), /obj/item/storage/belt/gun/flaregun, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Loading Rig", floor(scale * 15), /obj/item/storage/belt/shotgun, VENDOR_ITEM_REGULAR),
		list("G8-A General Utility Pouch", floor(scale * 15), /obj/item/storage/backpack/general_belt, VENDOR_ITEM_REGULAR),

		list("POUCHES", -1, null, null),
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

		list("RESTRICTED POUCHES", -1, null, null),
		list("Construction Pouch", 1.25, /obj/item/storage/pouch/construction, VENDOR_ITEM_REGULAR),
		list("Explosive Pouch", 1.25, /obj/item/storage/pouch/explosive, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch (Empty)", 2.5, /obj/item/storage/pouch/first_responder, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", floor(scale * 2), /obj/item/storage/pouch/magazine/pistol/large, VENDOR_ITEM_REGULAR),
		list("Tools Pouch", 1.25, /obj/item/storage/pouch/tools, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 1.25, /obj/item/storage/pouch/sling, VENDOR_ITEM_REGULAR),

		list("MASK", -1, null, null),
		list("Gas Mask", floor(scale * 15), /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", floor(scale * 10), /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR),
		list("Rebreather", floor(scale * 10), /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("MISCELLANEOUS", -1, null, null),
		list("Ballistic goggles", floor(scale * 10), /obj/item/clothing/glasses/mgoggles, VENDOR_ITEM_REGULAR),
		list("M1A1 Ballistic goggles", floor(scale * 10), /obj/item/clothing/glasses/mgoggles/v2, VENDOR_ITEM_REGULAR),
		list("Prescription ballistic goggles", floor(scale * 10), /obj/item/clothing/glasses/mgoggles/prescription, VENDOR_ITEM_REGULAR),
		list("Attachable Dogtags", floor(scale * 15), /obj/item/clothing/accessory/dogtags, VENDOR_ITEM_REGULAR),
		list("UPP patch", floor(scale * 15), /obj/item/clothing/accessory/patch/upp, VENDOR_ITEM_REGULAR),
		list("UPP Naval Infantry patch", floor(scale * 15), /obj/item/clothing/accessory/patch/upp/naval, VENDOR_ITEM_REGULAR),
		list("Bedroll", floor(scale * 20), /obj/item/roller/bedroll, VENDOR_ITEM_REGULAR),

		list("OPTICS", -1, null, null),
		list("Advanced Medical Optic (CORPSMAN ONLY)", floor(scale * 4), /obj/item/device/helmet_visor/medical/advanced, VENDOR_ITEM_REGULAR),

		)

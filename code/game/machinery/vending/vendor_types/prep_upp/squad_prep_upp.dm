//--------------UPP SQUAD GENERAL MUNITION VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/upp_squad
	name = "\improper UnionAraratCorp Automated Munition Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various ammunition types. Can be accessed by any Union Soldier."
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

	vend_x_offset = 2

/obj/structure/machinery/cm_vending/sorted/cargo_ammo/upp_squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state


/obj/structure/machinery/cm_vending/sorted/cargo_ammo/upp_squad/populate_product_list(scale)
	listed_products = list(
		list("ARMOR-PIERCING AMMUNITION", -1, null, null),
		list("Type 71 AP Magazine (5.45x39mm)", floor(scale * 6), /obj/item/ammo_magazine/rifle/type71/ap, VENDOR_ITEM_REGULAR),

		list("STANDARD AMMUNITION", -1, null, null),
		list("Type 71 Magazine (5.45x39mm)", floor(scale * 20), /obj/item/ammo_magazine/rifle/type71, VENDOR_ITEM_REGULAR),
		list("Type 64 Helical Magazine (7.62x19mm)", floor(scale * 20), /obj/item/ammo_magazine/smg/bizon, VENDOR_ITEM_REGULAR),
		list("Handful of Heavy Buckshot Shells (8g)", floor(scale * 40), /obj/item/ammo_magazine/handful/shotgun/heavy/buckshot, VENDOR_ITEM_REGULAR),
		list("Handful of Heavy Slug Shells (8g)", floor(scale * 40), /obj/item/ammo_magazine/handful/shotgun/heavy/slug, VENDOR_ITEM_REGULAR),
		list("Handful of Heavy Flechette Shells (8g)", floor(scale * 40), /obj/item/ammo_magazine/handful/shotgun/heavy/flechette, VENDOR_ITEM_REGULAR),

		list("PISTOL AMMUNITION", -1, null, null),
		list("Type 73 Magazine (7.62x25mm Tokarev)", floor(scale * 10), /obj/item/ammo_magazine/pistol/t73, VENDOR_ITEM_REGULAR),
		list("ZHNK-72 Speed Loader (7.62x38mmR)", floor(scale * 10), /obj/item/ammo_magazine/revolver/upp, VENDOR_ITEM_REGULAR),
		list("NP92 Magazine (9x18mm Makarov)", floor(scale * 10), /obj/item/ammo_magazine/pistol/np92, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARM AMMUNITION", -1, null, null),
		list("Type-19 stick magazine (7.62x25mm)", floor(scale * 6), /obj/item/ammo_magazine/smg/pps43, VENDOR_ITEM_REGULAR),
		list("M240 Incinerator Tank", floor(scale * 3), /obj/item/ammo_magazine/flamer_tank, VENDOR_ITEM_REGULAR),
		)

//--------------UPP SQUAD ARMAMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/upp_squad
	name = "\improper UnionAraratCorp Automated Utilities Squad Vendor"
	desc = "An automated supply rack hooked up to a small storage of various utilities and tools. Can be accessed by any Union Soldier."
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP
	hackable = TRUE

	vend_x_offset = 2
	vend_y_offset = 1
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

/obj/structure/machinery/cm_vending/sorted/cargo_guns/upp_squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/cargo_guns/upp_squad/populate_product_list(scale)
	listed_products = list(
		list("FOOD", -1, null, null),
		list("Ration", floor(scale * 20), /obj/item/reagent_container/food/snacks/upp, VENDOR_ITEM_REGULAR),

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
//		list("M89-S Signal Flare Pack", floor(scale * 1), /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR), (removed until signal flares work per faction)

		list("MISCELLANEOUS", -1, null, null),
		list("Engineer Kit", floor(scale * 1), /obj/item/storage/toolkit/empty, VENDOR_ITEM_REGULAR),
		list("Map", floor(scale * 5), /obj/item/map/current_map, VENDOR_ITEM_REGULAR),
		list("Extinguisher", floor(scale * 5), /obj/item/tool/extinguisher, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", floor(scale * 1), /obj/item/tool/extinguisher/mini, VENDOR_ITEM_REGULAR),
		list("Roller Bed", floor(scale * 1), /obj/item/roller, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", floor(scale * 5), /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR),
		list("Binoculars", floor(scale * 1), /obj/item/device/binoculars, VENDOR_ITEM_REGULAR),
		list("Spare PDT/L Battle Buddy Kit", floor(scale * 3), /obj/item/storage/box/pdt_kit, VENDOR_ITEM_REGULAR),
		list("W-Y brand rechargeable mini-battery", floor(scale * 2.5), /obj/item/cell/crap, VENDOR_ITEM_REGULAR),
		list("Nailgun Magazine (7x45mm)", floor(scale * 4), /obj/item/ammo_magazine/smg/nailgun, VENDOR_ITEM_REGULAR)
		)

//--------------UPP SQUAD ATTACHMENTS VENDOR--------------

/obj/structure/machinery/cm_vending/sorted/attachments/upp_squad
	name = "\improper UnionAraratCorp Squad Attachments Vendor"
	desc = "An automated supply rack hooked up to a small storage of weapons attachments. Can be accessed by any Union Soldier."
	req_access = list(ACCESS_UPP_GENERAL)
	vendor_theme = VENDOR_THEME_UPP
	hackable = TRUE
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND | VEND_STOCK_DYNAMIC

	vend_y_offset = 1

/obj/structure/machinery/cm_vending/sorted/attachments/upp_squad/ui_state(mob/user)
	return GLOB.not_incapacitated_and_adjacent_strict_state

/obj/structure/machinery/cm_vending/sorted/attachments/upp_squad/populate_product_list(scale)
	listed_products = list(
		list("BARREL", -1, null, null),
		list("Extended Barrel", 2.5, /obj/item/attachable/extended_barrel, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 2.5, /obj/item/attachable/compensator, VENDOR_ITEM_REGULAR),
		list("Suppressor", 2.5, /obj/item/attachable/suppressor, VENDOR_ITEM_REGULAR),

		list("RAIL", -1, null, null),
		list("B8 Smart-Scope", 1.5, /obj/item/attachable/scope/mini_iff, VENDOR_ITEM_REGULAR),
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

		)

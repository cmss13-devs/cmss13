//------------GEAR VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_gear_smartgun, list(
		list("SMARTGUN SET (MANDATORY)", 0, null, null, null),
		list("Essential Smartgunner Set", 0, /obj/item/storage/box/m56_system, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("GUN ATTACHMENTS (CHOOSE 1)", 0, null, null, null),
		list("Laser Sight", 0, /obj/item/attachable/lasersight, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 0, /obj/item/attachable/reddot, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 0, /obj/item/attachable/reflex, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("EXPLOSIVES", 0, null, null, null),
		list("M40 HEDP High Explosive Packet (x3 grenades)", 30, /obj/item/storage/box/packet/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M40 HIDP Incendiary Packet (x3 grenades)", 30, /obj/item/storage/box/packet/incendiary, null, VENDOR_ITEM_REGULAR),
		list("M40 HPDP White Phosphorus Packet (x3 grenades)", 30, /obj/item/storage/box/packet/phosphorus, null, VENDOR_ITEM_REGULAR),
		list("M40 HSDP Smoke Packet (x3 grenades)", 15, /obj/item/storage/box/packet/smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Frag Airburst Packet (x3 airburst grenades)", 20, /obj/item/storage/box/packet/airburst_he, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Incendiary Airburst Packet (x3 airburst grenades)", 20, /obj/item/storage/box/packet/airburst_incen, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Smoke Airburst Packet (x3 airburst grenades)", 10, /obj/item/storage/box/packet/airburst_smoke, null, VENDOR_ITEM_REGULAR),
		list("M74 AGM-Hornet Airburst Packet (x3 airburst grenades", 20, /obj/item/storage/box/packet/hornet, null, VENDOR_ITEM_REGULAR),
		list("M20 Mine Box (x4 mines)", 20, /obj/item/storage/box/explosive_mines, null, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", 0, null, null, null),
		list("M44 Heavy Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),
		list("M44 Marksman Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/marksman, null, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine", 5, /obj/item/ammo_magazine/pistol/hp, null, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine", 5, /obj/item/ammo_magazine/pistol/ap, null, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine", 5, /obj/item/ammo_magazine/pistol/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smartpistol Magazine (.45)", 10, /obj/item/ammo_magazine/pistol/smart, null, VENDOR_ITEM_REGULAR),

		list("RESTRICTED FIREARMS", 0, null, null, null),
		list("VP78 Pistol", 15, /obj/item/storage/box/guncase/vp78, null, VENDOR_ITEM_REGULAR),
		list("SU-6 Smart Pistol", 15, /obj/item/storage/box/guncase/smartpistol, null, VENDOR_ITEM_REGULAR),

		list("CLOTHING ITEMS", 0, null, null, null),
		list("Machete Scabbard (Full)", 6, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 6, /obj/item/storage/pouch/general/large, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Smartgun DV9 Battery", 15, /obj/item/smartgun_battery, null, VENDOR_ITEM_REGULAR),

		list("BINOCULARS", 0, null, null, null),
		list("Binoculars", 5, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Range Finder", 10, /obj/item/device/binoculars/range, null, VENDOR_ITEM_REGULAR),
		list("Laser Designator", 15, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_REGULAR),

		list("HELMET OPTICS", 0, null, null, null),
		list("Medical Helmet Optic", 15, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),

		list("PAMPHLETS", 0, null, null, null),
		list("JTAC Pamphlet", 15, /obj/item/pamphlet/skill/jtac, null, VENDOR_ITEM_REGULAR),
		list("Engineering Pamphlet", 15, /obj/item/pamphlet/skill/engineer, null, VENDOR_ITEM_REGULAR),

		list("RADIO KEYS", 0, null, null, null),
		list("Engineering Radio Encryption Key", 5, /obj/item/device/encryptionkey/engi, null, VENDOR_ITEM_REGULAR),
		list("Intel Radio Encryption Key", 5, /obj/item/device/encryptionkey/intel, null, VENDOR_ITEM_REGULAR),
		list("JTAC Radio Encryption Key", 5, /obj/item/device/encryptionkey/jtac, null, VENDOR_ITEM_REGULAR),
		list("Supply Radio Encryption Key", 5, /obj/item/device/encryptionkey/req, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/smartgun
	name = "\improper ColMarTech Squad Smartgunner Gear Rack"
	desc = "An automated gear rack for Squad Smartgunners."
	icon_state = "sg_gear"
	show_points = TRUE
	vendor_role = list(JOB_SQUAD_SMARTGUN)
	req_access = list(ACCESS_MARINE_SMARTPREP)

/obj/structure/machinery/cm_vending/gear/smartgun/get_listed_products(mob/user)
	return GLOB.cm_vending_gear_smartgun

//------------CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_smartgun, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Standard Marine Apparel", 0, list(/obj/item/clothing/under/marine, /obj/item/clothing/shoes/marine/knife, /obj/item/clothing/gloves/marine, /obj/item/device/radio/headset/almayer/marine, /obj/item/clothing/head/helmet/marine), MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("BELT", 0, null, null, null),
		list("M802 Smartgunner Sidearm Belt", 0, /obj/item/storage/belt/gun/smartgunner/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),
		list("M280 Smartgunner Drum Belt", 0, /obj/item/storage/belt/marine/smartgunner, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch", 0, /obj/item/storage/pouch/electronics, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Magazine Pouch", 0, /obj/item/storage/pouch/magazine, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Machete Pouch (Full)", 0, /obj/item/storage/pouch/machete/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
))

/obj/structure/machinery/cm_vending/clothing/smartgun
	name = "\improper ColMarTech Squad Smartgun Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Squad Smartgun standard-issue equipment."
	req_access = list(ACCESS_MARINE_SMARTPREP)
	vendor_role = list(JOB_SQUAD_SMARTGUN)

/obj/structure/machinery/cm_vending/clothing/smartgun/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_smartgun

/obj/structure/machinery/cm_vending/clothing/smartgun/alpha
	squad_tag = SQUAD_MARINE_1
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_ALPHA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/alpha

/obj/structure/machinery/cm_vending/clothing/smartgun/bravo
	squad_tag = SQUAD_MARINE_2
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_BRAVO)
	headset_type = /obj/item/device/radio/headset/almayer/marine/bravo

/obj/structure/machinery/cm_vending/clothing/smartgun/charlie
	squad_tag = SQUAD_MARINE_3
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_CHARLIE)
	headset_type = /obj/item/device/radio/headset/almayer/marine/charlie

/obj/structure/machinery/cm_vending/clothing/smartgun/delta
	squad_tag = SQUAD_MARINE_4
	req_access = list(ACCESS_MARINE_SMARTPREP, ACCESS_MARINE_DELTA)
	headset_type = /obj/item/device/radio/headset/almayer/marine/delta

//------------ESSENTIAL SETS---------------

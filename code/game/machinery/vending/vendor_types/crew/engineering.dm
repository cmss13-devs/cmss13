//------------ MT CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_maintenance_technician, list(
		list("MAINTENANCE SET (MANDATORY)", 0, null, null, null),
		list("Essential Maintenance Set", 0, /obj/effect/essentials_set/maintenance, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),

		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Insulated Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mt, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/mre, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Map", 0, /obj/item/map/current_map, MARINE_CAN_BUY_KIT, VENDOR_ITEM_MANDATORY),

		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Beret, Engineering", 0, /obj/item/clothing/head/beret/eng, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("White Hardhat", 0, /obj/item/clothing/head/hardhat/white, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Orange Hardhat", 0, /obj/item/clothing/head/hardhat/orange, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Blue Hardhat", 0, /obj/item/clothing/head/hardhat/dblue, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", 0, /obj/item/clothing/head/welding, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("SUIT (CHOOSE 1)", 0, null, null, null),
		list("Black Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Blue Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Orange Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Yellow Hazard Vest", 0, /obj/item/clothing/suit/storage/hazardvest/yellow, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Technician Backpack", 0, /obj/item/storage/backpack/marine/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Satchel", 0, /obj/item/storage/backpack/marine/satchel/tech, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welderpack", 0, /obj/item/storage/backpack/marine/engineerpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Technician Welder-Satchel", 0, /obj/item/storage/backpack/marine/engineerpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),
		list("Technician Welder Chestrig", 0, /obj/item/storage/backpack/marine/engineerpack/welder_chestrig, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_MANDATORY),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Medium General Pouch", 0, /obj/item/storage/pouch/general/medium, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Rebreather", 0, /obj/item/clothing/mask/rebreather, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Black Webbing", 0, /obj/item/clothing/accessory/storage/webbing/black, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("SPARE GEAR", 0, null, null, null),
		list("Synthetic Reset Key", 20, /obj/item/device/defibrillator/synthetic, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/maintenance_technician
	name = "\improper ColMarTech Maintenance Technician Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Maintenance Technician standard-issue equipment."
	req_access = list(ACCESS_MARINE_ENGINEERING)
	vendor_role = list(JOB_MAINT_TECH)

/obj/structure/machinery/cm_vending/clothing/maintenance_technician/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_maintenance_technician

/obj/effect/essentials_set/maintenance
	spawned_gear_list = list(
		/obj/item/device/lightreplacer,
		/obj/item/device/demo_scanner,
		/obj/item/storage/bag/trash,
		/obj/item/storage/toolbox/mechanical,
		/obj/item/device/flashlight,
	)

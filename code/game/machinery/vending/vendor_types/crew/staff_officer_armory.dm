/obj/structure/machinery/cm_vending/clothing/staff_officer_armory
	name = "\improper ColMarTech Staff Officer Armory Equipment Rack"
	desc = "An automated combat equipment vendor for Staff Officers."
	req_access = list(ACCESS_MARINE_COMMAND)
	icon_state = "mar_rack"
	vendor_role = list(JOB_SO)

/obj/structure/machinery/cm_vending/clothing/staff_officer_armory/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_staff_officer_armory

//------------GEAR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_staff_officer_armory, list(
		list("COMBAT EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Officer M3 Armor", 0, /obj/item/clothing/suit/storage/marine/MP/SO, MARINE_CAN_BUY_COMBAT_ARMOR, VENDOR_ITEM_MANDATORY),
		list("Officer M10 Helmet", 0, /obj/item/clothing/head/helmet/marine/MP/SO, MARINE_CAN_BUY_COMBAT_HELMET, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Marine Combat Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),
		list("Aviator Shades", 0, /obj/item/clothing/glasses/sunglasses/aviator, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_REGULAR),
		list("Bayonet", 0, /obj/item/attachable/bayonet, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("SPECIALISATION KIT (CHOOSE 1)", 0, null, null, null),
		list("Essential Engineer Set", 0, /obj/effect/essentials_set/engi, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),
		list("Essential Medical Set", 0, /obj/effect/essentials_set/medic, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_RECOMMENDED),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 Lifesaver Bag (Full)", 0, /obj/item/storage/belt/medical/lifesaver/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Medical Storage Rig (Full)", 0, /obj/item/storage/belt/medical/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M40 Grenade Rig", 0, /obj/item/storage/belt/grenade, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("Autoinjector Pouch", 0, /obj/item/storage/pouch/autoinjector, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Construction Pouch", 0, /obj/item/storage/pouch/construction, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Document Pouch", 0, /obj/item/storage/pouch/document, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Electronics Pouch (Full)", 0, /obj/item/storage/pouch/electronics/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("First Responder Pouch", 0, /obj/item/storage/pouch/first_responder, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 0, /obj/item/storage/pouch/flamertank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Pouch", 0, /obj/item/storage/pouch/medical, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Medical Kit Pouch", 0, /obj/item/storage/pouch/medkit, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Pistol Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("OTHER SUPPLIES", 0, null, null, null),
		list("Medical Helmet Optic", 5, /obj/item/device/helmet_visor/medical, null, VENDOR_ITEM_REGULAR),
		list("Welding Visor", 5, /obj/item/device/helmet_visor/welding_visor, null, VENDOR_ITEM_REGULAR),
		list("Magnetic Harness", 12, /obj/item/attachable/magnetic_harness, null, VENDOR_ITEM_REGULAR),
		list("Radio Telephone Pack", 15, /obj/item/storage/backpack/marine/satchel/rto, null, VENDOR_ITEM_RECOMMENDED),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("Laser Designator", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("Data Detector", 5, /obj/item/device/motiondetector/intel, null, VENDOR_ITEM_REGULAR),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("Fulton Recovery Device", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Blowtorch", 5, /obj/item/tool/weldingtool, null, VENDOR_ITEM_REGULAR),
		list("Wrench", 1, /obj/item/tool/wrench, null, VENDOR_ITEM_REGULAR),
		list("Crowbar", 1, /obj/item/tool/crowbar, null, VENDOR_ITEM_REGULAR),
		list("Entrenching Tool", 1, /obj/item/tool/shovel/etool, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 5, /obj/item/storage/large_holster/machete/full, null, VENDOR_ITEM_REGULAR)
	))

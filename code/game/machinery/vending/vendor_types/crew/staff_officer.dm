/obj/structure/machinery/cm_vending/clothing/staff_officer
	name = "\improper ColMarTech Staff Officer Equipment Rack"
	desc = "An automated equipment vendor for Staff Officers."
	req_access = list(ACCESS_MARINE_COMMAND)
	vendor_role = list(JOB_SO)

/obj/structure/machinery/cm_vending/clothing/staff_officer/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_staff_officer

//------------GEAR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_staff_officer, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Boots", 0, /obj/item/clothing/shoes/marine/knife, MARINE_CAN_BUY_SHOES, VENDOR_ITEM_MANDATORY),
		list("Headset", 0, /obj/item/device/radio/headset/almayer/mcom, MARINE_CAN_BUY_EAR, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),


		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Service Uniform", 0, /obj/item/clothing/under/marine/officer/bridge, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Operations Uniform", 0, /obj/item/clothing/under/marine/officer/boiler, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_RECOMMENDED),
		list("Gloves", 0, /obj/item/clothing/gloves/marine, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_REGULAR),

		list("JACKET (CHOOSE 1)", 0, null, null, null),
		list("Service Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/service, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),

		list("HAT (CHOOSE 1)", 0, null, null, null),
		list("Beret, Green", 0, /obj/item/clothing/head/beret/cm, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Beret, Tan", 0, /obj/item/clothing/head/beret/cm/tan, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Patrol Cap", 0, /obj/item/clothing/head/cmcap, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Officer Cap", 0, /obj/item/clothing/head/cmcap/bridge, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Service Peaked Cap", 0, /obj/item/clothing/head/marine/peaked/service, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),


		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("M44 Revolver", 0, /obj/item/storage/belt/gun/m44/mp, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("M4A3 Pistol", 0, /obj/item/storage/belt/gun/m4a3/commander, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),
		list("VP78 Pistol", 0, /obj/item/storage/belt/gun/m4a3/vp78, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("BACKPACK (CHOOSE 1)", 0, null, null, null),
		list("Backpack", 0, /obj/item/storage/backpack/marine, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Satchel", 0, /obj/item/storage/backpack/marine/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),


		list("OTHER SUPPLIES", 0, null, null, null),
		list("Binoculars", 5,/obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Rangefinder", 8, /obj/item/device/binoculars/range, null,  VENDOR_ITEM_REGULAR),
		list("Laser Designator", 12, /obj/item/device/binoculars/range/designator, null, VENDOR_ITEM_RECOMMENDED),
		list("Flashlight", 1, /obj/item/device/flashlight, null, VENDOR_ITEM_RECOMMENDED),
		list("Motion Detector", 5, /obj/item/device/motiondetector, null, VENDOR_ITEM_RECOMMENDED),
		list("Space Cleaner", 2, /obj/item/reagent_container/spray/cleaner, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	))

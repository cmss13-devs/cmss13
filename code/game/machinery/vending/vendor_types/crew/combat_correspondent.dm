//------------ CC CLOTHING VENDOR---------------

GLOBAL_LIST_INIT(cm_vending_clothing_combat_correspondent, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Essential Reporter's Set", 0, /obj/effect/essentials_set/cc, MARINE_CAN_BUY_ESSENTIALS, VENDOR_ITEM_MANDATORY),
		list("Leather Satchel", 0, /obj/item/storage/backpack/satchel, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_REGULAR),
		list("Press Broadcasting Camera", 0, /obj/item/device/broadcasting, MARINE_CAN_BUY_SECONDARY, VENDOR_ITEM_RECOMMENDED),

		list("CIVILIAN EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Portable Press Fax Machine", 0, /obj/item/device/fax_backpack, CIVILIAN_CAN_BUY_BACKPACK, VENDOR_ITEM_RECOMMENDED),

		list("UNIFORM (CHOOSE 1)", 0, null, null, null),
		list("Black Uniform", 0, /obj/item/clothing/under/marine/reporter/black, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Orange Uniform", 0, /obj/item/clothing/under/marine/reporter/orange, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),
		list("Red Uniform", 0, /obj/item/clothing/under/marine/reporter/red, MARINE_CAN_BUY_UNIFORM, VENDOR_ITEM_REGULAR),

		list("ARMOR (CHOOSE 1)", 0, null, null, null),
		list("Combat Correspondent's Armor", 0, /obj/item/clothing/suit/storage/marine/light/reporter, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_RECOMMENDED),
		list("Blue Vest", 0, /obj/item/clothing/suit/storage/jacket/marine/reporter/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Black Vest", 0, /obj/item/clothing/suit/storage/hazardvest/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Black Coat", 0, /obj/item/clothing/suit/storage/jacket/marine/reporter/black, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Green Coat", 0, /obj/item/clothing/suit/storage/jacket/marine/reporter/green, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Green Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/correspondent, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Blue Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/correspondent/blue, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Tan Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/correspondent/tan, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),
		list("Brown Jacket", 0, /obj/item/clothing/suit/storage/jacket/marine/correspondent/brown, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_REGULAR),


		list("HELMET (CHOOSE 1)", 0, null, null, null),
		list("Combat Correspondent's Helmet", 0, /obj/item/clothing/head/helmet/marine/reporter, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_RECOMMENDED),
		list("Combat Correspondent's Cap", 0, /obj/item/clothing/head/cmcap/reporter, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),
		list("Fedora", 0, /obj/item/clothing/head/fedora/grey, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_REGULAR),

		list("REFILLS", 0, null, null, null),
		list("Camera", 10, /obj/item/device/camera, null, VENDOR_ITEM_REGULAR),
		list("Camera Film", 5, /obj/item/device/camera_film, null, VENDOR_ITEM_REGULAR),
		list("Toner", 5, /obj/item/device/toner, null, VENDOR_ITEM_REGULAR),
		list("Regulation Tapes", 15, /obj/item/storage/box/tapes, null, VENDOR_ITEM_REGULAR),
		list("Paper Bin", 10, /obj/item/paper_bin/uscm, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/combat_correspondent
	name = "\improper ColMarTech Combat Correspondent Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Reporter standard-issue equipment."
	req_access = list(ACCESS_PRESS)
	vendor_role = list(JOB_COMBAT_REPORTER)

/obj/structure/machinery/cm_vending/clothing/combat_correspondent/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_combat_correspondent

/obj/effect/essentials_set/cc
	spawned_gear_list = list(
		/obj/item/device/flashlight,
		/obj/item/tool/pen,
		/obj/item/device/binoculars,
		/obj/item/notepad,
		/obj/item/device/taperecorder,
	)

GLOBAL_LIST_INIT(cm_vending_walker, list(
	list("WEAPONS (choose 2)", 0, null, null, null),
	list("M56 Double-Barrel Mounted Smartgun", 0, /obj/item/walker_gun/smartgun, MECH_GUN, VENDOR_ITEM_REGULAR),
	list("M30 Machine Gun", 0, /obj/item/walker_gun/hmg, MECH_GUN, VENDOR_ITEM_REGULAR),
	list("F40 \"Hellfire\" Flamethower", 0, /obj/item/walker_gun/flamer, MECH_GUN, VENDOR_ITEM_REGULAR),

	list("AMMUNITION", 0, null, null, null),
	list("M56 Magazine", 1, /obj/item/ammo_magazine/walker/smartgun, null, VENDOR_ITEM_REGULAR),
	list("M30 Magazine", 2, /obj/item/ammo_magazine/walker/hmg, null, VENDOR_ITEM_REGULAR),
	list("F40 UT-Napthal Canister", 2, /obj/item/ammo_magazine/walker/flamer, null, VENDOR_ITEM_REGULAR),
	// list("F40 UT-Napthal EX-type Canister", 3, /obj/item/ammo_magazine/walker/flamer/ex, null, VENDOR_ITEM_REGULAR),
	list("F40 UT-Napthal B-type Canister", 3, /obj/item/ammo_magazine/walker/flamer/btype, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/gear/walker
	name = "ColMarTech Automated Mech Vendor"
	desc = "This vendor is connected to main ship storage, allows to fetch one hardpoint module per category for free."
	icon_state = "engi"

	req_access = list(ACCESS_MARINE_WALKER)
	vendor_role = list(JOB_WALKER) //everyone else, mind your business
	var/available_categories = MECH_ALL_AVAIBALE

	unslashable = TRUE

	vend_delay = 4 SECONDS
	vend_sound = 'sound/machines/medevac_extend.ogg'

	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_TO_HAND|VEND_USE_VENDOR_FLAGS

/obj/structure/machinery/cm_vending/gear/walker/tip_over() //we don't do this here
	return

/obj/structure/machinery/cm_vending/gear/walker/flip_back()
	return

/obj/structure/machinery/cm_vending/gear/walker/get_listed_products(mob/user)
	var/list/display_list = list()

	display_list = GLOB.cm_vending_walker

	return display_list

/obj/structure/machinery/cm_vending/gear/walker/ui_data(mob/user)
	. = list()
	. += ui_static_data(user)

	.["current_m_points"] = supply_controller.mech_points

	var/list/ui_listed_products = get_listed_products(user)
	var/list/stock_values = list()
	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/avail_flag = myprod[4]
		if(supply_controller.mech_points >= p_cost && (!avail_flag || ((avail_flag in available_categories) && (available_categories[avail_flag]))))
			prod_available = TRUE
		stock_values += list(prod_available)

	.["stock_listing"] = stock_values

/obj/structure/machinery/cm_vending/gear/walker/handle_points(mob/living/carbon/human/H, list/L)
	. = TRUE
	if(L[4] != null)
		if(!(L[4] in available_categories))
			return FALSE
		if(!(available_categories[L[4]]))
			return FALSE
		if(supply_controller.mech_points < L[2])
			return FALSE
		else
			available_categories[L[4]] -= 1
			supply_controller.mech_points -= L[2]
	else
		if(supply_controller.mech_points < L[2])
			return FALSE
		else
			supply_controller.mech_points -= L[2]

//------------WEAPONS RACK---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vehicle_crew/walker
	name = "\improper ColMarTech Mech Operator Weapons Rack"
	desc = "An automated weapon rack hooked up to a small storage of standard-issue weapons. Can be accessed only by the Mech Operator."
	req_access = list(ACCESS_MARINE_WALKER)
	vendor_role = list(JOB_WALKER)

//------------CLOTHING RACK---------------

GLOBAL_LIST_INIT(cm_vending_clothing_walker, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Walker Armor", 0, /obj/item/clothing/suit/storage/marine/tanker/walker, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("M50 Walker Helmet", 0, /obj/item/clothing/head/helmet/marine/tech/tanker/walker, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("Medical Helmet Optic", 0, /obj/item/device/helmet_visor/medical, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
		list("Welding Kit", 0, /obj/item/tool/weldpack, MARINE_CAN_BUY_BACKPACK, VENDOR_ITEM_MANDATORY),
		list("MRE", 0, /obj/item/storage/box/MRE, MARINE_CAN_BUY_MRE, VENDOR_ITEM_MANDATORY),

		list("PERSONAL SIDEARM (CHOOSE 1)", 0, null, null, null),
		list("88 Mod 4 Combat Pistol", 0, /obj/item/weapon/gun/pistol/mod88, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),
		list("VP78 Pistol", 0, /obj/item/weapon/gun/pistol/vp78, MARINE_CAN_BUY_ATTACHMENT, VENDOR_ITEM_REGULAR),

		list("BELT (CHOOSE 1)", 0, null, null, null),
		list("G8-A General Utility Pouch", 0, /obj/item/storage/backpack/general_belt, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M103 Vehicle-Ammo Rig", 0, /obj/item/storage/belt/tank, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Ammo Load Rig", 0, /obj/item/storage/belt/marine, MARINE_CAN_BUY_BELT, VENDOR_ITEM_RECOMMENDED),
		list("M276 General Pistol Holster Rig", 0, /obj/item/storage/belt/gun/m4a3, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M39 Holster Rig", 0, /obj/item/storage/belt/gun/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/tank, MARINE_CAN_BUY_POUCH, VENDOR_ITEM_RECOMMENDED),

		list("ACCESSORIES (CHOOSE 1)", 0, null, null, null),
		list("Brown Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest/brown_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_RECOMMENDED),
		list("Black Webbing Vest", 0, /obj/item/clothing/accessory/storage/black_vest, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Shoulder Holster", 0, /obj/item/clothing/accessory/storage/holster, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Webbing", 0, /obj/item/clothing/accessory/storage/webbing, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),
		list("Drop Pouch", 0, /obj/item/clothing/accessory/storage/droppouch, MARINE_CAN_BUY_ACCESSORY, VENDOR_ITEM_REGULAR),

		list("MASK (CHOOSE 1)", 0, null, null, null),
		list("Gas Mask", 0, /obj/item/clothing/mask/gas, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),
		list("Heat Absorbent Coif", 0, /obj/item/clothing/mask/rebreather/scarf, MARINE_CAN_BUY_MASK, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", 0, null, null, null),
		list("Angled Grip", 10, /obj/item/attachable/angledgrip, null, VENDOR_ITEM_REGULAR),
		list("Extended Barrel", 10, /obj/item/attachable/extended_barrel, null, VENDOR_ITEM_REGULAR),
		list("Gyroscopic Stabilizer", 10, /obj/item/attachable/gyro, null, VENDOR_ITEM_REGULAR),
		list("Laser Sight", 10, /obj/item/attachable/lasersight, null, VENDOR_ITEM_REGULAR),
		list("Masterkey Shotgun", 10, /obj/item/attachable/attached_gun/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M37 Wooden Stock", 10, /obj/item/attachable/stock/shotgun, null, VENDOR_ITEM_REGULAR),
		list("M39 Stock", 10, /obj/item/attachable/stock/smg, null, VENDOR_ITEM_REGULAR),
		list("M41A Solid Stock", 10, /obj/item/attachable/stock/rifle, null, VENDOR_ITEM_REGULAR),
		list("Recoil Compensator", 10, /obj/item/attachable/compensator, null, VENDOR_ITEM_REGULAR),
		list("Red-Dot Sight", 10, /obj/item/attachable/reddot, null, VENDOR_ITEM_REGULAR),
		list("Reflex Sight", 10, /obj/item/attachable/reflex, null, VENDOR_ITEM_REGULAR),
		list("Suppressor", 10, /obj/item/attachable/suppressor, null, VENDOR_ITEM_REGULAR),
		list("Vertical Grip", 10, /obj/item/attachable/verticalgrip, null, VENDOR_ITEM_REGULAR),

		list("AMMUNITION", 0, null, null, null),
		list("M4RA AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/m4ra/ap, null, VENDOR_ITEM_REGULAR),
		list("M39 AP Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/ap , null, VENDOR_ITEM_REGULAR),
		list("M39 Extended Magazine (10x20mm)", 10, /obj/item/ammo_magazine/smg/m39/extended , null, VENDOR_ITEM_REGULAR),
		list("M40 HEDP Grenade", 10, /obj/item/explosive/grenade/high_explosive, null, VENDOR_ITEM_REGULAR),
		list("M41A AP Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/ap , null, VENDOR_ITEM_REGULAR),
		list("M41A Extended Magazine (10x24mm)", 10, /obj/item/ammo_magazine/rifle/extended , null, VENDOR_ITEM_REGULAR),
		list("M44 Heavy Speed Loader (.44)", 10, /obj/item/ammo_magazine/revolver/heavy, null, VENDOR_ITEM_REGULAR),

		list("UTILITIES", 0, null, null, null),
		list("Binoculars", 10, /obj/item/device/binoculars, null, VENDOR_ITEM_REGULAR),
		list("Fire Extinguisher (Portable)", 5, /obj/item/tool/extinguisher/mini, null, VENDOR_ITEM_REGULAR),
		list("Fuel Tank Strap Pouch", 5, /obj/item/storage/pouch/flamertank, null, VENDOR_ITEM_REGULAR),
		list("Fulton Device Stack", 5, /obj/item/stack/fulton, null, VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 10, /obj/item/storage/pouch/shotgun/large, null, VENDOR_ITEM_REGULAR),
		list("Motion Detector", 15, /obj/item/device/motiondetector, null, VENDOR_ITEM_REGULAR),
		list("Plastic Explosive", 10, /obj/item/explosive/plastic, null, VENDOR_ITEM_REGULAR),
		list("Roller Bed", 5, /obj/item/roller, null, VENDOR_ITEM_REGULAR),
		list("Whistle", 5, /obj/item/device/whistle, null, VENDOR_ITEM_REGULAR),
	))

/obj/structure/machinery/cm_vending/clothing/vehicle_crew/walker
	name = "\improper ColMarTech Mech Operator Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Mech Operator standard-issue equipment."
	req_access = list(ACCESS_MARINE_WALKER)
	vendor_role = list(JOB_WALKER)

/obj/structure/machinery/cm_vending/clothing/vehicle_crew/walker/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_walker

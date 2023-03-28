//------------VEHICLE MODULES VENDOR---------------

/obj/structure/machinery/cm_vending/gear/vehicle_crew
	name = "ColMarTech Vehicle Parts Delivery System"
	desc = "An automated delivery system unit hooked up to the underbelly of the ship. Allows the crewmen to choose one set of free equipment for their vehicle at the start of operation and order more spare parts if provided with additional budget by Command. Can be accessed only by the Vehicle Crewmen."
	icon = 'icons/obj/structures/machinery/vending_64x32.dmi'
	icon_state = "vehicle_gear"

	req_access = list(ACCESS_MARINE_CREWMAN)
	vendor_role = list(JOB_CREWMAN)
	bound_width = 64

	unslashable = TRUE

	vend_delay = 4 SECONDS
	vend_sound = 'sound/machines/medevac_extend.ogg'

	var/selected_vehicle
	var/budget_points = 0
	var/available_categories = VEHICLE_ALL_AVAILABLE

	available_points_to_display = 0

	vend_flags = VEND_CLUTTER_PROTECTION|VEND_CATEGORY_CHECK|VEND_TO_HAND|VEND_USE_VENDOR_FLAGS

/obj/structure/machinery/cm_vending/gear/vehicle_crew/Initialize(mapload, ...)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_VEHICLE_ORDERED, PROC_REF(populate_products))
	if(!VehicleGearConsole)
		VehicleGearConsole = src

/obj/structure/machinery/cm_vending/gear/vehicle_crew/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_VEHICLE_ORDERED)
	VehicleGearConsole = null
	return ..()

/obj/structure/machinery/cm_vending/gear/vehicle_crew/get_appropriate_vend_turf(mob/living/carbon/human/H)
	var/turf/T = loc
	T = get_step(T, SOUTH)
	return T

/obj/structure/machinery/cm_vending/gear/vehicle_crew/tip_over() //we don't do this here
	return

/obj/structure/machinery/cm_vending/gear/vehicle_crew/flip_back()
	return

/obj/structure/machinery/cm_vending/ex_act(severity)
	if(severity > EXPLOSION_THRESHOLD_LOW)
		if(prob(25))
			malfunction()
			return

/obj/structure/machinery/cm_vending/gear/vehicle_crew/proc/populate_products(datum/source, obj/vehicle/multitile/V)
	SIGNAL_HANDLER
	UnregisterSignal(SSdcs, COMSIG_GLOB_VEHICLE_ORDERED)

	selected_vehicle = "APC"
	available_categories &= ~(VEHICLE_ARMOR_AVAILABLE|VEHICLE_INTEGRAL_AVAILABLE) //APC lacks these, so we need to remove these flags to be able to access spare parts section

/obj/structure/machinery/cm_vending/gear/vehicle_crew/get_listed_products(mob/user)
	var/list/display_list = list()

	if(!user)
		display_list += GLOB.cm_vending_vehicle_crew_tank
		display_list += GLOB.cm_vending_vehicle_crew_tank_spare
		display_list += GLOB.cm_vending_vehicle_crew_apc
		display_list += GLOB.cm_vending_vehicle_crew_apc_spare
		return display_list

	if(selected_vehicle == "TANK")
		if(available_categories)
			display_list = GLOB.cm_vending_vehicle_crew_tank
		else
			display_list = GLOB.cm_vending_vehicle_crew_tank_spare

	else if(selected_vehicle == "APC")
		if(available_categories)
			display_list = GLOB.cm_vending_vehicle_crew_apc
		else //APC stuff costs more to prevent 4000 points spent on shitton of ammunition
			display_list = GLOB.cm_vending_vehicle_crew_apc_spare
	return display_list

/obj/structure/machinery/cm_vending/gear/vehicle_crew/ui_data(mob/user)
	. = list()
	. += ui_static_data(user)

	if(supply_controller.tank_points) //we steal points from supply_controller, meh-he-he. Solely to be able to modify amount of points in vendor if needed by just changing one var.
		available_points_to_display = supply_controller.tank_points
		supply_controller.tank_points = 0
	.["current_m_points"] = available_points_to_display

	var/list/ui_listed_products = get_listed_products(user)
	var/list/stock_values = list()
	for (var/i in 1 to length(ui_listed_products))
		var/list/myprod = ui_listed_products[i] //we take one list from listed_products
		var/prod_available = FALSE
		var/p_cost = myprod[2]
		var/avail_flag = myprod[4]
		if(budget_points >= p_cost && (!avail_flag || available_categories & avail_flag))
			prod_available = TRUE
		stock_values += list(prod_available)

	.["stock_listing"] = stock_values

/obj/structure/machinery/cm_vending/gear/vehicle_crew/handle_points(mob/living/carbon/human/H, list/L)
	. = TRUE
	if(available_categories)
		if(!(available_categories & L[4]))
			to_chat(usr, SPAN_WARNING("Module from this category is already taken."))
			vend_fail()
			return FALSE
		available_categories &= ~L[4]
	else
		if(available_points_to_display < L[2])
			to_chat(H, SPAN_WARNING("Not enough points."))
			vend_fail()
			return FALSE
		budget_points -= L[2]

/obj/structure/machinery/cm_vending/gear/vehicle_crew/get_appropriate_vend_turf(mob/living/carbon/human/H)
	var/turf/T = get_turf(src)
	T = get_step(T, SOUTH)
	return T

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_tank, list(
	list("STARTING KIT SELECTION:", 0, null, null, null),

	list("INTEGRAL PARTS", 0, null, null, null),
	list("M34A2-A Multipurpose Turret", 0, /obj/effect/essentials_set/tank/turret, VEHICLE_INTEGRAL_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("PRIMARY WEAPON", 0, null, null, null),
	list("AC3-E Autocannon", 0, /obj/effect/essentials_set/tank/autocannon, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_RECOMMENDED),
	list("DRG-N Offensive Flamer Unit", 0, /obj/effect/essentials_set/tank/dragonflamer, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("LTAA-AP Minigun", 0, /obj/effect/essentials_set/tank/gatling, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_REGULAR),

	list("SECONDARY WEAPON", 0, null, null, null),
	list("M92T Grenade Launcher", 0, /obj/effect/essentials_set/tank/tankgl, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("M56 Cupola", 0, /obj/effect/essentials_set/tank/m56cupola, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("LZR-N Flamer Unit", 0, /obj/effect/essentials_set/tank/tankflamer, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_RECOMMENDED),

	list("SUPPORT MODULE", 0, null, null, null),
	list("Artillery Module", 0, /obj/item/hardpoint/support/artillery_module, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("Integrated Weapons Sensor Array", 0, /obj/item/hardpoint/support/weapons_sensor, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("Overdrive Enhancer", 0, /obj/item/hardpoint/support/overdrive_enhancer, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_RECOMMENDED),

	list("ARMOR", 0, null, null, null),
	list("Ballistic Armor", 0, /obj/item/hardpoint/armor/ballistic, VEHICLE_ARMOR_AVAILABLE, VENDOR_ITEM_RECOMMENDED),
	list("Caustic Armor", 0, /obj/item/hardpoint/armor/caustic, VEHICLE_ARMOR_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("Concussive Armor", 0, /obj/item/hardpoint/armor/concussive, VEHICLE_ARMOR_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("Paladin Armor", 0, /obj/item/hardpoint/armor/paladin, VEHICLE_ARMOR_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("Snowplow", 0, /obj/item/hardpoint/armor/snowplow, VEHICLE_ARMOR_AVAILABLE, VENDOR_ITEM_REGULAR),

	list("TREADS", 0, null, null, null),
	list("Reinforced Treads", 0, /obj/item/hardpoint/locomotion/treads/robust, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_REGULAR),
	list("Treads", 0, /obj/item/hardpoint/locomotion/treads, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_RECOMMENDED)))

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_tank_spare, list(
	list("SPARE PARTS SELECTION:", 0, null, null, null),

	list("INTEGRAL PARTS", 0, null, null, null),
	list("M34A2-A Multipurpose Turret", 500, /obj/item/hardpoint/holder/tank_turret, null, VENDOR_ITEM_REGULAR),

	list("SUPPORT AMMUNITION", 0, null, null, null),
	list("Turret Smoke Screen Magazine", 50, /obj/item/ammo_magazine/hardpoint/turret_smoke, null, VENDOR_ITEM_REGULAR),

	list("PRIMARY WEAPON", 0, null, null, null),
	list("AC3-E Autocannon", 200, /obj/item/hardpoint/primary/autocannon, null, VENDOR_ITEM_REGULAR),
	list("DRG-N Offensive Flamer Unit", 200, /obj/item/hardpoint/primary/flamer, null, VENDOR_ITEM_REGULAR),
	list("LTAA-AP Minigun", 200, /obj/item/hardpoint/primary/minigun, null, VENDOR_ITEM_REGULAR),
	list("LTB Cannon", 400, /obj/item/hardpoint/primary/cannon, null, VENDOR_ITEM_RECOMMENDED),

	list("PRIMARY AMMUNITION", 0, null, null, null),
	list("AC3-E Autocannon Magazine", 100, /obj/item/ammo_magazine/hardpoint/ace_autocannon, null, VENDOR_ITEM_REGULAR),
	list("DRG-N Offensive Flamer Unit Fuel Tank", 100, /obj/item/ammo_magazine/hardpoint/primary_flamer, null, VENDOR_ITEM_REGULAR),
	list("LTAA-AP Minigun Magazine", 100, /obj/item/ammo_magazine/hardpoint/ltaaap_minigun, null, VENDOR_ITEM_REGULAR),
	list("LTB Cannon Magazine", 100, /obj/item/ammo_magazine/hardpoint/ltb_cannon, null, VENDOR_ITEM_REGULAR),

	list("SECONDARY WEAPON", 0, null, null, null),
	list("M92T Grenade Launcher", 200, /obj/item/hardpoint/secondary/grenade_launcher, null, VENDOR_ITEM_REGULAR),
	list("M56 Cupola", 200, /obj/item/hardpoint/secondary/m56cupola, null, VENDOR_ITEM_REGULAR),
	list("LZR-N Flamer Unit", 200, /obj/item/hardpoint/secondary/small_flamer, null, VENDOR_ITEM_REGULAR),
	list("TOW Launcher", 300, /obj/item/hardpoint/secondary/towlauncher, null, VENDOR_ITEM_REGULAR),

	list("SECONDARY AMMUNITION", 0, null, null, null),
	list("M92T Grenade Launcher Magazine", 50, /obj/item/ammo_magazine/hardpoint/tank_glauncher, null, VENDOR_ITEM_REGULAR),
	list("M56 Cupola Magazine", 50, /obj/item/ammo_magazine/hardpoint/m56_cupola, null, VENDOR_ITEM_REGULAR),
	list("LZR-N Flamer Unit Fuel Tank", 50, /obj/item/ammo_magazine/hardpoint/secondary_flamer, null, VENDOR_ITEM_REGULAR),
	list("TOW Launcher Magazine", 50, /obj/item/ammo_magazine/hardpoint/towlauncher, null, VENDOR_ITEM_REGULAR),

	list("SUPPORT MODULE", 0, null, null, null),
	list("Artillery Module", 300, /obj/item/hardpoint/support/artillery_module, null, VENDOR_ITEM_REGULAR),
	list("Integrated Weapons Sensor Array", 200, /obj/item/hardpoint/support/weapons_sensor, null, VENDOR_ITEM_REGULAR),
	list("Overdrive Enhancer", 200, /obj/item/hardpoint/support/overdrive_enhancer, null, VENDOR_ITEM_REGULAR),

	list("ARMOR", 0, null, null, null),
	list("Ballistic Armor", 300, /obj/item/hardpoint/armor/ballistic, null, VENDOR_ITEM_REGULAR),
	list("Caustic Armor", 300, /obj/item/hardpoint/armor/caustic, null, VENDOR_ITEM_REGULAR),
	list("Concussive Armor", 300, /obj/item/hardpoint/armor/concussive, null, VENDOR_ITEM_REGULAR),
	list("Paladin Armor", 300, /obj/item/hardpoint/armor/paladin, null, VENDOR_ITEM_REGULAR),
	list("Snowplow", 200, /obj/item/hardpoint/armor/snowplow, null, VENDOR_ITEM_REGULAR),

	list("TREADS", 0, null, null, null),
	list("Reinforced Treads", 200, /obj/item/hardpoint/locomotion/treads/robust, null, VENDOR_ITEM_REGULAR),
	list("Treads", 200, /obj/item/hardpoint/locomotion/treads, null, VENDOR_ITEM_REGULAR)))

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_apc, list(
	list("STARTING KIT SELECTION:", 0, null, null, null),

	list("PRIMARY WEAPON", 0, null, null, null),
	list("PARS-159 Boyars Dualcannon", 0, /obj/effect/essentials_set/apc/dualcannon, VEHICLE_PRIMARY_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("SECONDARY WEAPON", 0, null, null, null),
	list("RE-RE700 Frontal Cannon", 0, /obj/effect/essentials_set/apc/frontalcannon, VEHICLE_SECONDARY_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("SUPPORT MODULE", 0, null, null, null),
	list("M-97F Flare Launcher", 0, /obj/effect/essentials_set/apc/flarelauncher, VEHICLE_SUPPORT_AVAILABLE, VENDOR_ITEM_MANDATORY),

	list("WHEELS", 0, null, null, null),
	list("APC Wheels", 0, /obj/item/hardpoint/locomotion/apc_wheels, VEHICLE_TREADS_AVAILABLE, VENDOR_ITEM_MANDATORY)))

GLOBAL_LIST_INIT(cm_vending_vehicle_crew_apc_spare, list(
	list("SPARE PARTS SELECTION:", 0, null, null, null),

	list("PRIMARY WEAPON", 0, null, null, null),
	list("PARS-159 Boyars Dualcannon", 500, /obj/item/hardpoint/primary/dualcannon, null, VENDOR_ITEM_REGULAR),

	list("PRIMARY AMMUNITION", 0, null, null, null),
	list("PARS-159 Dualcannon Magazine", 150, /obj/item/ammo_magazine/hardpoint/ace_autocannon, null, VENDOR_ITEM_REGULAR),

	list("SECONDARY WEAPON", 0, null, null, null),
	list("RE-RE700 Frontal Cannon", 400, /obj/item/hardpoint/secondary/frontalcannon, null, VENDOR_ITEM_REGULAR),

	list("SECONDARY AMMUNITION", 0, null, null, null),
	list("RE-RE700 Frontal Cannon Magazine", 150, /obj/item/ammo_magazine/hardpoint/tank_glauncher, null, VENDOR_ITEM_REGULAR),

	list("SUPPORT MODULE", 0, null, null, null),
	list("M-97F Flare Launcher", 300, /obj/item/hardpoint/support/flare_launcher, null, VENDOR_ITEM_REGULAR),

	list("SUPPORT AMMUNITION", 0, null, null, null),
	list("M-97F Flare Launcher Magazine", 50, /obj/item/ammo_magazine/hardpoint/flare_launcher, null, VENDOR_ITEM_REGULAR),

	list("WHEELS", 0, null, null, null),
	list("APC Wheels", 200, /obj/item/hardpoint/locomotion/apc_wheels, null, VENDOR_ITEM_REGULAR)))


//------------WEAPONS RACK---------------

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vehicle_crew
	name = "\improper ColMarTech Vehicle Crewman Weapons Rack"
	desc = "An automated weapon rack hooked up to a small storage of standard-issue weapons. Can be accessed only by the Vehicle Crewmen."
	icon_state = "guns"
	req_access = list(ACCESS_MARINE_CREWMAN)
	vendor_role = list(JOB_CREWMAN)
	vend_flags = VEND_CLUTTER_PROTECTION | VEND_LIMITED_INVENTORY | VEND_TO_HAND

	listed_products = list(
		list("PRIMARY FIREARMS", -1, null, null),
		list("M4RA Battle Rifle", 2, /obj/item/weapon/gun/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M37A2 Pump Shotgun", 2, /obj/item/weapon/gun/shotgun/pump, VENDOR_ITEM_REGULAR),
		list("M39 Submachine Gun", 2, /obj/item/weapon/gun/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Pulse Rifle MK2", 2, /obj/item/weapon/gun/rifle/m41a, VENDOR_ITEM_REGULAR),

		list("PRIMARY AMMUNITION", -1, null, null),
		list("Box of Buckshot Shells (12g)", 6, /obj/item/ammo_magazine/shotgun/buckshot, VENDOR_ITEM_REGULAR),
		list("Box of Flechette Shells (12g)", 6, /obj/item/ammo_magazine/shotgun/flechette, VENDOR_ITEM_REGULAR),
		list("Box of Shotgun Slugs (12g)", 6, /obj/item/ammo_magazine/shotgun/slugs, VENDOR_ITEM_REGULAR),
		list("M4RA Magazine (10x24mm)", 12, /obj/item/ammo_magazine/rifle/m4ra, VENDOR_ITEM_REGULAR),
		list("M39 HV Magazine (10x20mm)", 12, /obj/item/ammo_magazine/smg/m39, VENDOR_ITEM_REGULAR),
		list("M41A Magazine (10x24mm)", 12, /obj/item/ammo_magazine/rifle, VENDOR_ITEM_REGULAR),

		list("SIDEARMS", -1, null, null),
		list("88 Mod 4 Combat Pistol", 2, /obj/item/weapon/gun/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Combat Revolver", 2, /obj/item/weapon/gun/revolver/m44, VENDOR_ITEM_REGULAR),
		list("M4A3 Service Pistol", 2, /obj/item/weapon/gun/pistol/m4a3, VENDOR_ITEM_REGULAR),
		list("M82F Flare Gun", 2, /obj/item/weapon/gun/flare, VENDOR_ITEM_REGULAR),

		list("SIDEARM AMMUNITION", -1, null, null),
		list("88M4 AP Magazine (9mm)", 10, /obj/item/ammo_magazine/pistol/mod88, VENDOR_ITEM_REGULAR),
		list("M44 Speedloader (.44)", 10, /obj/item/ammo_magazine/revolver, VENDOR_ITEM_REGULAR),
		list("M4A3 Magazine (9mm)", 10, /obj/item/ammo_magazine/pistol, VENDOR_ITEM_REGULAR),
		list("M4A3 AP Magazine (9mm)", 6, /obj/item/ammo_magazine/pistol/ap, VENDOR_ITEM_REGULAR),
		list("M4A3 HP Magazine (9mm)", 6, /obj/item/ammo_magazine/pistol/hp, VENDOR_ITEM_REGULAR),
		list("VP78 Magazine (9mm)", 8, /obj/item/ammo_magazine/pistol/vp78, VENDOR_ITEM_REGULAR),

		list("ATTACHMENTS", -1, null, null),
		list("Magnetic Harness", 2, /obj/item/attachable/magnetic_harness, VENDOR_ITEM_REGULAR),
		list("Rail Flashlight", 4, /obj/item/attachable/flashlight, VENDOR_ITEM_REGULAR),
		list("Underbarrel Flashlight Grip", 4, /obj/item/attachable/flashlight/grip, VENDOR_ITEM_REGULAR),

		list("UTILITIES", -1, null, null),
		list("Combat Flashlight", 2, /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("M5 Bayonet", 2, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
		list("M89-S Signal Flare Pack", 1, /obj/item/storage/box/m94/signal, VENDOR_ITEM_REGULAR),
		list("M94 Marking Flare pack", 10, /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
		list("Machete Scabbard (Full)", 2, /obj/item/storage/large_holster/machete/full, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/cargo_guns/vehicle_crew/populate_product_list(scale)
	return

//------------CLOTHING RACK---------------

GLOBAL_LIST_INIT(cm_vending_clothing_vehicle_crew, list(
		list("STANDARD EQUIPMENT (TAKE ALL)", 0, null, null, null),
		list("Gloves", 0, /obj/item/clothing/gloves/yellow, MARINE_CAN_BUY_GLOVES, VENDOR_ITEM_MANDATORY),
		list("Tanker Armor", 0, /obj/item/clothing/suit/storage/marine/tanker, MARINE_CAN_BUY_ARMOR, VENDOR_ITEM_MANDATORY),
		list("M50 Tanker Helmet", 0, /obj/item/clothing/head/helmet/marine/tech/tanker, MARINE_CAN_BUY_HELMET, VENDOR_ITEM_MANDATORY),
		list("SensorMate HUD", 0, /obj/item/clothing/glasses/hud/sensor, MARINE_CAN_BUY_GLASSES, VENDOR_ITEM_MANDATORY),
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
		list("M276 M39 Holster Rig", 0, /obj/item/storage/large_holster/m39, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M44 Holster Rig", 0, /obj/item/storage/belt/gun/m44, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 M82F Holster Rig", 0, /obj/item/storage/belt/gun/flaregun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Shotgun Shell Loading Rig", 0, /obj/item/storage/belt/shotgun, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),
		list("M276 Toolbelt Rig (Full)", 0, /obj/item/storage/belt/utility/full, MARINE_CAN_BUY_BELT, VENDOR_ITEM_REGULAR),

		list("POUCHES (CHOOSE 2)", 0, null, null, null),
		list("First-Aid Pouch (Refillable Injectors)", 0, /obj/item/storage/pouch/firstaid/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Splints, Gauze, Ointment)", 0, /obj/item/storage/pouch/firstaid/full/alternate, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("First-Aid Pouch (Pill Packets)", 0, /obj/item/storage/pouch/firstaid/full/pills, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),
		list("Flare Pouch (Full)", 0, /obj/item/storage/pouch/flare/full, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large General Pouch", 0, /obj/item/storage/pouch/general/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Magazine Pouch", 0, /obj/item/storage/pouch/magazine/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Pistol Magazine Pouch", 0, /obj/item/storage/pouch/magazine/pistol/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Large Shotgun Shell Pouch", 0, /obj/item/storage/pouch/shotgun/large, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sidearm Pouch", 0, /obj/item/storage/pouch/pistol, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Sling Pouch", 0, /obj/item/storage/pouch/sling, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_REGULAR),
		list("Tools Pouch (Full)", 0, /obj/item/storage/pouch/tools/tank, (MARINE_CAN_BUY_R_POUCH|MARINE_CAN_BUY_L_POUCH), VENDOR_ITEM_RECOMMENDED),

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

//MARINE_CAN_BUY_SHOES MARINE_CAN_BUY_UNIFORM currently not used
/obj/structure/machinery/cm_vending/clothing/vehicle_crew
	name = "\improper ColMarTech Vehicle Crewman Equipment Rack"
	desc = "An automated rack hooked up to a colossal storage of Vehicle Crewmen standard-issue equipment."
	req_access = list(ACCESS_MARINE_CREWMAN)
	vendor_role = list(JOB_CREWMAN)

/obj/structure/machinery/cm_vending/clothing/vehicle_crew/get_listed_products(mob/user)
	return GLOB.cm_vending_clothing_vehicle_crew

//------------ESSENTIAL SETS---------------

//Not essentials sets but fuck it the code's here
/obj/effect/essentials_set/tank/ltb
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
		/obj/item/ammo_magazine/hardpoint/ltb_cannon,
	)

/obj/effect/essentials_set/tank/gatling
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
		/obj/item/ammo_magazine/hardpoint/ltaaap_minigun,
	)

/obj/effect/essentials_set/tank/dragonflamer
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
		/obj/item/ammo_magazine/hardpoint/primary_flamer,
	)

/obj/effect/essentials_set/tank/autocannon
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
		/obj/item/ammo_magazine/hardpoint/ace_autocannon,
	)

/obj/effect/essentials_set/tank/tankflamer
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/small_flamer,
		/obj/item/ammo_magazine/hardpoint/secondary_flamer,
	)

/obj/effect/essentials_set/tank/tow
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
		/obj/item/ammo_magazine/hardpoint/towlauncher,
	)

/obj/effect/essentials_set/tank/m56cupola
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/m56cupola,
		/obj/item/ammo_magazine/hardpoint/m56_cupola,
	)

/obj/effect/essentials_set/tank/tankgl
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/grenade_launcher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
		/obj/item/ammo_magazine/hardpoint/tank_glauncher,
	)

/obj/effect/essentials_set/tank/turret
	spawned_gear_list = list(
		/obj/item/hardpoint/holder/tank_turret,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
		/obj/item/ammo_magazine/hardpoint/turret_smoke,
	)

/obj/effect/essentials_set/apc/dualcannon
	spawned_gear_list = list(
		/obj/item/hardpoint/primary/dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
		/obj/item/ammo_magazine/hardpoint/boyars_dualcannon,
	)

/obj/effect/essentials_set/apc/frontalcannon
	spawned_gear_list = list(
		/obj/item/hardpoint/secondary/frontalcannon,
		/obj/item/ammo_magazine/hardpoint/m56_cupola/frontal_cannon,
	)

/obj/effect/essentials_set/apc/flarelauncher
	spawned_gear_list = list(
		/obj/item/hardpoint/support/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
		/obj/item/ammo_magazine/hardpoint/flare_launcher,
	)

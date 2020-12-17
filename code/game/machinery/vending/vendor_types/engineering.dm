//------------ENGINEERING VENDORS---------------

/obj/structure/machinery/cm_vending/sorted/tech
	name = "\improper Engineering Vendor"
	desc = "You shouldn't be spawning this one."
	icon_state = "tool"
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE
	hackable = TRUE
	req_access = list(ACCESS_MARINE_ENGINEERING)
	vendor_theme = VENDOR_THEME_COMPANY


/obj/structure/machinery/cm_vending/sorted/tech/Initialize()
	. = ..()
	GLOB.cm_vending_vendors += src

/obj/structure/machinery/cm_vending/sorted/tech/Destroy()
	GLOB.cm_vending_vendors -= src
	return ..()
/obj/structure/machinery/cm_vending/sorted/tech/tool_storage
	name = "\improper Tool Storage Machine"
	desc = "A large storage machine containing various tools and devices for general repair."
	icon_state = "tool"

/obj/structure/machinery/cm_vending/sorted/tech/tool_storage/populate_product_list(var/scale)
	listed_products = list(
		list("EQUIPMENT", -1, null, null),
		list("Combat Flashlight", round(scale * 2), /obj/item/device/flashlight/combat, VENDOR_ITEM_REGULAR),
		list("Hardhat", round(scale * 2), /obj/item/clothing/head/hardhat, VENDOR_ITEM_REGULAR),
		list("Isolated Gloves", round(scale * 2), /obj/item/clothing/gloves/yellow, VENDOR_ITEM_REGULAR),
		list("Utility Tool Belt", round(scale * 2), /obj/item/storage/belt/utility, VENDOR_ITEM_REGULAR),
		list("Welding Goggles", round(scale * 2), /obj/item/clothing/glasses/welding, VENDOR_ITEM_REGULAR),
		list("Welding Helmet", round(scale * 2), /obj/item/clothing/head/welding, VENDOR_ITEM_REGULAR),

		list("SCANNERS", -1, null, null),
		list("Atmos Scanner", round(scale * 2), /obj/item/device/analyzer, VENDOR_ITEM_REGULAR),
		list("Demolitions Scanner", round(scale * 1), /obj/item/device/demo_scanner, VENDOR_ITEM_REGULAR),
		list("Meson Scanner", round(scale * 2), /obj/item/clothing/glasses/meson, VENDOR_ITEM_REGULAR),
		list("Reagent Scanner", round(scale * 2), /obj/item/device/reagent_scanner, VENDOR_ITEM_REGULAR),
		list("T-Ray Scanner", round(scale * 2), /obj/item/device/t_scanner, VENDOR_ITEM_REGULAR),

		list("TOOLS", -1, null, null),
		list("Blowtorch", round(scale * 4), /obj/item/tool/weldingtool, VENDOR_ITEM_REGULAR),
		list("Crowbar", round(scale * 4), /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("High-Capacity Industrial Blowtorch", 2, /obj/item/tool/weldingtool/hugetank, VENDOR_ITEM_REGULAR),
		list("Screwdriver", round(scale * 4), /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),
		list("Wirecutters", round(scale * 4), /obj/item/tool/wirecutters, VENDOR_ITEM_REGULAR),
		list("Wrench", round(scale * 4), /obj/item/tool/wrench, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/tech/tool_storage/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)

/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage
	name = "\improper Electronics Vendor"
	desc = "Spare tool vendor. What? Did you expect some witty description?"
	icon_state = "engivend"

/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage/populate_product_list(var/scale)
	listed_products = list(
		list("TOOLS", -1, null, null),
		list("Cable Coil", round(scale * 3), /obj/item/stack/cable_coil/random, VENDOR_ITEM_REGULAR),
		list("Multitool", round(scale * 2), /obj/item/device/multitool, VENDOR_ITEM_REGULAR),

		list("CIRCUITBOARDS", -1, null, null),
		list("Airlock Circuit Board", round(scale * 4), /obj/item/circuitboard/airlock, VENDOR_ITEM_REGULAR),
		list("APC Circuit Board", round(scale * 4), /obj/item/circuitboard/apc, VENDOR_ITEM_REGULAR),

		list("BATTERIES", -1, null, null),
		list("High-Capacity Power Cell", round(scale * 3), /obj/item/cell/high, VENDOR_ITEM_REGULAR),
		list("Low-Capacity Power Cell", round(scale * 6), /obj/item/cell, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)

/obj/structure/machinery/cm_vending/sorted/tech/comp_storage
	name = "\improper Component Storage Machine"
	desc = "A large storage machine containing various components."
	icon_state = "engi"

/obj/structure/machinery/cm_vending/sorted/tech/comp_storage/populate_product_list(var/scale)
	listed_products = list(
		list("ASSEMBLY COMPONENTS", -1, null, null),
		list("Igniter", round(scale * 8), /obj/item/device/assembly/igniter, VENDOR_ITEM_REGULAR),
		list("Timer", round(scale * 4), /obj/item/device/assembly/timer, VENDOR_ITEM_REGULAR),
		list("Proximity Sensor", round(scale * 4), /obj/item/device/assembly/prox_sensor, VENDOR_ITEM_REGULAR),
		list("Signaller", round(scale * 4), /obj/item/device/assembly/signaller, VENDOR_ITEM_REGULAR),

		list("CONTAINERS", -1, null, null),
		list("Bucket", round(scale * 6), /obj/item/reagent_container/glass/bucket, VENDOR_ITEM_REGULAR),
		list("Mop Bucket", round(scale * 2), /obj/item/reagent_container/glass/bucket/mopbucket, VENDOR_ITEM_REGULAR),

		list("STOCK PARTS", -1, null, null),
		list("Console Screen", round(scale * 4), /obj/item/stock_parts/console_screen, VENDOR_ITEM_REGULAR),
		list("Matter Bin", round(scale * 4), /obj/item/stock_parts/matter_bin, VENDOR_ITEM_REGULAR),
		list("Micro Laser", round(scale * 4), /obj/item/stock_parts/micro_laser , VENDOR_ITEM_REGULAR),
		list("Micro Manipulator", round(scale * 4), /obj/item/stock_parts/manipulator, VENDOR_ITEM_REGULAR),
		list("Scanning Module", round(scale * 4), /obj/item/stock_parts/scanning_module, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/tech/comp_storage/antag
	req_access = list(ACCESS_ILLEGAL_PIRATE)

//------COLONY-SPECIFIC VENDORS-------

/obj/structure/machinery/cm_vending/sorted/tech/science
	name = "\improper W-Y SciVend"
	desc = "Vendor containing basic equipment for your experiments."
	icon_state = "robotics"
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/cm_vending/sorted/tech/science/populate_product_list(var/scale)
	listed_products = list(
		list("EQUIPMENT", -1, null, null),
		list("Bio Hood", 2, /obj/item/clothing/head/bio_hood, VENDOR_ITEM_REGULAR),
		list("Bio Suit", 2, /obj/item/clothing/suit/bio_suit, VENDOR_ITEM_REGULAR),
		list("Scientist's Jumpsuit", 2, /obj/item/clothing/under/rank/scientist, VENDOR_ITEM_REGULAR),

		list("ASSEMBLY COMPONENTS", -1, null, null),
		list("Igniter", round(scale * 8), /obj/item/device/assembly/igniter, VENDOR_ITEM_REGULAR),
		list("Proximity Sensor", round(scale * 4), /obj/item/device/assembly/prox_sensor, VENDOR_ITEM_REGULAR),
		list("Signaller", round(scale * 4), /obj/item/device/assembly/signaller, VENDOR_ITEM_REGULAR),
		list("Tank Transfer Valve", round(scale * 4), /obj/item/device/transfer_valve, VENDOR_ITEM_REGULAR),
		list("Timer", round(scale * 4), /obj/item/device/assembly/timer, VENDOR_ITEM_REGULAR),
	)

/obj/structure/machinery/cm_vending/sorted/tech/robotics
	name = "\improper Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	req_access = list(ACCESS_MARINE_RESEARCH)

/obj/structure/machinery/cm_vending/sorted/tech/robotics/populate_product_list(var/scale)
	listed_products = list(
		list("EQUIPMENT", -1, null, null),
		list("Labcoat", 2, /obj/item/clothing/suit/storage/labcoat, VENDOR_ITEM_REGULAR),
		list("Medical Mask", 2, /obj/item/clothing/mask/breath/medical, VENDOR_ITEM_REGULAR),
		list("Roboticist's Jumpsuit", 2, /obj/item/clothing/under/rank/roboticist, VENDOR_ITEM_REGULAR),

		list("TOOLS", -1, null, null),
		list("Cable Coil", 4, /obj/item/stack/cable_coil/random, VENDOR_ITEM_REGULAR),
		list("Circular Saw", 2, /obj/item/tool/surgery/circular_saw, VENDOR_ITEM_REGULAR),
		list("Crowbar", 2, /obj/item/tool/crowbar, VENDOR_ITEM_REGULAR),
		list("Scalpel", 2, /obj/item/tool/surgery/scalpel, VENDOR_ITEM_REGULAR),
		list("Screwdriver", 2, /obj/item/tool/screwdriver, VENDOR_ITEM_REGULAR),

		list("ASSEMBLY COMPONENTS", -1, null, null),
		list("Flash", 4, /obj/item/device/flash, VENDOR_ITEM_REGULAR),
		list("High-Capacity Power Cell", 4, /obj/item/cell/high, VENDOR_ITEM_REGULAR),
		list("Proximity Sensor", 4, /obj/item/device/assembly/prox_sensor, VENDOR_ITEM_REGULAR),
		list("Signaller", 4, /obj/item/device/assembly/signaller, VENDOR_ITEM_REGULAR),

		list("MISCELLANOUS", -1, null, null),
		list("Anesthetic Tank", 2, /obj/item/tank/anesthetic, VENDOR_ITEM_REGULAR),
		list("Health Analyzer", 2, /obj/item/device/healthanalyzer, VENDOR_ITEM_REGULAR)
	)

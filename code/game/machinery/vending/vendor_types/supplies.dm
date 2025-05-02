/obj/structure/machinery/cm_vending/sorted/supplies
	name = "Supply Cabinet"
	desc = "A cabinet containing various supplies."
	icon = 'icons/obj/structures/machinery/lifeboat.dmi'
	icon_state = "supplycab"
	vend_delay = 0.3 SECONDS
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/supplies/lifeboat
	name = "Lifeboat Wall Cabinet"
	desc = "A wall-mounted emergency cabinet containing survival supplies."
	hackable = FALSE
	unacidable = TRUE
	unslashable = TRUE
	wrenchable = FALSE
	density = FALSE

	listed_products = list(

			list("FOOD AND BEVERAGE", -1, null, null),
			list("Emergency Rations", 4, /obj/item/ammo_box/magazine/misc/mre/emergency, VENDOR_ITEM_REGULAR),
			list("Water Bottle", 25, /obj/item/reagent_container/food/drinks/cans/waterbottle, VENDOR_ITEM_REGULAR),

			list("UTILITY", -1, null, null),
			list("M94 Marking Flare Pack", 5, /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
			list("M5 Bayonet", 8, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
			list("Handheld Radio", 5, /obj/item/device/radio, VENDOR_ITEM_REGULAR),
			list("deck of UNO cards", 5, /obj/item/toy/deck/uno, VENDOR_ITEM_REGULAR),

			list("CLOTHING", -1, null, null),
			list("Gas Mask", 15, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 15, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
			)

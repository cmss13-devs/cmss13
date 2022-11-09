/obj/structure/machinery/cm_vending/sorted/supplies
	name = "Supply Cabinet"
	desc = "A cabinet containing various supplies."
	icon = 'icons/obj/structures/machinery/lifeboat.dmi'
	icon_state = "supplycab"
	vend_delay = 3
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
	density = 0

	listed_products = list(

			list("FOOD AND BEVERAGE", -1, null, null),
			list("MRE", 25, /obj/item/storage/box/MRE, VENDOR_ITEM_REGULAR),
			list("Water Bottle", 25, /obj/item/reagent_container/food/drinks/cans/waterbottle, VENDOR_ITEM_REGULAR),
			list("Aspen Beer", 10, /obj/item/storage/beer_pack, VENDOR_ITEM_REGULAR),//NOTE TO SELF, LOCK THIS ALCOHOL BEHIND SHIP ESCAPE
			list("Wey-Yu Sake", 5, /obj/item/reagent_container/food/drinks/bottle/sake, VENDOR_ITEM_REGULAR),

			list("UTILITY", -1, null, null),
			list("M94 Marking Flare Pack", 5, /obj/item/storage/box/m94, VENDOR_ITEM_REGULAR),
			list("M5 Bayonet", 8, /obj/item/attachable/bayonet, VENDOR_ITEM_REGULAR),
			list("Handheld Radio", 5, /obj/item/device/radio, VENDOR_ITEM_REGULAR),

			list("CLOTHING", -1, null, null),
			list("Gas Mask", 15, /obj/item/clothing/mask/gas, VENDOR_ITEM_REGULAR),
			list("Heat Absorbent Coif", 15, /obj/item/clothing/mask/rebreather/scarf, VENDOR_ITEM_REGULAR)
			)

/obj/structure/machinery/cm_vending/sorted/supplies/vend_succesfully(var/list/L, var/mob/living/carbon/human/H, var/turf/T)
	if(stat & IN_USE)
		return

	stat |= IN_USE
	if(LAZYLEN(L))
		if(vend_delay)
			overlays += image(icon, icon_state + "_vend")
			if(vend_sound)
				playsound(loc, vend_sound, 25, 1, 2)
			sleep(vend_delay)
		var/prod_path = L[3]
		var/obj/item/IT
		IT = new prod_path(T)

		IT.add_fingerprint(usr)

		L[2]--
	else
		to_chat(H, SPAN_WARNING("ERROR: L is missing. Please report this to admins."))
		overlays += image(icon, icon_state + "_deny")
		sleep(15)
	update_icon()
	stat &= ~IN_USE
	return

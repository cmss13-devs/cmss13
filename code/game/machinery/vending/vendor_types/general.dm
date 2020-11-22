/obj/structure/machinery/cm_vending/sorted/walkman
	name = "\improper Rec-Vend"
	desc = "Contains Weston-Yamada approved recreational items, like Walkmans and Cards."
	icon_state = "walkman"
	wrenchable = TRUE
	hackable = TRUE
	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 5

	listed_products = list(
		list("WALKMAN", -1, null, null),
		list("Blue Cassette", 10, /obj/item/device/cassette_tape/pop1, VENDOR_ITEM_REGULAR),
		list("Blue Stripe Cassette", 10, /obj/item/device/cassette_tape/hiphop, VENDOR_ITEM_REGULAR),
		list("Green Cassette", 10, /obj/item/device/cassette_tape/nam, VENDOR_ITEM_REGULAR),
		list("Ocean Cassette", 10, /obj/item/device/cassette_tape/ocean, VENDOR_ITEM_REGULAR),
		list("Orange Cassette", 10, /obj/item/device/cassette_tape/pop3, VENDOR_ITEM_REGULAR),
		list("Pink Cassette", 10, /obj/item/device/cassette_tape/pop4, VENDOR_ITEM_REGULAR),
		list("Rainbow Cassette", 10, /obj/item/device/cassette_tape/pop2, VENDOR_ITEM_REGULAR),
		list("Red-Black Cassette", 10, /obj/item/device/cassette_tape/heavymetal, VENDOR_ITEM_REGULAR),
		list("Red Striped Cassette", 10, /obj/item/device/cassette_tape/hairmetal, VENDOR_ITEM_REGULAR),
		list("Rising Sun Cassette", 10, /obj/item/device/cassette_tape/indie, VENDOR_ITEM_REGULAR),
		list("Walkman", 50, /obj/item/device/walkman, VENDOR_ITEM_REGULAR),

		list("CARDS", -1, null, null),
		list("Deck of Cards", 5, /obj/item/toy/deck, VENDOR_ITEM_REGULAR),
		list("Deck of UNO Cards", 5, /obj/item/toy/deck/uno, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/walkman/stock(obj/item/item_to_stock, mob/user)
	var/list/R
	for(R in (listed_products))
		if(item_to_stock.type == R[3])
			if(istype(item_to_stock,/obj/item/device/walkman))
				var/obj/item/device/walkman/W = item_to_stock
				if(W.tape)
					to_chat(user,SPAN_WARNING("Remove the tape first!"))
					return

			if(item_to_stock.loc == user) //Inside the mob's inventory
				if(item_to_stock.flags_item & WIELDED)
					item_to_stock.unwield(user)
				user.temp_drop_inv_item(item_to_stock)

			if(isstorage(item_to_stock.loc)) //inside a storage item
				var/obj/item/storage/S = item_to_stock.loc
				S.remove_from_storage(item_to_stock, user.loc)

			qdel(item_to_stock)
			user.visible_message(SPAN_NOTICE("[user] stocks [src] with \a [R[1]]."),
			SPAN_NOTICE("You stock [src] with \a [R[1]]."))
			R[2]++
			updateUsrDialog()
			return //We found our item, no reason to go on.
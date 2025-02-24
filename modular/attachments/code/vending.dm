/obj/structure/machinery/cm_vending/sorted/attachments/populate_product_list(scale)
	. = ..()
	LAZYINSERT(listed_products, list(list("Barrel Charger", 2.5, /obj/item/attachable/heavy_barrel, VENDOR_ITEM_REGULAR)), 2)

/obj/structure/machinery/cm_vending/sorted/attachments/squad/populate_product_list(scale)
	. = ..()
	LAZYINSERT(listed_products, list(list("Barrel Charger", 0.9, /obj/item/attachable/heavy_barrel, VENDOR_ITEM_REGULAR)), 2)

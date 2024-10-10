/obj/item/clothing/shoes/marine
	var/base_icon_state

/obj/item/clothing/shoes/marine/Initialize(mapload, ...)
	base_icon_state = initial(icon_state)
	. = ..()

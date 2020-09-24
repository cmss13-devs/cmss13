////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_container/food
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	flags_atom = CAN_BE_SYRINGED
	var/filling_color = "#FFFFFF" //Used by sandwiches.

/obj/item/reagent_container/food/Initialize()
	. = ..()
	if (!pixel_x && !pixel_y)
		src.pixel_x = rand(-6.0, 6) //Randomizes postion
		src.pixel_y = rand(-6.0, 6)

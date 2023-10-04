//standart fridge

/obj/structure/closet/secure_closet/fridge
	name = "Refrigerator"
	icon = 'icons/obj/structures/machinery/kitchen.dmi'
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"

/obj/structure/closet/secure_closet/fridge/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened

// for almayer.

// Kitchen preparation room small quantity out of boxes...

// Kitchen Reserve big quantity stored in boxes

//meat surplus
/obj/structure/closet/secure_closet/fridge/meat_stock
	name = "meat"

/obj/structure/closet/secure_closet/fridge/meat_stock/Initialize()
	. = ..()
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/box/meat(src)

//fish surplus
/obj/structure/closet/secure_closet/fridge/fish_stock
	name = "fish"

/obj/structure/closet/secure_closet/fridge/fish_stock/Initialize()
	. = ..()
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/box/fish(src)

//groceries to hold milk in bulk
/obj/structure/closet/secure_closet/fridge/groceries
	name = "Groceries"

/obj/structure/closet/secure_closet/fridge/groceries/Initialize()
	. = ..()
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/box/milk(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/box/soymilk(src)
	for(var/i = 0, i < 7, i++)
		new /obj/item/storage/fancy/egg_box(src)
	new /obj/item/storage/box/enzyme(src)

//dry storage for dry food only... not a fridge
/obj/structure/closet/secure_closet/dry
	name = "dry"


/obj/structure/closet/secure_closet/dry/Initialize()
	. = ..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/storage/box/flour(src)
	new /obj/item/storage/box/sugar(src)

//standart organic storage.

/obj/structure/closet/secure_closet/fridge/organic
	name = "Organic"

/obj/structure/closet/secure_closet/fridge/organic/Initialize()
	. = ..()
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/apple(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/cabbage(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/carrot(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/mushroom/chanterelle(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/chili(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/corn(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/eggplant(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/potato(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/tomato(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/whitebeet(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/cherries(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/lime(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/lemon(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/orange(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/snacks/grown/banana(src)

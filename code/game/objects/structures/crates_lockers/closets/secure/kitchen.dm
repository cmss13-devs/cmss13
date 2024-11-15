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
	storage_capacity = 60 //give extra storage capacity so that everything can fit.

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

//standart organic storage.

/obj/structure/closet/secure_closet/fridge/organic
	name = "Organic"

/obj/structure/closet/secure_closet/fridge/organic/Initialize()
	. = ..()
	for(var/i in 1 to 2)
		new /obj/item/reagent_container/food/snacks/grown/apple(src)
		new /obj/item/reagent_container/food/snacks/grown/cabbage(src)
		new /obj/item/reagent_container/food/snacks/grown/carrot(src)
		new /obj/item/reagent_container/food/snacks/grown/mushroom/chanterelle(src)
		new /obj/item/reagent_container/food/snacks/grown/chili(src)
		new /obj/item/reagent_container/food/snacks/grown/corn(src)
		new /obj/item/reagent_container/food/snacks/grown/eggplant(src)
		new /obj/item/reagent_container/food/snacks/grown/potato(src)
		new /obj/item/reagent_container/food/snacks/grown/tomato(src)
		new /obj/item/reagent_container/food/snacks/grown/whitebeet(src)
		new /obj/item/reagent_container/food/snacks/grown/cherries(src)
		new /obj/item/reagent_container/food/snacks/grown/lime(src)
		new /obj/item/reagent_container/food/snacks/grown/lemon(src)
		new /obj/item/reagent_container/food/snacks/grown/orange(src)
		new /obj/item/reagent_container/food/snacks/grown/banana(src)

//DRy

/obj/structure/closet/secure_closet/fridge/dry
	name = "dry"

/obj/structure/closet/secure_closet/fridge/dry/Initialize()
	. = ..()
	for(var/i in 1 to 6)
		new /obj/item/reagent_container/food/snacks/flour(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_container/food/condiment/sugar(src)

//grocery

/obj/structure/closet/secure_closet/fridge/groceries
	name = "Groceries"

/obj/structure/closet/secure_closet/fridge/groceries/Initialize()
	. = ..()
	for(var/i in 1 to 2)
		new /obj/item/reagent_container/food/drinks/milk(src)
		new /obj/item/reagent_container/food/drinks/soymilk(src)
	new /obj/item/storage/fancy/egg_box(src)
	new /obj/item/reagent_container/food/condiment/enzyme(src)

// Kitchen Reserve big quantity stored in boxes

//meat surplus
/obj/structure/closet/secure_closet/fridge/meat/stock
	name = "meat"

/obj/structure/closet/secure_closet/fridge/meat/stock/Initialize()
	. = ..()
	for(var/i in 1 to 2)
		new /obj/item/storage/box/meat(src)

//fish surplus
/obj/structure/closet/secure_closet/fridge/fish/stock
	name = "fish"

/obj/structure/closet/secure_closet/fridge/fish/stock/Initialize()
	. = ..()
	for(var/i in 1 to 2)
		new /obj/item/storage/box/fish(src)

//groceries to hold milk in bulk
/obj/structure/closet/secure_closet/fridge/groceries/stock
	name = "Groceries"

/obj/structure/closet/secure_closet/fridge/groceries/stock/Initialize()
	. = ..()
	for(var/i in 1 to 2)
		new /obj/item/storage/box/milk(src)
		new /obj/item/storage/box/soymilk(src)
	for(var/i in 1 to 7)
		new /obj/item/storage/fancy/egg_box(src)
	new /obj/item/storage/box/enzyme(src)

//dry storage for dry food only... not a fridge
/obj/structure/closet/secure_closet/fridge/dry/stock
	name = "dry"

/obj/structure/closet/secure_closet/fridge/dry/stock/Initialize()
	. = ..()
	for(var/i in 1 to 4)
		new /obj/item/storage/box/flour(src)
	new /obj/item/storage/box/sugar(src)

// organic storage in bulk

/obj/structure/closet/secure_closet/fridge/organic/stock
	name = "Organic"

/obj/structure/closet/secure_closet/fridge/organic/stock/Initialize()
	. = ..()
	new /obj/item/storage/box/apple(src)
	new /obj/item/storage/box/banana(src)
	new /obj/item/storage/box/chanterelle(src)
	new /obj/item/storage/box/cherries(src)
	new /obj/item/storage/box/chili(src)
	new /obj/item/storage/box/cabbage(src)
	new /obj/item/storage/box/carrot(src)
	new /obj/item/storage/box/corn(src)
	new /obj/item/storage/box/eggplant(src)
	new /obj/item/storage/box/lemon(src)
	new /obj/item/storage/box/lime(src)
	new /obj/item/storage/box/orange(src)
	new /obj/item/storage/box/potato(src)
	new /obj/item/storage/box/tomato(src)
	new /obj/item/storage/box/whitebeet(src)

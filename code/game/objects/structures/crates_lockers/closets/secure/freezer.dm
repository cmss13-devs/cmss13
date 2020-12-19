/obj/structure/closet/secure_closet/freezer

/obj/structure/closet/secure_closet/freezer/update_icon()
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

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "Kitchen Cabinet"
	req_access = list(ACCESS_CIVILIAN_PUBLIC)

/obj/structure/closet/secure_closet/freezer/kitchen/Initialize()
	. = ..()
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_container/food/snacks/flour(src)
	new /obj/item/reagent_container/food/condiment/sugar(src)
	for(var/i = 0, i < 3, i++)
		new /obj/item/reagent_container/food/snacks/meat/monkey(src)


/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()



/obj/structure/closet/secure_closet/freezer/meat
	name = "Meat Fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"


/obj/structure/closet/secure_closet/freezer/meat/Initialize()
	. = ..()
	for(var/i = 0, i < 4, i++)
		new /obj/item/reagent_container/food/snacks/meat/monkey(src)



/obj/structure/closet/secure_closet/freezer/fridge
	name = "Refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"


/obj/structure/closet/secure_closet/freezer/fridge/Initialize()
	. = ..()
	for(var/i = 0, i < 5, i++)
		new /obj/item/reagent_container/food/drinks/milk(src)
	for(var/i = 0, i < 3, i++)
		new /obj/item/reagent_container/food/drinks/soymilk(src)
	for(var/i = 0, i < 2, i++)
		new /obj/item/storage/fancy/egg_box(src)

/obj/structure/closet/secure_closet/freezer/fridge/groceries
	name = "Groceries"

/obj/structure/closet/secure_closet/freezer/fridge/groceries/Initialize()
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

/obj/structure/closet/secure_closet/freezer/money
	name = "Freezer"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(ACCESS_CIVILIAN_PUBLIC)


/obj/structure/closet/secure_closet/freezer/money/Initialize()
	. = ..()
	for(var/i = 0, i < 3, i++)
		new /obj/item/spacecash/c1000(src)
	for(var/i = 0, i < 5, i++)
		new /obj/item/spacecash/c500(src)
	for(var/i = 0, i < 6, i++)
		new /obj/item/spacecash/c200(src)

/obj/structure/closet/secure_closet/freezer/fridge/full

/obj/structure/closet/secure_closet/freezer/fridge/full/Initialize()
	. = ..()
	for(var/i = 0, i < 2, i++)
		new /obj/item/reagent_container/food/condiment/sugar(src)
	for(var/i = 0, i < 6, i++)
		new /obj/item/reagent_container/food/snacks/flour(src)
	new /obj/item/reagent_container/food/condiment/enzyme(src)

/obj/structure/closet/secure_closet/freezer/industry
	name = "Industry Freezer"
	desc = "A powerful fine tuned freezer used to polymerize chemicals in the cold. This one is set to the perfect temperature for paraformaldehyde polymerization. The freezer must be kept closed for polymerization."
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(ACCESS_MARINE_OT)
	var/obj/structure/machinery/paraform_cooler/CU

/obj/structure/closet/secure_closet/freezer/industry/Initialize()
	CU = new /obj/structure/machinery/paraform_cooler()
	CU.freezer = src
	CU.start_processing()
	. = ..()

/obj/structure/machinery/paraform_cooler
	var/cooldown = 5
	var/list/polymerization_recipe = list("formaldehyde" = 3, "water" = 3)
	var/obj/structure/closet/secure_closet/freezer/industry/freezer

/obj/structure/machinery/paraform_cooler/process()
	if(!istype(freezer) || freezer.opened)
		return
	if(cooldown)
		cooldown--
		return
	cooldown = 5
	var/containers = 0
	for(var/obj/item/reagent_container/glass/I in freezer.contents)
		if(I.reagents.replace_with(polymerization_recipe, "paraformaldehyde", 3))
			containers++
		if(containers > 3)
			break
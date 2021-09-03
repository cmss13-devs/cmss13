/obj/item/reagent_container/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	bitesize = 3

/obj/item/reagent_container/food/snacks/meat/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 3)
	name = made_from_player + name

/obj/item/reagent_container/food/snacks/meat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/tool/kitchen/knife))
		new /obj/item/reagent_container/food/snacks/rawcutlet(src)
		new /obj/item/reagent_container/food/snacks/rawcutlet(src)
		new /obj/item/reagent_container/food/snacks/rawcutlet(src)
		to_chat(user, "You cut the meat in thin strips.")
		qdel(src)
	else
		..()

/obj/item/reagent_container/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/obj/item/reagent_container/food/snacks/meat/human
	name = "meat"
	desc = "A slab of flesh for cannibals."

/obj/item/reagent_container/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_container/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

/obj/item/reagent_container/food/snacks/meat/xenomeat
	name = "meat"
	desc = "A slab of acrid smelling meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

/obj/item/reagent_container/food/snacks/meat/xenomeat/Initialize()
	. = ..()
	reagents.add_reagent("xenoblood", 3)
	src.bitesize = 6
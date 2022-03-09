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
		var/turf/T = get_turf(src)
		new /obj/item/reagent_container/food/snacks/rawcutlet(T)
		new /obj/item/reagent_container/food/snacks/rawcutlet(T)
		new /obj/item/reagent_container/food/snacks/rawcutlet(T)
		to_chat(user, "You cut the meat in thin strips.")//this needs to be rewritten to support other types of not cutlet meat.
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

//fishable atoms meat
/obj/item/reagent_container/food/snacks/meat/fish
	name = "fish meat"
	desc = "Meat from a fish."
	icon_state = "fishmeat"
	icon = 'icons/obj/items/fishing_atoms.dmi'

/obj/item/reagent_container/food/snack/meat/fish/squid
	name = "squid meat"
	desc = "Mmm, calimari."
	icon_state = "squid_meat"
	bitesize = 3

/obj/item/reagent_container/food/snack/meat/squid/sock
	name = "sock squid meat"
	desc = "These small shelled squids aren't really technically squids. However, their meat is delicious if prepared properly."
	icon_state = "squid_sock_meat"
	bitesize = 2


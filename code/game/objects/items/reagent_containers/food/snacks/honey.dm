/obj/item/reagent_container/food/snacks/honeycomb
	name = "honeycomb"
	icon_state = "honeycomb"
	desc = "Dripping with sugary sweetness."

/obj/item/reagent_container/food/snacks/honeycomb/Initialize()
		..()

/obj/item/reagent_container/food/snacks/honeycomb/Initialize()
	..()
	reagents.add_reagent("honey",10)
	reagents.add_reagent("nutriment", 0.5)
	reagents.add_reagent("sugar", 2)
	bitesize = 2


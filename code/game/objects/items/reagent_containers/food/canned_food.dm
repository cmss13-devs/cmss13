/obj/item/reagent_container/food/drinks/cans/food
	name = "canned food"
	desc = "some food can."
	icon_state = ""
	needs_can_opener = TRUE
	crushable = FALSE
	open_sound = 'sound/effects/canopen.ogg'
	open_message = "You open the drink with an audible pop!"
	consume_sound = 'sound/items/eatfood.ogg'
	object_fluff = "can"
	has_open_icon = TRUE
	delete_on_empty = TRUE
	gulp_size = 5
	icon = 'icons/obj/items/food/drinkcans.dmi'

/obj/item/reagent_container/food/drinks/cans/food/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

/obj/item/reagent_container/food/drinks/cans/food/upp/rice
	name = "canned rice and beef"
	desc = "Canned boiled rice with bits of beef."
	icon_state = "Canned_rice"
	needs_can_opener = FALSE

/obj/item/reagent_container/food/drinks/cans/food/upp/rice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/buckwheat
	name = "canned buckwheat and pork"
	desc = "Canned buckwheat porridge with bits of pork. As they said, eat kasha, grow strong!"
	icon_state = "Canned_buckwheat"
	needs_can_opener = FALSE

/obj/item/reagent_container/food/drinks/cans/food/upp/buckwheat/Initialize()
	. = ..()
	reagents.add_reagent("buckwheat", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/pasta
	name = "canned navy pasta"
	desc = "Dish originated on a revolted Russian dreadnought, dish itself being a cooked pasta with minced meat."
	icon_state = "Canned_pasta"
	needs_can_opener = FALSE

/obj/item/reagent_container/food/drinks/cans/food/upp/pasta/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/vegetables
	name = "canned vegetables"
	desc = "An assortment of cooked and mixed corn, eggplant, tomato, garlic, onion and probably something else."
	icon_state = "Canned_vegetables"
	needs_can_opener = FALSE

/obj/item/reagent_container/food/drinks/cans/food/upp/vegetables/Initialize()
	. = ..()
	reagents.add_reagent("vegetables", 6)
	reagents.add_reagent("sodiumchloride", 2)

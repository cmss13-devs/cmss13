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
	food_interactable = TRUE
	has_open_icon = TRUE
	gulp_size = 5
	icon = 'icons/obj/items/food/drinkcans.dmi'

/obj/item/reagent_container/food/drinks/cans/food/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

/obj/item/reagent_container/food/drinks/cans/food/upp/rice
	name = "canned rice and beef"
	desc = "Contains blackberry food spread, good to combine with a sandwich."
	icon_state = "Canned_rice"

/obj/item/reagent_container/food/drinks/cans/food/upp/rice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 12)
	reagents.add_reagent("meatprotein", 2)

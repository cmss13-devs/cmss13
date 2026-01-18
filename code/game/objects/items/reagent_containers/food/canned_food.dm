/obj/item/reagent_container/food/drinks/cans/food
	name = "canned food"
	desc = "some food can."
	icon_state = ""
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/canned_food_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/canned_food_righthand.dmi'
	)
	needs_can_opener = TRUE
	crushable = FALSE
	open_sound = 'sound/items/can_opened.ogg'
	open_message = "You open the can with a metal clank!"
	consume_sound = 'sound/items/eatfood.ogg'
	object_fluff = "can"
	has_open_icon = TRUE
	delete_on_empty = TRUE

/obj/item/reagent_container/food/drinks/cans/food/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

/obj/item/reagent_container/food/drinks/cans/food/upp/meat
	name = "canned beef"
	desc = "Canned premium 100% beef. The question of, what part of cow is here exactly, is open to debate."
	icon_state = "Canned_meat"
	volume = 20

/obj/item/reagent_container/food/drinks/cans/food/upp/meat/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/stew
	name = "canned stew"
	desc = "Canned stew consisting of carrot, tomato, mushroom, meat, beans and god knows what else, makes for a great food when heated."
	icon_state = "Canned_stew"
	volume = 30

/obj/item/reagent_container/food/drinks/cans/food/upp/stew/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("tomatojuice", 5)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/speck
	name = "canned fatback"
	desc = "Canned cooked and salted pig fat, also known as speck. It is often used as a bread spread, or eaten on itself."
	icon_state = "Canned_speck"
	food_interactable = TRUE
	volume = 20

/obj/item/reagent_container/food/drinks/cans/food/upp/speck/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 5)

/obj/item/reagent_container/food/drinks/cans/food/upp/soup
	name = "canned soup"
	desc = "Canned soup consisting of beef boullion, potato, peas and god knows what else, makes for a great food when heated."
	icon_state = "Canned_stew"
	consume_sound = 'sound/items/drink.ogg'
	volume = 25

/obj/item/reagent_container/food/drinks/cans/food/upp/soup/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("meatprotein", 2)
	reagents.add_reagent("potato", 6)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/rice
	name = "canned rice and beef"
	desc = "Canned boiled rice with bits of beef."
	icon_state = "Canned_rice"
	needs_can_opener = FALSE
	volume = 10

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
	volume = 10

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
	volume = 10

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
	volume = 10

/obj/item/reagent_container/food/drinks/cans/food/upp/vegetables/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_milk
	name = "canned condensed milk"
	desc = "A milk can preserved with sugar, can be eaten on itself or added to drinks or used as an ingredient."
	icon_state = "Canned_condensed_milk"
	food_interactable = TRUE
	volume = 30

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_milk/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 15)
	reagents.add_reagent("milk", 15)

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_boiled_milk
	name = "canned boiled condensed milk"
	desc = "A caramelized boiled milk can preserved with sugar, can be eaten on itself or added to drinks or used as an ingredient."
	icon_state = "Canned_boiled_condensed_milk"
	food_interactable = TRUE
	volume = 30

/obj/item/reagent_container/food/drinks/cans/food/upp/condensed_boiled_milk/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 20)
	reagents.add_reagent("milk", 10)

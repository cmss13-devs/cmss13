//CLF

/obj/item/mre_food_packet/clf
	name = "\improper wrapped makeshift meal"
	desc = "Some home cooked or salvaged meal, you do what you must within your capabilities."
	icon_state = "clf_mealpack"
	no_packet_label = TRUE
	icon = 'icons/obj/items/food/mre_food/clf.dmi'
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/clf/meatpie,
		/obj/item/reagent_container/food/snacks/mre_food/clf/bananapie,
		/obj/item/reagent_container/food/snacks/mre_food/clf/cheesepizza,
		/obj/item/reagent_container/food/snacks/mre_food/clf/mushroompizza,
		/obj/item/reagent_container/food/snacks/mre_food/clf/vegetablepizza,
		/obj/item/reagent_container/food/snacks/mre_food/clf/meatpizza,
	)

/obj/item/reagent_container/food/snacks/mre_food/clf
	icon = 'icons/obj/items/food/mre_food/clf.dmi'

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpie
	name = "wrapped meat pie"
	icon_state = "clf_meatpie"
	desc = "A wrapped homemade minced meat pie, made with love."

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("meatprotein", 20)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/bananapie
	name = "wrapped banana pie"
	icon_state = "clf_pie"
	desc = "A wrapped homemade banana pie, sweet and creamy, made by someone with a sense of humor."

/obj/item/reagent_container/food/snacks/mre_food/clf/bananapie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("banana", 16)
	reagents.add_reagent("cream", 5)
	reagents.add_reagent("sugar", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/cheesepizza
	name = "wrapped cheese pizza"
	icon_state = "clf_cheesepizza"
	desc = "A smaller size wrapped pizza, has multiple different kinds of cheese on it."

/obj/item/reagent_container/food/snacks/mre_food/clf/cheesepizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 10)
	reagents.add_reagent("cheese", 16)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/mushroompizza
	name = "wrapped mushroom pizza"
	icon_state = "clf_mushroompizza"
	desc = "A smaller size wrapped pizza, made with creamy sauce and some mushroom slices."

/obj/item/reagent_container/food/snacks/mre_food/clf/mushroompizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("mushroom", 14)
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/vegetablepizza
	name = "wrapped vegetable pizza"
	icon_state = "clf_vegetablepizza"
	desc = "A smaller size wrapped pizza, vegeterian friendly, has some cheese on it tho."

/obj/item/reagent_container/food/snacks/mre_food/clf/vegetablepizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("vegetable", 14)
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpizza
	name = "wrapped meat pizza"
	icon_state = "clf_meatpizza"
	desc = "A smaller size wrapped pizza, has some slices of beef and bacon on it."

/obj/item/reagent_container/food/snacks/mre_food/clf/meatpizza/Initialize()
	. = ..()
	reagents.add_reagent("bread", 8)
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("tomatojuice", 6)
	reagents.add_reagent("sodiumchloride", 4)

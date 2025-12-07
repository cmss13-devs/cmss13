//TWE

/obj/item/mre_food_packet/twe
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = null

/obj/item/reagent_container/food/snacks/mre_food/twe
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/twe
	name = "\improper ORP main dish"
	desc = "An Operation Ration Pack entree component. Contains a luxurious well prepared main course based on TWE cuisines, preserved using high-tech methods."
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "twe_entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/bacon,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/tomatobeans,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnrice,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/ricenoodles,
		/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnchips,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/bacon
	name = "bacon"
	icon_state = "bacon"
	desc = "Yet another classic part of the British breakfast, bacon, fried to a crisp, goes well with a toast."

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/bacon/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/tomatobeans
	name = "tomato beans"
	icon_state = "tomato beans"
	desc = "Classic part of the British breakfast, baked beans in tomato sauce, goes well with a toast."

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/tomatobeans/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 14)
	reagents.add_reagent("tomatojuice", 8)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnrice
	name = "fish n rice"
	icon_state = "fish n rice"
	desc = "A dish born in Japan, initially made by the Commonwealth sailors suffering from lack of potatoes in Asian parts of the Empire, they figured out they could use rice for that instead."

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnrice/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/ricenoodles
	name = "rice ramen"
	icon_state = "rice noodles"
	desc = "A Japanese style rice noodle ramen, has a fair share of hot sauce to it, has some subtle bits of carrot and green onions."

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/ricenoodles/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("capsaicin", 4)
	reagents.add_reagent("hotsauce", 4)

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnchips
	name = "fish n chips"
	icon_state = "fish n chips"
	desc = "A British classic, stripes of fish covered in bread crumbs and fried, has a bit of a crunch to it, hands are all greasy after it."

/obj/item/reagent_container/food/snacks/mre_food/twe/entree/fishnchips/Initialize()
	. = ..()
	reagents.add_reagent("fish", 5)
	reagents.add_reagent("vegetable", 5)
	reagents.add_reagent("potato", 3)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 2)

///SIDE

/obj/item/mre_food_packet/twe/side
	name = "\improper ORP side dish"
	desc = "An Operation Ration Pack side component. Contains a side, to be eaten alongside the main."
	icon_state = "twe_side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/bean_stew,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/mushroom_soup,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty
	name = "chickpeas patty"
	icon_state = "nut patty"
	desc = "Vegeterian patte from from chickpeas, covered in bread crumbs and fried, reminds you of fish sticks for some reason."

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nutpatty/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/mushroom_soup
	name = "mushroom soup"
	icon_state = "mushroom_soup"
	desc = "Very nourishing soup with vegetables and a mushroom flavor, will keep you warm for a long time if heated."

/obj/item/reagent_container/food/snacks/mre_food/twe/side/mushroom_soup/Initialize()
	. = ..()
	reagents.add_reagent("mushroom", 3)
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/bean_stew
	name = "beans stew"
	icon_state = "bean_soup"
	desc = "Very nourishing bean stew with a tomato sauce, will keep you warm for a long time if heated."

/obj/item/reagent_container/food/snacks/mre_food/twe/side/bean_stew/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("water", 2)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi
	name = "nigiri sushi"
	icon_state = "nigiri sushi"
	desc = "A salmon slice on a ball of boiled rice, wrapped in a stripe of seaweed, melts in mouth."

/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 3)
	reagents.add_reagent("rice", 2)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("soysauce", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips
	name = "tomato chips"
	icon_state = "tomato chips"
	desc = "Very crisp, with a hint of basil, goes well with beer."

/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

///SNACK

/obj/item/mre_food_packet/twe/snack
	name = "\improper ORP snack"
	desc = "An ORP snack component. Contains a light snack in case you weren't feeling terribly hungry."
	icon_state = "twe_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/snack/cheese,
		/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond
	name = "almonds"
	icon_state = "almond"
	desc = "Oven dried almonds, rich in vitamins, flavor, has a nice crunch, the luxury you needed all along."

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/cheese
	name = "dehydrated cheese chunk"
	icon_state = "cheese"
	desc = "Freeze dried chunk of cheddar, very dry but has a concentrated flavor, makes a good snack."

/obj/item/reagent_container/food/snacks/mre_food/twe/snack/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/twe/dessert
	name = "\improper ORP dessert"
	desc = "An Operatipn Ration Pack side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "twe_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/chocobar,
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinyapplepie,
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinycheesecake,
		/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinypancakes,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/chocobar
	name = "dark chocolate bar"
	icon_state = "tiny chocolate bar"
	desc = "56% coco true dark chocolate, rich in flavor, classic, combines well with hot drinks."

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/chocobar/Initialize()
	. = ..()
	reagents.add_reagent("coco", 8)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinyapplepie
	name = "tiny applepie"
	icon_state = "tiny applepie"
	desc = "Has some juice apple slices with a cinnamon flavor."

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinyapplepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinycheesecake
	name = "tiny cheesecake"
	icon_state = "tiny cheesecake"
	desc = "Very airy and sugary cheesy, has a tasty vanilla cake base."

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinycheesecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("milk", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinypancakes
	name = "tiny pancakes"
	icon_state = "tiny pancakes"
	desc = "Buttery cupcakes with a honey topping."

/obj/item/reagent_container/food/snacks/mre_food/twe/dessert/tinypancakes/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("honey", 2)
	reagents.add_reagent("sugar", 1)

///PASTE TUBE

/obj/item/reagent_container/food/drinks/cans/tube
	name = "nutrient tube"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "paste1"
	desc = "Space food."
	open_sound = 'sound/effects/pillbottle.ogg'
	open_message = "You remove cap from the tube."
	volume = 15
	food_interactable = TRUE
	possible_transfer_amounts = list(1, 2, 3, 5)
	crushable = FALSE
	gulp_size = 5
	object_fluff = "tube"
	var/flavor = "paste_vegemite"

/obj/item/reagent_container/food/drinks/cans/tube/attack_self(mob/user)
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/tube/Initialize()
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/tube/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/tube/update_icon()
	overlays.Cut()
	if(open && reagents.total_volume)
		overlays += mutable_appearance(icon, flavor)

	if(!open)
		overlays += mutable_appearance(icon, "paste_cap")

	var/percent = floor((reagents.total_volume / volume) * 100)
	if(reagents && reagents.total_volume)
		switch(percent)
			if(1 to 32)
				icon_state = "paste3"
			if(33 to 65)
				icon_state = "paste2"
			if(66 to INFINITY)
				icon_state = "paste1"
	else
		icon_state = "paste3"

/obj/item/reagent_container/food/drinks/cans/tube/vegemite
	name = "ORP spread tube (vegemite)"
	desc = "Contains a very salty food spread, good to combine with a sandwich, however, not everyone is fond of the taste and looks of it."

/obj/item/reagent_container/food/drinks/cans/tube/vegemite/Initialize()
	. = ..()
	reagents.add_reagent("vegemite", 20)

/obj/item/reagent_container/food/drinks/cans/tube/strawberry
	name = "ORP spread tube (strawberry)"
	desc = "Contains strawberry food spread, good to combine with a sandwich."
	flavor = "paste_strawberry"

/obj/item/reagent_container/food/drinks/cans/tube/strawberry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 15)
	reagents.add_reagent("sugar", 5)

/obj/item/reagent_container/food/drinks/cans/tube/blackberry
	name = "ORP spread tube (blackberry)"
	desc = "Contains blackberry food spread, good to combine with a sandwich."
	flavor = "paste_blackberry"

/obj/item/reagent_container/food/drinks/cans/tube/blackberry/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 15)
	reagents.add_reagent("sugar", 5)

///LEMON DROP CANDY

/obj/item/reagent_container/food/snacks/lemondrop
	name = "Lemon Drop candy"
	desc = "A sugar coated, lemon flavored sweet and sour hard candy popular in TWE, with candy itself originating in England."
	icon_state = "lemondrop"
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	filling_color = "#e3f218"

/obj/item/reagent_container/food/snacks/lemondrop/Initialize()
	. = ..()
	reagents.add_reagent("lemonjuice", 3)
	reagents.add_reagent("sugar", 1)

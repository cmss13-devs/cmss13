//UPP

/obj/item/mre_food_packet/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'
	icon_state = null

/obj/item/reagent_container/food/snacks/mre_food/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

///SNACK

/obj/item/mre_food_packet/upp/snack
	name = "\improper IRP snack"
	desc = "An IRP snack, some nutritious snack to be eaten in a breaktime or combined with a main dish."
	icon_state = "upp_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish,
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish/alt,
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/mashed_potato,
		/obj/item/reagent_container/food/snacks/mre_food/upp/snack/riceball,
	)

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish
	name = "dried cod slice"
	icon_state = "driedfish"
	desc = "A dried and salted slice of cod, perfect snack for a sip of cold beer."

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/driedfish/alt
	name = "dried taran"
	icon_state = "driedfish_2"
	desc = "A dried and salted whole rutilus heckelii fish, perfect snack for a sip of cold beer."

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/mashed_potato
	name = "mashed potatoes"
	icon_state = "mashed potatoes"
	desc = "Really soft and gentle garnish, small portion intended to be combined with something else."

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/mashed_potato/Initialize()
	. = ..()
	reagents.add_reagent("potato", 4)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/riceball
	name = "rice ball"
	icon_state = "riceball"
	desc = "Cooked rice in a form of a ball, has a slighly buttery taste, doesn't fall apart, surprisingly."

/obj/item/reagent_container/food/snacks/mre_food/upp/snack/riceball/Initialize()
	. = ..()
	reagents.add_reagent("rice", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/upp/dessert
	name = "\improper IRP dessert"
	desc = "An IRP side component. Contains a sweet dessert, to be eaten with tea or any other hot drink."
	icon_state = "upp_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/birdmilk,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/toffees,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/hematogen,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/darkchocolate,
		/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/ricecandy,
	)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/birdmilk
	name = "bird milk"
	icon_state = "bird milk"
	desc = "Bird milk or also known as ptasie mleczko, is a popular candy in Slavic parts of Eastern Europe, a small bar of creamy marshmallow like candy covered in a layer of chocolate."

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/birdmilk/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 4)
	reagents.add_reagent("cream", 3)
	reagents.add_reagent("coco", 3)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/toffees
	name = "toffees"
	icon_state = "toffees"
	desc = "A hard candy made out of condensed milk and sugar, caramelized together."

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/toffees/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 6)
	reagents.add_reagent("milk", 4)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/hematogen
	name = "hematogen bar"
	icon_state = "hematogen"
	desc = "A bar of candy, origin of which tracks back to Soviet Union times. The bar is claimed to have blood regenerating and blood circulation improving properties, the bar itself is made out of: cow blood, condensed milk, honey and ascorbic acid."

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/hematogen/Initialize()
	. = ..()
	reagents.add_reagent("iron", 8)
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("blood", 4)
	reagents.add_reagent("milk", 4)
	reagents.add_reagent("honey", 3)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/darkchocolate
	name = "dark chocolate bar"
	icon_state = "dark chocolate"
	desc = "56% coco true dark chocolate, rich in flavor, classic, combines well with hot drinks and other snacks."

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/darkchocolate/Initialize()
	. = ..()
	reagents.add_reagent("coco", 8)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/ricecandy
	name = "chocolate rice candies"
	icon_state = "rice candies"
	desc = "An assortment of rice candies covered in white chocolate, smooth on the outside, crunchy on the inside."

/obj/item/reagent_container/food/snacks/mre_food/upp/dessert/ricecandy/Initialize()
	. = ..()
	reagents.add_reagent("coco", 4)
	reagents.add_reagent("rice", 2)

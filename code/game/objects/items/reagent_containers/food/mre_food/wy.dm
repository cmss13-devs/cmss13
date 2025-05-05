//WY

/obj/item/mre_food_packet/wy
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = null

/obj/item/reagent_container/food/snacks/mre_food/wy
	icon = 'icons/obj/items/food/mre_food/wy.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/wy
	name = "\improper CFR main dish"
	desc = "An CFR entree component. Contains a luxurious well prepared main course, preserved using high-tech methods."
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "pmc_entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/bakedfish,
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/smokyribs,
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/ham,
		/obj/item/reagent_container/food/snacks/mre_food/wy/entree/beefstake,
	)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/bakedfish
	name = "baked salmon"
	icon_state = "baked fish"
	desc = "A creamy baked wild salmon, contains just the right amount of vitamin D3 you might need for the next four days."

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/bakedfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 14)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/smokyribs
	name = "smoky ribs"
	icon_state = "smoky ribs"
	desc = "A well smoked beef ribs, in a black pepper and apple sauce, very juicy and chewy."

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/smokyribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 13)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("fruit", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/ham
	name = "baked ham"
	icon_state = "ham"
	desc = "Medium-rare baked ham, with a peppery outer layer, moist and rich in flavor."

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/ham/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("blood", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/beefstake
	name = "beefsteak"
	icon_state = "beefstake"
	desc = "Medium-well steak, finished with an orange juice sauce and thyme."

/obj/item/reagent_container/food/snacks/mre_food/wy/entree/beefstake/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("orangejuice", 3)
	reagents.add_reagent("sodiumchloride", 1)

///SIDE

/obj/item/mre_food_packet/wy/side
	name = "\improper CFR side dish"
	desc = "An CFR side component. Contains a side, to be eaten alongside the main."
	icon_state = "pmc_side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/nigirisushi,
		/obj/item/reagent_container/food/snacks/mre_food/twe/side/tomatochips,
	)

///SNACK

/obj/item/mre_food_packet/wy/snack
	name = "\improper CFR snack"
	desc = "An CFR side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "pmc_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe/snack/almond,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels,
	)

///DESSERT

/obj/item/mre_food_packet/wy/dessert
	name = "\improper CFR dessert"
	desc = "An CFR side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "pmc_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/eclair,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/strawberrycake,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/cherrypie,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/croissant,
		/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/whitecoco,
	)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/eclair
	name = "eclair"
	icon_state = "eclair"
	desc = "A gentle pastry, filled with an airy vanilla flavored cream, iced with a layer of chocolate on the top."

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/eclair/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("coco", 1)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/strawberrycake
	name = "strawberry cake"
	icon_state = "strawberry cake"
	desc = "Light vanilla cake, with a thick layer of strawberry icing and a strawberry filling inside."

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/strawberrycake/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/cherrypie
	name = "cherry pie"
	icon_state = "cherry pie"
	desc = "A pie with a crisp outer crust and a soft cherry jelly filling."

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/cherrypie/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/croissant
	name = "chocolate croissant"
	icon_state = "croissant"
	desc = "A crisp croissant with dark chocolate filling."

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/croissant/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/whitecoco
	name = "white chocolate bar"
	icon_state = "white chocolate bar"
	desc = "A white chocolate bar, with bits of almonds and coconut. Don't let the heretics call it a false chocolate, you are the one enjoying it here."

/obj/item/reagent_container/food/snacks/mre_food/wy/dessert/whitecoco/Initialize()
	. = ..()
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("nuts", 2)
	reagents.add_reagent("coconutmilk", 2)
	reagents.add_reagent("sugar", 1)

//WY GENERAL RATION

/obj/item/mre_food_packet/entree/wy_colonist
	name = "\improper W-Y brand ration main dish"
	desc = "Probably the most edible component of it, contains main nutrition contents."
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "wy_main"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast,
	)

//WY EMERGENCY RATION

/obj/item/mre_food_packet/wy/cookie_brick
	name = "emergency food packet (cookie briquette)"
	desc = "A brick of a cookie, designed to be stored for prolonged periods of time, in extreme conditions, but still tastes like a compressed buttery cookie."
	icon_state = "cookie_brick"
	no_packet_label = TRUE
	food_list = list(/obj/item/reagent_container/food/snacks/mre_food/wy_emergency_cookie)

/obj/item/reagent_container/food/snacks/mre_food/wy_emergency_cookie
	name = "\improper W-Y brand emergency nutrition briquette"
	desc = "A brick of a cookie, designed to be stored for prolonged periods of time, in extreme conditions, but still tastes like a compressed buttery cookie."
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "cookie_brick_open"

/obj/item/reagent_container/food/snacks/mre_food/wy_emergency_cookie/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 12)
	reagents.add_reagent("bread", 12)
	reagents.add_reagent("sugar", 4)

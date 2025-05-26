//USCM

/obj/item/mre_food_packet/uscm
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/uscm
	name = "\improper MRE main dish"
	desc = "An MRE entree component. Contains the main course for nutrients."
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs
	name = "boneless pork ribs"
	icon_state = "boneless pork ribs"
	desc = "You can't even taste processed meat taste under all those spices!"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken
	name = "grilled chicken"
	icon_state = "grilled chicken"
	desc = "Doesn't actually tastes like grilled one, but do you really expect that luxury here?"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare
	name = "pizza square"
	icon_state = "pizza square"
	desc = "An American classic, been added and removed from the menu about 27 times at this point, still loved despite being cheap parody of a real thing."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("meatprotein", 3)
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("vegetable", 2)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare
	name = "pepperoni pizza square"
	icon_state = "pepperoni square"
	desc = "A newer addition to the timeless MRE classic, very similar."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pepperonisquare/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender
	name = "chicken tender"
	icon_state = "chicken tender"
	desc = "Really tasty and has nice crumbs texture, but makes you wish for some good chicken wings..."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast
	name = "grilled chicken breast"
	icon_state = "grilled chicken breast"
	desc = "Very plain grilled chicken meat, simple but yet very classic taste."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks
	name = "meat spaghetti"
	icon_state = "spaghetti chunks"
	desc = "Spaghetti with some cooked meat chunks, all covered in a tomato sauce."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 8)
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne
	name = "chili con carne"
	icon_state = "chili con carne"
	desc = "Spicy minced meat dish, there is no limit on adding chili in there, having some milk in near proximity is recommended."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("hotsauce", 6)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup
	name = "noodle soup"
	icon_state = "noodle soup"
	desc = "Very nourishing noodle soup with vegetables and a chicken flavor, will keep you warm for a long time if heated."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 9)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("meatprotein", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada
	name = "feijoada"
	icon_state = "brazilian-style feijoada"
	desc = "A Brazillian dish filled with black beans, different kinds of meat, vegetables and spices, very nourishing and rich in flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada/Initialize()
	. = ..()
	reagents.add_reagent("vegetable", 7)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("plantmatter", 2)

///SIDE

/obj/item/mre_food_packet/uscm/side
	name = "\improper MRE side dish"
	desc = "An MRE side component. Contains a side, to be eaten alongside the main."
	icon_state = "side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker
	name = "cracker"
	icon_state = "cracker"
	desc = "Crumbs easily but it's the most satisfying part."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes
	name = "mashed potatoes"
	icon_state = "mashed potatoes"
	desc = "Really soft and gentle, goes well with a main dish."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes/Initialize()
	. = ..()
	reagents.add_reagent("potato", 6)
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto
	name = "risotto"
	icon_state = "risotto"
	desc = "A bit more exotic, but Italian cuisine never dissapoints."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("rice", 4)
	reagents.add_reagent("cornoil", 1)
	reagents.add_reagent("vegetable", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri
	name = "rice onigiri"
	icon_state = "rice onigiri"
	desc = "Cooked rice in a form of a triangle, covered in a seaweed at the bottom, doesn't fall apart, surprisingly."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri/Initialize()
	. = ..()
	reagents.add_reagent("rice", 5)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread
	name = "cornbread"
	icon_state = "cornbread"
	desc = "Almost universally hated, very dry and simple taste of it really gets old fast. Requisitions probably has ass-load of it in the back. Nobody eats that shit."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale
	name = "marinated kale"
	icon_state = "kale"
	desc = "A sort of cabbage, marinated in spices, still has a lot of moist and crunch to it."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 6)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas
	name = "tortillas"
	icon_state = "tortillas"
	desc = "A kind of flat bread, goes well with adding other things onto it."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits
	name = "biscuits"
	icon_state = "biscuits"
	desc = "An assortment of biscuits, go well with adding other things onto them."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)


/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices
	name = "cinnamon apple slices"
	icon_state = "cinnamon apple slices"
	desc = "A bit gooey pieces of apple in cinnamon sauce, a bit sticky but tasty."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice
	name = "boiled rice"
	icon_state = "rice"
	desc = "A packet of plain boiled rice, a bit boring but would go well with additives."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)

///SNACK

/obj/item/mre_food_packet/uscm/snack
	name = "\improper MRE snack"
	desc = "An MRE snack component. Contains a light snack in case you weren't feeling terribly hungry."
	icon_state = "snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit
	name = "biscuit"
	icon_state = "biscuit"
	desc = "Reminds you of a cracker, but has a lot more different grains in it, which gives it more unique texture and flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs
	name = "meatballs"
	icon_state = "meatballs"
	desc = "You can even taste muscle fibers, despite it being a cooked minced meat."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels
	name = "pretzels"
	icon_state = "pretzels"
	desc = "Really salty and crunchy, thirst provoking."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi
	name = "sushi"
	icon_state = "sushi"
	desc = "You kinda highly doubt that raw fish wouldn't go bad in here, it barely smells like one... is it even fish?..."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("soysauce", 2)
	reagents.add_reagent("soymilk", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts
	name = "peanuts"
	icon_state = "peanuts"
	desc = "Some crunchy salted peanuts, easy to get addicted to."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/uscm/dessert
	name = "\improper MRE dessert"
	desc = "An MRE side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan,
		/obj/item/reagent_container/food/snacks/cookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro,
		/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples
	name = "spiced apples"
	icon_state = "spiced apples"
	desc = "A bit dry pieces of apple in cinnamon spice, makes your mouth water, but still tasty."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie
	name = "chocolate brownie"
	icon_state = "chocolate brownie"
	desc = "Coco filled cake base with a chocolate frosting on top, has a deep chocolate flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("sprinkles", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie
	name = "sugar cookie"
	icon_state = "sugar cookie"
	desc = "Baked cookie frosted with a caramelized sugar."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("bread", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar
	name = "coco bar"
	icon_state = "coco bar"
	desc = "Good old milk chocolate bar, goes well with hot drinks."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/cocobar/Initialize()
	. = ..()
	reagents.add_reagent("coco", 5)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan
	name = "flan"
	icon_state = "flan"
	desc = "A soft milky biscuit pie."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan/Initialize()
	. = ..()
	reagents.add_reagent("milk", 1)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan
	name = "honey flan"
	icon_state = "honey flan"
	desc = "A soft milky biscuit pie, covered in honey topping."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie
	name = "lemon pie"
	icon_state = "lemon pie"
	desc = "A creamy pie with a milky lemon filling and a thick crust."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("lemonjuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie
	name = "key lime pie"
	icon_state = "key lime pie"
	desc = "A creamy pie with a milky lime filling and a thick crust."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/limepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("limejuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro
	name = "brigadeiro balls"
	icon_state = "brigadeiro balls"
	desc = "A traditional Brazillian dessert, made out of condensed milk, cocoa and butter, very soft and sugary in taste."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro/Initialize()
	. = ..()
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("coco", 4)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster
	name = "strawberry toaster pastry"
	icon_state = "strawberry toaster pastry"
	desc = "A crunchy biscuit with a strawberry jam inside it, with a frosting on top."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("berryjuice", 3)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sprinkles", 2)
	reagents.add_reagent("egg", 1)

///SPREAD

/obj/item/reagent_container/food/drinks/cans/spread
	name = "spread packet (cheese)"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "spread"
	desc = "A creamy and cheesy spread, made out of a processed cheese, combines well with tortillas and other snacks."
	open_sound = "rip"
	open_message = "You pull open the package of the spread!"
	volume = 6
	var/flavor = "cheese spread"
	food_interactable = TRUE
	possible_transfer_amounts = list(1, 2, 3, 5)
	crushable = FALSE
	gulp_size = 5
	object_fluff = "packet"

/obj/item/reagent_container/food/drinks/cans/spread/update_icon()
	overlays.Cut()
	if(open)
		icon_state = "spread_open"
		if(reagents.total_volume)
			overlays += mutable_appearance(icon, flavor)

/obj/item/reagent_container/food/drinks/cans/spread/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/reagent_container/food/drinks/cans/spread/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/drinks/cans/spread/jalapeno
	name = "spread packet (jalapeno cheese)"
	desc = "A creamy and cheesy spread, made out of a processed cheese, combines well with tortillas and other snacks, this one has a spicy jalapeno flavor."
	flavor = "jalapeno cheese spread"

/obj/item/reagent_container/food/drinks/cans/spread/jalapeno/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_container/food/drinks/cans/spread/peanut_butter
	name = "spread packet (peanut butter)"
	desc = "A creamy and nutty spread, made out of a processed peanuts, combines well with tortillas and other snacks."
	flavor = "peanut butter"

/obj/item/reagent_container/food/drinks/cans/spread/peanut_butter/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 2)

///BEVERAGE DRINKS

/obj/item/reagent_container/food/drinks/beverage_drink
	name = "beverage powder packet"
	desc = "A packet of a beverage, to be mixed with water, makes a ready-in-a-field drink."
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "beverage"
	volume = 20

/obj/item/reagent_container/food/drinks/beverage_drink/grape
	name = "electrolyte beverage powder packet (grape)"
	desc = "A packet of an electrolyte beverage, to be mixed with water, makes a ready-in-a-field drink. Has a grape flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/grape/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_grape_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/orange
	name = "electrolyte beverage powder packet (orange)"
	desc = "A packet of an electrolyte beverage, to be mixed with water, makes a ready-in-a-field drink. Has a citrusy orange flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/orange/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_orange_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime
	name = "electrolyte beverage powder packet (lemon-lime)"
	desc = "A packet of an electrolyte beverage, to be mixed with water, makes a ready-in-a-field drink. Has a citrusy lemon-lime flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_lemonlime_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate
	name = "protein drink beverage powder packet (milk chocolate)"
	desc = "A packet of a protein drink, to be mixed with water, makes a ready-in-a-field drink. Has a chocolate flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate/Initialize()
	. = ..()
	reagents.add_reagent("chocolate_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut
	name = "protein drink beverage powder packet (chocolate hazelnut)"
	desc = "A packet of a protein drink, to be mixed with water, makes a ready-in-a-field drink. Has a chocolate hazelnut flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut/Initialize()
	. = ..()
	reagents.add_reagent("hazelnut_beverage", 4)

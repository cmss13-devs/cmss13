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
	desc = "You can't even taste the processed meat protein under all those spices!"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/porkribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken
	name = "grilled chicken"
	icon_state = "grilled chicken"
	desc = "Doesn't actually taste like grilled chicken, but did you really expect that luxury here?"

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchicken/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/pizzasquare
	name = "pizza square"
	icon_state = "pizza square"
	desc = "An American classic that's been added and removed from the menu about 27 times. Still loved despite being a cheap parody of the real thing."

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
	desc = "A newer addition to the standard MRE. Like the ordinary pizza square, its texture is that of a piece of greased cardboard. However, this one has some overly spiced circles of imitation pepperoni."

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
	desc = "Surprisingly tasty, but mostly succeeds in making you want the real thing."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chickentender/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast
	name = "grilled chicken breast"
	icon_state = "grilled chicken breast"
	desc = "Doesn't actually taste like grilled chicken, but if you're fine with bland food and don't mind the chewy texture, it's not that bad."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/grilledchickenbreast/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks
	name = "meat spaghetti"
	icon_state = "spaghetti chunks"
	desc = "Limp, rubbery noodles with some cooked meat chunks, all covered in a tomato sauce. It's unpleasantly cold and somewhat slimy. Might be more appetizing if you heated it up, but you don't have the time for that."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/spaghettichunks/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 8)
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/chiliconcarne
	name = "chili con carne"
	icon_state = "chili con carne"
	desc = "An incredibly spicy minced meat dish. There's probably more chili powder than meat in here. Having some milk in close proximity is recommended."

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
	desc = "A watery noodle soup with vegetables, a chicken flavor, and some nutrient powder to round out the meal. Will keep you warm for a long time if heated."

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/noodlesoup/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 9)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("meatprotein", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/entree/feijoada
	name = "feijoada"
	icon_state = "brazilian-style feijoada"
	desc = "A Brazillian dish filled with black beans, different kinds of meat, vegetables and spices. Rich in flavor and very filling."

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
	desc = "Crumbles easily. You'll never quite get the crumbs out of your uniform."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cracker/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes
	name = "mashed potatoes"
	icon_state = "mashed potatoes"
	desc = "Great for someone with a busted jaw, and fans of room temperature puree."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/mashedpotatoes/Initialize()
	. = ..()
	reagents.add_reagent("potato", 6)
	reagents.add_reagent("vegetable", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto
	name = "risotto"
	icon_state = "risotto"
	desc = "A bit more exotic, but Italian cuisine never disappoints. Budget imitation Italian made with a shelf life of 3-5 years, however, often does."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/risotto/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("rice", 4)
	reagents.add_reagent("cornoil", 1)
	reagents.add_reagent("vegetable", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri
	name = "rice onigiri"
	icon_state = "rice onigiri"
	desc = "Cooked rice in the form of a triangle with a seaweed wrap at the bottom. Well... you think it might be seaweed."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/onigiri/Initialize()
	. = ..()
	reagents.add_reagent("rice", 5)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread
	name = "cornbread"
	icon_state = "cornbread"
	desc = "Universally hated for being incredibly dry and tasting like uncooked flour. Requisitions probably has an ass-load of it in the back. Nobody eats that shit."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cornbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale
	name = "marinated kale"
	icon_state = "kale"
	desc = "Dried plant covered in spices. Kale can be a hard sell even when it's not military grade."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/kale/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 6)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas
	name = "tortillas"
	icon_state = "tortillas"
	desc = "Added to the MRE with the idea of wrapping your entree in it. This idea literally falls apart when you get a spaghetti square."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/tortillas/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits
	name = "biscuits"
	icon_state = "biscuits"
	desc = "An assortment of biscuits. Always hard and somewhat stale, but goes well with other things."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/biscuits/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)


/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices
	name = "cinnamon apple slices"
	icon_state = "cinnamon apple slices"
	desc = "Gooey pieces of apple in a cinnamon sauce. Noteable for being sweet and even somewhat delicious, but also terribly sticky. Wash your hands after eating, or your gun will be horribly tacky for a year."

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/cinnamonappleslices/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/side/boiledrice
	name = "boiled rice"
	icon_state = "rice"
	desc = "A packet of plain boiled rice. Bland and boring, but would go well with additives."

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
	desc = "Reminds you of a cracker, but this one's whole grain. Purportedly part of a USCM health initiative, it has a unique texture and flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/biscuit/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs
	name = "meatballs"
	icon_state = "meatballs"
	desc = "Despite being a ball of cooked, minced meat, you can still taste the gristle."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/meatballs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels
	name = "pretzels"
	icon_state = "pretzels"
	desc = "Salty and crunchy, these pretzels will have you parched in no time."

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/pretzels/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi
	name = "sushi"
	icon_state = "sushi"
	desc = "You highly doubt that raw fish wouldn't go bad in here. It barely smells like the real thing... is this even fish?"

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/sushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("soysauce", 2)
	reagents.add_reagent("soymilk", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/snack/peanuts
	name = "peanuts"
	icon_state = "peanuts"
	desc = "Some crunchy salted peanuts. Surprisingly, not a bad snack. You might even find yourself wanting more."

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
	desc = "Dried apple slices spiced with cinnamon. Gives you cottonmouth, but that's why MREs include water."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/spicedapples/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie
	name = "chocolate brownie"
	icon_state = "chocolate brownie"
	desc = "A chocolatey square of cake. Home-made brownies are dense and chewy in a good way. This brownie is not home-made."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/chocolatebrownie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("sprinkles", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/sugarcookie
	name = "sugar cookie"
	icon_state = "sugar cookie"
	desc = "A sweet cookie. A little hard, but still better than most of the entrees."

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
	desc = "A soft milky biscuit pie. Somewhat flaky and crumbly to the touch."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/flan/Initialize()
	. = ..()
	reagents.add_reagent("milk", 1)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan
	name = "honey flan"
	icon_state = "honey flan"
	desc = "A soft milky biscuit pie, covered in a honey topping. The topping itself is more of a thick gel than a syrupy sauce. Maybe the manufacturer learned from the cinnamon apple slices."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/honeyflan/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/lemonpie
	name = "lemon pie"
	icon_state = "lemon pie"
	desc = "A pie with a thick, overpoweringly lemon flavored filling and a dry, chunky crust."

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
	desc = "A pie with an overpoweringly sour lime flavored filling and a dry, chunky crust"

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
	desc = "A traditional Brazillian dessert, made out of condensed milk, cocoa and butter. Allegedly."

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/brigadeiro/Initialize()
	. = ..()
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 3)
	reagents.add_reagent("coco", 4)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm/dessert/strawberrytoaster
	name = "strawberry toaster pastry"
	icon_state = "strawberry toaster pastry"
	desc = "A crunchy biscuit with artifical tasting strawberry jam inside of it. Dry frosting on the top completes the look of a popular breakfast product. Despite the impression, this is actually a toaster pastry: the manufacturer wanted to avoid copyright infringement."

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
	desc = "A creamy and cheesy spread, made out of a processed cheese. Combines well with tortillas and other snacks."
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
	desc = "A creamy and cheesy spread, made out of a processed cheese. Combines well with tortillas and other snacks; this one has a spicy jalapeno flavor."
	flavor = "jalapeno cheese spread"

/obj/item/reagent_container/food/drinks/cans/spread/jalapeno/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("capsaicin", 2)

/obj/item/reagent_container/food/drinks/cans/spread/peanut_butter
	name = "spread packet (peanut butter)"
	desc = "A creamy and nutty spread, made out of processed peanuts. Combines well with tortillas and other snacks."
	flavor = "peanut butter"

/obj/item/reagent_container/food/drinks/cans/spread/peanut_butter/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 2)

///BEVERAGE DRINKS

/obj/item/reagent_container/food/drinks/beverage_drink
	name = "beverage powder packet"
	desc = "Powdered flavoring that can be mixed in water for a ready-in-a-field drink."
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
	desc = "Powdered orange flavoring that can be mixed in water for a ready-in-a-field drink. Contains electrolytes that are supposed to help with hydration."

/obj/item/reagent_container/food/drinks/beverage_drink/orange/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_orange_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime
	name = "electrolyte beverage powder packet (lemon-lime)"
	desc = "Powdered lemon-lime flavoring that can be mixed in water for a ready-in-a-field drink. Contains electrolytes that are supposed to help with hydration."

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_lemonlime_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate
	name = "protein drink beverage powder packet (milk chocolate)"
	desc = "A packet of powdered protein mix that can be added to water for a ready-in-a-field drink. Has a chocolate flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate/Initialize()
	. = ..()
	reagents.add_reagent("chocolate_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut
	name = "protein drink beverage powder packet (chocolate hazelnut)"
	desc = "A packet of powdered protein mix that can be added to water for a ready-in-a-field drink. Has a chocolate hazelnut flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut/Initialize()
	. = ..()
	reagents.add_reagent("hazelnut_beverage", 4)

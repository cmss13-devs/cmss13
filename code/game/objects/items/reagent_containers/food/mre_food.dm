//CORE PACKAGE ITEM
/obj/item/mre_food_packet
	name = "\improper ration component"
	desc = "A ration package."
	icon_state = "entree"
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	var/contents_food
	var/no_packet_label = FALSE
	var/food_list = list()

/obj/item/mre_food_packet/Initialize(mapload, ...)
	. = ..()
	contents_food = pick(food_list)
	if(!no_packet_label)
		var/obj/item/reagent_container/food/snacks/food = contents_food
		name += " ([food.name])"

/obj/item/mre_food_packet/ex_act()
	deconstruct(FALSE)
	return

/obj/item/mre_food_packet/attack_self(mob/M)
	..()

	if(!ispath(contents_food, /obj/item))
		return

	var/obj/item/I = new contents_food(M)
	M.temp_drop_inv_item(src)
	M.put_in_hands(I)
	I.add_fingerprint(M)
	to_chat(M, SPAN_NOTICE("You pull open the package of the meal!"))
	playsound(loc, "rip", 15, 1)
	qdel(src)
	return

//CORE MRE FOOD ITEM
/obj/item/reagent_container/food/snacks/mre_food
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	package = 1
	bitesize = 5
	package = 0

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
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pizzasquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pepperonisquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chiliconcarne,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/noodlesoup,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchickenbreast,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/feijoada,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/porkribs
	name = "boneless pork ribs"
	icon_state = "boneless pork ribs"
	desc = "You can't even taste processed meat taste under all those spices!"

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/porkribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchicken
	name = "grilled chicken"
	icon_state = "grilled chicken"
	desc = "Doesn't actually tastes like grilled one, but do you really expect that luxury here?"

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchicken/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pizzasquare
	name = "pizza square"
	icon_state = "pizza square"
	desc = "An American classic, been added and removed from the menu about 27 times at this point, still loved despite being cheap parody of a real thing."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pizzasquare/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("meatprotein", 3)
	reagents.add_reagent("bread", 5)
	reagents.add_reagent("vegetables", 2)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pepperonisquare
	name = "pepperoni pizza square"
	icon_state = "pepperoni square"
	desc = "A newer addition to the timeless MRE classic, very similar."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pepperonisquare/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 3)
	reagents.add_reagent("meatprotein", 5)
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chickentender
	name = "chicken tender"
	icon_state = "chicken tender"
	desc = "Really tasty and has nice crumbs texture, but makes you wish for some good chicken wings..."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chickentender/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchickenbreast
	name = "grilled chicken breast"
	icon_state = "grilled chicken breast"
	desc = "Very plain grilled chicken meat, simple but yet very classic taste."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchickenbreast/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/spaghettichunks
	name = "meat spaghetti"
	icon_state = "spaghetti chunks"
	desc = "Spaghetti with some cooked meat chunks, all covered in a tomato sauce."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/spaghettichunks/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 8)
	reagents.add_reagent("meatprotein", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chiliconcarne
	name = "chili con carne"
	icon_state = "chili con carne"
	desc = "Spicy minced meat dish, there is no limit on adding chili in there, having some milk in near proximity is recommended."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chiliconcarne/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 10)
	reagents.add_reagent("hotsauce", 6)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("tomatojuice", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/noodlesoup
	name = "noodle soup"
	icon_state = "noodle soup"
	desc = "Very nourishing noodle soup with vegetables and a chicken flavor, will keep you warm for a long time if heated."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/noodlesoup/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 9)
	reagents.add_reagent("vegetable", 4)
	reagents.add_reagent("water", 5)
	reagents.add_reagent("meatprotein", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/feijoada
	name = "feijoada"
	icon_state = "brazilian-style feijoada"
	desc = "A Brazillian dish filled with black beans, different kinds of meat, vegetables and spices, very nourishing and rich in flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/feijoada/Initialize()
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
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/mashedpotatoes,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cornbread,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/kale,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/tortillas,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cinnamonappleslices,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/boiledrice,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cracker
	name = "cracker"
	icon_state = "cracker"
	desc = "Crumbs easily but it's the most satisfying part."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cracker/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/mashedpotatoes
	name = "mashed potatoes"
	icon_state = "mashed potatoes"
	desc = "Really soft and gentle, goes well with a main dish."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/mashedpotatoes/Initialize()
	. = ..()
	reagents.add_reagent("potato", 6)
	reagents.add_reagent("vegetables", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/risotto
	name = "risotto"
	icon_state = "risotto"
	desc = "A bit more exotic, but Italian cuisine never dissapoints."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/risotto/Initialize()
	. = ..()
	reagents.add_reagent("sodiumchloride", 1)
	reagents.add_reagent("rice", 4)
	reagents.add_reagent("cornoil", 1)
	reagents.add_reagent("vegetable", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/onigiri
	name = "rice onigiri"
	icon_state = "rice onigiri"
	desc = "Cooked rice in a form of a triangle, covered in a seaweed at the bottom, doesn't fall apart, surprisingly."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/onigiri/Initialize()
	. = ..()
	reagents.add_reagent("rice", 5)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cornbread
	name = "cornbread"
	icon_state = "cornbread"
	desc = "Almost universally hated, very dry and simple taste of it really gets old fast. Requisitions probably has ass-load of it in the back. Nobody eats that shit."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cornbread/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/kale
	name = "conserved kale"
	icon_state = "kale"
	desc = "A sort of cabbage, conserved in spices, still has a lot of moist and crunch to it."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/kale/Initialize()
	. = ..()
	reagents.add_reagent("plantmatter", 6)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/tortillas
	name = "tortillas"
	icon_state = "tortillas"
	desc = "A kind of flat bread, goes well with adding other things onto it."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/tortillas/Initialize()
	. = ..()
	reagents.add_reagent("bread", 6)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cinnamonappleslices
	name = "cinnamon apple slices"
	icon_state = "cinnamon apple slices"
	desc = "A bit gooey pieces of apple in cinnamon sauce, a bit sticky but tasty."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cinnamonappleslices/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 3)
	reagents.add_reagent("sugar", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/boiledrice
	name = "boiled rice"
	icon_state = "rice"
	desc = "A packet of plain boiled rice, a bit boring but would go well with additives."

/obj/item/reagent_container/food/snacks/mre_food/uscm_side/boiledrice/Initialize()
	. = ..()
	reagents.add_reagent("rice", 6)

///SNACK

/obj/item/mre_food_packet/uscm/snack
	name = "\improper MRE snack"
	desc = "An MRE snack component. Contains a light snack in case you weren't feeling terribly hungry."
	icon_state = "snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/biscuit,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/meatballs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/pretzels,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/sushi,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/peanuts,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/biscuit
	name = "biscuit"
	icon_state = "biscuit"
	desc = "Reminds you of a cracker, but has a lot more different grains in it, which gives it more unique texture and flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/biscuit/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/meatballs
	name = "meatballs"
	icon_state = "meatballs"
	desc = "You can even taste muscle fibers, despite it being a cooked minced meat."

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/meatballs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 4)
	reagents.add_reagent("sodiumchloride", 2)
	reagents.add_reagent("blackpepper", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/pretzels
	name = "pretzels"
	icon_state = "pretzels"
	desc = "Really salty and crunchy, thirst provoking."

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/pretzels/Initialize()
	. = ..()
	reagents.add_reagent("bread", 4)
	reagents.add_reagent("sodiumchloride", 4)

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/sushi
	name = "sushi"
	icon_state = "sushi"
	desc = "You kinda highly doubt that raw fish wouldn't go bad in here, it barely smells like one... is it even fish?..."

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/sushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("soysauce", 2)
	reagents.add_reagent("soymilk", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/peanuts
	name = "peanuts"
	icon_state = "peanuts"
	desc = "Some crunchy salted peanuts, easy to get addicted to."

/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/peanuts/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/uscm/dessert
	name = "\improper MRE dessert"
	desc = "An MRE side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/spicedapples,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/chocolatebrownie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/sugarcookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/cocobar,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/flan,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/honeyflan,
		/obj/item/reagent_container/food/snacks/cookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/lemonpie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/limepie,
	)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/spicedapples
	name = "spiced apples"
	icon_state = "spiced apples"
	desc = "A bit dry pieces of apple in cinnamon spice, makes your mouth water, but still tasty."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/spicedapples/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/chocolatebrownie
	name = "chocolate brownie"
	icon_state = "chocolate brownie"
	desc = "Coco filled cake base with a chocolate frosting on top, has a deep chocolate flavor."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/chocolatebrownie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/sugarcookie
	name = "sugar cookie"
	icon_state = "sugar cookie"
	desc = "Baked cookie frosted with a caramelized sugar."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/sugarcookie/Initialize()
	. = ..()
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("bread", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/cocobar
	name = "coco bar"
	icon_state = "coco bar"
	desc = "Good old milk chocolate bar, goes well with hot drinks."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/cocobar/Initialize()
	. = ..()
	reagents.add_reagent("coco", 5)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/flan
	name = "flan"
	icon_state = "flan"
	desc = "A soft milky biscuit pie."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/flan/Initialize()
	. = ..()
	reagents.add_reagent("milk", 1)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/honeyflan
	name = "honey flan"
	icon_state = "honey flan"
	desc = "A soft milky biscuit pie, covered in honey topping."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/honeyflan/Initialize()
	. = ..()
	reagents.add_reagent("honey", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("sugar", 2)
	reagents.add_reagent("egg", 3)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/lemonpie
	name = "lemon pie"
	icon_state = "lemon pie"
	desc = "A creamy pie with a milky lemon filling and a thick crust."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/lemonpie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("lemonjuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 1)
	reagents.add_reagent("egg", 1)

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/limepie
	name = "key lime pie"
	icon_state = "key lime pie"
	desc = "A creamy pie with a milky lime filling and a thick crust."

/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/limepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("limejuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sugar", 1)
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
	name = "beverage packet"
	desc = "A packet of a beverage, to be mixed with water, makes a ready-in-a-field drink."
	icon = 'icons/obj/items/food/mre_food/uscm.dmi'
	icon_state = "beverage"
	volume = 20

/obj/item/reagent_container/food/drinks/beverage_drink/grape
	name = "electrolyte beverage packet (grape)"
	desc = "A packet of an electrolyte beverage, to be mixed with water, makes a ready-in-a-field drink. Has a grape flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/grape/Initialize()
	. = ..()
	reagents.add_reagent("dehydrated_grape_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/orange
	name = "electrolyte beverage packet (orange)"
	desc = "A packet of an electrolyte beverage, to be mixed with water, makes a ready-in-a-field drink. Has a citrusy orange flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/orange/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_orange_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime
	name = "electrolyte beverage packet (lemon-lime)"
	desc = "A packet of an electrolyte beverage, to be mixed with water, makes a ready-in-a-field drink. Has a citrusy lemon-lime flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/lemonlime/Initialize()
	. = ..()
	reagents.add_reagent("electrolyte_lemonlime_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate
	name = "protein drink beverage packet (milk chocolate)"
	desc = "A packet of a protein drink, to be mixed with water, makes a ready-in-a-field drink. Has a chocolate flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate/Initialize()
	. = ..()
	reagents.add_reagent("chocolate_beverage", 4)

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut
	name = "protein drink beverage packet (chocolate hazelnut)"
	desc = "A packet of a protein drink, to be mixed with water, makes a ready-in-a-field drink. Has a chocolate hazelnut flavor."

/obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut/Initialize()
	. = ..()
	reagents.add_reagent("hazelnut_beverage", 4)

//WY

/obj/item/mre_food_packet/wy
	icon = 'icons/obj/items/food/mre_food/wy.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/wy
	name = "\improper CFR main dish"
	desc = "An CFR entree component. Contains a luxurious well prepared main course, preserved using high-tech methods."
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "pmc_entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/bakedfish,
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/smokyribs,
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/ham,
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/beefstake,
	)

/obj/item/reagent_container/food/snacks/mre_food/wy_entree
	icon = 'icons/obj/items/food/mre_food/wy.dmi'

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/bakedfish
	name = "baked salmon"
	icon_state = "baked fish"
	desc = "A creamy baked wild salmon, contains just the right amount of vitamin D3 you might need for the next four days."

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/bakedfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 14)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/smokyribs
	name = "smoky ribs"
	icon_state = "smoky ribs"
	desc = "A well smoked beef ribs, in a black pepper and apple sauce, very juicy and chewy."

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/smokyribs/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 13)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("fruit", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/ham
	name = "baked ham"
	icon_state = "ham"
	desc = "Medium-rare baked ham, with a peppery outer layer, moist and rich in flavor."

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/ham/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("blood", 1)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/beefstake
	name = "beefsteak"
	icon_state = "beefstake"
	desc = "Medium-well steak, finished with an orange juice sauce and thyme."

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/beefstake/Initialize()
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
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/twe_side/nigirisushi,
		/obj/item/reagent_container/food/snacks/mre_food/twe_side/tomatochips,
	)

///SNACK

/obj/item/mre_food_packet/wy/snack
	name = "\improper CFR snack"
	desc = "An CFR side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "pmc_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe_snack/almond,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/peanuts,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/pretzels,
	)

///DESSERT

/obj/item/mre_food_packet/wy/dessert
	name = "\improper CFR dessert"
	desc = "An CFR side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "pmc_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/eclair,
		/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/strawberrycake,
		/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/cherrypie,
		/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/croissant,
		/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/whitecoco,
	)

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert
	icon = 'icons/obj/items/food/mre_food/wy.dmi'

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/eclair
	name = "eclair"
	icon_state = "eclair"
	desc = "A gentle pastry, filled with an airy vanilla flavored cream, iced with a layer of chocolate on the top."

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/eclair/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("coco", 1)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/strawberrycake
	name = "strawberry cake"
	icon_state = "strawberry cake"
	desc = "Light vanilla cake, with a thick layer of strawberry icing and a strawberry filling inside."

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/strawberrycake/Initialize()
	. = ..()
	reagents.add_reagent("berryjuice", 5)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sprinkles", 2)

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/cherrypie
	name = "cherry pie"
	icon_state = "cherry pie"
	desc = "A pie with a crisp outer crust and a soft cherry jelly filling."

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/cherrypie/Initialize()
	. = ..()
	reagents.add_reagent("cherryjelly", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/croissant
	name = "chocolate croissant"
	icon_state = "croissant"
	desc = "A crisp croissant with dark chocolate filling."

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/croissant/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/whitecoco
	name = "white chocolate bar"
	icon_state = "white chocolate bar"
	desc = "A white chocolate bar, with bits of almonds and coconut. Don't let the heretics call it a false chocolate, you are the one enjoying it here."

/obj/item/reagent_container/food/snacks/mre_food/wy_dessert/whitecoco/Initialize()
	. = ..()
	reagents.add_reagent("coco", 3)
	reagents.add_reagent("milk", 2)
	reagents.add_reagent("nuts", 1)
	reagents.add_reagent("coconutmilk", 2)
	reagents.add_reagent("sugar", 2)

//WY GENERAL RATION

/obj/item/mre_food_packet/entree/wy_colonist
	name = "\improper W-Y brand ration main dish"
	desc = "Probably the most edible component of it, contains main nutrition contents."
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "wy_main"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchickenbreast,
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

//TWE

/obj/item/mre_food_packet/twe
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/twe
	name = "\improper ORP main dish"
	desc = "An Operation Ration Pack entree component. Contains a luxurious well prepared main course based on TWE cuisines, preserved using high-tech methods."
	icon = 'icons/obj/items/food/mre_food/twe.dmi'
	icon_state = "twe_entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe_entree/bacon,
		/obj/item/reagent_container/food/snacks/mre_food/twe_entree/tomatobeans,
		/obj/item/reagent_container/food/snacks/mre_food/twe_entree/fishnrice,
		/obj/item/reagent_container/food/snacks/mre_food/twe_entree/ricenoodles,
		/obj/item/reagent_container/food/snacks/mre_food/twe_entree/fishnchips,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe_entree
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/bacon
	name = "bacon"
	icon_state = "bacon"
	desc = "Yet another classic part of the British breakfast, bacon, fried to a crisp, goes well with a toast."

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/bacon/Initialize()
	. = ..()
	reagents.add_reagent("meatprotein", 14)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/tomatobeans
	name = "tomato beans"
	icon_state = "tomato beans"
	desc = "Classic part of the British breakfast, baked beans in tomato sauce, goes well with a toast."

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/tomatobeans/Initialize()
	. = ..()
	reagents.add_reagent("vegetables", 14)
	reagents.add_reagent("tomatojuice", 8)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/fishnrice
	name = "fish n rice"
	icon_state = "fish n rice"
	desc = "A dish born in Japan, initially made by the Commonwealth sailors suffering from lack of potatoes in Asian parts of the Empire, they figured out they could use rice for that instead."

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/fishnrice/Initialize()
	. = ..()
	reagents.add_reagent("fish", 6)
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("cornoil", 2)
	reagents.add_reagent("sodiumchloride", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/ricenoodles
	name = "rice ramen"
	icon_state = "rice noodles"
	desc = "A Japanese style rice noodle ramen, has a fair share of hot sauce to it, has some subtle bits of carrot and green onions."

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/ricenoodles/Initialize()
	. = ..()
	reagents.add_reagent("noodles", 6)
	reagents.add_reagent("rice", 6)
	reagents.add_reagent("vegetables", 2)
	reagents.add_reagent("capsaicin", 4)
	reagents.add_reagent("hotsauce", 4)

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/fishnchips
	name = "fish n chips"
	icon_state = "fish n chips"
	desc = "A British classic, stripes of fish covered in bread crumbs and fried, has a bit of a crunch to it, hands are all greasy after it."

/obj/item/reagent_container/food/snacks/mre_food/twe_entree/fishnchips/Initialize()
	. = ..()
	reagents.add_reagent("fish", 5)
	reagents.add_reagent("vegetables", 5)
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
		/obj/item/reagent_container/food/snacks/mre_food/twe_side/nutpatty,
		/obj/item/reagent_container/food/snacks/mre_food/twe_side/nigirisushi,
		/obj/item/reagent_container/food/snacks/mre_food/twe_side/nutpatty,
		/obj/item/reagent_container/food/snacks/mre_food/twe_side/tomatochips,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe_side
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

/obj/item/reagent_container/food/snacks/mre_food/twe_side/nutpatty
	name = "chickpeas patty"
	icon_state = "nut patty"
	desc = "Vegeterian patte from from chickpeas, covered in bread crumbs and fried, reminds you of fish sticks for some reason."

/obj/item/reagent_container/food/snacks/mre_food/twe_side/nutpatty/Initialize()
	. = ..()
	reagents.add_reagent("vegetables", 2)
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("plantmatter", 2)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe_side/nigirisushi
	name = "nigiri sushi"
	icon_state = "nigiri sushi"
	desc = "A salmon slice on a ball of boiled rice, wrapped in a stripe of seaweed, melts in mouth."

/obj/item/reagent_container/food/snacks/mre_food/twe_side/nigirisushi/Initialize()
	. = ..()
	reagents.add_reagent("fish", 3)
	reagents.add_reagent("rice", 2)
	reagents.add_reagent("plantmatter", 1)
	reagents.add_reagent("soysauce", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe_side/tomatochips
	name = "tomato chips"
	icon_state = "tomato chips"
	desc = "Very crisp, with a hint of basil, goes well with beer."

/obj/item/reagent_container/food/snacks/mre_food/twe_side/tomatochips/Initialize()
	. = ..()
	reagents.add_reagent("vegetables", 6)
	reagents.add_reagent("tomatojuice", 4)
	reagents.add_reagent("blackpepper", 2)
	reagents.add_reagent("sodiumchloride", 2)

///SNACK

/obj/item/mre_food_packet/twe/snack
	name = "\improper ORP snack"
	desc = "An ORP snack component. Contains a light snack in case you weren't feeling terribly hungry."
	icon_state = "twe_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe_snack/cheese,
		/obj/item/reagent_container/food/snacks/mre_food/twe_snack/almond,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe_snack
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

/obj/item/reagent_container/food/snacks/mre_food/twe_snack/almond
	name = "almonds"
	icon_state = "almond"
	desc = "Oven dried almonds, rich in vitamins, flavor, has a nice crunch, the luxury you needed all along."

/obj/item/reagent_container/food/snacks/mre_food/twe_snack/almond/Initialize()
	. = ..()
	reagents.add_reagent("nuts", 4)
	reagents.add_reagent("sodiumchloride", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe_snack/cheese
	name = "dehydrated cheese chunk"
	icon_state = "cheese"
	desc = "Freeze dried chunk of cheddar, very dry but has a concentrated flavor, makes a good snack."

/obj/item/reagent_container/food/snacks/mre_food/twe_snack/cheese/Initialize()
	. = ..()
	reagents.add_reagent("cheese", 4)
	reagents.add_reagent("sodiumchloride", 1)

///DESSERT

/obj/item/mre_food_packet/twe/dessert
	name = "\improper ORP dessert"
	desc = "An Operatipn Ration Pack side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "twe_dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/chocobar,
		/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinyapplepie,
		/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinycheesecake,
		/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinypancakes,
	)

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert
	icon = 'icons/obj/items/food/mre_food/twe.dmi'

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/chocobar
	name = "dark chocolate bar"
	icon_state = "tiny chocolate bar"
	desc = "56% coco true dark chocolate, rich in flavor, classic, combines well with hot drinks."

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/chocobar/Initialize()
	. = ..()
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinyapplepie
	name = "tiny applepie"
	icon_state = "tiny applepie"
	desc = "Has some juice apple slices with a cinnamon flavor."

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinyapplepie/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("fruit", 2)
	reagents.add_reagent("sugar", 1)

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinycheesecake
	name = "tiny cheesecake"
	icon_state = "tiny cheesecake"
	desc = "Very airy and sugary cheesy, has a tasty vanilla cake base."

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinycheesecake/Initialize()
	. = ..()
	reagents.add_reagent("bread", 2)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("milk", 2)

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinypancakes
	name = "tiny pancakes"
	icon_state = "tiny pancakes"
	desc = "Buttery cupcakes with a honey topping."

/obj/item/reagent_container/food/snacks/mre_food/twe_dessert/tinypancakes/Initialize()
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

///FACTION NEUTRAL RATION

/obj/item/mre_food_packet/merc
	icon = 'icons/obj/items/food/mre_food/merc.dmi'

///ENTREE

/obj/item/mre_food_packet/entree/merc
	name = "\improper FSR main dish"
	desc = "An FRS entree component. Contains the main course for nutrients."
	icon = 'icons/obj/items/food/mre_food/merc.dmi'
	icon_state = "entree"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/porkribs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchicken,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pizzasquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/chickentender,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/pepperonisquare,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/spaghettichunks,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_entree/grilledchickenbreast,
	)

///SIDE

/obj/item/mre_food_packet/merc/side
	name = "\improper FSR side dish"
	desc = "An FSR side component. Contains a side, to be eaten alongside the main."
	icon_state = "side"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cracker,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/risotto,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/onigiri,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cornbread,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/tortillas,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_side/cinnamonappleslices,
	)

///SNACK

/obj/item/mre_food_packet/merc/snack
	name = "\improper FSR snack"
	desc = "An FSR snack component. Contains a light snack in case you weren't feeling terribly hungry."
	icon_state = "snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/biscuit,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/meatballs,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/pretzels,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/sushi,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_snack/peanuts,
	)

///DESSERT

/obj/item/mre_food_packet/merc/dessert
	name = "\improper FSR dessert"
	desc = "An FSR side component. Contains a sweet dessert, to be eaten after the main (or before, if you're rebellious)."
	icon_state = "dessert"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/spicedapples,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/chocolatebrownie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/sugarcookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/cocobar,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/flan,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/honeyflan,
		/obj/item/reagent_container/food/snacks/cookie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/lemonpie,
		/obj/item/reagent_container/food/snacks/mre_food/uscm_dessert/limepie,
	)

//WY

/obj/item/mre_food_packet/upp
	icon = 'icons/obj/items/food/mre_food/upp.dmi'

///ENTREE

/obj/item/mre_food_packet/upp/upp/snack
	name = "\improper IRP snack"
	desc = "An IRP snack, some nutritious snack to be eaten in a breaktime."
	icon = 'icons/obj/items/food/mre_food/wy.dmi'
	icon_state = "upp_snack"
	food_list = list(
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/bakedfish,
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/smokyribs,
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/ham,
		/obj/item/reagent_container/food/snacks/mre_food/wy_entree/beefstake,
	)

/obj/item/reagent_container/food/snacks/mre_food/upp_snack
	icon = 'icons/obj/items/food/mre_food/wy.dmi'

/obj/item/reagent_container/food/snacks/mre_food/upp_snack/driedfish
	name = "baked salmon"
	icon_state = "baked fish"
	desc = "A creamy baked wild salmon, contains just the right amount of vitamin D3 you might need for the next four days."

/obj/item/reagent_container/food/snacks/mre_food/wy_entree/bakedfish/Initialize()
	. = ..()
	reagents.add_reagent("fish", 14)
	reagents.add_reagent("cream", 2)
	reagents.add_reagent("sodiumchloride", 2)

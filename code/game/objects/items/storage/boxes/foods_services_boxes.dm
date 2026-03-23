/*
Foods and produce, whatever the chef needs really
*/

/obj/item/storage/box/condimentbottles
	name = "box of condiment bottles"
	desc = "It has a large ketchup smear on it."
	w_class = SIZE_LARGE

/obj/item/storage/box/condimentbottles/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/condiment(src)

/obj/item/storage/box/cups
	name = "box of paper cups"
	desc = "It has pictures of paper cups on the front."

/obj/item/storage/box/cups/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/drinks/sillycup( src )

/obj/item/storage/box/drinkingglasses
	name = "box of drinking glasses"
	desc = "It has a picture of drinking glasses on it."
	w_class = SIZE_LARGE

/obj/item/storage/box/drinkingglasses/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/drinks/drinkingglass(src)

/obj/item/storage/box/donkpockets
	name = "box of donk-pockets"
	desc = "<B>Instructions:</B> <I>Heat in microwave. Product will cool if not eaten within seven minutes.</I>"
	icon_state = "donk_kit"
	item_state = "donk_kit"

/obj/item/storage/box/donkpockets/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/donkpocket(src)

/obj/item/storage/box/teabags
	name = "box of Earl Grey tea bags"
	desc = "A box of instant tea bags."
	icon_state = "teabag_box"
	item_state = "teabag_box"
	w_class = SIZE_SMALL
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/teabags/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/pill/teabag/earl_grey(src)

/obj/item/storage/box/lemondrop
	name = "box of Lemon Drop candies"
	desc = "A box of lemon flavored hard candies."
	icon_state = "lemon_drop_box"
	item_state = "lemon_drop_box"
	w_class = SIZE_SMALL
	storage_slots = STORAGE_SLOTS_DEFAULT

/obj/item/storage/box/lemondrop/fill_preset_inventory()
	for(var/i in 1 to storage_slots)
		new /obj/item/reagent_container/food/snacks/lemondrop(src)

//food boxes for storage in bulk

//meat
/obj/item/storage/box/meat
	name = "box of meat"
	w_class = SIZE_SMALL

/obj/item/storage/box/meat/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/meat/monkey(src)

//fish
/obj/item/storage/box/fish
	name = "box of fish"
	w_class = SIZE_SMALL

/obj/item/storage/box/fish/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/carpmeat(src)

//grocery

//milk
/obj/item/storage/box/milk
	name = "box of milk"
	w_class = SIZE_LARGE

/obj/item/storage/box/milk/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/drinks/milk(src)

//soymilk
/obj/item/storage/box/soymilk
	name = "box of soymilk"
	w_class = SIZE_LARGE

/obj/item/storage/box/soymilk/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/drinks/soymilk(src)

//enzyme
/obj/item/storage/box/enzyme
	name = "box of enzyme"
	w_class = SIZE_LARGE

/obj/item/storage/box/enzyme/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/condiment/enzyme(src)

//dry storage

//flour
/obj/item/storage/box/flour
	name = "box of flour"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/flour/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/flour(src)

//sugar
/obj/item/storage/box/sugar
	name = "box of sugar"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/sugar/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/condiment/sugar(src)

//saltshaker
/obj/item/storage/box/saltshaker
	name = "box of saltshakers"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/saltshaker/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/condiment/saltshaker(src)

//peppermill
/obj/item/storage/box/peppermill
	name = "box of peppermills"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/peppermill/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/condiment/peppermill(src)

//mint
/obj/item/storage/box/mint
	name = "box of mints"
	w_class = SIZE_SMALL

/obj/item/storage/box/mint/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/mint(src)

// ORGANICS

//apple
/obj/item/storage/box/apple
	name = "box of apples"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/apple/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/apple(src)

//banana
/obj/item/storage/box/banana
	name = "box of bananas"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/banana/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/banana(src)

//chanterelle
/obj/item/storage/box/chanterelle
	name = "box of chanterelles"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/chanterelle/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/mushroom/chanterelle(src)

//cherries
/obj/item/storage/box/cherries
	name = "box of cherries"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/cherries/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/cherries(src)

//chili
/obj/item/storage/box/chili
	name = "box of chili"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/chili/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/chili(src)

//cabbage
/obj/item/storage/box/cabbage
	name = "box of cabbages"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/cabbage/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/cabbage(src)

//carrot
/obj/item/storage/box/carrot
	name = "box of carrots"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/carrot/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/carrot(src)

//corn
/obj/item/storage/box/corn
	name = "box of corn"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/corn/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/corn(src)

//eggplant
/obj/item/storage/box/eggplant
	name = "box of eggplants"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/eggplant/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/eggplant(src)

//lemon
/obj/item/storage/box/lemon
	name = "box of lemons"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/lemon/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/lemon(src)

//lime
/obj/item/storage/box/lime
	name = "box of limes"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/lime/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/lime(src)

//orange
/obj/item/storage/box/orange
	name = "box of oranges"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/orange/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/orange(src)

//potato
/obj/item/storage/box/potato
	name = "box of potatoes"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/potato/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/potato(src)

//tomato
/obj/item/storage/box/tomato
	name = "box of tomatoes"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/tomato/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/tomato(src)

//whitebeet
/obj/item/storage/box/whitebeet
	name = "box of whitebeet"
	w_class = SIZE_MEDIUM

/obj/item/storage/box/whitebeet/fill_preset_inventory()
	for(var/i in 1 to STORAGE_SLOTS_DEFAULT)
		new /obj/item/reagent_container/food/snacks/grown/whitebeet(src)

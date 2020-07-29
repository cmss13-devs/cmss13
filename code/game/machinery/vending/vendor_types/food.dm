//------------CANTEEN MRE VENDOR---------------
/obj/structure/machinery/cm_vending/sorted/marine_food
	name = "\improper ColMarTech Food Vendor"
	desc = "USCM Food Vendor, containing standard military Prepared Meals."
	icon_state = "marine_food"
	vend_delay = 3
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

	listed_products = list(
			list("PREPARED MEALS", -1, null, null),
			list("USCM Prepared Meal (Chicken)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal5, VENDOR_ITEM_REGULAR),
			list("USCM Prepared Meal (Cornbread)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal1, VENDOR_ITEM_REGULAR),
			list("USCM Prepared Meal (Pasta)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal3, VENDOR_ITEM_REGULAR),
			list("USCM Prepared Meal (Pizza)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal4, VENDOR_ITEM_REGULAR),
			list("USCM Prepared Meal (Pork)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal2, VENDOR_ITEM_REGULAR),
			list("USCM Prepared Meal (Tofu)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal6, VENDOR_ITEM_REGULAR),
			list("USCM Protein Bar", 50, /obj/item/reagent_container/food/snacks/protein_pack, VENDOR_ITEM_REGULAR),

			//list("CHRISTMAS MEALS", -1, null, null),		//uncomment during emerge... Christmas
			//list("Xmas Prepared Meal (Fruitcake)", 25, /obj/item/reagent_container/food/snacks/mre_pack/xmas3, VENDOR_ITEM_REGULAR),
			//list("Xmas Prepared Meal (Gingerbread Cookies)", 25, /obj/item/reagent_container/food/snacks/mre_pack/xmas2, VENDOR_ITEM_REGULAR),
			//list("Xmas Prepared Meal (Sugar Cookies)", 25, /obj/item/reagent_container/food/snacks/mre_pack/xmas1, VENDOR_ITEM_REGULAR),

			list("FLASKS", -1, null, null),
			list("Metal Flask", 10, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
			list("USCM Flask", 5, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR)
			)

//------------BOOZE-O-MAT VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/boozeomat
	name = "\improper Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 15
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

	listed_products = list(
			list("ALCOHOL", -1, null, null),
			list("Ale", 6, /obj/item/reagent_container/food/drinks/cans/ale, VENDOR_ITEM_REGULAR),
			list("Beer", 6, /obj/item/reagent_container/food/drinks/cans/beer, VENDOR_ITEM_REGULAR),
			list("Briar Rose Grenadine Syrup", 5, /obj/item/reagent_container/food/drinks/bottle/grenadine, VENDOR_ITEM_REGULAR),
			list("Caccavo Guaranteed Quality Tequilla", 5, /obj/item/reagent_container/food/drinks/bottle/tequilla, VENDOR_ITEM_REGULAR),
			list("Captain Pete's Cuban Spiced Rum", 5, /obj/item/reagent_container/food/drinks/bottle/rum, VENDOR_ITEM_REGULAR),
			list("Chateau De Baton Premium Cognac", 5, /obj/item/reagent_container/food/drinks/bottle/cognac, VENDOR_ITEM_REGULAR),
			list("Davenport Rye Whiskey", 3, /obj/item/reagent_container/food/drinks/bottle/davenport, VENDOR_ITEM_REGULAR),
			list("Doublebeard Bearded Special Wine", 5, /obj/item/reagent_container/food/drinks/bottle/wine, VENDOR_ITEM_REGULAR),
			list("Emeraldine Melon Liquor", 2, /obj/item/reagent_container/food/drinks/bottle/melonliquor, VENDOR_ITEM_REGULAR),
			list("Goldeneye Vermouth", 5, /obj/item/reagent_container/food/drinks/bottle/vermouth, VENDOR_ITEM_REGULAR),
			list("Griffeater Gin", 5, /obj/item/reagent_container/food/drinks/bottle/gin, VENDOR_ITEM_REGULAR),
			list("Jailbreaker Verte", 2, /obj/item/reagent_container/food/drinks/bottle/absinthe, VENDOR_ITEM_REGULAR),
			list("Miss Blue Curacao", 2, /obj/item/reagent_container/food/drinks/bottle/bluecuracao, VENDOR_ITEM_REGULAR),
			list("Red Star Vodka", 5, /obj/item/reagent_container/food/drinks/bottle/vodka, VENDOR_ITEM_REGULAR),
			list("Robert Robust's Coffee Liqueur", 5, /obj/item/reagent_container/food/drinks/bottle/kahlua, VENDOR_ITEM_REGULAR),
			list("Uncle Git's Special Reserve", 5, /obj/item/reagent_container/food/drinks/bottle/whiskey, VENDOR_ITEM_REGULAR),
			list("Weston-Yamada Aspen Beer", 20, /obj/item/reagent_container/food/drinks/cans/aspen, VENDOR_ITEM_REGULAR),

			list("NON-ALCOHOL", -1, null, null),
			list("Duke Purple Tea", 10, /obj/item/reagent_container/food/drinks/tea, VENDOR_ITEM_REGULAR),
			list("Fruit-Beer", 8, /obj/item/reagent_container/food/drinks/cans/cola, VENDOR_ITEM_REGULAR),
			list("Lime Juice", 4, /obj/item/reagent_container/food/drinks/bottle/limejuice, VENDOR_ITEM_REGULAR),
			list("Milk Cream", 4, /obj/item/reagent_container/food/drinks/bottle/cream, VENDOR_ITEM_REGULAR),
			list("Orange Juice", 4, /obj/item/reagent_container/food/drinks/bottle/orangejuice, VENDOR_ITEM_REGULAR),
			list("Soda Water", 15, /obj/item/reagent_container/food/drinks/cans/sodawater, VENDOR_ITEM_REGULAR),
			list("Tomato Juice", 4, /obj/item/reagent_container/food/drinks/bottle/tomatojuice, VENDOR_ITEM_REGULAR),
			list("Tonic Water", 8, /obj/item/reagent_container/food/drinks/cans/tonic, VENDOR_ITEM_REGULAR),

			list("CONTAINERS", -1, null, null),
			list("Flask", 5, /obj/item/reagent_container/food/drinks/flask/barflask, VENDOR_ITEM_REGULAR),
			list("Glass", 30, /obj/item/reagent_container/food/drinks/drinkingglass, VENDOR_ITEM_REGULAR),
			list("Ice Cup", 30, /obj/item/reagent_container/food/drinks/ice, VENDOR_ITEM_REGULAR),
			list("Vacuum Flask", 5, /obj/item/reagent_container/food/drinks/flask/vacuumflask, VENDOR_ITEM_REGULAR)
			)
//------------CANTEEN MRE VENDOR---------------
/obj/structure/machinery/cm_vending/sorted/marine_food
	name = "\improper ColMarTech Food Vendor"
	desc = "USCM Food Vendor, containing standard military Prepared Meals."
	icon_state = "marine_food"
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/marine_food/populate_product_list(scale)
	listed_products = list(
		list("PREPARED MEALS", -1, null, null),
		list("USCM Prepared Meal (Chicken)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal5, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Cornbread)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal1, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Pasta)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal3, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Pizza)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal4, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Pork)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal2, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Tofu)", 15, /obj/item/reagent_container/food/snacks/mre_pack/meal6, VENDOR_ITEM_REGULAR),
		list("USCM Protein Bar", 50, /obj/item/reagent_container/food/snacks/protein_pack, VENDOR_ITEM_REGULAR),
		list("FLASKS", -1, null, null),
		list("Canteen", 10, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		list("Metal Flask", 10, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
		list("USCM Flask", 5, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR),
		list("W-Y Flask", 5, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR)
	)

/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial
	hackable = FALSE
	wrenchable = FALSE
	req_access = list(ACCESS_TUTORIAL_LOCKED)

/obj/structure/machinery/cm_vending/sorted/marine_food/tutorial/populate_product_list(scale)
	listed_products = list(
		list("PREPARED MEALS", -1, null, null),
		list("USCM Prepared Meal (Chicken)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal5, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Cornbread)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal1, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Pasta)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal3, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Pizza)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal4, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Pork)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal2, VENDOR_ITEM_REGULAR),
		list("USCM Prepared Meal (Tofu)", 0, /obj/item/reagent_container/food/snacks/mre_pack/meal6, VENDOR_ITEM_REGULAR),
		list("USCM Protein Bar", 1, /obj/item/reagent_container/food/snacks/protein_pack, VENDOR_ITEM_RECOMMENDED),
		list("FLASKS", -1, null, null),
		list("Canteen", 0, /obj/item/reagent_container/food/drinks/flask/canteen, VENDOR_ITEM_REGULAR),
		list("Metal Flask", 0, /obj/item/reagent_container/food/drinks/flask, VENDOR_ITEM_REGULAR),
		list("USCM Flask", 0, /obj/item/reagent_container/food/drinks/flask/marine, VENDOR_ITEM_REGULAR),
		list("W-Y Flask", 0, /obj/item/reagent_container/food/drinks/flask/weylandyutani, VENDOR_ITEM_REGULAR)
	)
//------------BOOZE-O-MAT VENDOR---------------

/obj/structure/machinery/cm_vending/sorted/boozeomat
	name = "\improper Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"
	vendor_theme = VENDOR_THEME_COMPANY
	vend_delay = 1.5 SECONDS
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/boozeomat/populate_product_list(scale)
	listed_products = list(
		list("ALCOHOL", -1, null, null),
		list("Ale", 6, /obj/item/reagent_container/food/drinks/cans/ale, VENDOR_ITEM_REGULAR),
		list("Beer", 6, /obj/item/reagent_container/food/drinks/cans/beer, VENDOR_ITEM_REGULAR),
		list("Briar Rose Grenadine Syrup", 5, /obj/item/reagent_container/food/drinks/bottle/grenadine, VENDOR_ITEM_REGULAR),
		list("Caccavo Guaranteed Quality tequila", 5, /obj/item/reagent_container/food/drinks/bottle/tequila, VENDOR_ITEM_REGULAR),
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
		list("Weyland-Yutani Aspen Beer", 20, /obj/item/reagent_container/food/drinks/cans/aspen, VENDOR_ITEM_REGULAR),

		list("CRAFT BEERS", -1, null, null),
		list("Pendleton's Triple Star", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft, VENDOR_ITEM_REGULAR),
		list("Tuxedo Premium", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/tuxedo, VENDOR_ITEM_REGULAR),
		list("Ganucci's Genuine Light", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/ganucci, VENDOR_ITEM_REGULAR),
		list("Blue Malt", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/bluemalt, VENDOR_ITEM_REGULAR),
		list("Party Popper Ale", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/partypopper, VENDOR_ITEM_REGULAR),
		list("Tazhushka's Turquoise Beer", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/tazhushka, VENDOR_ITEM_REGULAR),
		list("Reaper Red", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/reaper, VENDOR_ITEM_REGULAR),
		list("Mono Lager", 5, /obj/item/reagent_container/food/drinks/bottle/beer/craft/mono, VENDOR_ITEM_REGULAR),

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

/obj/structure/machinery/cm_vending/sorted/boozeomat/populate_product_list_and_boxes(scale)
	. = ..()

	// If this is groundside and isn't dynamically changing we will spawn with stock randomly removed from it
	if(vend_flags & VEND_STOCK_DYNAMIC)
		return
	if(Check_WO())
		return
	var/turf/location = get_turf(src)
	if(location && is_ground_level(location.z))
		random_unstock()

/// Randomly removes amounts of listed_products and reagents
/obj/structure/machinery/cm_vending/sorted/boozeomat/proc/random_unstock()
	for(var/list/vendspec as anything in listed_products)
		var/amount = vendspec[2]
		if(amount <= 0)
			continue

		// Chance to just be empty
		if(prob(25))
			vendspec[2] = 0
			continue

		// Otherwise its some amount between 1 and the original amount
		vendspec[2] = rand(1, 3)

/obj/structure/machinery/cm_vending/sorted/boozeomat/chess
	name = "\improper Chess-O-Mat"
	desc = "In 2143 Red Star Drinks, a UPP-CA (Colonial Administration) affiliated corporation ran a promotional sweepstakes for drinkers who had found special codes on the inside of the caps of a limited run of Red Star Vodka, shipping them a Chess-O-Mat with unlimited refills."
	vendor_theme = VENDOR_THEME_COMPANY
	icon_state = "chessomat"
	hackable = TRUE
	unacidable = FALSE
	unslashable = FALSE
	wrenchable = TRUE

/obj/structure/machinery/cm_vending/sorted/boozeomat/chess/populate_product_list(scale)
	listed_products = list(
		list("White Pieces", -1, null, null),
		list("Pawn", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_pawn, VENDOR_ITEM_REGULAR),
		list("Bishop", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_bishop, VENDOR_ITEM_REGULAR),
		list("Knight", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_knight, VENDOR_ITEM_REGULAR),
		list("Rook", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_rook, VENDOR_ITEM_REGULAR),
		list("King", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_king, VENDOR_ITEM_REGULAR),
		list("Queen", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/w_queen, VENDOR_ITEM_REGULAR),

		list("Black Pieces", -1, null, null),
		list("Pawn", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_pawn, VENDOR_ITEM_REGULAR),
		list("Bishop", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_bishop, VENDOR_ITEM_REGULAR),
		list("Knight", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_knight, VENDOR_ITEM_REGULAR),
		list("Rook", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_rook, VENDOR_ITEM_REGULAR),
		list("King", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_king, VENDOR_ITEM_REGULAR),
		list("Queen", 2, /obj/item/reagent_container/food/drinks/bottle/vodka/chess/b_queen, VENDOR_ITEM_REGULAR)
	)

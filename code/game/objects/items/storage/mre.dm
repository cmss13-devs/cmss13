///CORE MRE, ALSO JUST SO HAPPEN TO BE USCM MRE
/obj/item/storage/box/mre
	name = "\improper USCM MRE"
	desc = "A Meal, Ready-to-Eat. A single-meal combat ration designed to provide a soldier with enough nutrients for a day of strenuous work. Its expiration date is at least 20 years ahead of your combat life expectancy."
	icon = 'icons/obj/items/storage/mre.dmi'
	item_icons = list(
		WEAR_L_HAND = 'icons/mob/humans/onmob/inhands/items/mres_lefthand.dmi',
		WEAR_R_HAND = 'icons/mob/humans/onmob/inhands/items/mres_righthand.dmi'
	)
	icon_state = "mealpack"
	item_state = "mealpack"
	w_class = SIZE_SMALL
	can_hold = list()
	storage_slots = 4
	max_w_class = 0
	use_sound = "rip"
	var/trash_item = /obj/item/trash/uscm_mre
	var/icon_closed = "mealpack"
	var/icon_opened = "mealpackopened"
	var/entree = /obj/item/mre_food_packet/entree/uscm
	var/side = /obj/item/mre_food_packet/uscm/side
	var/snack = /obj/item/mre_food_packet/uscm/snack
	var/dessert = /obj/item/mre_food_packet/uscm/dessert
	var/should_have_drink = TRUE
	var/should_have_cookie = TRUE
	var/should_have_cigarettes = TRUE
	//Used for some unique items that aren't falling under the main categories
	var/misc_item = null
	var/should_have_matches = TRUE
	var/should_have_spread = TRUE
	var/should_have_beverage = TRUE
	var/should_have_utencil = TRUE
	//If mre should include name of entree in its own name
	var/has_main_name = TRUE
	var/isopened = FALSE

/obj/item/storage/box/mre/fill_preset_inventory()
	pickflavor()

/obj/item/storage/box/mre/proc/pickflavor()
	//1 in 3 chance of getting a fortune cookie
	var/cookie
	if(should_have_cookie)
		cookie = rand(1,3)
	if(cookie == 1)
		storage_slots += 1
	new entree(src)
	new side(src)
	new snack(src)
	new dessert(src)
	if(misc_item)
		new misc_item(src)
		storage_slots += 1
	if(has_main_name)
		var/obj/item/mre_food_packet/entree/packet = locate() in src //Name is determined from entree's contents_food name
		var/obj/item/reagent_container/food/snacks/mre_food/food = packet.contents_food
		name += " ([food.name])"
	if(should_have_spread)
		choose_spread()
		storage_slots += 1
	if(should_have_beverage)
		choose_beverage()
		storage_slots += 1
	if(should_have_utencil)
		choose_utencil()
		storage_slots += 1
	if(should_have_drink)
		choose_drink()
		storage_slots += 1
	if(cookie == 1)
		new /obj/item/reagent_container/food/snacks/fortunecookie/prefilled(src)
	if(should_have_cigarettes)
		choose_cigarettes()
		storage_slots += 1
	if(should_have_matches)
		choose_matches()
		storage_slots += 1

/obj/item/storage/box/mre/proc/choose_cigarettes()
	new /obj/item/storage/fancy/cigarettes/lucky_strikes_4(src)

/obj/item/storage/box/mre/proc/choose_drink()
	new /obj/item/reagent_container/food/drinks/cans/waterbottle(src)

/obj/item/storage/box/mre/proc/choose_spread()
	var/spread_type = rand(1, 3)
	switch(spread_type)
		if(1)
			new /obj/item/reagent_container/food/drinks/cans/spread/cheese(src)
		if(2)
			new /obj/item/reagent_container/food/drinks/cans/spread/jalapeno(src)
		if(3)
			new /obj/item/reagent_container/food/drinks/cans/spread/peanut_butter(src)

/obj/item/storage/box/mre/proc/choose_beverage()
	var/beverage_type = rand(1, 5)
	switch(beverage_type)
		if(1)
			new /obj/item/reagent_container/food/drinks/beverage_drink/grape(src)
		if(2)
			new /obj/item/reagent_container/food/drinks/beverage_drink/orange(src)
		if(3)
			new /obj/item/reagent_container/food/drinks/beverage_drink/lemonlime(src)
		if(4)
			new /obj/item/reagent_container/food/drinks/beverage_drink/chocolate(src)
		if(5)
			new /obj/item/reagent_container/food/drinks/beverage_drink/chocolate_hazelnut(src)

/obj/item/storage/box/mre/proc/choose_utencil()
	new /obj/item/tool/kitchen/utensil/mre_spork(src)

/obj/item/storage/box/mre/proc/choose_matches()
	var/matches_type = rand(1, 5)
	switch(matches_type)
		if(1)
			new /obj/item/storage/fancy/cigar/matchbook(src)
		if(2)
			new /obj/item/storage/fancy/cigar/matchbook/koorlander(src)
		if(3)
			new /obj/item/storage/fancy/cigar/matchbook/exec_select(src)
		if(4)
			new /obj/item/storage/fancy/cigar/matchbook/wy_gold(src)
		if(5)
			new /obj/item/storage/fancy/cigar/matchbook/brown(src)

/obj/item/storage/box/mre/Initialize()
	. = ..()
	isopened = FALSE
	icon_state = icon_closed
	RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(try_forced_folding))

/obj/item/storage/box/mre/proc/try_forced_folding(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!isturf(loc))
		return

	if(locate(/obj/item/mre_food_packet) in src)
		return

	UnregisterSignal(src, COMSIG_ITEM_DROPPED)
	storage_close(user)
	to_chat(user, SPAN_NOTICE("You throw away [src]."))
	new trash_item(user.loc)
	qdel(src)

/obj/item/storage/box/mre/update_icon()
	if(!isopened)
		isopened = TRUE
		icon_state = icon_opened

///WY PMC RATION

/obj/item/storage/box/mre/pmc
	name = "\improper PMC CFR ration"
	desc = "A Combat Field Ration. Uses similar to USCM MRE format, but utilizes expensive preserving materials and methods and not less expensive foods, not much different from going to a restaurant. Eating better worlds."
	icon_state = "pmc_mealpack"
	icon_closed = "pmc_mealpack"
	icon_opened = "pmc_mealpackopened"
	item_state = "pmc_mealpack"
	trash_item = /obj/item/trash/pmc_mre
	should_have_spread = FALSE
	should_have_beverage = FALSE
	should_have_utencil = FALSE
	entree = /obj/item/mre_food_packet/entree/wy
	side = /obj/item/mre_food_packet/wy/side
	snack = /obj/item/mre_food_packet/wy/snack
	dessert = /obj/item/mre_food_packet/wy/dessert

/obj/item/storage/box/mre/pmc/choose_cigarettes()
	var/cig_type = rand(1, 2)
	switch(cig_type)
		if(1)
			new /obj/item/storage/fancy/cigarettes/wypacket_4(src)
		if(2)
			new /obj/item/storage/fancy/cigarettes/blackpack_4(src)

/obj/item/storage/box/mre/pmc/choose_drink()
	var/matches_type = rand(1, 2)
	switch(matches_type)
		if(1)
			new /obj/item/reagent_container/food/drinks/cans/soylent(src)
		if(2)
			new /obj/item/reagent_container/food/drinks/cans/coconutmilk(src)

/obj/item/storage/box/mre/pmc/choose_matches()
	var/matches_type = rand(1, 2)
	switch(matches_type)
		if(1)
			new /obj/item/storage/fancy/cigar/matchbook/exec_select(src)
		if(2)
			new /obj/item/storage/fancy/cigar/matchbook/wy_gold(src)

///TWE RATION

/obj/item/storage/box/mre/twe
	name = "\improper TWE ORP ration"
	desc = "An Operation Ration Pack. Uses similar to USCM MRE format, but utilizes expensive preserving materials and methods and not less expensive meals from TWE cuisine."
	icon_state = "twe_mealpack"
	icon_closed = "twe_mealpack"
	icon_opened = "twe_mealpackopened"
	item_state = "twe_mealpack"
	trash_item = /obj/item/trash/twe_mre
	entree = /obj/item/mre_food_packet/entree/twe
	side = /obj/item/mre_food_packet/twe/side
	snack = /obj/item/mre_food_packet/twe/snack
	dessert = /obj/item/mre_food_packet/twe/dessert

/obj/item/storage/box/mre/twe/Initialize()
	misc_item = pick(/obj/item/reagent_container/food/snacks/wrapped/twe_bar, /obj/item/storage/box/lemondrop)
	return ..()

/obj/item/storage/box/mre/twe/choose_beverage()
	new /obj/item/reagent_container/pill/teabag(src)

/obj/item/storage/box/mre/twe/choose_utencil()
	new /obj/item/reagent_container/food/drinks/sillycup(src)

/obj/item/storage/box/mre/twe/choose_cigarettes()
	var/cig_type = rand(1, 2)
	switch(cig_type)
		if(1)
			new /obj/item/storage/fancy/cigarettes/wypacket_4(src)
		if(2)
			new /obj/item/storage/fancy/cigarettes/balaji_4(src)

/obj/item/storage/box/mre/twe/choose_matches()
	var/matches_type = rand(1, 2)
	switch(matches_type)
		if(1)
			new /obj/item/storage/fancy/cigar/matchbook/balaji_imperial(src)
		if(2)
			new /obj/item/storage/fancy/cigar/matchbook/wy_gold(src)

/obj/item/storage/box/mre/twe/choose_spread()
	var/spread_type = rand(1, 3)
	switch(spread_type)
		if(1)
			new /obj/item/reagent_container/food/drinks/cans/tube/strawberry(src)
		if(2)
			new /obj/item/reagent_container/food/drinks/cans/tube/vegemite(src)
		if(3)
			new /obj/item/reagent_container/food/drinks/cans/tube/blackberry(src)

/obj/item/storage/box/mre/fsr
	name = "\improper FSR combat ration"
	desc = "First Strike Ration, produced by the same manufacturere that produces MREs for UA militaries, but oriented on a civillian and private markets."
	icon_state = "merc_mealpack"
	icon_closed = "merc_mealpack"
	icon_opened = "merc_mealpackopened"
	item_state = "merc_mealpack"
	trash_item = /obj/item/trash/merc_mre
	entree = /obj/item/mre_food_packet/entree/merc
	side = /obj/item/mre_food_packet/merc/side
	snack = /obj/item/mre_food_packet/merc/snack
	dessert = /obj/item/mre_food_packet/merc/dessert
	should_have_cigarettes = FALSE
	should_have_matches = FALSE

/obj/item/storage/box/mre/fsr/choose_utencil()
	new /obj/item/tool/kitchen/utensil/mre_spork/fsr(src)

/obj/item/storage/box/mre/wy
	name = "\improper W-Y brand ration pack"
	desc = "A more or less cohesive ration, intended for colonist and corporate security, packed with a medium quality foods with a long shelf life. \nOn the box is the Weyland-Yutani logo, with a slogan surrounding it: \n<b>WEYLAND-YUTANI. FEEDING BETTER WORLDS</b>."
	icon_state = "wy_mealpack"
	icon_closed = "wy_mealpack"
	icon_opened = "wy_mealpackopened"
	item_state = "wy_mealpack"
	trash_item = /obj/item/trash/wy_mre
	entree = /obj/item/mre_food_packet/entree/wy_colonist
	side = null
	snack = /obj/item/reagent_container/food/snacks/packaged_hdogs
	dessert = null
	should_have_beverage = FALSE
	should_have_cigarettes = FALSE
	should_have_matches = FALSE
	should_have_spread = FALSE
	should_have_cookie = FALSE
	should_have_utencil = FALSE

/obj/item/storage/box/mre/wy/choose_drink()
	new /obj/item/reagent_container/food/drinks/cans/bugjuice(src)

/obj/item/storage/box/mre/wy/pickflavor()
	side = pick(
		/obj/item/reagent_container/food/snacks/packaged_burger,
		/obj/item/reagent_container/food/snacks/packaged_burrito,
	)
	dessert = pick(
		/obj/item/reagent_container/food/snacks/eat_bar,
		/obj/item/reagent_container/food/snacks/wrapped/booniebars,
		/obj/item/reagent_container/food/snacks/wrapped/barcardine,
		/obj/item/reagent_container/food/snacks/wrapped/chunk,
	)
	return ..()

/obj/item/storage/box/mre/upp
	name = "\improper UPP IRP ration pack"
	desc = "An Individual Meal Ration, mainly composed of a selection of canned food, despite being heavier, it has proven to be a lot more reliable."
	icon_state = "upp_mealpack"
	icon_closed = "upp_mealpack"
	icon_opened = "upp_mealpackopened"
	item_state = "upp_mealpack"
	entree = null
	side = null
	trash_item = /obj/item/trash/upp_mre
	snack = /obj/item/mre_food_packet/upp/snack
	dessert = /obj/item/mre_food_packet/upp/dessert
	has_main_name = FALSE
	misc_item = /obj/item/reagent_container/food/snacks/wrapped/upp_biscuits
	should_have_beverage = FALSE
	should_have_cigarettes = FALSE
	should_have_matches = FALSE
	should_have_spread = FALSE
	should_have_cookie = FALSE
	should_have_utencil = TRUE

/obj/item/storage/box/mre/upp/choose_utencil()
	new /obj/item/tool/kitchen/utensil/pspoon(src)

/obj/item/storage/box/mre/upp/choose_drink()
	new /obj/item/reagent_container/food/drinks/cans/waterbottle/upp(src)

/obj/item/storage/box/mre/upp/pickflavor()
	entree = pick(
		/obj/item/reagent_container/food/drinks/cans/food/upp/meat,
		/obj/item/reagent_container/food/drinks/cans/food/upp/stew,
		/obj/item/reagent_container/food/drinks/cans/food/upp/soup,
		/obj/item/reagent_container/food/drinks/cans/food/upp/speck,
	)
	side = pick(
		/obj/item/reagent_container/food/drinks/cans/food/upp/vegetables,
		/obj/item/reagent_container/food/drinks/cans/food/upp/pasta,
		/obj/item/reagent_container/food/drinks/cans/food/upp/buckwheat,
		/obj/item/reagent_container/food/drinks/cans/food/upp/rice,
	)
	return ..()

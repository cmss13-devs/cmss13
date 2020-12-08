/**********************Marine Gear**************************/

//MARINE COMBAT LIGHT

/obj/item/device/flashlight/combat
	name = "combat flashlight"
	desc = "A Flashlight designed to be held in the hand, or attached to a rifle"
	icon_state = "flashlight"
	item_state = "flashlight"
	brightness_on = 5 //Pretty luminous, but still a flashlight that fits in a pocket

//MARINE SNIPER TARPS

/obj/item/bodybag/tarp
	name = "\improper V1 thermal-dapening tarp (folded)"
	desc = "A tarp carried by USCM Snipers. When laying underneath the tarp, the sniper is almost indistinguishable from the landscape if utilized correctly. The tarp contains a thermal-dampening weave to hide the wearer's heat signatures, optical camoflauge, and smell dampening."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "jungletarp_folded"
	w_class = SIZE_MEDIUM
	unfolded_path = /obj/structure/closet/bodybag/tarp
	unacidable = TRUE

/obj/item/bodybag/tarp/snow
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "snowtarp_folded"
	unfolded_path = /obj/structure/closet/bodybag/tarp/snow

/obj/item/bodybag/tarp/reactive
	name = "\improper V2 reactive thermal tarp (folded)"
	desc = "A tarp carried by some USCM infantry. This updated tarp is capable of blending into its environment nearly flawlessly, given that is can properly collate data once deployed. The tarp is able to hide the wearer's heat signature."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "reactivetarp_folded"
	unfolded_path = /obj/structure/closet/bodybag/tarp/reactive

/obj/structure/closet/bodybag/tarp
	name = "\improper V1 thermal-dampening tarp"
	desc = "A tarp carried by USCM Snipers. When laying underneath the tarp, the sniper is almost indistinguishable from the landscape if utilized correctly. The tarp contains a thermal-dampening weave to hide the wearer's heat signatures, optical camouflage, and smell dampening."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "jungletarp_closed"
	icon_closed = "jungletarp_closed"
	icon_opened = "jungletarp_open"
	open_sound = 'sound/effects/vegetation_walk_1.ogg'
	close_sound = 'sound/effects/vegetation_walk_2.ogg'
	item_path = /obj/item/bodybag/tarp
	anchored = 0

/obj/structure/closet/bodybag/tarp/snow
	icon_state = "snowtarp_closed"
	icon_closed = "snowtarp_closed"
	icon_opened = "snowtarp_open"
	item_path = /obj/item/bodybag/tarp/snow

/obj/structure/closet/bodybag/tarp/reactive
	name = "\improper V2 reactive thermal tarp"
	desc = "A tarp carried by some USCM infantry. This updated tarp is capable of blending into its environment nearly flawlessly, given that is can properly collate data once deployed. The tarp is able to hide the wearer's heat signature."
	icon_state = "reactivetarp_closed"
	icon_closed = "reactivetarp_closed"
	icon_opened = "reactivetarp_open"
	open_sound = 'sound/effects/vegetation_walk_1.ogg'
	close_sound = 'sound/effects/vegetation_walk_2.ogg'

	item_path = /obj/item/bodybag/tarp/reactive
	anchored = 0

/obj/structure/closet/bodybag/tarp/store_mobs(var/stored_units)//same as stasis bag proc
	var/list/mobs_can_store = list()
	for(var/mob/living/carbon/human/H in loc)
		if(H.buckled)
			continue
		if(H.stat == DEAD) // dead, nope
			continue
		mobs_can_store += H
	var/mob/living/carbon/human/mob_to_store
	if(mobs_can_store.len)
		mob_to_store = pick(mobs_can_store)
		mob_to_store.forceMove(src)
		stored_units += mob_size
	return stored_units

/obj/structure/closet/bodybag/tarp/open()
	animate(src, alpha = 255, time = SECONDS_3, easing = QUAD_EASING)
	. = ..()

/obj/structure/closet/bodybag/tarp/close()
	animate(src, alpha = 60, time = SECONDS_12, easing = QUAD_EASING)
	. = ..()

/obj/structure/closet/bodybag/tarp/dump_contents()
	for(var/obj/I in src)
		I.forceMove(loc)
	for(var/mob/M in src)//No stun
		M.forceMove(loc)
		M.update_canmove()
		if(!M.lying)
			M.visible_message(SPAN_WARNING("[M] suddenly gets out of [src]!"),
			SPAN_WARNING("You get out of [src] and get your bearings!"))

/obj/item/coin/marine
	name = "marine specialist weapon token"
	desc = "Insert this into a specialist vendor in order to access a single highly dangerous weapon."
	icon_state = "coin_adamantine"

	attackby(obj/item/W as obj, mob/user as mob) //To remove attaching a string functionality
		return

/obj/structure/broken_apc
	name = "\improper M577 armored personnel carrier"
	desc = "A large, armored behemoth capable of ferrying marines around. \nThis one is sitting nonfunctional."
	anchored = 1
	opacity = 1
	density = 1
	icon = 'icons/obj/apc.dmi'
	icon_state = "apc"


/obj/item/storage/box/uscm_mre
	name = "\improper USCM meal ready to eat"
	desc = "<B>Instructions:</B> Extract food using maximum firepower. Eat.\n\nOn the box is a picture of a shouting Squad Leader. \n\"YOU WILL EAT YOUR NUTRIENT GOO AND YOU WILL ENJOY IT, MAGGOT.\""
	icon_state = "mre1"

/obj/item/storage/box/uscm_mre/Initialize()
	. = ..()
	pixel_y = rand(-3,3)
	pixel_x = rand(-3,3)
	for(var/i = 0,i < 6,i++)
		var/rand_type = rand(0,8)
		switch(rand_type)
			if(0 to 2)
				new /obj/item/reagent_container/food/snacks/protein_pack(src)
			if(3)
				new /obj/item/reagent_container/food/snacks/mre_pack/meal1(src)
			if(4)
				new /obj/item/reagent_container/food/snacks/mre_pack/meal2(src)
			if(5)
				new /obj/item/reagent_container/food/snacks/mre_pack/meal3(src)
			if(6)
				new /obj/item/reagent_container/food/snacks/mre_pack/meal4(src)
			if(7)
				new /obj/item/reagent_container/food/snacks/mre_pack/meal5(src)
			if(8)
				new /obj/item/reagent_container/food/snacks/mre_pack/meal6(src)


/obj/item/reagent_container/food/snacks/protein_pack
	name = "stale USCM protein bar"
	desc = "The most fake looking protein bar you have ever laid eyes on, covered in the a subtitution chocolate. The powder used to make these is a subsitute of a substitute of whey substitute."
	icon_state = "yummers"
	filling_color = "#ED1169"
	w_class = SIZE_TINY

/obj/item/reagent_container/food/snacks/protein_pack/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	bitesize = 4


/obj/item/reagent_container/food/snacks/mre_pack
	name = "\improper generic MRE pack"
	//trash = /obj/item/trash/USCMtray
	trash = null
	w_class = SIZE_SMALL

/obj/item/reagent_container/food/snacks/mre_pack/meal1
	name = "\improper USCM Prepared Meal (cornbread)"
	desc = "A tray of standard USCM food. Stale cornbread, tomato paste and some green goop fill this tray."
	icon_state = "MREa"
	filling_color = "#ED1169"

/obj/item/reagent_container/food/snacks/mre_pack/meal1/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal2
	name = "\improper USCM Prepared Meal (pork)"
	desc = "A tray of standard USCM food. Partially raw pork, goopy corn and some water mashed potatos fill this tray."
	icon_state = "MREb"

/obj/item/reagent_container/food/snacks/mre_pack/meal2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 2

/obj/item/reagent_container/food/snacks/mre_pack/meal3
	name = "\improper USCM Prepared Meal (pasta)"
	desc = "A tray of standard USCM food. Overcooked spaghetti, waterlogged carrots and two french fries fill this tray."
	icon_state = "MREc"

/obj/item/reagent_container/food/snacks/mre_pack/meal3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 9)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal4
	name = "\improper USCM Prepared Meal (pizza)"
	desc = "A tray of standard USCM food. Cold pizza, wet greenbeans and a shitty egg fill this tray. Get something other than pizza, lardass."
	icon_state = "MREd"

/obj/item/reagent_container/food/snacks/mre_pack/meal4/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 8)
	bitesize = 1

/obj/item/reagent_container/food/snacks/mre_pack/meal5
	name = "\improper USCM Prepared Meal (chicken)"
	desc = "A tray of standard USCM food. Moist chicken, dry rice and a mildly depressed piece of broccoli fill this tray."
	icon_state = "MREe"

/obj/item/reagent_container/food/snacks/mre_pack/meal5/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 10)
	bitesize = 3

/obj/item/reagent_container/food/snacks/mre_pack/meal6
	name = "\improper USCM Prepared Meal (tofu)"
	desc = "The USCM doesn't serve tofu you grass sucking hippie. The flag signifies your defeat."
	icon_state = "MREf"

/obj/item/reagent_container/food/snacks/mre_pack/meal6/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 2)
	bitesize = 1

/obj/item/reagent_container/food/snacks/mre_pack/xmas1
	name = "\improper USCM M25 'X-MAS' Meal: Sugar Cookies"
	desc = "The USCM M25 Sugar Cookies Meal was designed to give marines a feeling of Christmas joy. But to the bemusement of superior officers, the costs-savings measure of simply fabricating protein bars in the shape of cookies with chocolate substitute chips and the replacement of the expected milk with artifically colored water did not go over well with most marines."
	icon_state = "mreCookies"

/obj/item/reagent_container/food/snacks/mre_pack/xmas1/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/xmas2
	name = "\improper USCM M25 'X-MAS' Meal: Gingerbread Cookies"
	desc = "The USCM M25 Gingerbread Cookies Meal was designed to give marines convenient and cheap access to gingerbread cookies as a replacement for annual gingerbread making classes due to rising expenses and comically low success rates for the Basic Holidays Festivities Course. However, due to cost saving measures, these cookies seldom inspire happiness, nor holiday spirit."
	icon_state = "mreGingerbread"

/obj/item/reagent_container/food/snacks/mre_pack/xmas2/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/reagent_container/food/snacks/mre_pack/xmas3
	name = "\improper USCM M25 'X-MAS' Meal: Fruitcake"
	desc = "The USCM M25 Fruitcake Meal was the third meal designed by an officers' committee as part of the M25 Project; this shows through the terrible hardness and tartness of the bread and raisined fruits. It can be logically deduced that the people who vended this option are worse than the Grinch and the Miser combined, along with the people who designed and prepared this fruitcake."
	icon_state = "mreFruitcake"

/obj/item/reagent_container/food/snacks/mre_pack/xmas3/Initialize()
	. = ..()
	reagents.add_reagent("nutriment", 15)
	reagents.add_reagent("sugar", 9)
	bitesize = 8

/obj/item/storage/box/pizza
	name = "food delivery box"
	desc = "A space-age food storage device, capable of keeping food extra fresh. Actually, it's just a box."

/obj/item/storage/box/pizza/Initialize()
	. = ..()
	pixel_y = rand(-3,3)
	pixel_x = rand(-3,3)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	var/randsnack
	for(var/i = 1 to 3)
		randsnack = rand(0,5)
		switch(randsnack)
			if(0)
				new /obj/item/reagent_container/food/snacks/fries(src)
			if(1)
				new /obj/item/reagent_container/food/snacks/cheesyfries(src)
			if(2)
				new /obj/item/reagent_container/food/snacks/bigbiteburger(src)
			if(4)
				new /obj/item/reagent_container/food/snacks/taco(src)
			if(5)
				new /obj/item/reagent_container/food/snacks/hotdog(src)

/obj/item/paper/janitor
	name = "crumbled paper"
	icon_state = "pamphlet"
	info = "In loving memory of Cub Johnson."



/obj/item/storage/box/wy_mre
	name = "\improper Weston-Yamada brand MRE"
	desc = "A prepackaged, long-lasting food box from Weston-Yamada Industries.\nOn the box is the Weston-Yamada logo, with a slogan surrounding it: \n<b>WESTON-YAMADA. BUILDING BETTER LUNCHES</b>"
	icon_state = "mre2"
	can_hold = list(/obj/item/reagent_container/food/snacks)
	w_class = SIZE_LARGE

/obj/item/storage/box/wy_mre/Initialize()
	. = ..()
	pixel_y = rand(-3,3)
	pixel_x = rand(-3,3)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/snacks/donkpocket(src)
	new /obj/item/reagent_container/food/drinks/coffee(src)
	var/randsnack = rand(0,5)
	switch(randsnack)
		if(0)
			new /obj/item/reagent_container/food/snacks/cheesiehonkers(src)
		if(1)
			new /obj/item/reagent_container/food/snacks/no_raisin(src)
		if(2)
			new /obj/item/reagent_container/food/snacks/spacetwinkie(src)
		if(4)
			new /obj/item/reagent_container/food/snacks/cookie(src)
		if(5)
			new /obj/item/reagent_container/food/snacks/chocolatebar(src)

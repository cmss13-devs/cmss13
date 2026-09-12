/*/datum/cooking/recipe/appendixburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/appendix
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/organ/appendix),
	)

/datum/cooking/recipe/appendixburger_bitten
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/appendix
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/appendix),
	)
	appear_in_default_catalog = FALSE

/datum/cooking/recipe/baconburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/bacon
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
	)

/datum/cooking/recipe/baseballburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/baseball
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/melee/baseball_bat),
	)

/datum/cooking/recipe/bearger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/bearger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monstermeat/bearmeat),
	)*/

/datum/cooking/recipe/bigbiteburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/bigbiteburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monkeyburger),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
	)

/datum/cooking/recipe/brainburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/brainburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/organ/brain),
	)
/*
/datum/cooking/recipe/cheeseburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/cheese
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
	)

/datum/cooking/recipe/chickenburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/chicken
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/chicken),
	)*/

/datum/cooking/recipe/clownburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/clownburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/clothing/mask/gas/clown_hat),
	)
/*
/datum/cooking/recipe/crazyburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/crazy
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/toy/crayon/green),
		PCWJ_ADD_ITEM(/obj/item/flashlight/flare),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_REAGENT("cornoil", 15),
	)

/datum/cooking/recipe/elecburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/elec
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/stack/sheet/mineral/plasma),
		PCWJ_ADD_ITEM(/obj/item/stack/sheet/mineral/plasma),
	)
*/
/datum/cooking/recipe/fishburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/fishburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
	)
/*
/datum/cooking/recipe/fivealarmburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/fivealarm
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/ghost_chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/ghost_chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
	)

/datum/cooking/recipe/ghostburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ghost
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/ectoplasm),
	)
*/
/datum/cooking/recipe/hamborger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/roburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/fake_robot_head),
	)

/datum/cooking/recipe/hotdog
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/hotdog
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sausage),
	)

/datum/cooking/recipe/jellyburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/jellyburger/cherry
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
	)
/*
/datum/cooking/recipe/mcguffin
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/mcguffin
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/friedegg),
	)

/datum/cooking/recipe/mcrib
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/mcrib
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bbqribs),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliced/onion_slice),
	)*/

/datum/cooking/recipe/mimeburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/mimeburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/clothing/head/beret),
	)

/datum/cooking/recipe/plainburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/monkeyburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
	)
/*
/datum/cooking/recipe/ppattyblue
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/blue
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("berryjuice", 5),
	)

/datum/cooking/recipe/ppattygreen
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/green
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("limejuice", 5),
	)

/datum/cooking/recipe/ppattyorange
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/orange
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("orangejuice", 5),
	)

/datum/cooking/recipe/ppattypurple
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/purple
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("grapejuice", 5),
	)

/datum/cooking/recipe/ppattyrainbow
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/rainbow
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/red),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/orange),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/yellow),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/green),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/blue),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/purple),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burger/ppatty/white),
	)

/datum/cooking/recipe/ppattyred
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/red
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
	)

/datum/cooking/recipe/ppattywhite
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/white
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("sugar", 5),
	)

/datum/cooking/recipe/ppattyyellow
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/ppatty/yellow
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_REAGENT("lemonjuice", 5),
	)

/datum/cooking/recipe/ratburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/rat
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/holder/mouse),
	)

/datum/cooking/recipe/slimeburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_REAGENT("slimejelly", 5),
	)

/datum/cooking/recipe/spellburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burger/spell
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/clothing/head/wizard),
	)*/

/datum/cooking/recipe/superbiteburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/superbiteburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bigbiteburger),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/patty),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("sodiumchloride", 5),
		PCWJ_ADD_REAGENT("blackpepper", 5),
	)

/datum/cooking/recipe/tofuburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/tofuburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
	)

/datum/cooking/recipe/xenoburger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/xenoburger
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/xenomeat),
	)

/datum/cooking/recipe/cherrysandwich
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/jellysandwich/cherry
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
	)
/*
/datum/cooking/recipe/slimesandwich
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/jellysandwich/slime
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)*/

/datum/cooking/recipe/twobread
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/twobread
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("wine", 5),
	)
/*
/datum/cooking/recipe/wrap
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/wrap
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/friedegg),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_REAGENT("soysauce", 10),
	)*/

/datum/cooking/recipe/sandwich
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/sandwich
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatsteak),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)
/*
/datum/cooking/recipe/philly_cheesesteak
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/philly_cheesesteak
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)

/datum/cooking/recipe/pbj_cherry
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/peanut_butter_jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("peanutbutter", 5),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)

/datum/cooking/recipe/slime
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/peanut_butter_jelly/slime
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("peanutbutter", 5),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)

/datum/cooking/recipe/peanut_butter_banana
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/peanut_butter_banana
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("peanutbutter", 5),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)

/datum/cooking/recipe/notasandwich
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/notasandwich
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/clothing/mask/fakemoustache),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)*/

/datum/cooking/recipe/jelliedtoast
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/jelliedtoast/cherry
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
	)

/datum/cooking/recipe/human_burger
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/human/burger
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bun),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/human),
	)
	appear_in_default_catalog = FALSE
/*
/datum/cooking/recipe/burrito
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/burrito
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tortilla),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/beans),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_REAGENT("capsaicin", 5),
		PCWJ_ADD_REAGENT("rice", 5),
	)

/datum/cooking/recipe/blt
	container_type = /obj/item/reagent_container/cooking/board
	product_type = /obj/item/reagent_container/food/snacks/blt
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
	)*/

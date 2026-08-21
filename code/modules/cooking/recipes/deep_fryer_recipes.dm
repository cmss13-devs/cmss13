/*/datum/cooking/recipe/apple_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/apple
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("applejuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/apple_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/apple/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("applejuice", 5),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherryapple_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/apple/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("applejuice", 5),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/apple_slime_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/apple/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("applejuice", 5),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/blumpkin_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/blumpkin
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("blumpkinjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/jelly_blumpkin_berry_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/blumpkin/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("blumpkinjuice", 5),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_blumpkin
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/blumpkin/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("blumpkinjuice", 5),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/slime_blumpkin_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/blumpkin/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("blumpkinjuice", 5),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/bungo_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/bungo
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("bungojuice", 5),
		PCWJ_ADD_REAGENT("frostoil", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/jelly_bungo_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/bungo/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("bungojuice", 5),
		PCWJ_ADD_REAGENT("frostoil", 5),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_bungo_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/bungo/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("bungojuice", 5),
		PCWJ_ADD_REAGENT("frostoil", 5),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/slime_bungo_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/bungo/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("bungojuice", 5),
		PCWJ_ADD_REAGENT("frostoil", 5),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/caramel_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/caramel
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/jelly_caramel_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/caramel/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_caramel_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/caramel/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/slime_caramel_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/caramel/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)*/

/datum/cooking/recipe/chaosdonut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/chaos
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("frostoil", 5),
		PCWJ_ADD_REAGENT("capsaicin", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)
/*
/datum/cooking/recipe/chocolate_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/chocolate
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/jelly_choco_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/chocolate/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_choco_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/chocolate/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/slime_chocolate_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/chocolate/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)*/

/datum/cooking/recipe/donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)
/*
/datum/cooking/recipe/sprinkles
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/sprinkles
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("sprinkles", 2),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)*/

/datum/cooking/recipe/jellydonut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/cherryjelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)
/*
/datum/cooking/recipe/slimejelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/jelly/slimejelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/matcha_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/matcha
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("teapowder", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/jelly_matcha_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/matcha/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("teapowder", 5),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_matcha_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/matcha/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("teapowder", 5),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/slime_matcha_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/matcha/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("teapowder", 5),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/meat_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/meat
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_REAGENT("ketchup", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/pink_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/pink
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/pink_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/pink/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/pink_cherry_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/pink/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/pink_slime_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/pink/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/spaceman_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/spaceman
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/trumpet),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/jelly_spaceman_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/spaceman/jelly
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/trumpet),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/cherry_spaceman_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/spaceman/jelly/cherry
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/trumpet),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/slime_spaceman_jelly_donut
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/donut/spaceman/jelly/slime
	catalog_category = COOKBOOK_CATEGORY_DONUTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donut, exact = TRUE),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/trumpet),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_DEEP_FRYER(20 SECONDS),
	)

/datum/cooking/recipe/deepfryer_friedbanana
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/friedbanana
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

/datum/cooking/recipe/carrotfries
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/carrotfries
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot/wedges),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

/datum/cooking/recipe/chimichanga
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/chimichanga
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/burrito),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

/datum/cooking/recipe/corn_chips
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/cornchips
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/corn),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

/datum/cooking/recipe/fried_tofu
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/fried_tofu
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)*/

/datum/cooking/recipe/fries
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/fries
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/rawsticks),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)
/*
/datum/cooking/recipe/onionrings
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/onionrings
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliced/onion_slice),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

/datum/cooking/recipe/potato_chips
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/chips
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/wedges),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

/datum/cooking/recipe/shrimp
	container_type = /obj/item/reagent_container/cooking/deep_basket
	product_type = /obj/item/reagent_container/food/snacks/fried_shrimp
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/shrimp),
		PCWJ_USE_DEEP_FRYER(10 SECONDS),
	)

*/

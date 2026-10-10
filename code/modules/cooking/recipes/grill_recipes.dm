/datum/cooking/recipe/bacon
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/bacon
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/raw_bacon),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/bbqribs
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/bbqribs
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_REAGENT("bbqsauce", 5),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/birdsteak
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/meatsteak/chicken
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/chicken),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/cutlet
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/cutlet
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/rawcutlet),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)
/*
/datum/cooking/recipe/fish_skewer
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/fish_skewer
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/fish/salmon),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/fish/salmon),
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/fishfingers
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/fishfingers
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/grilledcheese
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/grilledcheese
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/human_kebab
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/human/kabob
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/human),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/human),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)
	appear_in_default_catalog = FALSE

/datum/cooking/recipe/meatkeb
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/monkeykabob
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/meatsteak
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/meatsteak
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat, "exact"), // add exact with this so meat subtypes dont complete this
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/omelette
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/omelette
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_GRILL(J_MED, 20 SECONDS),
	)
/*
/datum/cooking/recipe/picoss_kebab
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/picoss_kebab
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_REAGENT("vinegar", 5),
		PCWJ_USE_GRILL(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/rofflewaffles
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/rofflewaffles
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("psilocybin", 5),
		PCWJ_ADD_REAGENT("sugar", 10),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)
/*
/datum/cooking/recipe/salmonsteak
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/salmonsteak
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/fish/salmon),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/sausage
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/sausage
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)
/*
/datum/cooking/recipe/shrimp_skewer
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/shrimp_skewer
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/shrimp),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/shrimp),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/shrimp),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/shrimp),
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_USE_GRILL(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/sushi_tamago
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/sliced/sushi_tamago
	catalog_category = COOKBOOK_CATEGORY_SUSHI
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/boiledrice),
		PCWJ_ADD_ITEM(/obj/item/stack/seaweed),
		PCWJ_ADD_REAGENT("sake", 5),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/sushi_unagi
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/sushi_unagi
	catalog_category = COOKBOOK_CATEGORY_SUSHI
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/fish/electric_eel),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/boiledrice),
		PCWJ_ADD_ITEM(/obj/item/stack/seaweed),
		PCWJ_ADD_REAGENT("sake", 5),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/syntikebab
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/monkeykabob
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/syntisteak
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/meatsteak
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)
/*
/datum/cooking/recipe/syntitelebacon
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/telebacon
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_ADD_ITEM(/obj/item/assembly/signaler),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/telebacon
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/telebacon
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/assembly/signaler),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/tofukebab
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/tofukabob
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/stack/rods),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/waffles
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/waffles
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("sugar", 10),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/wingfangchu
	container_type = /obj/item/reagent_container/cooking/grill_grate
	product_type = /obj/item/reagent_container/food/snacks/wingfangchu
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/xenomeat),
		PCWJ_ADD_REAGENT("soysauce", 5),
		PCWJ_USE_GRILL(J_MED, 10 SECONDS),
	)


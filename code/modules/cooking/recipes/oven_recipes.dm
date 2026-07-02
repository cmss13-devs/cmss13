/datum/cooking/recipe/amanita_pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/amanita_pie
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/amanita),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/applecake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/applecake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/apple),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/apple),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/applepie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/applepie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/apple),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/appletart
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/appletart
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/goldapple),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/baguette
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/baguette
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/bananabread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/bananabread
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/bananacake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/bananacake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/banarnarbread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/banarnarbread
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("blood", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/beary_pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/beary_pie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monstermeat/bearmeat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/berry_muffin
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/berry_muffin
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/berryclafoutis
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/berryclafoutis
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/birthdaycake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/birthdaycake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/clothing/head/cakehat),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_ADD_REAGENT("vanilla", 10),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/*/datum/cooking/recipe/blumpkin_pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/blumpkin_pie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/pumpkin/blumpkin),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/booberry_muffin
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/booberry_muffin
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/ectoplasm),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/braincake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/braincake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/organ/brain),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/bread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/bread
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/bun
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/bun
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/cannoli
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/cannoli
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_ADD_REAGENT("milk", 1),
		PCWJ_ADD_REAGENT("sugar", 3),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/carrotcake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/carrotcake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/datum/cooking/recipe/cheesecake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/cheesecake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/cheesepizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/cheesepizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/datum/cooking/recipe/cherry_cupcake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/cherry_cupcake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/blue
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/cherry_cupcake/blue
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/bluecherries),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/cherrypie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/cherrypie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_REAGENT("sugar", 10),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/chocolate_cornet
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/chocolate_cornet
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/chocolate_lava_tart
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/chocolate_lava_tart
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/slime_extract),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/chocolatecake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/chocolatecake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/clowncake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/clowncake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/frozen/sundae),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/frozen/sundae),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 30 SECONDS),
	)

/datum/cooking/recipe/cookies
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/storage/bag/tray/cookies_tray
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/rawcookies/chocochips),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/cracker
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/cracker
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/doughslice),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/creamcheesebread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/creamcheesebread
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/croissant
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/croissant
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/dankpizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/dankpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cannabis),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cannabis),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cannabis),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cannabis),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/datum/cooking/recipe/donkpocketpizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/donkpocketpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donkpocket),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/donkpocket),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/firecrackerpizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/firecrackerpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_REAGENT("capsaicin", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/flatbread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/flatbread
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/fortunecookie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/fortunecookie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/doughslice),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/fortunecookiefilled
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/fortunecookie/prefilled
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/doughslice),
		PCWJ_ADD_ITEM(/obj/item/paper),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/french_silk_pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/french_silk_pie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/frosty_pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/frosty_pie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/bluecherries),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/garlicpizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/garlicpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/garlic),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/garlic),
		PCWJ_ADD_REAGENT("garlic", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/grape_tart
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/grape_tart
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/grapes),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/grapes),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/grapes),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/hardware_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/hardware_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/circuitboard),
		PCWJ_ADD_ITEM(/obj/item/circuitboard),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_ADD_REAGENT("sacid", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/hawaiianpizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/hawaiianpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliced/pineapple),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliced/pineapple),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/datum/cooking/recipe/holy_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/holy_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_ADD_REAGENT("holywater", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/honey_bun
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/honey_bun
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("honey", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/lasagna
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/lasagna
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/lemoncake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/lemoncake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/lemon),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/lemon),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/liars_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/liars_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 30 SECONDS),
	)*/

/datum/cooking/recipe/limecake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/limecake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/lime),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/lime),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/loadedbakedpotato
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/loadedbakedpotato
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/macncheesepizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/macpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/macncheese),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/meatbread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/meatbread
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/meatpie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/meatpie
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/meatpizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/meatpizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/*/datum/cooking/recipe/mime_tart
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/mime_tart
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_REAGENT("nothing", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/moffin
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/moffin
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/grown/cotton),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/mothmallow
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/mothmallow
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/soybeans),
		PCWJ_ADD_REAGENT("vanilla", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_ADD_REAGENT("rum", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/muffin
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/muffin
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/mushroompizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/mushroompizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/oatmeal_cookie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/oatmeal_cookie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/oat),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/orangecake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/orangecake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/orange),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/orange),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/peanut_butter_cookie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/peanut_butter_cookie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("peanutbutter", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/pepperonipizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/pepperonipizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sausage),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/pestopizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/pestopizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("wasabi", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/pie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/pizzamargherita
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/margherita
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/plaincake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/plaincake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/plum_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/plum_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/plum),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/plum),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/plump_pie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/plump_pie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/plumphelmet),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/plumphelmetbiscuit
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/plumphelmetbiscuit
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/plumphelmet),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("flour", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/pound_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pound_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/plaincake),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/plaincake),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/plaincake),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/plaincake),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/pumpkin_spice_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pumpkin_spice_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/pumpkin),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/pumpkin),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/pumpkinpie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pumpkinpie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/pumpkin),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/raisin_cookie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/raisin_cookie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/no_raisin),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/slime_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/slime_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/slime_extract),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/spaceman_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/spaceman_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/trumpet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/trumpet),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/sugarcookies
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/storage/bag/tray/cookies_tray/sugarcookie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/rawcookies),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/syntibread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/meatbread
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/synthmeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/toastedsandwich
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/toastedsandwich
	catalog_category = COOKBOOK_CATEGORY_BURGS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sandwich),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/tofubread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/tofubread
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/tofupie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/tofupie
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/tofurkey
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/tofurkey
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/stuffing),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/turkey
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/turkey
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/stuffing),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/stuffing),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/datum/cooking/recipe/vanilla_berry_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/vanilla_berry_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/vanilla_cake
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/vanilla_cake
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/vanillapod),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/vanillapod),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/vegetablepizza
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/pizza/vegetablepizza
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/eggplant),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/corn),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_OVEN(J_MED, 15 SECONDS),
	)

/datum/cooking/recipe/xemeatpie
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/xemeatpie
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/xenomeat),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/xenomeatbread
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/sliceable/xenomeatbread
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/xenomeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/xenomeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/xenomeat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/yakiimo
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/yakiimo
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/sweet),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/poppypretzel
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/poppypretzel
	catalog_category = COOKBOOK_CATEGORY_BREAD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/seeds/poppyseed),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

/*/datum/cooking/recipe/dionaroast
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/dionaroast
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/holder/diona),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/apple),
		PCWJ_ADD_REAGENT("facid", 5),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)*/

/datum/cooking/recipe/donkpocket
	container_type = /obj/item/reagent_container/cooking/oven
	product_type = /obj/item/reagent_container/food/snacks/donkpocket
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_USE_OVEN(J_MED, 10 SECONDS),
	)

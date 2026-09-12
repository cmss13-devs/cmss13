/datum/cooking/recipe/friedegg
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/friedegg
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_STOVE(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/beetsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/beetsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/whitebeet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/bloodsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/bloodsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("blood", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/chicken_noodle_soup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/chicken_noodle_soup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/boiledspagetti),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/clownchili
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/clownchili
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/clothing/shoes/clown_shoes),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/coldchili
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/coldchili
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/icepepper),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/cornchowder
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/cornchowder
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/corn),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/cullenskink
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/cullenskink
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/fish/salmon),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("milk", 10),
		PCWJ_ADD_REAGENT("blackpepper", 4),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/eyesoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/eyesoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/organ/internal/eyes),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/frenchonionsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/frenchonionsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/hong_kong_borscht
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/hong_kong_borscht
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("soysauce", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/hong_kong_macaroni
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/hong_kong_macaroni
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/boiledspagetti),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/bacon),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("cream", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/hotchili
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/hotchili
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/meatball_noodles
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/meatball_noodles
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/spagetti),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/peanuts),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/meatballsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/meatballsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/misosoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/milosoup //i think this is miso soup, it has the same recipe
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/soydope),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/soydope),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/mushroomsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/mushroomsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/mysterysoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/mysterysoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/badrecipe),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/nettlesoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/nettlesoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/nettle),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/oatstew
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/oatstew
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/oat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/sweet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/parsnip),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/red_porridge
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/red_porridge
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/redbeet),
		PCWJ_ADD_REAGENT("vanilla", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("yogurt", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/redbeetsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/redbeetsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/redbeet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/redbeet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/seedsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/seedsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/seeds/sunflower),
		PCWJ_ADD_ITEM(/obj/item/seeds/poppyseed/lily),
		PCWJ_ADD_ITEM(/obj/item/seeds/ambrosia),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("vinegar", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/slimesoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/slimesoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("slimejelly", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/stew
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/stew
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/eggplant),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/sweetpotatosoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/sweetpotatosoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/sweet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/sweet),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("milk", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/tomatosoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/tomatosoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/vegetablesoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/vegetablesoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/corn),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/eggplant),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/wishsoup
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/wishsoup
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_REAGENT("water", 20),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/zurek
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soup/zurek
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/boiledegg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sausage),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/onion),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/amanitajelly
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/amanitajelly
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/amanita),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/amanita),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/amanita),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("vodka", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/beans
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/beans
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/soybeans),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/soybeans),
		PCWJ_ADD_REAGENT("ketchup", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/benedict
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/benedict
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/friedegg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatsteak),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/breadslice),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/boiled_shrimp
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/boiled_shrimp
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/shrimp),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/boiledegg
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/boiledegg
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/boiledrice
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/boiledrice
	steps = list(
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("rice", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/boiledslimeextract
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/boiledslimecore
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/slime_extract),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/boiledspaghetti
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/boiledspagetti
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/spagetti),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/boiledspiderleg
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/boiledspiderleg
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monstermeat/spiderleg, exclude_reagents = list("toxin")),
		PCWJ_ADD_REAGENT("water", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/candiedapple
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/candiedapple
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/apple),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/chawanmushi
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/chawanmushi
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("soysauce", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/cheese_balls
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/cheese_balls
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheese_curds),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("flour", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("honey", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/cheesyfries
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/cheesyfries
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/fries),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/cubancarp
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/cubancarp
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/dulce_de_batata
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/sliceable/dulce_de_batata
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/sweet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato/sweet),
		PCWJ_ADD_REAGENT("vanilla", 5),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/eggplantparm
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/eggplantparm
	catalog_category = COOKBOOK_CATEGORY_VEGE
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/eggplant),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/enchiladas
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/enchiladas
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cutlet),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/chili),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/corn),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/fishandchips
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/fishandchips
	catalog_category = COOKBOOK_CATEGORY_SEAFOOD
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/fries),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/friedbanana
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/friedbanana
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("sugar", 10),
		PCWJ_ADD_REAGENT("cornoil", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/macncheese
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/macncheese
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cheesewedge),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/macaroni),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/mashedtaters
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/mashed_potatoes
	catalog_category = COOKBOOK_CATEGORY_SIDES
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/potato),
		PCWJ_ADD_REAGENT("gravy", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/meatballspaggetti
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/meatballspagetti
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/spagetti),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/meatbun
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/meatbun
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/dough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cabbage),
		PCWJ_ADD_REAGENT("soysauce", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/monkeysdelight
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/monkeysdelight
	catalog_category = COOKBOOK_CATEGORY_MEAT
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monkeycube),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/pastatomato
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/pastatomato
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/spagetti),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/popcorn
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/popcorn
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/corn),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/ricepudding
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/ricepudding
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("rice", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/sashimi
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/sashimi
	catalog_category = COOKBOOK_CATEGORY_SUSHI
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monstermeat/spidereggs),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/carpmeat),
		PCWJ_ADD_REAGENT("soysauce", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/soylentgreen
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soylentgreen
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/human),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meat/human),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)
	appear_in_default_catalog = FALSE

/datum/cooking/recipe/soylentviridians
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/soylentviridians
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/soybeans),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/spacylibertyduff
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/spacylibertyduff
	steps = list(
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/libertycap),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/libertycap),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/mushroom/libertycap),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("vodka", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/spesslaw
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/spesslaw
	catalog_category = COOKBOOK_CATEGORY_PIZZAS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/spagetti),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/meatball),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/spidereggsham
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/spidereggsham
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monstermeat/spidereggs),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/monstermeat/spidermeat),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)*/

/datum/cooking/recipe/stewedsoymeat
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/stewedsoymeat
	catalog_category = COOKBOOK_CATEGORY_SOUPS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/soydope),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/soydope),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/carrot),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/tomato),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/datum/cooking/recipe/stuffing
	container_type = /obj/item/reagent_container/cooking/pot
	product_type = /obj/item/reagent_container/food/snacks/stuffing
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/bread),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("sodiumchloride", 1),
		PCWJ_ADD_REAGENT("blackpepper", 1),
		PCWJ_USE_STOVE(J_MED, 20 SECONDS),
	)

/*/datum/cooking/recipe/pancake
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/pancakes
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_USE_STOVE(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/berry_pancake
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/pancake/berry_pancake
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/berries),
		PCWJ_USE_STOVE(J_MED, 10 SECONDS),
	)

/datum/cooking/recipe/choc_chip_pancake
	container_type = /obj/item/reagent_container/cooking/pan
	product_type = /obj/item/reagent_container/food/snacks/pancake/choc_chip_pancake
	catalog_category = COOKBOOK_CATEGORY_BREAKFASTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookiedough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/choc_pile),
		PCWJ_USE_STOVE(J_MED, 10 SECONDS),
	)*/

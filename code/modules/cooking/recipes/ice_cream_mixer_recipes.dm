/*/datum/cooking/recipe/antpopsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/ant
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("ants", 10),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/bananatopsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/bananatop
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("banana", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/berrycreamsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/berrycream
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_ADD_REAGENT("berryjuice", 4),
		PCWJ_ADD_REAGENT("ice", 2),
		PCWJ_ADD_REAGENT("vanilla", 2),
		PCWJ_ADD_REAGENT("cream", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/berryicecreamsandwich
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/berryicecreamsandwich
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/wafflecone),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_REAGENT("ice", 5),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/berrytopsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/berrytop
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cornuto
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/cornuto
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliceable/flatdough),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("ice", 2),
		PCWJ_ADD_REAGENT("sugar", 4),
		PCWJ_ADD_REAGENT("cream", 4),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/frozenpineapplepop
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/frozenpineapple
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliced/pineapple),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/honkdae
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/honkdae
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/wafflecone),
		PCWJ_ADD_ITEM(/obj/item/clothing/mask/gas/clown_hat),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_ADD_REAGENT("ice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(20 SECONDS),
	)

/datum/cooking/recipe/icecreamsandwich
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/icecreamsandwich
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/frozen/icecream),
		PCWJ_ADD_REAGENT("ice", 5),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/jumboicecream
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_ADD_REAGENT("ice", 2),
		PCWJ_ADD_REAGENT("vanilla", 3),
		PCWJ_ADD_REAGENT("cream", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/licoricecreamsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/licoricecream
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_ADD_REAGENT("blumpkinjuice", 4),
		PCWJ_ADD_REAGENT("ice", 2),
		PCWJ_ADD_REAGENT("vanilla", 2),
		PCWJ_ADD_REAGENT("cream", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/orangecreamsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/orangecream
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_ADD_REAGENT("orangejuice", 4),
		PCWJ_ADD_REAGENT("ice", 2),
		PCWJ_ADD_REAGENT("vanilla", 2),
		PCWJ_ADD_REAGENT("cream", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/peanutbuttermochi
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/peanutbuttermochi
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/wafflecone),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_ADD_REAGENT("rice", 5),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("peanutbutter", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/pineappletopsicle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/pineappletop
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/tofu),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("pineapplejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/seasalticecream
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/popsicle/sea_salt
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/popsicle_stick),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("sodiumchloride", 3),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/apple
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/apple
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("applejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/berry
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/berry
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/bluecherry
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/bluecherry
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("bluecherryjelly", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cherry_snowcone
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/cherry
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cola
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/cola
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("cola", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/flavorless
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fruitsalad_snowcone
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/fruitsalad
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("banana", 5),
		PCWJ_ADD_REAGENT("orangejuice", 5),
		PCWJ_ADD_REAGENT("watermelonjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/grape
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/grape
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("grapejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/honey
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/honey
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("honey", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/lemon
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/lemon
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("lemonjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/lime
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/lime
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("limejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/mime
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/mime
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("nothing", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/orange
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/orange
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("orangejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/pineapple
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/pineapple
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("pineapplejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/rainbow
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/rainbow
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("colorful_reagent", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/spacemountainwind
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/snowcone/spacemountain
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/drinks/sillycup),
		PCWJ_ADD_REAGENT("ice", 15),
		PCWJ_ADD_REAGENT("spacemountainwind", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/spacefreezy
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/spacefreezy
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/frozen/icecream),
		PCWJ_ADD_REAGENT("bluecherryjelly", 5),
		PCWJ_ADD_REAGENT("spacemountainwind", 15),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/sundae
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/frozen/sundae
	catalog_category = COOKBOOK_CATEGORY_DESSERTS
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/wafflecone),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/banana),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/crunch
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/confectionery/rice
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/candybar),
		PCWJ_ADD_REAGENT("rice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/malper
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/confectionery/caramel
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/candybar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/toolerone
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/confectionery/nougat
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/candybar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/nougat),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/toxinstest
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/confectionery/caramel_nougat
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/candybar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/nougat),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/yumbaton
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/confectionery/toffee
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/candybar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/toffee),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/candied_pineapple
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/candied_pineapple
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/sliced/pineapple),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_ADD_REAGENT("water", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/candybar
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/candybar
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/caramel
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/caramel
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)*/

/datum/cooking/recipe/chocolate_bar
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/chocolatebar
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("soymilk", 2),
		PCWJ_ADD_REAGENT("cocoa", 2),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/chocolate_bar2
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/chocolatebar
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("milk", 2),
		PCWJ_ADD_REAGENT("cocoa", 2),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)
/*
/datum/cooking/recipe/chocolate_bunny
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/chocolate_bunny
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("sugar", 2),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/chocolate_coin
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/chocolate_coin
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/coin),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/chocolate_orange
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/chocolate_orange
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/orange),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/c_tube),
		PCWJ_ADD_REAGENT("sugar", 15),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_blue
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/blue
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("berryjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_green
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/green
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("limejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_orange
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/orange
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("orangejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_pink
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/pink
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("watermelonjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_poison
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/poison
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("poisonberryjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_purple
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/purple
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("grapejuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_rainbow
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/rainbow
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/red),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/blue),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/green),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/yellow),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/orange),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/purple),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/pink),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_rainbow2
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/bad_rainbow
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/red),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/poison),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/green),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/yellow),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/orange),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/purple),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton/pink),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_red
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/red
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("cherryjelly", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/cottoncandy_yellow
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/cotton/yellow
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/cotton),
		PCWJ_ADD_REAGENT("lemonjuice", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fudge
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/fudge
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fudge_cherry
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/fudge/cherry
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/cherries),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fudge_cookies_n_cream
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/fudge/cookies_n_cream
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/cookie),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_ADD_REAGENT("cream", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fudge_dice
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/fudge_dice
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/dice),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fudge_peanut
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/fudge/peanut
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/peanuts),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/peanuts),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/peanuts),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/fudge_turtle
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/fudge/turtle
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/candy/caramel),
		PCWJ_ADD_PRODUCE(/obj/item/reagent_container/food/snacks/grown/peanuts),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("milk", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/gum
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/gum
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("water", 5),
		PCWJ_ADD_REAGENT("cornoil", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/nougat
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/nougat
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("cornoil", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/taffy
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/taffy
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("salglu_solution", 15),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/toffee
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/candy/toffee
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("flour", 10),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/wafflecone
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/wafflecone
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("milk", 1),
		PCWJ_ADD_REAGENT("sugar", 1),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)*/

/datum/cooking/recipe/mint_2
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/mint
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_REAGENT("sugar", 5),
		PCWJ_ADD_REAGENT("frostoil", 5),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

/datum/cooking/recipe/chocolateegg
	container_type = /obj/item/reagent_container/cooking/icecream_bowl
	product_type = /obj/item/reagent_container/food/snacks/chocolateegg
	catalog_category = COOKBOOK_CATEGORY_CANDY
	steps = list(
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/egg),
		PCWJ_ADD_ITEM(/obj/item/reagent_container/food/snacks/chocolatebar),
		PCWJ_USE_ICE_CREAM_MIXER(10 SECONDS),
	)

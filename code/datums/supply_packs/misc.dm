/*******************************************************************************
SCIENCE
*******************************************************************************/


/datum/supply_packs/phoron
	name = "phoron assembly crate"
	contains = list(
					/obj/item/tank/phoron,
					/obj/item/tank/phoron,
					/obj/item/tank/phoron,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer
					)
	cost = RO_PRICE_PRICY
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "phoron assembly crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"


/*******************************************************************************
SUPPLIES
*******************************************************************************/


/datum/supply_packs/mre
	name = "USCM MRE crate (x20)"
	contains = list(
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE,
					/obj/item/storage/box/MRE
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper MRE crate"
	group = "Supplies"

/datum/supply_packs/flour
	name = "food ingredients crate (x25)"
	contains = list(
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/flour,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/reagent_container/food/snacks/meat/monkey,
					/obj/item/storage/fancy/egg_box,
					/obj/item/reagent_container/food/condiment/sugar
					)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Ingredients crate"
	group = "Supplies"

/datum/supply_packs/funfood
	name = "special ingredients crate (x6)"
	randomised_num_contained = 6
	contraband = 1
	contains = list(
					/obj/item/reagent_container/food/condiment/enzyme,
					/obj/item/reagent_container/food/condiment/saltshaker,
					/obj/item/reagent_container/food/condiment/saltshaker,
					/obj/item/reagent_container/food/condiment/saltshaker,
					/obj/item/reagent_container/food/condiment/peppermill,
					/obj/item/reagent_container/food/condiment/peppermill,
					/obj/item/reagent_container/food/condiment/peppermill,
					/obj/item/reagent_container/food/condiment/sugar,
					/obj/item/reagent_container/food/condiment/sugar,
					/obj/item/reagent_container/food/snacks/grown/potato,
					/obj/item/reagent_container/food/snacks/grown/potato,
					/obj/item/reagent_container/food/snacks/grown/potato,
					/obj/item/reagent_container/food/snacks/grown/potato,
					/obj/item/reagent_container/food/snacks/grown/potato,
					/obj/item/reagent_container/food/snacks/mint,
					/obj/item/reagent_container/food/snacks/grown/tomato,
					/obj/item/reagent_container/food/snacks/grown/tomato,
					/obj/item/reagent_container/food/snacks/grown/carrot,
					/obj/item/reagent_container/food/snacks/grown/carrot,
					/obj/item/reagent_container/food/snacks/grown/lemon,
					/obj/item/reagent_container/food/snacks/grown/lemon,
					/obj/item/reagent_container/food/snacks/grown/orange,
					/obj/item/reagent_container/food/snacks/grown/orange,
					/obj/item/reagent_container/food/snacks/grown/lime,
					/obj/item/reagent_container/food/snacks/grown/lime,
					/obj/item/reagent_container/food/drinks/bottle/whiskey,
					/obj/item/reagent_container/food/drinks/bottle/tequilla,
					/obj/item/reagent_container/food/drinks/bottle/rum,
					/obj/item/reagent_container/food/drinks/bottle/wine,
					/obj/item/reagent_container/food/drinks/bottle/wine,
					/obj/item/reagent_container/food/drinks/bottle/wine
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Special ingredients crate"
	group = "Supplies"

/datum/supply_packs/internals
	name = "oxygen internals crate (x3 masks, x3 tanks)"
	contains = list(
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/tank/air
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/internals
	containername = "internals crate"
	group = "Supplies"

/datum/supply_packs/evacuation
	name = "emergency equipment (x2 toolbox, x2 hazard vest, x5 oxygen tank, x5 masks)"
	contains = list(
					/obj/item/storage/toolbox/emergency,
					/obj/item/storage/toolbox/emergency,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/tank/emergency_oxygen,
					/obj/item/tank/emergency_oxygen,
					/obj/item/tank/emergency_oxygen,
					/obj/item/tank/emergency_oxygen,
					/obj/item/tank/emergency_oxygen,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/internals
	containername = "emergency crate"
	group = "Supplies"

/datum/supply_packs/boxes
	name = "empty boxes (x10)"
	contains = list(
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box,
					/obj/item/storage/box
					)
	cost = RO_PRICE_WORTHLESS
	containertype = "/obj/structure/closet/crate/supply"
	containername = "empty box crate"
	group = "Supplies"

/datum/supply_packs/janitor
	name = "assorted janitorial supplies"
	contains = list(
					/obj/item/reagent_container/glass/bucket,
					/obj/item/reagent_container/glass/bucket,
					/obj/item/reagent_container/glass/bucket,
					/obj/item/tool/mop,
					/obj/item/tool/wet_sign,
					/obj/item/tool/wet_sign,
					/obj/item/tool/wet_sign,
					/obj/item/storage/bag/trash,
					/obj/item/reagent_container/spray/cleaner,
					/obj/item/reagent_container/glass/rag,
					/obj/item/explosive/grenade/chem_grenade/cleaner,
					/obj/item/explosive/grenade/chem_grenade/cleaner,
					/obj/item/explosive/grenade/chem_grenade/cleaner,
					/obj/structure/mopbucket,
					/obj/item/paper/janitor
					)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper Janitorial supplies crate"
	group = "Supplies"

/datum/supply_packs/poster
	name = "posters"
	contains = list(
					/obj/item/poster,
					/obj/item/poster,
					/obj/item/poster,
					/obj/item/poster,
					/obj/item/poster
					)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper posters crate"
	group = "Supplies"

/datum/supply_packs/crayons
	name = "boxes of crayons"
	contains = list(
					/obj/item/storage/fancy/crayons,
					/obj/item/storage/fancy/crayons,
					/obj/item/storage/fancy/crayons,
					/obj/item/storage/fancy/crayons,
					/obj/item/storage/fancy/crayons
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper crayons crate"
	group = "Supplies"

/datum/supply_packs/presents
	name = "assorted presents"
	contains = list(
					/obj/item/a_gift,
					/obj/item/a_gift,
					/obj/item/a_gift,
					/obj/item/a_gift,
					/obj/item/a_gift
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper crate of presents"
	group = "Supplies"

/datum/supply_packs/wrapping_supplies
	name = "wrapping supplies"
	contains = list(
					/obj/item/wrapping_paper,
					/obj/item/wrapping_paper,
					/obj/item/wrapping_paper,
					/obj/item/wrapping_paper,
					/obj/item/tool/wirecutters,
					/obj/item/tool/wirecutters
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper wrapping supplies crate"
	group = "Supplies"

/datum/supply_packs/donuts
	name = "boxes of donuts"
	contains = list(
					/obj/item/storage/donut_box,
					/obj/item/storage/donut_box,
					/obj/item/storage/donut_box,
					/obj/item/storage/donut_box,
					/obj/item/storage/donut_box,
					/obj/item/storage/donut_box
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/supply
	containername = "\improper donuts crate"
	group = "Supplies"



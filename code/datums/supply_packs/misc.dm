//*******************************************************************************
//SCIENCE
//*******************************************************************************/


/datum/supply_packs/assembly
	name = "assembly crate"
	contains = list(
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/igniter,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/prox_sensor,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer,
					/obj/item/device/assembly/timer
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "assembly crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"

/datum/supply_packs/pyrotec
	name = "pyrotecnics crate"
	contains = list(
					/obj/item/reagent_container/glass/beaker/sulphuric,
					/obj/item/reagent_container/glass/beaker/sulphuric,
					/obj/item/reagent_container/glass/beaker/sulphuric,
					/obj/item/reagent_container/glass/beaker/ethanol,
					/obj/item/reagent_container/glass/beaker/ethanol,
					/obj/item/reagent_container/glass/beaker/ethanol,
					/obj/item/reagent_container/glass/beaker/large/phosphorus,
					/obj/item/reagent_container/glass/beaker/large/phosphorus,
					/obj/item/reagent_container/glass/beaker/large/phosphorus,
					/obj/item/reagent_container/glass/beaker/large/lithium,
					/obj/item/reagent_container/glass/beaker/large/lithium,
					/obj/item/reagent_container/glass/beaker/large/sodiumchloride,
					/obj/item/reagent_container/glass/beaker/large/sodiumchloride,
					/obj/item/reagent_container/glass/beaker/large/potassiumchloride,
					/obj/item/reagent_container/glass/beaker/large/potassiumchloride
					)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "pyrotecnics crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"

/datum/supply_packs/phoron
	name = "phoron crate"
	contains = list(
					/obj/item/stack/sheet/mineral/phoron/medium_stack,
					/obj/item/stack/sheet/mineral/phoron/medium_stack
					)
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "phoron crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"

/datum/supply_packs/plastic
	name = "plastic crate"
	contains = list(
					/obj/item/stack/sheet/mineral/plastic/small_stack,
					/obj/item/stack/sheet/mineral/plastic/small_stack
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "plastic crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"

/datum/supply_packs/precious_metals
	name = "precious metals crate"
	contains = list(
					/obj/item/stack/sheet/mineral/gold/small_stack,
					/obj/item/stack/sheet/mineral/silver/small_stack,
					/obj/item/stack/sheet/mineral/uranium/small_stack
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "precious metals crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"

/datum/supply_packs/exp_production
	name = "explosives production crate"
	contains = list(
					/obj/item/reagent_container/glass/canister,
					/obj/item/reagent_container/glass/canister,
					/obj/item/reagent_container/glass/canister/ammonia,
					/obj/item/reagent_container/glass/canister/ammonia,
					/obj/item/reagent_container/glass/canister/methane,
					/obj/item/reagent_container/glass/canister/methane,
					/obj/item/reagent_container/glass/canister/oxygen,
					/obj/item/reagent_container/glass/canister/oxygen,
					/obj/item/reagent_container/glass/canister/pacid,
					/obj/item/reagent_container/glass/canister/pacid
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "explosives production crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Science"

//*******************************************************************************
//SUPPLIES
//*******************************************************************************/


/datum/supply_packs/mre
	name = "USCM MRE crate (x24)"
	contains = list(
					/obj/item/ammo_box/magazine/misc/mre,
					/obj/item/ammo_box/magazine/misc/mre,
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
	containertype = /obj/structure/closet/crate/supply
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
					/obj/item/explosive/grenade/custom/cleaner,
					/obj/item/explosive/grenade/custom/cleaner,
					/obj/item/explosive/grenade/custom/cleaner,
					/obj/item/reagent_container/glass/bucket/mopbucket,
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



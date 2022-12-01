// move all the sciences related crate to research.dm

/datum/supply_packs/plastic
	name = "plastic crate"
	contains = list(
					/obj/item/stack/sheet/mineral/plastic/small_stack,
					/obj/item/stack/sheet/mineral/plastic/small_stack
					)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "plastic crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

/datum/supply_packs/precious_metals
	name = "precious metals crate"
	contains = list(
					/obj/item/stack/sheet/mineral/gold/small_stack,
					/obj/item/stack/sheet/mineral/silver/small_stack,
					/obj/item/stack/sheet/mineral/uranium/small_stack
					)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "precious metals crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

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
	cost = 20
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "explosives production crate"
	access = ACCESS_MARINE_ENGINEERING
	group = "Research"

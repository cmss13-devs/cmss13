//*******************************************************************************
//ARMOR
//*******************************************************************************/


/datum/supply_packs/armor_basic
	name = "M3 Pattern Medium Armor Crate (x5 helmet, x5 armor)"
	contains = list(
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/suit/storage/marine/medium,
					/obj/item/clothing/suit/storage/marine/medium,
					/obj/item/clothing/suit/storage/marine/medium,
					/obj/item/clothing/suit/storage/marine/medium,
					/obj/item/clothing/suit/storage/marine/medium
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "M3 Pattern Medium Armor Crate"
	group = "Armor"

/datum/supply_packs/armor_light
	name = "M3 Pattern Light Armor Crate (x3)"
	contains = list(
		/obj/item/clothing/suit/storage/marine/light,
		/obj/item/clothing/suit/storage/marine/light,
		/obj/item/clothing/suit/storage/marine/light
	)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate
	containername = "M3 Pattern Light Armor Crate"
	group = "Armor"

/datum/supply_packs/armor_heavy
	name = "M3 Pattern Heavy Armor Crate (x3)"
	contains = list(
		/obj/item/clothing/suit/storage/marine/heavy,
		/obj/item/clothing/suit/storage/marine/heavy,
		/obj/item/clothing/suit/storage/marine/heavy
	)
	cost = RO_PRICE_WORTHLESS
	containertype = /obj/structure/closet/crate
	containername = "M3 Pattern Heavy Armor Crate"
	group = "Armor"

/datum/supply_packs/armor_leader
	name = "B12 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(
					/obj/item/clothing/head/helmet/marine/leader,
					/obj/item/clothing/suit/storage/marine/leader
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "B12 pattern marine armor crate"
	group = "Armor"

/datum/supply_packs/clothing/merc
	contains = list()
	name = "black market clothing crate(x1)"
	cost = RO_PRICE_CHEAP
	contraband = 1
	containertype = /obj/structure/largecrate/merc/clothing
	containername = "\improper black market clothing crate"
	group = "Clothing"

/datum/supply_packs/armor_rto
	name = "M4 pattern marine armor crate (x1 helmet, x1 armor)"
	contains = list(/obj/item/clothing/head/helmet/marine/rto,
					/obj/item/clothing/suit/storage/marine/rto)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "M4 pattern marine armor crate"
	group = "Armor"


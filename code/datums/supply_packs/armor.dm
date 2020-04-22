/*******************************************************************************
ARMOR
*******************************************************************************/


/datum/supply_packs/armor_basic
	name = "M3 pattern armor crate (x5 helmet, x5 armor)"
	contains = list(
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/head/helmet/marine,
					/obj/item/clothing/suit/storage/marine,
					/obj/item/clothing/suit/storage/marine,
					/obj/item/clothing/suit/storage/marine,
					/obj/item/clothing/suit/storage/marine,
					/obj/item/clothing/suit/storage/marine
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "armor crate"
	group = "Armor"

/datum/supply_packs/armor_leader
	name = "M3 pattern squad leader crate (x1 helmet, x1 armor)"
	contains = list(
					/obj/item/clothing/head/helmet/marine/leader,
					/obj/item/clothing/suit/storage/marine/leader
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "squad leader armor crate"
	group = "Armor"


/*******************************************************************************
CLOTHING
*******************************************************************************/


/datum/supply_packs/officer_outfits
	contains = list(
					/obj/item/clothing/under/rank/ro_suit,
					/obj/item/clothing/under/marine/officer/bridge,
					/obj/item/clothing/under/marine/officer/bridge,
					/obj/item/clothing/under/marine/officer/exec,
					/obj/item/clothing/under/marine/officer/ce
					)
	name = "officer outfit closet"
	cost = RO_PRICE_CHEAP
	containertype = /obj/structure/closet
	containername = "officer dress closet"
	group = "Clothing"

/datum/supply_packs/marine_outfits
	contains = list(
					/obj/item/clothing/under/marine,
					/obj/item/clothing/under/marine,
					/obj/item/clothing/under/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/belt/marine,
					/obj/item/storage/backpack/marine,
					/obj/item/storage/backpack/marine,
					/obj/item/storage/backpack/marine,
					/obj/item/clothing/shoes/marine,
					/obj/item/clothing/shoes/marine,
					/obj/item/clothing/shoes/marine
					)
	name = "marine outfit closet"
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet
	containername = "marine outfit closet"
	group = "Clothing"

/datum/supply_packs/webbing
	name = "webbings and holsters crate"
	contains = list(
					/obj/item/clothing/accessory/holster,
					/obj/item/clothing/accessory/storage/black_vest/brown_vest,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/clothing/accessory/storage/webbing,
					/obj/item/storage/belt/gun/m4a3,
					/obj/item/storage/belt/gun/m44,
					/obj/item/storage/large_holster/m39
					)
	cost = RO_PRICE_NORMAL
	containertype = /obj/structure/closet/crate
	containername = "extra storage crate"
	group = "Clothing"

/datum/supply_packs/pouches_general
	name = "general pouches crate (2x normal, 1x medium, 1x large)"
	contains = list(
					/obj/item/storage/pouch/general,
					/obj/item/storage/pouch/general,
					/obj/item/storage/pouch/general/medium,
					/obj/item/storage/pouch/general/large
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "general pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_weapons
	name = "weapons pouches crate (1x bayonet, pistol, explosive)"
	contains = list(
					/obj/item/storage/pouch/bayonet,
					/obj/item/storage/pouch/pistol,
					/obj/item/storage/pouch/explosive
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "weapons pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_ammo
	name = "ammo pouches crate (1x normal, large, pistol, pistol large)"
	contains = list(
					/obj/item/storage/pouch/magazine,
					/obj/item/storage/pouch/magazine/large,
					/obj/item/storage/pouch/magazine/pistol,
					/obj/item/storage/pouch/magazine/pistol/large
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "ammo pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_medical
	name = "medical pouches crate (1x firstaid, medical, syringe, medkit, autoinjector)"
	contains = list(
					/obj/item/storage/pouch/firstaid,
					/obj/item/storage/pouch/medical,
					/obj/item/storage/pouch/syringe,
					/obj/item/storage/pouch/medkit,
					/obj/item/storage/pouch/autoinjector,
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "medical pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_survival
	name = "survival pouches crate (1x radio, flare, survival)"
	contains = list(
					/obj/item/storage/pouch/radio,
					/obj/item/storage/pouch/flare,
					/obj/item/storage/pouch/survival
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "survival pouches crate"
	group = "Clothing"

/datum/supply_packs/pouches_construction
	name = "construction pouches crate (1x document, electronics, tools, construction)"
	contains = list(
					/obj/item/storage/pouch/document,
					/obj/item/storage/pouch/electronics,
                    /obj/item/storage/pouch/tools,
					/obj/item/storage/pouch/construction
					)
	cost = RO_PRICE_VERY_CHEAP
	containertype = /obj/structure/closet/crate
	containername = "construction pouches crate"
	group = "Clothing"